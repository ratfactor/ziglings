//
// Here's a fun one: Zig has multi-line strings!
//
// To make a multi-line string, put '\\' at the beginning of each
// line just like a code comment but with backslashes instead:
//
//     const two_lines =
//         \\Line One
//         \\Line Two
//     ;
//
// If you get the error: "expected expression, found ';'" 
// that means you used forward slashes, multi line strings are not comments 
//
// See if you can make this program print some song lyrics.
//
const std = @import("std");

pub fn main() void {
    const lyrics =
        Ziggy played guitar
        Jamming good with Andrew Kelley
        And the Spiders from Mars
    ;

    std.debug.print("{s}\n", .{lyrics});
}
