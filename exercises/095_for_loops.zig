//
// The Zig language is in rapid development and continuously
// improves the language constructs. Ziglings evolves with it.
//
// Until version 0.11, Zig's 'for' loops did not directly
// replicate the functionality of the C-style: "for(a;b;c)"
// which are so well suited for iterating over a numeric
// sequence.
//
// Instead, 'while' loops with counters clumsily stood in their
// place:
//
//     var i: usize = 0;
//     while (i < 10) : (i += 1) {
//         // Here variable 'i' will have each value 0 to 9.
//     }
//
// But here we are in the glorious future and Zig's 'for' loops
// can now take this form:
//
//     for (0..10) |i| {
//         // Here variable 'i' will have each value 0 to 9.
//     }
//
// The key to understanding this example is to know that '0..9'
// uses the new range syntax:
//
//     0..10 is a range from 0 to 9
//     1..4  is a range from 1 to 3
//
// At the moment, ranges are only supported in 'for' loops.
//
// Perhaps you recall Exercise 13? We were printing a numeric
// sequence like so:
//
//     var n: u32 = 1;
//
//     // I want to print every number between 1 and 20 that is NOT
//     // divisible by 3 or 5.
//     while (n <= 20) : (n += 1) {
//         // The '%' symbol is the "modulo" operator and it
//         // returns the remainder after division.
//         if (n % 3 == 0) continue;
//         if (n % 5 == 0) continue;
//         std.debug.print("{} ", .{n});
//     }
//
//  Let's try out the new form of 'for' to re-implement that
//  exercise:
//
const std = @import("std");

pub fn main() void {

    // I want to print every number between 1 and 20 that is NOT
    // divisible by 3 or 5.
    for (???) |n| {

        // The '%' symbol is the "modulo" operator and it
        // returns the remainder after division.
        if (n % 3 == 0) continue;
        if (n % 5 == 0) continue;
        std.debug.print("{} ", .{n});
    }

    std.debug.print("\n", .{});
}
//
// That's a bit nicer, right?
//
// Of course, both 'while' and 'for' have different advantages.
// Exercises 11, 12, and 14 would NOT be simplified by switching
// a 'while' for a 'for'.
