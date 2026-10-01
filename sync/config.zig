// config: <project>/.claude/chorus/config.json, and the questions the
// sync core asks of it

const std = @import("std");

pub const dir_name = ".claude/chorus";
pub const file_name = "config.json";

pub const Drawer = struct {
    // a drawer in our cabinet, e.g. /projects/chorus
    path: []const u8,
    // the authors whose slips sync from it, each by groundwire id;
    // null means only ours
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
// move onto the ship without touching the sync core. .nym is the
// author's groundwire id as the ship gives it
pub fn trusted(drawer: Drawer, ours: bool, nym: []const u8) bool {
    if (ours) return true;
    const who = drawer.who orelse return false;
    for (who) |name| {
        if (names(name, nym)) return true;
    }
    return false;
}

// whether a nym in the config names an author. the words are the id.
// a one-dot name asks for an author the ship found under %gw-btc, so
// it turns away the same words at two dots; a two-dot or bare name
// takes either. an author with no nym comes here as an @p, which no
// name matches
fn names(name: []const u8, nym: []const u8) bool {
    if (nym.len == 0 or nym[0] != '.') return false;
    const words = std.mem.trimLeft(u8, name, ".");
    if (words.len == 0) return false;
    if (!std.mem.eql(u8, words, std.mem.trimLeft(u8, nym, "."))) return false;
    return !verified(name) or verified(nym);
}

fn verified(nym: []const u8) bool {
    return nym.len > 1 and nym[0] == '.' and nym[1] != '.';
}

pub const Error = error{
    // a drawer's .who holds an urbit id where a groundwire id belongs
    AuthorMustBeNym,
};

// a groundwire id is dotted words; an urbit id opens with a sig
pub fn checkAuthor(name: []const u8) Error!void {
    if (name.len == 0 or name[0] == '~') return Error.AuthorMustBeNym;
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
    for (parsed.drawers) |drawer| {
        for (drawer.who orelse continue) |name| try checkAuthor(name);
    }
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

test "our own slips always sync; others need naming by nym" {
    const closed = Drawer{ .path = "/a" };
    const open = Drawer{ .path = "/a", .who = &.{ "..abet.baboon", ".cabin.dawn", "early.fable" } };
    try std.testing.expect(trusted(closed, true, "..zeal.zebra"));
    try std.testing.expect(!trusted(closed, false, "..abet.baboon"));
    try std.testing.expect(trusted(open, false, "..abet.baboon"));
    try std.testing.expect(!trusted(open, false, "..abet.bacon"));
    // a two-dot or bare name takes the author at either standing
    try std.testing.expect(trusted(open, false, ".abet.baboon"));
    try std.testing.expect(trusted(open, false, "..early.fable"));
    // a one-dot name turns away the same words unverified
    try std.testing.expect(trusted(open, false, ".cabin.dawn"));
    try std.testing.expect(!trusted(open, false, "..cabin.dawn"));
    // an author with no nym goes by an @p, and no name reaches them
    const sigged = Drawer{ .path = "/a", .who = &.{ "..~zod", ".~zod" } };
    try std.testing.expect(!trusted(sigged, false, "~zod"));
    try std.testing.expect(trusted(sigged, true, "~zod"));
}

test "an urbit id is no author" {
    try std.testing.expectError(Error.AuthorMustBeNym, checkAuthor("~sampel"));
    try checkAuthor("..abet.baboon");
}
