//
// Understanding how Zig treats numeric literals is fundamental
// and important, but it isn't exactly exciting.
//
// We're about to get into the cool wizard stuff that makes
// programming computers fun. But first, let's introduce a new and
// vital Zig keyword:
//
//                       comptime
//
// When you put 'comptime' in front of a variable declaration,
// function parameter, or expression, you're saying, "I want Zig
// to evaluate this at compile time rather than runtime."
//
// We've already seen that Zig implicitly performs certain types
// of evaluations at compile time. (Many compilers do a certain
// amount of this, but Zig is explicit about it.) Therefore,
// these two statements are equivalent and using the 'comptime'
// keyword here is redundant:
//
//    const foo1 = 5;
//    comptime const foo2 = 5;
//
// But here it makes a difference:
//
//    var bar1 = 5;            // ERROR!
//    comptime var bar2 = 5;   // OKAY!
//
// 'bar1' gives us an error because Zig assumes mutable
// identifiers will be used at runtime and trying to use a
// comptime_int of undetermined size at runtime is basically a
// MEMORY CRIME and you are UNDER ARREST.
//
// 'bar2' is okay because we've told Zig that this identifier
// MUST be resolvable at compile time. Now Zig won't yell at us
// for assigning a comptime_int to it without a specific runtime
// size.
//
// The comptime property is also INFECTIOUS. Once you declare
// something to be comptime, Zig will always either:
//
//     1. Be able to resolve that thing at compile time.
//     2. Yell at you.
//
const print = @import("std").debug.print;

pub fn main() void  {
    //
    // In this contrived example, we've decided to allocate some
    // arrays using a variable count!
    //
    // Please make this work. Please?
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

    print("{s} {s} {s} {s}\n", .{a1, a2, a3, a4});
}
