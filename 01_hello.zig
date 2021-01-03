//
// Oh no! This program is supposed to print "Hello world!" but it needs
// your help!
//
// Hint: Zig functions are private by default.
//       The main() function should be public.
//       Declare a public function with "pub fn ..."
//
// Try to fix the program and run `ziglings` to see if it passes.
//
const std = @import("std");

fn main() void {
    std.debug.print("Hello world!\n", .{});
}

