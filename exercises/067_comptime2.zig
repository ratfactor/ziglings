//
// We've seen that Zig implicitly performs some evaluations at
// compile time. But sometimes you'll want to explicitly request
// compile time evaluation. For that, we have a new keyword:
//
//  .     .   .      o       .          .       *  . .     .
//    .  *  |     .    .            .   .     .   .     * .    .
//        --o--            comptime        *    |      ..    .
//     *    |       *  .        .    .   .    --*--  .     *  .
//  .     .    .    .   . . .      .        .   |   .    .  .
//
// When placed before a variable declaration, 'comptime'
// guarantees that every usage of that variable will be performed
// at compile time.
//
// As a simple example, compare these two statements:
//
//    var bar1 = 5;            // ERROR!
//    comptime var bar2 = 5;   // OKAY!
//
// The first one gives us an error because Zig assumes mutable
// identifiers (declared with 'var') will be used at runtime and
// we have not assigned a runtime type (like u8 or f32). Trying
// to use a comptime_int of undetermined size at runtime is
// a MEMORY CRIME and you are UNDER ARREST.
//
// The second one is okay because we've told Zig that 'bar2' is
// a compile time variable. Zig will help us ensure this is true
// and let us know if we make a mistake.
//
const print = @import("std").debug.print;

pub fn main() void {
    //
    // In this contrived example, we've decided to allocate some
    // arrays using a variable count! But something's missing...
    //
    var count = 0;

    count += 1;
    var a1: [count]u8 = .{'A'} ** count;

    count += 1;
    var a2: [count]u8 = .{'B'} ** count;

    count += 1;
    var a3: [count]u8 = .{'C'} ** count;

    count += 1;
    var a4: [count]u8 = .{'D'} ** count;

    print("{s} {s} {s} {s}\n", .{ a1, a2, a3, a4 });

    // Builtin BONUS!
    //
    // The @compileLog() builtin is like a print statement that
    // ONLY operates at compile time. The Zig compiler treats
    // @compileLog() calls as errors, so you'll want to use them
    // temporarily to debug compile time logic.
    //
    // Try uncommenting this line and playing around with it
    // (copy it, move it) to see what it does:
    //@compileLog("Count at compile time: ", count);
}
