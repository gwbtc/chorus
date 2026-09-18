// ship: the sync core's view of an urbit ship. scries the chorus agent
// over eyre, and holds one eyre channel subscribed to /cabinet. knows
// nothing about where slips end up on disk

const std = @import("std");

pub const Error = error{
    // the ship refused the cookie
    Unauthorized,
    // the ship answered with something we did not expect
    BadResponse,
};

// one slip as the chorus json marks give it, at its cabinet tree path
pub const Slip = struct {
    path: []const u8,
    author: []const u8,
    created: []const u8,
    fqsp: []const u8,
    wire: []const u8,
    text: []const u8,
};

pub const Event = union(enum) {
    slip: Slip,
    discard: []const u8,
};

pub const Ship = struct {
    gpa: std.mem.Allocator,
    client: std.http.Client,
    // base url with no trailing slash, e.g. http://localhost:8080
    url: []const u8,
    // the whole cookie pair, e.g. urbauth-~zod=0v...
    cookie: []const u8,

    pub fn init(gpa: std.mem.Allocator, url: []const u8, cookie: []const u8) Ship {
        return .{
            .gpa = gpa,
            .client = .{ .allocator = gpa },
            .url = std.mem.trimRight(u8, url, "/"),
            .cookie = cookie,
        };
    }

    pub fn deinit(self: *Ship) void {
        self.client.deinit();
    }

    // the ship's name, read off the cookie: ~zod
    pub fn name(self: *const Ship) ![]const u8 {
        const prefix = "urbauth-";
        if (!std.mem.startsWith(u8, self.cookie, prefix)) return Error.BadResponse;
        const end = std.mem.indexOfScalar(u8, self.cookie, '=') orelse return Error.BadResponse;
        return self.cookie[prefix.len..end];
    }

    // every slip under one drawer of our cabinet
    pub fn drawer(self: *Ship, arena: std.mem.Allocator, path: []const u8, out: *std.ArrayList(Slip)) !void {
        const trimmed = std.mem.trimRight(u8, path, "/");
        const url = try std.fmt.allocPrint(arena, "{s}/~/scry/chorus/cabinet/drawer{s}.json", .{ self.url, trimmed });
        const body = try self.get(arena, url);
        const tree = std.json.parseFromSliceLeaky(std.json.Value, arena, body, .{}) catch return Error.BadResponse;
        try walk(arena, tree, trimmed, out);
    }

    fn get(self: *Ship, arena: std.mem.Allocator, url: []const u8) ![]const u8 {
        var body: std.Io.Writer.Allocating = .init(arena);
        const res = try self.client.fetch(.{
            .location = .{ .url = url },
            .redirect_behavior = .unhandled,
            .extra_headers = &.{.{ .name = "cookie", .value = self.cookie }},
            .response_writer = &body.writer,
        });
        try checkStatus(res.status);
        return body.written();
    }

    fn put(self: *Ship, url: []const u8, payload: []const u8) !void {
        const res = try self.client.fetch(.{
            .location = .{ .url = url },
            .method = .PUT,
            .payload = payload,
            .redirect_behavior = .unhandled,
            .extra_headers = &.{
                .{ .name = "cookie", .value = self.cookie },
                .{ .name = "content-type", .value = "application/json" },
            },
        });
        try checkStatus(res.status);
    }

    // subscribe to /cabinet and hand every fact to .handler until the
    // ship closes the stream. .ready runs once the subscription is
    // open, so the caller can catch up without missing a fact
    pub fn watch(
        self: *Ship,
        ctx: anytype,
        comptime ready: fn (@TypeOf(ctx)) anyerror!void,
        comptime handler: fn (@TypeOf(ctx), std.mem.Allocator, Event) anyerror!void,
    ) !void {
        var arena_state = std.heap.ArenaAllocator.init(self.gpa);
        defer arena_state.deinit();
        const arena = arena_state.allocator();

        var rand: [8]u8 = undefined;
        std.crypto.random.bytes(&rand);
        const channel = try std.fmt.allocPrint(arena, "{s}/~/channel/chorus-{d}-{x}", .{
            self.url, std.time.timestamp(), std.mem.readInt(u64, &rand, .little),
        });
        const who = try self.name();
        const subscribe = try std.fmt.allocPrint(
            arena,
            "[{{\"id\":1,\"action\":\"subscribe\",\"ship\":\"{s}\",\"app\":\"chorus\",\"path\":\"/cabinet\"}}]",
            .{std.mem.trimLeft(u8, who, "~")},
        );
        try self.put(channel, subscribe);

        var req = try self.client.request(.GET, try std.Uri.parse(channel), .{
            .redirect_behavior = .unhandled,
            .keep_alive = false,
            .headers = .{ .accept_encoding = .{ .override = "identity" } },
            .extra_headers = &.{
                .{ .name = "cookie", .value = self.cookie },
                .{ .name = "accept", .value = "text/event-stream" },
            },
        });
        defer req.deinit();
        try req.sendBodiless();
        var response = try req.receiveHead(&.{});
        try checkStatus(response.head.status);

        try ready(ctx);

        var transfer: [16 * 1024]u8 = undefined;
        const reader = response.reader(&transfer);
        var pending: std.ArrayList(u8) = .empty;
        defer pending.deinit(self.gpa);
        var event_id: ?u64 = null;
        var next_id: u64 = 2;

        while (true) {
            const chunk = reader.peekGreedy(1) catch |err| switch (err) {
                error.EndOfStream => return,
                else => return err,
            };
            try pending.appendSlice(self.gpa, chunk);
            reader.toss(chunk.len);

            while (std.mem.indexOfScalar(u8, pending.items, '\n')) |end| {
                const line = std.mem.trimRight(u8, pending.items[0..end], "\r");
                if (std.mem.startsWith(u8, line, "id:")) {
                    event_id = std.fmt.parseInt(u64, std.mem.trim(u8, line[3..], " "), 10) catch null;
                } else if (std.mem.startsWith(u8, line, "data:")) {
                    var event_arena = std.heap.ArenaAllocator.init(self.gpa);
                    defer event_arena.deinit();
                    const quit = try self.dispatch(event_arena.allocator(), line[5..], ctx, handler);
                    if (event_id) |eid| {
                        const ack = try std.fmt.allocPrint(
                            event_arena.allocator(),
                            "[{{\"id\":{d},\"action\":\"ack\",\"event-id\":{d}}}]",
                            .{ next_id, eid },
                        );
                        next_id += 1;
                        try self.put(channel, ack);
                    }
                    // a kicked subscription ends the watch; the
                    // caller opens a fresh one
                    if (quit) return;
                }
                const rest = pending.items[end + 1 ..];
                std.mem.copyForwards(u8, pending.items[0..rest.len], rest);
                pending.shrinkRetainingCapacity(rest.len);
            }
        }
    }

    // returns whether the ship closed our subscription
    fn dispatch(
        self: *Ship,
        arena: std.mem.Allocator,
        data: []const u8,
        ctx: anytype,
        comptime handler: fn (@TypeOf(ctx), std.mem.Allocator, Event) anyerror!void,
    ) !bool {
        _ = self;
        const msg = std.json.parseFromSliceLeaky(std.json.Value, arena, data, .{}) catch return false;
        if (msg != .object) return false;
        const response = str(msg.object.get("response")) orelse return false;
        if (std.mem.eql(u8, response, "quit")) return true;
        if (!std.mem.eql(u8, response, "diff")) return false;
        const fact = msg.object.get("json") orelse return false;
        if (fact != .object) return false;
        const kind = str(fact.object.get("type")) orelse return false;
        if (std.mem.eql(u8, kind, "chorus-slip")) {
            const path = str(fact.object.get("path")) orelse return false;
            const slip = slipOf(fact, path) orelse return false;
            try handler(ctx, arena, .{ .slip = slip });
        } else if (std.mem.eql(u8, kind, "chorus-slip-discarded")) {
            const path = str(fact.object.get("path")) orelse return false;
            try handler(ctx, arena, .{ .discard = path });
        }
        return false;
    }
};

