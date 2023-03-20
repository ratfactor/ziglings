//
// The Zig language is in rapid development and continuously improves
// the language constructs steadily.
//
// Since version 0.11, the "for-loops" widely used in other languages
// such as C, e.g. "for (int i = 0; i < 10..." can now also be formed
// similarly in Zig, which previously required a "while" construct.
// Similar in this case actually means better, just as Zig generally
// tries to make everything simple and "better".
//
// These new "for-loops" look like the following in Zig:
//
//           for (0..10) |idx| {
//               // In this case 'idx' takes all values from 0 to 9.
//           }
//
// This is really simple and can replace the previous, somewhat bulky:
//
//           var idx: usize = 0;
//           while (idx < 10) : (idx += 1) {
//               // Again, idx takes all values from 0 to 9.
//           }
//
// This would also simplify exercise 13, for example.
// The best way to try this out is to use this exercise, which in the
// original looks like this:
//
//            ...
//            var n: u32 = 1;
//
//            // I want to print every number between 1 and 20 that is NOT
//            // divisible by 3 or 5.
//            while (n <= 20) : (n += 1) {
//                // The '%' symbol is the "modulo" operator and it
//                // returns the remainder after division.
//                if (n % 3 == 0) continue;
//                if (n % 5 == 0) continue;
//                std.debug.print("{} ", .{n});
//            }
//            ...
//
const std = @import("std");

// And now with the new "for-loop".
pub fn main() void {

    // I want to print every number between 1 and 20 that is NOT
    // divisible by 3 or 5.
    for (1..21) |n| {

        // The '%' symbol is the "modulo" operator and it
        // returns the remainder after division.
        if (n % 3 == 0) continue;
        if (n % 5 == 0) continue;
        std.debug.print("{} ", .{n});
    }

    std.debug.print("\n", .{});
}

// Is actually a little easier. The interesting thing here is that the other
// previous 'while' exercises (11,12, 14) cannot be simplified by this
// new "for-loop". Therefore it is good to be able to use both variations
// accordingly.
