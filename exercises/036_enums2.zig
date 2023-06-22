//
// Enums are really just a set of numbers. You can leave the
// numbering up to the compiler, or you can assign them
// explicitly. You can even specify the numeric type used.
//
//     const Stuff = enum(u8){ foo = 16 };
//
// You can get the integer out with a builtin function,
// @intFromEnum(). We'll learn about builtins properly in a later
// exercise.
//
//     const my_stuff: u8 = @intFromEnum(Stuff.foo);
//
// Note how that built-in function starts with "@" just like the
// @import() function we've been using.
//
const std = @import("std");

// Zig lets us write integers in hexadecimal format:
//
//     0xf (is the value 15 in hex)
//
// Web browsers let us specify colors using a hexadecimal
// number where each byte represents the brightness of the
// Red, Green, or Blue component (RGB) where two hex digits
// are one byte with a value range of 0-255:
//
//     #RRGGBB
//
// Please define and use a pure blue value Color:
const Color = enum(u32) {
    red = 0xff0000,
    green = 0x00ff00,
    blue = ???,
};

pub fn main() void {
    // Remember Zig's multi-line strings? Here they are again.
    // Also, check out this cool format string:
    //
    //     {x:0>6}
    //      ^
    //      x       type ('x' is lower-case hexadecimal)
    //       :      separator (needed for format syntax)
    //        0     padding character (default is ' ')
    //         >    alignment ('>' aligns right)
    //          6   width (use padding to force width)
    //
    // Please add this formatting to the blue value.
    // (Even better, experiment without it, or try parts of it
    // to see what prints!)
    std.debug.print(
        \\<p>
        \\  <span style="color: #{x:0>6}">Red</span>
        \\  <span style="color: #{x:0>6}">Green</span>
        \\  <span style="color: #{}">Blue</span>
        \\</p>
        \\
    , .{
        @intFromEnum(Color.red),
        @intFromEnum(Color.green),
        @intFromEnum(???), // Oops! We're missing something!
    });
}
