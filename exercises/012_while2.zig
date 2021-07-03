//
// Zig 'while' statements can have an optional 'continue expression'
// which runs every time the while loop continues (either at the
// end of the loop or when an explicit 'continue' is invoked - we'll
// try those out next):
//
//     while (condition) : (continue expression) {
//         ...
//     }
//
// Example:
//
//     var foo = 2;
//     while (foo<10) : (foo+=2) {
//         // Do something with even numbers less than 10...
//     }
//
// See if you can re-write the last exercise using a continue
// expression:
//
const std = @import("std");

pub fn main() void {
    var n: u32 = 2;

    // Please set the continue expression so that we get the desired
    // results in the print statement below.
    while (n < 1000) : (n *= 2) {
        // Print the current number
        std.debug.print("{} ", .{n});
    }

    // As in the last exercise, we want this to result in "n=1024"
    std.debug.print("n={}\n", .{n});
}
