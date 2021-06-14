//
// Quiz time! Let's see if you can fix this whole program.
//
// You'll have to think about this one a bit.
//
// Let the compiler tell you what's wrong.
//
// Start at the top.
//
const std = @import("std");

pub fn main() void {
    // What is this nonsense? :-)
    const letters = "YZhifg";

    // Note: usize is an unsigned integer type used for...sizes.
    // The exact size of usize depends on the target CPU
    // architecture. We could have used a u8 here, but usize is
    // the idiomatic type to use for array indexing.
    //
    // There IS a problem on this line, but 'usize' isn't it.
    const x: usize = 1;

    // Note: When you want to declare memory (an array in this
    // case) without putting anything in it, you can set it to
    // 'undefined'. There is no problem on this line.
    var lang: [3]u8 = undefined;

    // The following lines attempt to put 'Z', 'i', and 'g' into the
    // 'lang' array we just created by indexing the array
    // 'letters' with the variable 'x'. As you can see above, x=1
    // to begin with.
    lang[0] = letters[x];

    x = 3;
    lang[???] = letters[x];

    x = ???;
    lang[2] = letters[???];

    // We want to "Program in Zig!" of course:
    std.debug.print("Program in {s}!\n", .{lang});
}
