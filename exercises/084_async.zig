//
// Six Facts:
//
// 1. The memory space allocated to your program for the
// invocation of a function and all of its data is called a
// "stack frame".
//
// 2. The 'return' keyword "pops" the current function
// invocation's frame off of the stack (it is no longer needed)
// and returns control to the place where the function was
// called.
//
//     fn foo() void {
//         return; // Pop the frame and return control
//     }
//
// 3. Like 'return', the 'suspend' keyword returns control to the
// place where the function was called BUT the function
// invocation's frame remains so that it can regain control again
// at a later time. Functions which do this are "async"
// functions.
//
//     fn fooThatSuspends() void {
//         suspend {} // return control, but leave the frame alone
//     }
//
// 4. To call any function in async context and get a reference
// to its frame for later use, use the 'async' keyword:
//
//     var foo_frame = async fooThatSuspends();
//
// 5. If you call an async function without the 'async' keyword,
// the function FROM WHICH you called the async function itself
// becomes async! In this example, the bar() function is now
// async because it calls fooThatSuspends(), which is async.
//
//     fn bar() void {
//         fooThatSuspends();
//     }
//
// 6. The main() function cannot be async!
//
// Given facts 3 and 4, how do we fix this program (broken by facts
// 5 and 6)?
//
const print = @import("std").debug.print;

pub fn main() void {
    // Additional Hint: you can assign things to '_' when you
    // don't intend to do anything with them.
    _ = async foo();
}

fn foo() void {
    print("foo() A\n", .{});
    suspend {}
    print("foo() B\n", .{});
}
