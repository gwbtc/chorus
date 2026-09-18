// chorus: the claude code adapter for a ship's chorus agent. today it
// keeps chosen drawers of the ship's cabinet in a claude code project
// memory folder. sync runs one way, ship to folder, and says nothing
// about it: changes go to a log, not to stdout, so a slip's text never
// lands in claude's context unasked
//
//   chorus start [--project <dir>]
//   chorus sync [--project <dir>] [--once | --detached]
//   chorus guard
//   chorus init [--project <dir>] [--ship <url>] [--code <+code>]
//               [--drawer </path[:~ship,~ship]>]...

const std = @import("std");
const builtin = @import("builtin");
const claude = @import("claude.zig");
const config = @import("config.zig");
const setup = @import("init.zig");
const ship_lib = @import("ship.zig");

const usage =
    \\usage:
    \\  chorus start [--project <dir>]
    \\      SessionStart hook: sync once, note the claude code session,
    \\      and leave a detached daemon following the ship
    \\  chorus sync [--project <dir>] [--once | --detached]
    \\      sync the configured drawers into project memory, then follow
    \\      the ship for changes. --once syncs and exits; --detached
    \\      leaves the terminal and exits when no noted session is alive
    \\  chorus guard
    \\      PreToolUse hook: deny edits to synced slips
    \\  chorus init [--project <dir>] [--ship <url>] [--code <+code>]
    \\              [--drawer </path[:~ship,~ship]>]...
    \\      write the config and the claude code plugin for a project
    \\
;

pub fn main() !u8 {
    var gpa_state = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = gpa_state.allocator();
    var arena_state = std.heap.ArenaAllocator.init(gpa);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const args = try std.process.argsAlloc(arena);
    if (args.len < 2) {
        std.debug.print("{s}", .{usage});
        return 2;
    }
    const command = args[1];
    if (std.mem.eql(u8, command, "start")) return start(gpa, arena, args[2..]);
    if (std.mem.eql(u8, command, "sync")) return sync(gpa, arena, args[2..]);
    if (std.mem.eql(u8, command, "guard")) return guard(arena);
    if (std.mem.eql(u8, command, "init")) return setup.init(gpa, arena, args[2..]);
    std.debug.print("{s}", .{usage});
    return 2;
}

// the project root: --project, else where claude code says it is,
// else the working directory
pub fn projectDir(arena: std.mem.Allocator, flag: ?[]const u8) ![]const u8 {
    if (flag) |dir| return std.fs.cwd().realpathAlloc(arena, dir);
    if (std.process.getEnvVarOwned(arena, "CLAUDE_PROJECT_DIR")) |dir| {
        if (dir.len > 0) return dir;
    } else |_| {}
    return std.fs.cwd().realpathAlloc(arena, ".");
}

// the one line stdout ever carries. fixed text, so a forged copy in a
// slip can waste one sentence and no more
const login_failed = "chorus: login failed, rerun `chorus init`\n";

// <project>/.claude/chorus/log: one line per change, timestamped.
// past the cap the older half goes
const Log = struct {
    path: []const u8,
    const cap = 256 * 1024;

    fn append(self: Log, gpa: std.mem.Allocator, lines: []const u8) !void {
        if (lines.len == 0) return;
        var stamped = std.Io.Writer.Allocating.init(gpa);
        defer stamped.deinit();
        const stamp = timestamp(std.time.timestamp());
        var it = std.mem.splitScalar(u8, std.mem.trimRight(u8, lines, "\n"), '\n');
        while (it.next()) |line| try stamped.writer.print("{s} {s}\n", .{ &stamp, line });

        const file = try std.fs.cwd().createFile(self.path, .{ .truncate = false, .read = true });
        defer file.close();
        const size = (try file.stat()).size;
        if (size + stamped.written().len > cap) try trim(gpa, file);
        try file.seekFromEnd(0);
        try file.writeAll(stamped.written());
    }

    // keep the newer half of the log, from a line boundary
    fn trim(gpa: std.mem.Allocator, file: std.fs.File) !void {
        try file.seekTo(0);
        const old = try file.readToEndAlloc(gpa, cap * 2);
        defer gpa.free(old);
        var from = old.len / 2;
        if (std.mem.indexOfScalarPos(u8, old, from, '\n')) |nl| from = nl + 1;
        try file.seekTo(0);
        try file.setEndPos(0);
        try file.writeAll(old[from..]);
    }
};