fn checkStatus(status: std.http.Status) !void {
    switch (status.class()) {
        .success => {},
        // eyre redirects a stale session to the login page
        .redirect => return Error.Unauthorized,
        else => switch (status) {
            .unauthorized, .forbidden => return Error.Unauthorized,
            else => return Error.BadResponse,
        },
    }
}

fn str(value: ?std.json.Value) ?[]const u8 {
    const v = value orelse return null;
    return if (v == .string) v.string else null;
}

fn slipOf(value: std.json.Value, path: []const u8) ?Slip {
    if (value != .object) return null;
    const o = value.object;
    return .{
        .path = path,
        .author = str(o.get("author")) orelse return null,
        .created = str(o.get("created")) orelse return null,
        .fqsp = str(o.get("fqsp")) orelse return null,
        .wire = str(o.get("wire")) orelse return null,
        .text = str(o.get("text")) orelse return null,
    };
}

// flatten the cabinet mark's nested json: {slip, dir: {segment: tree}}
fn walk(arena: std.mem.Allocator, tree: std.json.Value, path: []const u8, out: *std.ArrayList(Slip)) !void {
    if (tree != .object) return Error.BadResponse;
    if (tree.object.get("slip")) |leaf| {
        if (slipOf(leaf, path)) |slip| try out.append(arena, slip);
    }
    const dir = tree.object.get("dir") orelse return;
    if (dir != .object) return;
    var it = dir.object.iterator();
    while (it.next()) |kid| {
        const kid_path = try std.fmt.allocPrint(arena, "{s}/{s}", .{ path, kid.key_ptr.* });
        try walk(arena, kid.value_ptr.*, kid_path, out);
    }
}

// log in with the ship's +code and return the session cookie pair
pub fn login(gpa: std.mem.Allocator, url: []const u8, code: []const u8) ![]const u8 {
    var client: std.http.Client = .{ .allocator = gpa };
    defer client.deinit();
    const target = try std.fmt.allocPrint(gpa, "{s}/~/login", .{std.mem.trimRight(u8, url, "/")});
    defer gpa.free(target);
    const payload = try std.fmt.allocPrint(gpa, "password={s}&redirect=/", .{code});
    defer gpa.free(payload);

    var req = try client.request(.POST, try std.Uri.parse(target), .{
        .redirect_behavior = .unhandled,
        .keep_alive = false,
        .extra_headers = &.{.{ .name = "content-type", .value = "application/x-www-form-urlencoded" }},
    });
    defer req.deinit();
    req.transfer_encoding = .{ .content_length = payload.len };
    var body = try req.sendBodyUnflushed(&.{});
    try body.writer.writeAll(payload);
    try body.end();
    try req.connection.?.flush();
    const response = try req.receiveHead(&.{});

    var headers = response.head.iterateHeaders();
    while (headers.next()) |header| {
        if (!std.ascii.eqlIgnoreCase(header.name, "set-cookie")) continue;
        if (!std.mem.startsWith(u8, header.value, "urbauth-")) continue;
        const end = std.mem.indexOfScalar(u8, header.value, ';') orelse header.value.len;
        return gpa.dupe(u8, header.value[0..end]);
    }
    return Error.Unauthorized;
}
