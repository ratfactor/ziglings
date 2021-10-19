//
// It's important to note that variable pointers and constant pointers
// are different types.
//
// Given:
//
//     var foo: u8 = 5;
//     const bar: u8 = 5;
//
// Then:
//
//     &foo is of type "*u8"
//     &bar is of type "*const u8"
//
// You can always make a constant pointer to a variable, but you cannot
// make a variable pointer to a constant. This sounds like a logic puzzle,
// but it just means that once data is declared immutable, you can't
// coerce it to a mutable type. It's a safety thing (to prevent mistakes).
//
const std = @import("std");

pub fn main() void {
    const a: u8 = 12;
    const b: *const u8 = &a; // fix this!

    std.debug.print("a: {}, b: {}\n", .{ a, b.* });
}
