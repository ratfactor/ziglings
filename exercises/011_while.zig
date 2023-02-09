//
// Zig 'while' statements create a loop that runs while the
// condition is true. This runs once (at most):
//
//     while (condition) {
//         condition = false;
//     }
//
// Remember that the condition must be a boolean value and
// that we can get a boolean value from conditional operators
// such as:
//
//     a == b   means "a equals b"
//     a < b    means "a is less than b"
//     a > b    means "a is greater than b"
//     a != b   means "a does not equal b"
//
const std = @import("std");

pub fn main() void {
    var n: u32 = 2;

    // Please use a condition that is true UNTIL "n" reaches 1024:
    while (n < 1024) {
        // Print the current number
        std.debug.print("{} ", .{n});

        // Set n to n multiplied by 2
        n *= 2;
    }

    // Once the above is correct, this will print "n=1024"
    std.debug.print("n={}\n", .{n});
}
