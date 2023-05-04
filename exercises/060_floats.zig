//
// Zig has support for IEEE-754 floating-point numbers in these
// specific sizes: f16, f32, f64, f80, and f128. Floating point
// literals may be written in the same ways as integers but also
// in scientific notation:
//
//     const a1: f32 = 1200;       //    1,200
//     const a2: f32 = 1.2e+3;     //    1,200
//     const b1: f32 = -500_000.0; // -500,000
//     const b2: f32 = -5.0e+5;    // -500,000
//
// Hex floats can't use the letter 'e' because that's a hex
// digit, so we use a 'p' instead:
//
//     const hex: f16 = 0x2A.F7p+3; // Wow, that's arcane!
//
// Be sure to use a float type that is large enough to store your
// value (both in terms of significant digits and scale).
// Rounding may or may not be okay, but numbers which are too
// large or too small become inf or -inf (positive or negative
// infinity)!
//
//     const pi: f16 = 3.1415926535;   // rounds to 3.140625
//     const av: f16 = 6.02214076e+23; // Avogadro's inf(inity)!
//
// When performing math operations with numeric literals, ensure
// the types match. Zig does not perform unsafe type coercions
// behind your back:
//
//    var foo: f16 = 5; // NO ERROR
//
//    var foo: u16 = 5; // A literal of a different type
//    var bar: f16 = foo; // ERROR
//
// Please fix the two float problems with this program and
// display the result as a whole number.

const print = @import("std").debug.print;

pub fn main() void {
    // The approximate weight of the Space Shuttle upon liftoff
    // (including boosters and fuel tank) was 2,200 tons.
    //
    // We'll convert this weight from tons to kilograms at a
    // conversion of 907.18kg to the ton.
    var shuttle_weight: f16 = 907.18 * 2200;

    // By default, float values are formatted in scientific
    // notation. Try experimenting with '{d}' and '{d:.3}' to see
    // how decimal formatting works.
    print("Shuttle liftoff weight: {d:.0}kg\n", .{shuttle_weight});
}

// Floating further:
//
// As an example, Zig's f16 is a IEEE 754 "half-precision" binary
// floating-point format ("binary16"), which is stored in memory
// like so:
//
//         0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 0
//         | |-------| |-----------------|
//         |  exponent     significand
//         |
//          sign
//
// This example is the decimal number 3.140625, which happens to
// be the closest representation of Pi we can make with an f16
// due to the way IEEE-754 floating points store digits:
//
//   * Sign bit 0 makes the number positive.
//   * Exponent bits 10000 are a scale of 16.
//   * Significand bits 1001001000 are the decimal value 584.
//
// IEEE-754 saves space by modifying these values: the value
// 01111 is always subtracted from the exponent bits (in our
// case, 10000 - 01111 = 1, so our exponent is 2^1) and our
// significand digits become the decimal value _after_ an
// implicit 1 (so 1.1001001000 or 1.5703125 in decimal)! This
// gives us:
//
//     2^1 * 1.5703125 = 3.140625
//
// Feel free to forget these implementation details immediately.
// The important thing to know is that floating point numbers are
// great at storing big and small values (f64 lets you work with
// numbers on the scale of the number of atoms in the universe),
// but digits may be rounded, leading to results which are less
// precise than integers.
//
// Fun fact: sometimes you'll see the significand labeled as a
// "mantissa" but Donald E. Knuth says not to do that.
//
// C compatibility fact: There is also a Zig floating point type
// specifically for working with C ABIs called c_longdouble.
