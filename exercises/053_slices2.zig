//
// You are perhaps tempted to try slices on strings? They're arrays of
// u8 characters after all, right? Slices on strings work great.
// There's just one catch: don't forget that Zig string literals are
// immutable (const) values. So we need to change the type of slice
// from:
//
//     var foo: []u8 = "foobar"[0..3];
//
// to:
//
//     var foo: []const u8 = "foobar"[0..3];
//
// See if you can fix this Zero Wing-inspired phrase descrambler:
const std = @import("std");

pub fn main() void {
    const scrambled = "great base for all your justice are belong to us";

    const base1: []const u8 = scrambled[15..23];
    const base2: []const u8 = scrambled[6..10];
    const base3: []const u8 = scrambled[32..];
    printPhrase(base1, base2, base3);

    const justice1: []const u8 = scrambled[11..14];
    const justice2: []const u8 = scrambled[0..5];
    const justice3: []const u8 = scrambled[24..31];
    printPhrase(justice1, justice2, justice3);

    std.debug.print("\n", .{});
}

fn printPhrase(part1: []const u8, part2: []const u8, part3: []const u8) void {
    std.debug.print("'{s} {s} {s}.' ", .{ part1, part2, part3 });
}
