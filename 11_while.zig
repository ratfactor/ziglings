//
// Zig 'while' statements create a loop that runs while the
// condition is true:
//
//     while (condition) {
//         condition = false;
//     }
//
// Remember that the condition must be a boolean value and
// that we can get a boolean value from conditional operators
// such as:
//
//     a == b   a equals b
//     a < b    a is less than b
//     a > b    a is greater than b
//     a !=b    a does not equal b
//
const std = @import("std");

pub fn main() void {
    var n: u32 = 2;

    while ( ??? ){
        // Print the current number
        std.debug.print("{} ", .{n});

        // Set n to n multiplied by 2
        n *= 2;
    }

    // Make this print n=1024
    std.debug.print("n={}\n", .{n});
}
