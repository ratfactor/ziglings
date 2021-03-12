//
// Oh no! This program is supposed to print "Hello world!" but it needs
// your help!
//
//
// Zig functions are private by default but the main() function should
// be public.
//
// A function is declared public with the "pub" statement like so:
//
//     pub fn foo() void {
//         ...
//     }
//
// Try to fix the program and run `ziglings` to see if it works!
//
const std = @import("std");

fn main() void {
    std.debug.print("Hello world!\n", .{});
}
