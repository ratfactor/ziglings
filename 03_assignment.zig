//
// Oh dear! It seems we got a little carried away making const u8 values.
//     * const means constant (cannot be changed)
//     * u8 means unsigned (cannot be negative), 8-bit integer
//
// Hint 1: Use 'var' for values that can change.
// Hint 2: Use enough bits to hold the value you want:
//             u8             255
//             u16         65,535
//             u32  4,294,967,295
// Hint 3: Use 'i' (e.g. 'i8', 'i16') for signed integers.
//
const std = @import("std");

pub fn main() void {
    const n: u8 = 50;
    n = n + 5;

    const pi: u8 = 314159;

    const negative_eleven: u8 = -11;

    // There are no errors in the next line, just explanation:
    // Perhaps you noticed before that the print function takes two
    // parameters. Now it will make more sense: the first parameter
    // is a string. The string may contain placeholders '{}', and the
    // second parameter is an anonymous struct (data structure)
    // with values to be printed in place of the placeholders.
    std.debug.print("{} {} {}\n", .{n, pi, negative_eleven});
}
