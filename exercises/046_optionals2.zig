//
// Now that we have optional types, we can apply them to structs.
// The last time we checked in with our elephants, we had to link
// all three of them together in a "circle" so that the last tail
// linked to the first elephant. This is because we had NO CONCEPT
// of a tail that didn't point to another elephant!
//
// We also introduce the handy ".?" shortcut:
//
//     const foo = bar.?;
//
// is the same as
//
//     const foo = bar orelse unreachable;
//
// See if you can find where we use this shortcut below.
//
// Now let's make those elephant tails optional!
//
const std = @import("std");

const Elephant = struct {
    letter: u8,
    tail: *Elephant = null, // Hmm... tail needs something...
    visited: bool = false,
};

pub fn main() void {
    var elephantA = Elephant{ .letter = 'A' };
    var elephantB = Elephant{ .letter = 'B' };
    var elephantC = Elephant{ .letter = 'C' };

    // Link the elephants so that each tail "points" to the next.
    elephantA.tail = &elephantB;
    elephantB.tail = &elephantC;

    visitElephants(&elephantA);

    std.debug.print("\n", .{});
}

// This function visits all elephants once, starting with the
// first elephant and following the tails to the next elephant.
fn visitElephants(first_elephant: *Elephant) void {
    var e = first_elephant;

    while (!e.visited) {
        std.debug.print("Elephant {u}. ", .{e.letter});
        e.visited = true;

        // We should stop once we encounter a tail that
        // does NOT point to another element. What can
        // we put here to make that happen?
        if (e.tail == null) ???;

        e = e.tail.?;
    }
}
