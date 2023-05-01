//
// We've seen that the 'for' loop can let us perform some action
// for every item in an array or slice.
//
// More recently, we discovered that it supports ranges to
// iterate over number sequences.
//
// This is part of a more general capability of the `for` loop:
// looping over one or more "objects" where an object is an
// array, slice, or range.
//
// In fact, we *did* use multiple objects way back in Exercise
// 016 where we iterated over an array and also a numeric index.
// It didn't always work exactly this way, so the exercise had to
// be retroactively modified a little bit.
//
//     for (bits, 0..) |bit, i| { ... }
//
// The general form of a 'for' loop with two lists is:
//
//     for (list_a, list_b) |a, b| {
//         // Here we have the first item from list_a and list_b,
//         // then the second item from each, then the third and
//         // so forth...
//     }
//
// What's really beautiful about this is that we don't have to
// keep track of an index or advancing a memory pointer for
// *either* of these lists. That error-prone stuff is all taken
// care of for us by the compiler.
//
// Below, we have a program that is supposed to compare two
// arrays. Please make it work!
//
const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    const hex_nums = [_]u8{ 0xb, 0x2a, 0x77 };
    const dec_nums = [_]u8{ 11, 42, 119 };

    for (hex_nums, ???) |hn, ???| {
        if (hn != dn) {
            std.debug.print("Uh oh! Found a mismatch: {d} vs {d}\n", .{ hn, dn });
            return;
        }
    }

    std.debug.print("Arrays match!\n", .{});
}
//
// You are perhaps wondering what happens if one of the two lists
// is longer than the other? Try it!
//
// By the way, congratulations for making it to Exercise 100!
//
//    +-------------+
//    | Celebration |
//    | Area  * * * |
//    +-------------+
//
// Please keep your celebrating within the area provided.
