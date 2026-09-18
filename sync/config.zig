// config: <project>/.claude/chorus/config.json, and the questions the
// sync core asks of it

const std = @import("std");

pub const dir_name = ".claude/chorus";
pub const file_name = "config.json";

pub const Drawer = struct {
    // a drawer in our cabinet, e.g. /projects/chorus
    path: []const u8,
    // the authors whose slips sync from it; null means only ours
    who: ?[]const []const u8 = null,
};

pub const Config = struct {
    ship: []const u8,
    cookie: []const u8,
    memory: []const u8,
    drawers: []const Drawer,

    // the first drawer holding a cabinet path
    pub fn drawerFor(self: Config, path: []const u8) ?Drawer {
        for (self.drawers) |drawer| {
            const root = std.mem.trimRight(u8, drawer.path, "/");
            if (!std.mem.startsWith(u8, path, root)) continue;
            if (path.len == root.len or path[root.len] == '/') return drawer;
        }
        return null;
    }
};

// whether an author's slips may reach project memory through a drawer.
// every reader of .who goes through here, so the source of trust can
// move onto the ship without touching the sync core
pub fn trusted(drawer: Drawer, our: []const u8, author: []const u8) bool {
    if (std.mem.eql(u8, our, author)) return true;
    const who = drawer.who orelse return false;
    for (who) |ship| {
        if (std.mem.eql(u8, ship, author)) return true;
    }
    return false;
}

// null when the project has no chorus config
pub fn load(arena: std.mem.Allocator, project: []const u8) !?Config {
    const path = try std.fs.path.join(arena, &.{ project, dir_name, file_name });
    const bytes = std.fs.cwd().readFileAlloc(arena, path, 1 << 20) catch |err| switch (err) {
        error.FileNotFound => return null,
        else => return err,
    };
    var parsed = try std.json.parseFromSliceLeaky(Config, arena, bytes, .{ .ignore_unknown_fields = true });
    parsed.memory = try expandHome(arena, parsed.memory);
    return parsed;
}

pub fn expandHome(arena: std.mem.Allocator, path: []const u8) ![]const u8 {
    if (!std.mem.startsWith(u8, path, "~/")) return path;
    const home = try std.process.getEnvVarOwned(arena, "HOME");
    return std.fs.path.join(arena, &.{ home, path[2..] });
}

test "a drawer holds its own path and the paths under it" {
    const config = Config{
        .ship = "",
        .cookie = "",
        .memory = "",
        .drawers = &.{.{ .path = "/projects/chorus" }},
    };
    try std.testing.expect(config.drawerFor("/projects/chorus/wick-signing") != null);
    try std.testing.expect(config.drawerFor("/projects/chorus") != null);
    try std.testing.expect(config.drawerFor("/projects/chorus-two/foo") == null);
    try std.testing.expect(config.drawerFor("/notes/foo") == null);
}

test "our own slips always sync; others need naming" {
    const closed = Drawer{ .path = "/a" };
    const open = Drawer{ .path = "/a", .who = &.{"~sampel"} };
    try std.testing.expect(trusted(closed, "~zod", "~zod"));
    try std.testing.expect(!trusted(closed, "~zod", "~sampel"));
    try std.testing.expect(trusted(open, "~zod", "~sampel"));
    try std.testing.expect(!trusted(open, "~zod", "~palnet"));
}
