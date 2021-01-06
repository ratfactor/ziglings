//
// Let's learn some array basics. Arrays are declared with:
//
//   const foo [size]<type> = [size]<type>{ values };
//
// When Zig can infer the size of the array, you can use '_' for the
// size. You can also let Zig infer the type of the value so the
// declaration is much less verbose.
//
//   const foo = [_]<type>{ values };
//
const std = @import("std");

pub fn main() void {

    const some_primes = [_]u8{ 1, 3, 5, 7, 11, 13, 17, 19 };

    // Individual values can be set with '[]' notation. Let's fix
    // the first prime (it should be 2!):
    some_primes[0] = 2;

    // Individual values can also be accessed with '[]' notation.
    const first = some_primes[0];

    // Looks like we need to complete this expression (like 'first'):
    const fourth = ???;

    // Use '.len' to get the length of the array:
    const length = some_primes.???;

    std.debug.print("First: {}, Fourth: {}, Length: {}\n",
        .{first, fourth, length});
}
