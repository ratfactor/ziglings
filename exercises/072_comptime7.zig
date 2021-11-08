//
// There is also an 'inline while'. Just like 'inline for', it
// loops at compile time, allowing you do all sorts of
// interesting things not possible at runtime. See if you can
// figure out what this rather bonkers example prints:
//
//     const foo = [3]*const [5]u8{ "~{s}~", "<{s}>", "d{s}b" };
//     comptime var i = 0;
//
//     inline while ( i < foo.len ) : (i += 1) {
//         print(foo[i] ++ "\n", .{foo[i]});
//     }
//
// You haven't taken off that wizard hat yet, have you?
//
const print = @import("std").debug.print;

pub fn main() void {
    // Here is a string containing a series of arithmetic
    // operations and single-digit decimal values. Let's call
    // each operation and digit pair an "instruction".
    const instructions = "+3 *5 -2 *2";

    // Here is a u32 variable that will keep track of our current
    // value in the program at runtime. It starts at 0, and we
    // will get the final value by performing the sequence of
    // instructions above.
    var value: u32 = 0;

    // This "index" variable will only be used at compile time in
    // our loop.
    comptime var i = 0;

    // Here we wish to loop over each "instruction" in the string
    // at compile time.
    //
    // Please fix this to loop once per "instruction":
    ??? (i < instructions.len) : (???) {

        // This gets the digit from the "instruction". Can you
        // figure out why we subtract '0' from it?
        comptime var digit = instructions[i + 1] - '0';

        // This 'switch' statement contains the actual work done
        // at runtime. At first, this doesn't seem exciting...
        switch (instructions[i]) {
            '+' => value += digit,
            '-' => value -= digit,
            '*' => value *= digit,
            else => unreachable,
        }
        // ...But it's quite a bit more exciting than it first appears.
        // The 'inline while' no longer exists at runtime and neither
        // does anything else not touched directly by runtime
        // code. The 'instructions' string, for example, does not
        // appear anywhere in the compiled program because it's
        // not used by it!
        //
        // So in a very real sense, this loop actually converts
        // the instructions contained in a string into runtime
        // code at compile time. Guess we're compiler writers
        // now. See? The wizard hat was justified after all.
    }

    print("{}\n", .{value});
}
