//
// Zig has some fun array operators.
//
// You can use '++' to concatenate two arrays:
//   const a = [_]u8{ 1,2 };
//   const b = [_]u8{ 3,4 };
//   const c = a ++ b ++ [_]u8{ 5 }; // 1,2,3,4,5
//
// You can use '**' to repeat an array:
//   const d = [_]u8{ 1,2,3 } ** 2; // 1,2,3,1,2,3
//
const std = @import("std");

pub fn main() void {
    const le = [_]u8{ 1, 3 };
    const et = [_]u8{ 3, 7 };

    // I want this to contain digits: 1 3 3 7
    const leet = ???;

    // I want this to contain digits: 1 0 0 1 1 0 0 1 1 0 0 1
    const bit_pattern = [_]u8{ ??? } ** 3;


    // We could print these arrays with leet[0], leet[1],...but let's
    // have a little preview of Zig 'for' loops instead!
    std.debug.print("LEET: ", .{});

    for (leet) |*n| {
        std.debug.print("{}", .{n.*});
    }

    std.debug.print(", Bits: ", .{});

    for (bit_pattern) |*n| {
        std.debug.print("{}", .{n.*});
    }

    std.debug.print("\n", .{});
}
