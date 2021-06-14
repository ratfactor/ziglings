//
// Remember how a function with 'suspend' is async and calling an
// async function without the 'async' keyword makes the CALLING
// function async?
//
//     fn fooThatMightSuspend(maybe: bool) void {
//         if (maybe) suspend {}
//     }
//
//     fn bar() void {
//         fooThatMightSuspend(true); // Now bar() is async!
//     }
// 
// But if you KNOW the function won't suspend, you can make a
// promise to the compiler with the 'nosuspend' keyword:
//
//     fn bar() void {
//         nosuspend fooThatMightSuspend(false);
//     }
//
// If the function does suspend and YOUR PROMISE TO THE COMPILER
// IS BROKEN, the program will panic at runtime, which is
// probably better than you deserve, you oathbreaker! >:-(
//
const print = @import("std").debug.print;

pub fn main() void {

    // The main() function can not be async. But we know
    // getBeef() will not suspend with this particular
    // invocation. Please make this okay:
    var my_beef = getBeef(0);

    print("beef? {X}!\n", .{my_beef});
}

fn getBeef(input: u32) u32 {
    if (input > 0xDEAD) {
        suspend {}
    }

    return 0xBEEF;
}
