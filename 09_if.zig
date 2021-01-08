//
// Now we get into the fun stuff, starting with the 'if' statement!
//
//   if (true) {
//      // stuff
//   } else {
//      // other stuff
//   }
//
// Zig has the usual comparison operators such as:
//
//   a == b   a equals b
//   a < b    a is less than b
//   a !=b    a does not equal b
//
// The important thing about Zig's 'if' is that it *only* accepts
// boolean values. It won't coerce numbers or other types of data
// to true and false.
//
const std = @import("std");

pub fn main() void {
    const foo = 1;

    if (foo) {
        // We want out program to print this message!
        std.debug.print("Foo is 1!\n", .{});
    } else {
        std.debug.print("Foo is not 1!\n", .{});
    }
}
