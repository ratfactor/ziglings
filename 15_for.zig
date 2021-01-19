//
// Behold the 'for' loop! It lets you execute code for each
// member of an array (and things called 'slices' which we'll
// get to in a bit).
//
//     for (items) |item| {
//         // Do something with item
//     }
//
const std = @import("std");

pub fn main() void {
    const story = [_]u8{ 'h', 'h', 's', 'n', 'h' };

    std.debug.print("A Dramatic Story: ", .{});

    for (???) |???| {
        if(scene == 'h') std.debug.print(":-)  ", .{});
        if(scene == 's') std.debug.print(":-(  ", .{});
        if(scene == 'n') std.debug.print(":-|  ", .{});
    }

    std.debug.print("The End.\n", .{});
}
