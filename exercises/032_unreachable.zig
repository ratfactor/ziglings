//
// Zig has an "unreachable" statement. Use it when you want to tell the
// compiler that a branch of code should never be executed and that the
// mere act of reaching it is an error.
//
//     if (true) {
//         ...
//     } else {
//         unreachable;
//     }
//
// Here we've made a little virtual machine that performs mathematical
// operations on a single numeric value. It looks great but there's one
// little problem: the switch statement doesn't cover every possible
// value of a u8 number!
//
// WE know there are only three operations but Zig doesn't. Use the
// unreachable statement to make the switch complete. Or ELSE. :-)
//
const std = @import("std");

pub fn main() void {
    const operations = [_]u8{ 1, 1, 1, 3, 2, 2 };

    var current_value: u32 = 0;

    for (operations) |op| {
        switch (op) {
            1 => {
                current_value += 1;
            },
            2 => {
                current_value -= 1;
            },
            3 => {
                current_value *= current_value;
            },
            else => unreachable,
        }

        std.debug.print("{} ", .{current_value});
    }

    std.debug.print("\n", .{});
}
