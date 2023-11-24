//
// Check this out:
//
//     var foo: u8 = 5;      // foo is 5
//     var bar: *u8 = &foo;  // bar is a pointer
//
// What is a pointer? It's a reference to a value. In this example
// bar is a reference to the memory space that currently contains the
// value 5.
//
// A cheatsheet given the above declarations:
//
//     u8         the type of a u8 value
//     foo        the value 5
//     *u8        the type of a pointer to a u8 value
//     &foo       a reference to foo
//     bar        a pointer to the value at foo
//     bar.*      the value 5 (the dereferenced value "at" bar)
//
// We'll see why pointers are useful in a moment. For now, see if you
// can make this example work!
//
const std = @import("std");

pub fn main() void {
    var num1: u8 = 5;
    const num1_pointer: *u8 = &num1;

    var num2: u8 = undefined;

    // Please make num2 equal 5 using num1_pointer!
    // (See the "cheatsheet" above for ideas.)
    num2 = ???;

    std.debug.print("num1: {}, num2: {}\n", .{ num1, num2 });
}
