//
// It seems we got a little carried away making everything "const u8"!
//
//     "const" values cannot change.
//     "u"     types are "unsigned" and cannot store negative values.
//     "8"     means the type is 8 bits in size.
//
// Example: foo cannot change (it is CONSTant)
//          bar can change (it is VARiable):
//
//     const foo: u8 = 20;
//     var bar: u8 = 20;
//
// Example: foo cannot be negative and can hold 0 to 255
//          bar CAN be negative and can hold −128 to 127
//
//     const foo: u8 = 20;
//     const bar: i8 = -20;
//
// Example: foo can hold 8 bits (0 to 255)
//          bar can hold 16 bits (0 to 65,535)
//
//     const foo: u8 = 20;
//     const bar: u16 = 2000;
//
// You can do just about any combination of these that you can think of:
//
//     u32 can hold 0 to 4,294,967,295
//     i64 can hold −9,223,372,036,854,775,808 to 9,223,372,036,854,775,807
//
// Please fix this program so that the types can hold the desired values
// and the errors go away!
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
    // second parameter is an "anonymous list literal" (don't worry
    // about this for now!) with the values to be printed.
    std.debug.print("{} {} {}\n", .{ n, pi, negative_eleven });
}
