//
// A union lets you store different types and sizes of data at
// the same memory address. How is this possible? The compiler
// sets aside enough memory for the largest thing you might want
// to store.
//
// In this example, an instance of Foo always takes up u64 of
// space in memory even if you're currently storing a u8.
//
//     const Foo = union {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };
//
// The syntax looks just like a struct, but a Foo can only hold a
// small OR a medium OR a large value. Once a field becomes
// active, the other inactive fields cannot be accessed. To
// change active fields, assign a whole new instance:
//
//     var f = Foo{ .small = 5 };
//     f.small += 5;                  // OKAY
//     f.medium = 5432;               // ERROR!
//     f = Foo{ .medium = 5432 };     // OKAY
//
// Unions can save space in memory because they let you "re-use"
// a space in memory. They also provide a sort of primitive
// polymorphism. Here fooBar() can take a Foo no matter what size
// of unsigned integer it holds:
//
//     fn fooBar(f: Foo) void { ... }
//
// Oh, but how does fooBar() know which field is active? Zig has
// a neat way of keeping track, but for now, we'll just have to
// do it manually.
//
// Let's see if we can get this program working!
//
const std = @import("std");

// We've just started writing a simple ecosystem simulation.
// Insects will be represented by either bees or ants. Bees store
// the number of flowers they've visited that day and ants just
// store whether or not they're still alive.
const Insect = union {
    flowers_visited: u16,
    still_alive: bool,
};

// Since we need to specify the type of insect, we'll use an
// enum (remember those?).
const AntOrBee = enum { a, b };

pub fn main() void {
    // We'll just make one bee and one ant to test them out:
    const ant = Insect{ .still_alive = true };
    const bee = Insect{ .flowers_visited = 15 };

    std.debug.print("Insect report! ", .{});

    // Oops! We've made a mistake here.
    printInsect(ant, AntOrBee.c);
    printInsect(bee, AntOrBee.c);

    std.debug.print("\n", .{});
}

// Eccentric Doctor Zoraptera says that we can only use one
// function to print our insects. Doctor Z is small and sometimes
// inscrutable but we do not question her.
fn printInsect(insect: Insect, what_it_is: AntOrBee) void {
    switch (what_it_is) {
        .a => std.debug.print("Ant alive is: {}. ", .{insect.still_alive}),
        .b => std.debug.print("Bee visited {} flowers. ", .{insect.flowers_visited}),
    }
}