// utc, YYYY-MM-DD HH:MM:SS
fn timestamp(seconds: i64) [19]u8 {
    const epoch = std.time.epoch.EpochSeconds{ .secs = @intCast(@max(seconds, 0)) };
    const day = epoch.getEpochDay();
    const year_day = day.calculateYearDay();
    const month_day = year_day.calculateMonthDay();
    const clock = epoch.getDaySeconds();
    var out: [19]u8 = undefined;
    _ = std.fmt.bufPrint(&out, "{d:0>4}-{d:0>2}-{d:0>2} {d:0>2}:{d:0>2}:{d:0>2}", .{
        year_day.year,
        month_day.month.numeric(),
        month_day.day_index + 1,
        clock.getHoursIntoDay(),
        clock.getMinutesIntoHour(),
        clock.getSecondsIntoMinute(),
    }) catch unreachable;
    return out;
}

// <project>/.claude/chorus/sessions/<pid>: one empty file per claude
// code process that started a session here. the detached daemon lives
// as long as one of them does, so it needs no monitor to tie it to a
// session and no hook to stop it
const Sessions = struct {
    dir: []const u8,

    fn note(self: Sessions, pid: std.posix.pid_t) !void {
        var dir = try std.fs.cwd().makeOpenPath(self.dir, .{});
        defer dir.close();
        var name: [16]u8 = undefined;
        const file = try dir.createFile(try std.fmt.bufPrint(&name, "{d}", .{pid}), .{});
        file.close();
    }

    // forget the dead; say whether anyone is left
    fn anyAlive(self: Sessions) bool {
        var dir = std.fs.cwd().openDir(self.dir, .{ .iterate = true }) catch return false;
        defer dir.close();
        var alive = false;
        var it = dir.iterate();
        while (it.next() catch null) |entry| {
            const pid = std.fmt.parseInt(std.posix.pid_t, entry.name, 10) catch continue;
            if (isAlive(pid)) {
                alive = true;
            } else {
                dir.deleteFile(entry.name) catch {};
            }
        }
        return alive;
    }

    // the daemon's second thread: leave once every session has. every
    // write is a temp file and a rename, so leaving mid-sync is safe
    fn watch(self: Sessions) void {
        while (true) {
            std.Thread.sleep(10 * std.time.ns_per_s);
            if (!self.anyAlive()) std.process.exit(0);
        }
    }
};

// static linux builds have no libc to ask
const sys = if (builtin.os.tag == .linux) std.os.linux else std.c;

fn isAlive(pid: std.posix.pid_t) bool {
    std.posix.kill(pid, 0) catch |err| return err == error.PermissionDenied;
    return true;
}

const shells = [_][]const u8{ "sh", "bash", "zsh", "dash", "fish", "ksh" };

// the claude code process behind a hook: our nearest ancestor that is
// not a shell, since claude code runs hooks through one
fn sessionPid(arena: std.mem.Allocator) !std.posix.pid_t {
    var pid: std.posix.pid_t = sys.getppid();
    var hops: usize = 0;
    while (hops < 8 and pid > 1) : (hops += 1) {
        var arg: [16]u8 = undefined;
        const res = try std.process.Child.run(.{
            .allocator = arena,
            .argv = &.{ "ps", "-o", "ppid=,comm=", "-p", try std.fmt.bufPrint(&arg, "{d}", .{pid}) },
        });
        const line = std.mem.trim(u8, res.stdout, " \n");
        const gap = std.mem.indexOfScalar(u8, line, ' ') orelse return pid;
        const comm = std.fs.path.basename(std.mem.trim(u8, line[gap..], " -"));
        const is_shell = for (shells) |shell| {
            if (std.mem.eql(u8, comm, shell)) break true;
        } else false;
        if (!is_shell) return pid;
        pid = std.fmt.parseInt(std.posix.pid_t, line[0..gap], 10) catch return pid;
    }
    return pid;
}

