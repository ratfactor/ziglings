//
// Behold the 'for' loop! For loops let you execute code for each
// element of an array:
//
//     for (items) |item| {
//
//         // Do something with item
//
//     }
//
const std = @import("std");

pub fn main() void {
    const story = [_]u8{ 'h', 'h', 's', 'n', 'h' };

    std.debug.print("A Dramatic Story: ", .{});

    for (story) |scene| {
        if (scene == 'h') std.debug.print(":-)  ", .{});
        if (scene == 's') std.debug.print(":-(  ", .{});
        if (scene == 'n') std.debug.print(":-|  ", .{});
    }

    std.debug.print("The End.\n", .{});
}
// Note that 'for' loops also work on things called "slices"
// which we'll see later.
//
// Also note that 'for' loops have recently become more flexible
// and powerful (two years after this exercise was written).
// More about that in a moment.
