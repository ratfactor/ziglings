const std = @import("std");
const print = std.debug.print;
const string = []const u8;

const cwd = std.fs.cwd();
const Dir = std.fs.Dir;
const Allocator = std.mem.Allocator;

const EXERCISES_PATH = "exercises";
const HEALED_PATH = "patches/healed";
const TEMP_PATH = "patches/healed/tmp";
const PATCHES_PATH = "patches/patches";

// Heals all the exercises.
fn heal(alloc: Allocator) !void {
    try cwd.makePath(HEALED_PATH);

    const org_path = try cwd.realpathAlloc(alloc, EXERCISES_PATH);
    const patch_path = try cwd.realpathAlloc(alloc, PATCHES_PATH);
    const healed_path = try cwd.realpathAlloc(alloc, HEALED_PATH);

    var idir = try cwd.openIterableDir(EXERCISES_PATH, Dir.OpenDirOptions{});
    defer idir.close();

    var it = idir.iterate();
    while (try it.next()) |entry| {

        // create filenames
        const healed_file = try concat(alloc, &.{ healed_path, "/", entry.name });
        const patch_file = try concat(alloc, &.{ patch_path, "/", try patch_name(alloc, entry.name) });

        // patch file
        const result = try std.ChildProcess.exec(.{
            .allocator = alloc,
            .argv = &.{ "patch", "-i", patch_file, "-o", healed_file, entry.name },
            .cwd = org_path,
        });

        print("{s}", .{result.stderr});
    }
}

// Yields all the healed exercises that are not correctly formatted.
fn check_healed(alloc: Allocator) !void {
    try cwd.makePath(TEMP_PATH);

    const temp_path = try cwd.realpathAlloc(alloc, TEMP_PATH);
    const healed_path = try cwd.realpathAlloc(alloc, HEALED_PATH);

    var idir = try cwd.openIterableDir(HEALED_PATH, Dir.OpenDirOptions{});
    defer idir.close();

    var it = idir.iterate();
    while (try it.next()) |entry| {

        // Check the healed file
        const result = try std.ChildProcess.exec(.{
            .allocator = alloc,
            .argv = &.{ "zig", "fmt", "--check", entry.name },
            .cwd = healed_path,
        });

        // Is there something to fix?
        if (result.stdout.len > 0) {
            const temp_file = try concat(alloc, &.{ temp_path, "/", entry.name });
            const healed_file = try concat(alloc, &.{ healed_path, "/", entry.name });
            try std.fs.copyFileAbsolute(healed_file, temp_file, std.fs.CopyFileOptions{});

            // Formats the temp file
            _ = try std.ChildProcess.exec(.{
                .allocator = alloc,
                .argv = &.{ "zig", "fmt", entry.name },
                .cwd = temp_path,
            });

            // Show the differences
            const diff = try std.ChildProcess.exec(.{
                .allocator = alloc,
                .argv = &.{ "diff", "-c", healed_file, entry.name },
                .cwd = temp_path,
            });

            print("{s}", .{diff.stdout});
            try std.fs.deleteFileAbsolute(temp_file);
        }
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
    try check_healed(alloc);
}
