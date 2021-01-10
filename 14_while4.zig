//
// Continue expressions do NOT execute when a while loop stops
// because of a 'break' statement.
//
// Example:
//
//     while (condition) : (continue expression){
//         if(other condition) break;
//         ...
//     }
//
const std = @import("std");

pub fn main() void {
    var n: u32 = 1;

    // Oh dear! This while loop will go forever!?
    while (true) : (n+=1) {
        if(???) ???;
    }

    // Result: we want n=4
    std.debug.print("n={}\n", .{n});
}
