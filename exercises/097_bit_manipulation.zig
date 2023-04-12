//
// Bit manipulations is a very powerful tool just also from Zig.
// Since the dawn of the computer age, numerous algorithms have been
// developed that solve tasks solely by moving, setting, or logically
// combining bits.
//
// Zig also uses direct bit manipulation in its standard library for
// functions where possible. And it is often possible with calculations
// based on integers.
//
// Often it is not easy to understand at first glance what exactly these
// algorithms do when only "numbers" in memory areas change outwardly.
// But it must never be forgotten that the numbers only represent the
// interpretation of the bit sequences.
//
// Quasi the reversed case we have otherwise, namely that we represent
// numbers in bit sequences.
//
// We remember: 1 byte = 8 bits = 11111111 = 255 decimal = FF hex.
//
// Zig provides all the necessary functions to change the bits inside
// a variable. It is distinguished whether the bit change leads to an
// overflow or not.The details are in the Zig documentation in section
// 10.1 "Table of Operators".
//
// Here are some examples of how the bits of variables can be changed:
//
//          const numOne: u8 = 15;        //   =  0000 1111
//          const numTwo: u8 = 245;       //   =  1111 0101
//
//          const res1 = numOne >> 4;     //   =  0000 0000 - shift right
//          const res2 = numOne << 4;     //   =  1111 0000 - shift left
//          const res3 = numOne & numTwo; //   =  0000 0101 - and
//          const res4 = numOne | numTwo; //   =  1111 1111 - or
//          const res5 = numOne ^ numTwo; //   =  1111 1010 - xor
//
//
// To familiarize ourselves with bit manipulation, we start with a simple
// but often underestimated function and then add other exercises in
// loose order.
//
// The following text contains excerpts from Wikipedia.
//
// Swap
// In computer programming, the act of swapping two variables refers to
// mutually exchanging the values of the variables. Usually, this is
// done with the data in memory. For example, in a program, two variables
// may be defined thus (in pseudocode):
//
//                        data_item x := 1
//                        data_item y := 0
//
//                        swap (x, y);
//
// After swap() is performed, x will contain the value 0 and y will
// contain 1; their values have been exchanged. The simplest and probably
// most widely used method to swap two variables is to use a third temporary
// variable:
//
//                        define swap (x, y)
//                        temp := x
//                        x := y
//                        y := temp
//
// However, with integers we can also achieve the swap function simply by
// bit manipulation. To do this, the variables are mutually linked with xor
// and the result is the same.

const std = @import("std");
const print = std.debug.print;

pub fn main() !void {

    // As in the example above, we use 1 and 0 as values for x and y
    var x: u8 = 1;
    var y: u8 = 0;

    // Now we swap the values of the two variables by doing xor on them
    x ^= y;
    y ^= x;

    // What must be written here?
    ???;

    print("x = {d}; y = {d}\n", .{ x, y });
}

// This variable swap takes advantage of the fact that the value resulting
// from the xor of two values contains both of these values.
// This circumstance was (and still is) sometimes used for encryption.
// Value XOR Key = Crypto. => Crypto XOR Key = Value.
// Since this can be swapped arbitrarily, you can swap two variables in this way.
//
// For Crypto it is better not to use this, but in sorting algorithms like
// Bubble Sort it works very well.
