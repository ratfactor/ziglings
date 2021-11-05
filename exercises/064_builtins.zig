//
// The Zig compiler provides "builtin" functions. You've already
// gotten used to seeing an @import() at the top of every
// Ziglings exercise.
//
// We've also seen @intCast() in "016_for2.zig", "058_quiz7.zig";
// and @enumToInt() in "036_enums2.zig".
//
// Builtins are special because they are intrinsic to the Zig
// language itself (as opposed to being provided in the standard
// library). They are also special because they can provide
// functionality that is only possible with help from the
// compiler, such as type introspection (the ability to examine
// type properties from within a program).
//
// Zig currently contains 101 builtin functions. We're certainly
// not going to cover them all, but we can look at some
// interesting ones.
//
// Before we begin, know that many builtin functions have
// parameters marked as "comptime". It's probably fairly clear
// what we mean when we say that these parameters need to be
// "known at compile time." But rest assured we'll be doing the
// "comptime" subject real justice soon.
//
const print = @import("std").debug.print;

pub fn main() void {
    // The first builtin, alphabetically, is:
    //
    //   @addWithOverflow(comptime T: type, a: T, b: T, result: *T) bool
    //     * 'T' will be the type of the other parameters.
    //     * 'a' and 'b' are numbers of the type T.
    //     * 'result' is a pointer to space you're providing of type T.
    //     * The return value is true if the addition resulted in a
    //       value over or under the capacity of type T.
    //
    // Let's try it with a tiny 4-bit integer size to make it clear:
    const a: u4 = 0b1101;
    const b: u4 = 0b0101;
    var my_result: u4 = undefined;
    var overflowed: bool = undefined;
    overflowed = @addWithOverflow(u4, a, b, &my_result);
    //
    // The print() below will produce: "1101 + 0101 = 0010 (true)".
    // Let's make sense of this answer by counting up from 1101:
    //
    //                     Overflowed?
    //    1101 + 1 = 1110      No.
    //    1110 + 1 = 1111      No.
    //    1111 + 1 = 0000      Yes! (Real answer is 10000)
    //    0000 + 1 = 0001      Yes!
    //    0001 + 1 = 0010      Yes!
    //
    // Also, check out our fancy formatting! b:0>4 means, "print
    // as a binary number, zero-pad right-aligned four digits."
    print("{b:0>4} + {b:0>4} = {b:0>4} ({})", .{ a, b, my_result, overflowed });

    print(". Furthermore, ", .{});

    // Here's a fun one:
    //
    //   @bitReverse(comptime T: type, integer: T) T
    //     * 'T' will be the type of the input and output.
    //     * 'integer' is the value to reverse.
    //     * The return value will be the same type with the
    //       value's bits reversed!
    //
    // Now it's your turn. See if you can fix this attempt to use
    // this builtin to reverse the bits of a u8 integer.
    const input: u8 = 0b11110000;
    const tupni: u8 = @bitReverse(input);
    print("{b:0>8} backwards is {b:0>8}.\n", .{ input, tupni });
}
