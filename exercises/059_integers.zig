//
// Zig lets you express integer literals in several convenient
// formats. These are all the same value:
//
//     const a1: u8 = 65;        // decimal
//     const a2: u8 = 0x41;      // hexadecimal
//     const a3: u8 = 0o101;     // octal
//     const a4: u8 = 0b1000001; // binary
//     const a5: u8 = 'A';       // ASCII code point literal
//     const a6: u16 = 'Ȁ';      // Unicode code points can take up to 21 bits
//
// You can also place underscores in numbers to aid readability:
//
//     const t1: u32 = 14_689_520 // Ford Model T sales 1909-1927
//     const t2: u32 = 0xE0_24_F0 // same, in hex pairs
//
// Please fix the message:

const print = @import("std").debug.print;

pub fn main() void {
    const zig = [_]u8{
        0o131, // octal
        0b1101000, // binary
        0x66, // hex
    };

    print("{s} is cool.\n", .{zig});
}
