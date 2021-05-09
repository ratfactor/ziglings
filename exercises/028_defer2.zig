//
// Now that you know how "defer" works, let's do something more
// interesting with it.
//
const std = @import("std");

pub fn main() void {
    const animals = [_]u8{ 'g', 'c', 'd', 'd', 'g', 'z' };

    for (animals) |a| printAnimal(a);

    std.debug.print("done.\n", .{});
}

// This function is _supposed_ to print an animal name in parentheses
// like "(Goat) ", but we somehow need to print the end parenthesis
// even though this function can return in four different places!
fn printAnimal(animal: u8) void {
    std.debug.print("(", .{});

    std.debug.print(") ", .{}); // <---- how?!

    if (animal == 'g') {
        std.debug.print("Goat", .{});
        return;
    }
    if (animal == 'c') {
        std.debug.print("Cat", .{});
        return;
    }
    if (animal == 'd') {
        std.debug.print("Dog", .{});
        return;
    }

    std.debug.print("Unknown", .{});
}
