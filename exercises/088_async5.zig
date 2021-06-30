//
// Sure, we can solve our async value problem with a global
// variable. But this hardly seems like an ideal solution.
//
// So how do we REALLY get return values from async functions?
//
// The 'await' keyword waits for an async function to complete
// and then captures its return value.
//
//     fn foo() u32 {
//         return 5;
//     }
//
//    var foo_frame = async foo(); // invoke and get frame
//    var value = await foo_frame; // await result using frame
//
// The above example is just a silly way to call foo() and get 5
// back. But if foo() did something more interesting such as wait
// for a network response to get that 5, our code would pause
// until the value was ready.
//
// As you can see, async/await basically splits a function call
// into two parts:
//
//    1. Invoke the function ('async')
//    2. Getting the return value ('await')
//
// Also notice that a 'suspend' keyword does NOT need to exist in
// a function to be called in an async context.
//
// Please use 'await' to get the string returned by
// getPageTitle().
//
const print = @import("std").debug.print;

pub fn main() void {
    var myframe = async getPageTitle("http://example.com");

    var value = ???

    print("{s}\n", .{value});
}

fn getPageTitle(url: []const u8) []const u8 {
    // Please PRETEND this is actually making a network request.
    _ = url;
    return "Example Title.";
}
