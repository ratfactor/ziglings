//
// Zig has some fun array operators.
//
// You can use '++' to concatenate two arrays:
//
//   const a = [_]u8{ 1,2 };
//   const b = [_]u8{ 3,4 };
//   const c = a ++ b ++ [_]u8{ 5 }; // equals 1 2 3 4 5
//
// You can use '**' to repeat an array:
//
//   const d = [_]u8{ 1,2,3 } ** 2; // equals 1 2 3 1 2 3
//
const std = @import("std");

pub fn main() void {
    const le = [_]u8{ 1, 3 };
    const et = [_]u8{ 3, 7 };

    // (Problem 1)
    // Please set this array concatenating the two arrays above.
    // It should result in: 1 3 3 7
    const leet = ???;

    // (Problem 2)
    // Please set this array using repetition.
    // It should result in: 1 0 0 1 1 0 0 1 1 0 0 1
    const bit_pattern = [_]u8{ ??? } ** 3;

    // Okay, that's all of the problems. Let's see the results.
    //
    // We could print these arrays with leet[0], leet[1],...but let's
    // have a little preview of Zig 'for' loops instead:
    //
    //    for (<item array>) |item| { <do something with item> }
    //
    // Don't worry, we'll cover looping properly in upcoming
    // lessons.
    //
    std.debug.print("LEET: ", .{});

    for (leet) |n| {
        std.debug.print("{}", .{n});
    }

    std.debug.print(", Bits: ", .{});

    for (bit_pattern) |n| {
        std.debug.print("{}", .{n});
    }

    std.debug.print("\n", .{});
}
