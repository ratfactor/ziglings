//
// You can assign some code to run _after_ a block of code exits by
// deferring it with a "defer" statement:
//
//     {
//         defer runLater();
//         runNow();
//     }
//
// In the example above, runLater() will run when the block ({...})
// is finished. So the code above will run in the following order:
//
//     runNow();
//     runLater();
//
// This feature seems strange at first, but we'll see how it could be
// useful in the next exercise.
const std = @import("std");

pub fn main() void {
    // Without changing anything else, please add a 'defer' statement
    // to this code so that our program prints "One Two\n":
    std.debug.print("Two\n", .{});
    std.debug.print("One ", .{});
}
