//
// Remember our ant and bee simulator constructed with unions
// back in exercises 55 and 56? There, we demonstrated that
// unions allow us to treat different data types in a uniform
// manner.
//
// One neat feature was using tagged unions to create a single
// function to print a status for ants *or* bees by switching:
//
//   switch (insect) {
//      .still_alive => ...      // (print ant stuff)
//      .flowers_visited => ...  // (print bee stuff)
//   }
//
// Well, that simulation was running just fine until a new insect
// arrived in the virtual garden, a grasshopper!
//
// Doctor Zoraptera started to add grasshopper code to the
// program, but then she backed away from her keyboard with an
// angry hissing sound. She had realized that having code for
// each insect in one place and code to print each insect in
// another place was going to become unpleasant to maintain when
// the simulation expanded to hundreds of different insects.
//
// Thankfully, Zig has another comptime feature we can use
// to get out of this dilema called the 'inline else'.
//
// We can replace this redundant code:
//
//   switch (thing) {
//       .a => |a| special(a),
//       .b => |b| normal(b),
//       .c => |c| normal(c),
//       .d => |d| normal(d),
//       .e => |e| normal(e),
//       ...
//   }
//
// With:
//
//   switch (thing) {
//       .a => |a| special(a),
//       inline else => |t| normal(t),
//   }
//
// We can have special handling of some cases and then Zig
// handles the rest of the matches for us.
//
// With this feature, you decide to make an Insect union with a
// single uniform 'print()' function. All of the insects can
// then be responsible for printing themselves. And Doctor
// Zoraptera can calm down and stop gnawing on the furniture.
//
const std = @import("std");

const Ant = struct {
    still_alive: bool,

    pub fn print(self: Ant) void {
        std.debug.print("Ant is {s}.\n", .{if (self.still_alive) "alive" else "dead"});
    }
};

const Bee = struct {
    flowers_visited: u16,

    pub fn print(self: Bee) void {
        std.debug.print("Bee visited {} flowers.\n", .{self.flowers_visited});
    }
};

// Here's the new grasshopper. Notice how we've also added print
// methods to each insect.
const Grasshopper = struct {
    distance_hopped: u16,

    pub fn print(self: Grasshopper) void {
        std.debug.print("Grasshopper hopped {} meters.\n", .{self.distance_hopped});
    }
};

const Insect = union(enum) {
    ant: Ant,
    bee: Bee,
    grasshopper: Grasshopper,

    // Thanks to 'inline else', we can think of this print() as
    // being an interface method. Any member of this union with
    // with a print() method can be treated uniformly by outside
    // code without needing to know any other details. Cool!
    pub fn print(self: Insect) void {
        switch (self) {
            inline else => |case| return case.print(),
        }
    }
};

pub fn main() !void {
    var my_insects = [_]Insect{
        Insect{ .ant = Ant{ .still_alive = true } },
        Insect{ .bee = Bee{ .flowers_visited = 17 } },
        Insect{ .grasshopper = Grasshopper{ .distance_hopped = 32 } },
    };

    std.debug.print("Daily Insect Report:\n", .{});
    for (my_insects) |insect| {
        // Almost done! We want to print() each insect with a
        // single method call here.
        ???
    }
}

// Our print() method in the Insect union above demonstrates
// something very similar to the object-oriented concept of an
// abstract data type. That is, the Insect type doesn't contain
// the underlying data, and the print() function doesn't
// actually do the printing.
//
// The point of an interface is to support generic programming:
// the ability to treat different things as if they were the
// same to cut down on clutter and conceptual complexity.
//
// The Daily Insect Report doesn't need to worry about *which*
// insects are in the report - they all print the same way via
// the interface!
//
// Doctor Zoraptera loves it.
