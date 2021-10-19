//
// Oops! This program is supposed to print a line like our Hello World
// example. But we forgot how to import the Zig Standard Library.
//
// The @import() function is built into Zig. It returns a value which
// represents the imported code. It's a good idea to store the import as
// a constant value with the same name as the import:
//
//     const foo = @import("foo");
//
// Please complete the import below:
//

const std = @import("std");

pub fn main() void {
    std.debug.print("Standard Library.\n", .{});
}

// For the curious: Imports must be declared as constants because they
// can only be used at compile time rather than run time. Zig evaluates
// constant values at compile time. Don't worry, we'll cover imports
// in detail later.
// Also see this answer: https://stackoverflow.com/a/62567550/695615
