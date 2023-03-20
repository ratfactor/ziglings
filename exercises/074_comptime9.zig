//
// In addition to knowing when to use the 'comptime' keyword,
// it's also good to know when you DON'T need it.
//
// The following contexts are already IMPLICITLY evaluated at
// compile time, and adding the 'comptime' keyword would be
// superfluous, redundant, and smelly:
//
//    * The global scope (outside of any function in a source file)
//    * Type declarations of:
//        * Variables
//        * Functions (types of parameters and return values)
//        * Structs
//        * Unions
//        * Enums
//    * The test expressions in inline for and while loops
//    * An expression passed to the @cImport() builtin
//
// Work with Zig for a while, and you'll start to develop an
// intuition for these contexts. Let's work on that now.
//
// You have been given just one 'comptime' statement to use in
// the program below. Here it is:
//
//     comptime
//
// Just one is all it takes. Use it wisely!
//
const print = @import("std").debug.print;

// Being in the global scope, everything about this value is
// implicitly required to be known compile time.
const llama_count = 5;

// Again, this value's type and size must be known at compile
// time, but we're letting the compiler infer both from the
// return type of a function.
const llamas = makeLlamas(llama_count);

// And here's the function. Note that the return value type
// depends on one of the input arguments!
fn makeLlamas(comptime count: usize) [count]u8 {
    var temp: [count]u8 = undefined;
    var i = 0;

    // Note that this does NOT need to be an inline 'while'.
    while (i < count) : (i += 1) {
        temp[i] = i;
    }

    return temp;
}

pub fn main() void {
    print("My llama value is {}.\n", .{llamas[2]});
}
//
// The lesson here is to not pepper your program with 'comptime'
// keywords unless you need them. Between the implicit compile
// time contexts and Zig's aggressive evaluation of any
// expression it can figure out at compile time, it's sometimes
// surprising how few places actually need the keyword.
