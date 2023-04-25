const std = @import("std");
const print = std.debug.print;
const string = []const u8;

const cwd = std.fs.cwd();
const Dir = std.fs.Dir;
const Allocator = std.mem.Allocator;

const EXERCISES_PATH = "exercises";
const ANSWERS_PATH = "answers";
const PATCHES_PATH = "patches/patches";

// Heals all the exercises.
fn heal(alloc: Allocator) !void {
    try cwd.makePath(ANSWERS_PATH);

    const org_path = try cwd.realpathAlloc(alloc, EXERCISES_PATH);
    const patch_path = try cwd.realpathAlloc(alloc, PATCHES_PATH);
    const healed_path = try cwd.realpathAlloc(alloc, ANSWERS_PATH);

    var idir = try cwd.openIterableDir(EXERCISES_PATH, Dir.OpenDirOptions{});
    defer idir.close();

    var it = idir.iterate();
    while (try it.next()) |entry| {

        // create filenames
        const healed_file = try concat(alloc, &.{ healed_path, "/", entry.name });
        const patch_file = try concat(alloc, &.{ patch_path, "/", try patch_name(alloc, entry.name) });

        // patch the file
        const result = try std.ChildProcess.exec(.{
            .allocator = alloc,
            .argv = &.{ "patch", "-i", patch_file, "-o", healed_file, entry.name },
            .cwd = org_path,
        });

        print("{s}", .{result.stderr});
    }
}

// Creates new patch files for every exercise
fn update(alloc: Allocator) !void {
    const org_path = try cwd.realpathAlloc(alloc, EXERCISES_PATH);
    const healed_path = try cwd.realpathAlloc(alloc, ANSWERS_PATH);
    const patch_path = try cwd.realpathAlloc(alloc, PATCHES_PATH);

    var idir = try cwd.openIterableDir(EXERCISES_PATH, Dir.OpenDirOptions{});
    defer idir.close();

    var it = idir.iterate();
    while (try it.next()) |entry| {

        // create diff
        const org_file = try concat(alloc, &.{ org_path, "/", entry.name });
        const healed_file = try concat(alloc, &.{ healed_path, "/", entry.name });
        const result = try std.ChildProcess.exec(.{
            .allocator = alloc,
            .argv = &.{ "diff", org_file, healed_file },
        });
        std.debug.assert(result.term.Exited == 1);

        // write diff to file
        const patch_file = try concat(alloc, &.{ patch_path, "/", try patch_name(alloc, entry.name) });
        var file = try std.fs.cwd().createFile(patch_file, .{ .read = false });
        defer file.close();
        try file.writer().print("{s}", .{result.stdout});
    }
}

fn concat(alloc: Allocator, slices: []const string) !string {
    const buf = try std.mem.concat(alloc, u8, slices);
    return buf;
}

fn patch_name(alloc: Allocator, path: string) !string {
    var filename = path;
    const index = std.mem.lastIndexOfScalar(u8, path, '.') orelse return path;
    if (index > 0) filename = path[0..index];
    return try concat(alloc, &.{ filename, ".patch" });
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    try heal(alloc);
    try update(alloc);
}
