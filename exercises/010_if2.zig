//
// If statements are also valid expressions:
//
//     const foo: u8 = if (a) 2 else 3;
//
const std = @import("std");

pub fn main() void {
    const discount = true;

    // Please use an if...else expression to set "price".
    // If discount is true, the price should be $17, otherwise $20:
    const price: u8 = if ???;

    std.debug.print("With the discount, the price is ${}.\n", .{price});
}