// the SessionStart hook. make the folder and the index current before
// claude code loads the index, then leave a daemon behind. the daemon
// takes nothing from us but /dev/null, so the hook returns at once
fn start(gpa: std.mem.Allocator, arena: std.mem.Allocator, args: []const []const u8) !u8 {
    var project_flag: ?[]const u8 = null;
    if (args.len == 2 and std.mem.eql(u8, args[0], "--project")) {
        project_flag = args[1];
    } else if (args.len != 0) {
        std.debug.print("{s}", .{usage});
        return 2;
    }
    const project = try projectDir(arena, project_flag);
    if ((try config.load(arena, project)) == null) return 0;

    const code = try sync(gpa, arena, &.{ "--once", "--project", project });
    const sessions = Sessions{ .dir = try std.fs.path.join(arena, &.{ project, config.dir_name, "sessions" }) };
    try sessions.note(try sessionPid(arena));

    var child = std.process.Child.init(&.{
        try std.fs.selfExePathAlloc(arena), "sync", "--detached", "--project", project,
    }, arena);
    child.stdin_behavior = .Ignore;
    child.stdout_behavior = .Ignore;
    child.stderr_behavior = .Ignore;
    try child.spawn();
    return code;
}

const Sync = struct {
    gpa: std.mem.Allocator,
    cfg: config.Config,
    our: []const u8,
    ship: *ship_lib.Ship,
    // the synced set, keyed by cabinet path. slips live in .store,
    // which a full resync empties
    store: std.heap.ArenaAllocator,
    set: std.StringArrayHashMapUnmanaged(claude.Entry) = .empty,
    log: Log,
    synced: bool = false,

    // fetch every configured drawer afresh. the folder is a cache and
    // the ship is the truth
    fn resync(self: *Sync) anyerror!void {
        var scratch = std.heap.ArenaAllocator.init(self.gpa);
        defer scratch.deinit();
        var slips = std.ArrayList(ship_lib.Slip).empty;
        for (self.cfg.drawers) |drawer| {
            try self.ship.drawer(scratch.allocator(), drawer.path, &slips);
        }
        _ = self.store.reset(.retain_capacity);
        self.set = .empty;
        for (slips.items) |slip| try self.keep(slip);
        try self.write();
        self.synced = true;
    }

    // take a slip into the set if a drawer holds its path and trusts
    // its author
    fn keep(self: *Sync, slip: ship_lib.Slip) !void {
        const drawer = self.cfg.drawerFor(slip.path) orelse return;
        if (!config.trusted(drawer, self.our, slip.author)) return;
        const a = self.store.allocator();
        const path = try a.dupe(u8, slip.path);
        try self.set.put(a, path, .{ .slip = .{
            .path = path,
            .author = try a.dupe(u8, slip.author),
            .created = try a.dupe(u8, slip.created),
            .fqsp = try a.dupe(u8, slip.fqsp),
            .wire = try a.dupe(u8, slip.wire),
            .text = try a.dupe(u8, slip.text),
        } });
    }

    fn write(self: *Sync) !void {
        var scratch = std.heap.ArenaAllocator.init(self.gpa);
        defer scratch.deinit();
        const a = scratch.allocator();
        var drawers = std.ArrayList([]const u8).empty;
        for (self.cfg.drawers) |drawer| try drawers.append(a, drawer.path);
        var lines = std.Io.Writer.Allocating.init(a);
        try claude.apply(a, self.cfg.memory, self.our, self.set.values(), drawers.items, &lines.writer);
        try self.log.append(self.gpa, lines.written());
    }

    fn onEvent(self: *Sync, _: std.mem.Allocator, event: ship_lib.Event) anyerror!void {
        const path = switch (event) {
            .slip => |slip| slip.path,
            .discard => |path| path,
        };
        if (self.cfg.drawerFor(path) == null) return;
        // a path that ends in a ship is one half of a split, and the
        // other half moved without a fact of its own: ask the ship
        const last = path[(std.mem.lastIndexOfScalar(u8, path, '/') orelse 0) + 1 ..];
        if (last.len > 0 and last[0] == '~') return self.resync();
        switch (event) {
            .slip => |slip| {
                _ = self.set.orderedRemove(slip.path);
                try self.keep(slip);
            },
            .discard => _ = self.set.orderedRemove(path),
        }
        try self.write();
    }
};

