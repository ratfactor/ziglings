//
// "Compile time" is a program's environment while it is being
// compiled. In contrast, "run time" is the environment while the
// compiled program is executing (traditionally as machine code
// on a hardware CPU).
//
// Errors make an easy example:
//
// 1. Compile-time error: caught by the compiler, usually
//    resulting in a message to the programmer.
//
// 2. Runtime error: either caught by the running program itself
//    or by the host hardware or operating system. Could be
//    gracefully caught and handled or could cause the computer
//    to crash (or halt and catch fire)!
//
// All compiled languages must perform a certain amount of logic
// at compile time in order to analyze the code, maintain a table
// of symbols (such as variable and function names), etc.
//
// Optimizing compilers can also figure out how much of a program
// can be pre-computed or "inlined" at compile time to make the
// resulting program more efficient. Smart compilers can even
// "unroll" loops, turning their logic into a fast linear
// sequence of statements (at the usually very slight expense of
// the increased size of the repeated code).
//
// Zig takes these concepts further by making these optimizations
// an integral part of the language itself!
//
const print = @import("std").debug.print;

pub fn main() void {
    // ALL numeric literals in Zig are of type comptime_int or
    // comptime_float. They are of arbitrary size (as big or
    // little as you need).
    //
    // Notice how we don't have to specify a size like "u8",
    // "i32", or "f64" when we assign identifiers immutably with
    // "const".
    //
    // When we use these identifiers in our program, the VALUES
    // are inserted at compile time into the executable code. The
    // IDENTIFIERS "const_int" and "const_float" don't exist in
    // our compiled application!
    const const_int = 12345;
    const const_float = 987.654;

    print("Immutable: {}, {d:.3}; ", .{ const_int, const_float });

    // But something changes when we assign the exact same values
    // to identifiers mutably with "var".
    //
    // The literals are STILL comptime_int and comptime_float,
    // but we wish to assign them to identifiers which are
    // mutable at runtime.
    //
    // To be mutable at runtime, these identifiers must refer to
    // areas of memory. In order to refer to areas of memory, Zig
    // must know exactly how much memory to reserve for these
    // values. Therefore, it follows that we just specify numeric
    // types with specific sizes. The comptime numbers will be
    // coerced (if they'll fit!) into your chosen runtime types.
    // For this it is necessary to specify a size, e.g. 32 bit.
    var var_int = 12345;
    var var_float = 987.654;

    // We can change what is stored at the areas set aside for
    // "var_int" and "var_float" in the running compiled program.
    var_int = 54321;
    var_float = 456.789;

    print("Mutable: {}, {d:.3}; ", .{ var_int, var_float });

    // Bonus: Now that we're familiar with Zig's builtins, we can
    // also inspect the types to see what they are, no guessing
    // needed!
    print("Types: {}, {}, {}, {}\n", .{
        @TypeOf(const_int),
        @TypeOf(const_float),
        @TypeOf(var_int),
        @TypeOf(var_float),
    });
}
