//
// If statements are also valid expressions:
//
//     var foo: u8 = if (a) 2 else 3;
//
// Note: You'll need to declare a variable type when assigning a value
// from a statement like this because the compiler isn't smart enough
// to infer the type for you.
//
// This WON'T work:
//
//     var foo = if (a) 2 else 3; // error!
//
const std = @import("std");

pub fn main() void {
    var discount = true;

    // Please use an if...else expression to set "price".
    // If discount is true, the price should be $17, otherwise $20:
    var price = if ???;

    std.debug.print("With the discount, the price is ${}.\n", .{price});
}

