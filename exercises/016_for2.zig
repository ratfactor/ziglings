//
// For-loops can iterate over multiple things at the same time as
// long as they are the same length:
//
//   - Error: for ([3]u8{ 1, 0, 1 }, [2]u8{ 1, 0 }) |_, _| {}
//   - Compiles: for ([2]u8{ 1, 0 }, [2]u8{ 1, 0 }) |_, _| {}
//
//
// A range of numbers is represented with a starting integer and an
// (excluded) ending integer.
//
//     0..10, in a for loop, behaves like this array
//     [10]usize{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
//
// The ending integer can be left out when it can be infered by the
// length of the array it is paired with. This can be used to capture
// the current index of your iteration.
//
//     for ([2]u8{ 1, 0 }, 0..) |bit, index| {}
//
const std = @import("std");

pub fn main() void {
    // Let's store the bits of binary number 1101 in
    // 'little-endian' order (least significant byte first):
    const bits = [_]u8{ 1, 0, 1, 1 };
    var value: u32 = 0;

    // Now we'll convert the binary bits to a number value by adding
    // the value of the place as a power of two for each bit.
    //
    // See if you can figure out the missing pieces:
    for (bits, ???) |bit, ???| {
        // Note that we convert the usize i to a u32 with
        // @intCast(), a builtin function just like @import().
        // We'll learn about these properly in a later exercise.
        var place_value = std.math.pow(u32, 2, @intCast(u32, i));
        value += place_value * bit;
    }

    std.debug.print("The value of bits '1101': {}.\n", .{value});
}
