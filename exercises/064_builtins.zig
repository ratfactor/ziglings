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
    // The second builtin, alphabetically, is:
    //   @addWithOverflow(a: anytype, b: anytype) struct { @TypeOf(a, b), u1 }
    //     * 'T' will be the type of the other parameters.
    //     * 'a' and 'b' are numbers of the type T.
    //     * The return value is a tuple with the result and a possible overflow bit.
    //
    // Let's try it with a tiny 4-bit integer size to make it clear:
    const a: u4 = 0b1101;
    const b: u4 = 0b0101;
    const my_result = @addWithOverflow(a, b);

    // Check out our fancy formatting! b:0>4 means, "print
    // as a binary number, zero-pad right-aligned four digits."
    // The print() below will produce: "1101 + 0101 = 0010 (true)".
    print("{b:0>4} + {b:0>4} = {b:0>4} ({s})", .{ a, b, my_result[0], if (my_result[1] == 1) "true" else "false" });

    // Let's make sense of this answer. The value of 'b' in decimal is 5.
    // Let's add 5 to 'a' but go one by one and see where it overflows:
    //
    //   a  |  b   | result | overflowed?
    // ----------------------------------
    // 1101 + 0001 =  1110  | false
    // 1110 + 0001 =  1111  | false
    // 1111 + 0001 =  0000  | true  (the real answer is 10000)
    // 0000 + 0001 =  0001  | false
    // 0001 + 0001 =  0010  | false
    //
    // In the last two lines the value of 'a' is corrupted because there was
    // an overflow in line 3, but the operations of lines 4 and 5 themselves
    // do not overflow.
    // There is a difference between
    //  - a value, that overflowed at some point and is now corrupted
    //  - a single operation that overflows and maybe causes subsequent errors
    // In practise we usually notice the overflowed value first and have to work
    // our way backwards to the operation that caused the overflow.
    //
    // If there was no overflow at all while adding 5 to a, what value would
    // 'my_result' hold? Write the answer in into 'expected_result'.
    const expected_result: u8 = ???;
    print(". Without overflow: {b:0>8}. ", .{expected_result});

    print("Furthermore, ", .{});

    // Here's a fun one:
    //
    //   @bitReverse(integer: anytype) T
    //     * 'integer' is the value to reverse.
    //     * The return value will be the same type with the
    //       value's bits reversed!
    //
    // Now it's your turn. See if you can fix this attempt to use
    // this builtin to reverse the bits of a u8 integer.
    const input: u8 = 0b11110000;
    const tupni: u8 = @bitReverse(input, tupni);
    print("{b:0>8} backwards is {b:0>8}.\n", .{ input, tupni });
}
