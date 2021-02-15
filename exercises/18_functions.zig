//
// Functions! We've already seen a lot of one called "main()". Now let's try
// writing one of our own:
//
//     fn foo(n: u8) u8 {
//         return n + 1;
//     }
//
// The foo() function above takes a number "n" and returns a number that is
// larger by one.
//
// If your function doesn't take any parameters and doesn't return anything,
// it would be defined like main():
//
//     fn foo() void { }
//
const std = @import("std");

pub fn main() void {
    // The new function deepThought() should return the number 42. See below.
    const answer: u8 = deepThought();

    std.debug.print("Answer to the Ultimate Question: {}\n", .{answer});
}

// Please define the deepThought() function below.
//
// We're just missing a couple things. One thing we're NOT missing is the
// keyword "pub", which is not needed here. Can you guess why?
//
??? deepThought() ??? {
    return 42; // Number courtesy Douglas Adams
}
