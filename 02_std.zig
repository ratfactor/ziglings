//
// Oops! This program is supposed to print a line like our Hello World
// example. But we forgot how to import the Zig Standard Library.
//
// Hint 1: The @import() built-in function returns a value representing
//         imported code. We need to give that value a name to use it.
// Hint 2: We use the name "std" in the main function (see below).
// Hint 3: Imports need to be named by declaring them as "const" values.
// Hint 4: Take a look at how the previous exercise did this!
//
@import("std");

pub fn main() void {
    std.debug.print("Standard Library.\n", .{});
}

// Going deeper: imports must be declared as "constants" (with the 'const'
// keyword rather than "variables" (with the 'var' keyword) is that they
// can only be used at "compile time" rather than "run time". Zig evaluates
// const values at compile time. Don't worry if none of this makes sense
// yet! See also this answer: https://stackoverflow.com/a/62567550/695615
