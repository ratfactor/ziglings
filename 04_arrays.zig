//
// Let's learn some array basics. Arrays literals are declared with:
//
//   [size]<type>{ values };
//
// When Zig can infer the size of the array, you can use '_' for the
// size like so:
//
//   [_]<type>{ values };
//
const std = @import("std");

pub fn main() void {
    const some_primes = [_]u8{ 2, 3, 5, 7, 11, 13, 17, 19 };

    // Array values are accessed using square bracket '[]' notation.
    //
    // (Note that when Zig can infer the type (u8 in this case) of a
    // value, we don't have to manually specify it.)
    //
    const first = some_primes[0];

    // Looks like we need to complete this expression:
    const fourth = ???;

    // Use '.len' to get the length of the array:
    const length = some_primes.???;

    std.debug.print("First: {}, Fourth: {}, Length: {}\n",
        .{first, fourth, length});
}