fn sync(gpa: std.mem.Allocator, arena: std.mem.Allocator, args: []const []const u8) !u8 {
    var project_flag: ?[]const u8 = null;
    var once = false;
    var detached = false;
    var i: usize = 0;
    while (i < args.len) : (i += 1) {
        if (std.mem.eql(u8, args[i], "--once")) {
            once = true;
        } else if (std.mem.eql(u8, args[i], "--detached")) {
            detached = true;
        } else if (std.mem.eql(u8, args[i], "--project") and i + 1 < args.len) {
            i += 1;
            project_flag = args[i];
        } else {
            std.debug.print("{s}", .{usage});
            return 2;
        }
    }
    const project = try projectDir(arena, project_flag);
    // no config means this project does not use chorus
    const cfg = (try config.load(arena, project)) orelse return 0;
    const log = Log{ .path = try std.fs.path.join(arena, &.{ project, config.dir_name, "log" }) };

    // one daemon per project; a second session's daemon leaves the
    // first to work
    var lock: ?std.fs.File = null;
    defer if (lock) |file| file.close();
    if (!once) {
        // leave the terminal's session, so nothing typed there signals us
        if (detached) _ = sys.setsid();
        const lock_path = try std.fs.path.join(arena, &.{ project, config.dir_name, "lock" });
        lock = try std.fs.cwd().createFile(lock_path, .{ .truncate = false });
        // a daemon on its way out may still hold the lock: give it a
        // few seconds before leaving the work to whoever has it
        var tries: usize = 0;
        while (!try lock.?.tryLock(.exclusive)) : (tries += 1) {
            if (!detached or tries == 5) return 0;
            std.Thread.sleep(std.time.ns_per_s);
        }
    }
    if (detached) {
        const sessions = Sessions{ .dir = try std.fs.path.join(arena, &.{ project, config.dir_name, "sessions" }) };
        if (!sessions.anyAlive()) return 0;
        (try std.Thread.spawn(.{}, Sessions.watch, .{sessions})).detach();
    }

    var ship = ship_lib.Ship.init(gpa, cfg.ship, cfg.cookie);
    defer ship.deinit();
    var state = Sync{
        .gpa = gpa,
        .cfg = cfg,
        .our = try ship.name(),
        .ship = &ship,
        .store = std.heap.ArenaAllocator.init(gpa),
        .log = log,
    };

    if (once) {
        state.resync() catch |err| return fail(gpa, log, err);
        return 0;
    }

    var backoff: u64 = 1;
    while (true) {
        state.synced = false;
        ship.watch(&state, Sync.resync, Sync.onEvent) catch |err| switch (err) {
            ship_lib.Error.Unauthorized => return fail(gpa, log, err),
            else => {
                var line: [128]u8 = undefined;
                const text = std.fmt.bufPrint(&line, "chorus: {s}; retrying in {d}s", .{ @errorName(err), backoff }) catch unreachable;
                log.append(gpa, text) catch {};
            },
        };
        if (state.synced) backoff = 1;
        std.Thread.sleep(backoff * std.time.ns_per_s);
        backoff = @min(backoff * 2, 60);
    }
}

// a failed login is the one thing the user must act on, so it is the
// one thing that reaches stdout, and claude's context. everything
// else goes to the log. exit 0 either way: a hook only passes stdout
// on when the command succeeds
fn fail(gpa: std.mem.Allocator, log: Log, err: anyerror) u8 {
    if (err == ship_lib.Error.Unauthorized) {
        log.append(gpa, std.mem.trimRight(u8, login_failed, "\n")) catch {};
        std.fs.File.stdout().writeAll(login_failed) catch {};
        return 0;
    }
    var line: [128]u8 = undefined;
    const text = std.fmt.bufPrint(&line, "chorus: sync failed: {s}", .{@errorName(err)}) catch unreachable;
    log.append(gpa, text) catch {};
    return 1;
}

