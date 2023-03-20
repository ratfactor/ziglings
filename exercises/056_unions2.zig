//
// It is really quite inconvenient having to manually keep track
// of the active field in our union, isn't it?
//
// Thankfully, Zig also has "tagged unions", which allow us to
// store an enum value within our union representing which field
// is active.
//
//     const FooTag = enum{ small, medium, large };
//
//     const Foo = union(FooTag) {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };
//
// Now we can use a switch directly on the union to act on the
// active field:
//
//     var f = Foo{ .small = 10 };
//
//     switch (f) {
//         .small => |my_small| do_something(my_small),
//         .medium => |my_medium| do_something(my_medium),
//         .large => |my_large| do_something(my_large),
//     }
//
// Let's make our Insects use a tagged union (Doctor Zoraptera
// approves).
//
const std = @import("std");

const InsectStat = enum { flowers_visited, still_alive };

const Insect = union(InsectStat) {
    flowers_visited: u16,
    still_alive: bool,
};

pub fn main() void {
    var ant = Insect{ .still_alive = true };
    var bee = Insect{ .flowers_visited = 16 };

    std.debug.print("Insect report! ", .{});

    // Could it really be as simple as just passing the union?
    printInsect(ant);
    printInsect(bee);

    std.debug.print("\n", .{});
}

fn printInsect(insect: Insect) void {
    switch (insect) {
        .still_alive => |a| std.debug.print("Ant alive is: {}. ", .{a}),
        .flowers_visited => |f| std.debug.print("Bee visited {} flowers. ", .{f}),
    }
}

// By the way, did unions remind you of optional values and errors?
// Optional values are basically "null unions" and errors use "error
// union types". Now we can add our own unions to the mix to handle
// whatever situations we might encounter:
//          union(Tag) { value: u32, toxic_ooze: void }
