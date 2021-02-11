//
// Quiz time! Let's see if you can fix this whole program.
//
// This is meant to be challenging.
//
// Let the compiler tell you what's wrong.
//
// Start at the top.
//
const std = @import("std");

pub fn main() void {
    // What is this nonsense? :-)
    const letters = "YZhifg";

    const x: u8 = 1;

    // This is something you haven't seen before: declaring an array
    // without putting anything in it. There is no error here:
    var lang: [3]u8 = undefined;

    // The following lines attempt to put 'Z', 'i', and 'g' into the
    // 'lang' array we just created.
    lang[0] = letters[x];

    x = 3;
    lang[???] = letters[x];

    x = ???;
    lang[2] = letters[???];

    // We want to "Program in Zig!" of course:
    std.debug.print("Program in {s}!\n", .{lang});
}