const deny_reason = "This memory is a read-only copy of a chorus slip. " ++
    "Publish a new revision with the `chorus/publish-slip` tool.";

// the PreToolUse hook: deny an Edit or Write under <memory>/chorus/
fn guard(arena: std.mem.Allocator) !u8 {
    var in_buf: [4096]u8 = undefined;
    var stdin = std.fs.File.stdin().reader(&in_buf);
    const input = try stdin.interface.allocRemaining(arena, .limited(16 << 20));
    const hook = std.json.parseFromSliceLeaky(std.json.Value, arena, input, .{}) catch return 0;
    if (hook != .object) return 0;
    const tool_input = hook.object.get("tool_input") orelse return 0;
    if (tool_input != .object) return 0;
    const file_value = tool_input.object.get("file_path") orelse return 0;
    if (file_value != .string) return 0;

    const cwd: ?[]const u8 = if (hook.object.get("cwd")) |v| (if (v == .string) v.string else null) else null;
    const project = if (std.process.getEnvVarOwned(arena, "CLAUDE_PROJECT_DIR")) |dir|
        dir
    else |_|
        cwd orelse return 0;
    const cfg = (config.load(arena, project) catch return 0) orelse return 0;

    const target = try std.fs.path.resolve(arena, &.{ cwd orelse project, file_value.string });
    const root = try std.fs.path.resolve(arena, &.{ cfg.memory, claude.folder });
    if (!std.mem.startsWith(u8, target, root)) return 0;
    if (target.len != root.len and target[root.len] != '/') return 0;

    var out_buf: [1024]u8 = undefined;
    var stdout = std.fs.File.stdout().writer(&out_buf);
    try stdout.interface.print(
        "{{\"hookSpecificOutput\":{{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"deny\",\"permissionDecisionReason\":{f}}}}}\n",
        .{std.json.fmt(deny_reason, .{})},
    );
    try stdout.interface.flush();
    return 0;
}

test "a session lives as long as its process" {
    var tmp = std.testing.tmpDir(.{});
    defer tmp.cleanup();
    const path = try tmp.dir.realpathAlloc(std.testing.allocator, ".");
    defer std.testing.allocator.free(path);
    const sessions = Sessions{ .dir = path };
    try std.testing.expect(!sessions.anyAlive());
    // no process has a pid this high
    try sessions.note(0x3fffffff);
    try std.testing.expect(!sessions.anyAlive());
    try std.testing.expectError(error.FileNotFound, tmp.dir.statFile("1073741823"));
    try sessions.note(sys.getpid());
    try std.testing.expect(sessions.anyAlive());
}

test "timestamps read as utc" {
    try std.testing.expectEqualStrings("2026-09-18 09:15:07", &timestamp(1789722907));
}

test "the log keeps its newer half past the cap" {
    var tmp = std.testing.tmpDir(.{});
    defer tmp.cleanup();
    const path = try tmp.dir.realpathAlloc(std.testing.allocator, ".");
    defer std.testing.allocator.free(path);
    const log_path = try std.fs.path.join(std.testing.allocator, &.{ path, "log" });
    defer std.testing.allocator.free(log_path);
    const log = Log{ .path = log_path };
    const line = "chorus: /projects/chorus/" ++ "x" ** 40 ++ " updated";
    var n: usize = 0;
    while (n < Log.cap / line.len + 10) : (n += 1) try log.append(std.testing.allocator, line);
    const stat = try tmp.dir.statFile("log");
    try std.testing.expect(stat.size < Log.cap);
    try std.testing.expect(stat.size > Log.cap / 4);
    const bytes = try tmp.dir.readFileAlloc(std.testing.allocator, "log", Log.cap);
    defer std.testing.allocator.free(bytes);
    try std.testing.expect(std.mem.startsWith(u8, bytes, "20"));
    try std.testing.expect(std.mem.endsWith(u8, bytes, "updated\n"));
}

test {
    _ = claude;
    _ = config;
    _ = setup;
}
