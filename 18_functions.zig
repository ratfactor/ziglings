//
// Functions! FUNctions! FUN!
//
const std = @import("std");

pub fn main() void {
    // The new function deepThought() should return the number 42. See below.
    const answer = deepThought();
    
    std.debug.print("Answer to the Ultimate Question: {}\n", .{answer});
}

//
// We're just missing a couple things here. One thing we're NOT missing is the
// keyword 'pub', which is not needed here. Can you guess why?
//
??? deepThought() ??? {
    return 42; // Number courtesy Douglas Adams
}
