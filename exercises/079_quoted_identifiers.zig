//
// Sometimes you need to create an identifier that will not, for
// whatever reason, play by the naming rules:
//
//     const 55_cows: i32 = 55; // ILLEGAL: starts with a number
//     const isn't true: bool = false; // ILLEGAL: what even?!
//
// If you try to create either of these under normal
// circumstances, a special Program Identifier Syntax Security
// Team (PISST) will come to your house and take you away.
//
// Thankfully, Zig has a way to sneak these wacky identifiers
// past the authorities: the @"" identifier quoting syntax.
//
//     @"foo"
//
// Please help us safely smuggle these fugitive identifiers into
// our program:
//
const print = @import("std").debug.print;

pub fn main() void {
    const @"55_cows": i32 = 55;
    const @"isn't true": bool = false;

    print("Sweet freedom: {}, {}.\n", .{
        @"55_cows",
        @"isn't true",
    });
}
