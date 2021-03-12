//
// Now that we've seen how methods work, let's see if we can help
// our elephants out a bit more with some Elephant methods.
//
const std = @import("std");

const Elephant = struct {
    letter: u8,
    tail: ?*Elephant = null,
    visited: bool = false,

    // New Elephant methods!
    pub fn getTail(self: *Elephant) *Elephant {
        return self.tail.?; // Remember, this is means "orelse unreachable"
    }

    pub fn hasTail(self: *Elephant) bool {
        return (self.tail != null);
    }

    pub fn visit(self: *Elephant) void {
        self.visited = true;
    }

    pub fn print(self: *Elephant) void {
        // Prints elephant letter and [v]isited
        var v: u8 = if (self.visited) 'v' else ' ';
        std.debug.print("{u}{u} ", .{ self.letter, v });
    }
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

    while (true) {
        e.print();
        e.visit();

        // Get the next elephant or stop.
        if (e.hasTail()) {
            e = e.???; // Which method do we want here?
        } else {
            break;
        }
    }
}

// Bonus: Zig's enums can also have methods! Can you find
// one in the wild? If you can, mention it along with your
// name or alias in a comment below this one and make a
// pull request on GitHub for a piece of eternal Ziglings
// glory. The first five (5) PRs will be accepted!
//
// 1) drforester - I found one in the Zig source:
// https://github.com/ziglang/zig/blob/041212a41cfaf029dc3eb9740467b721c76f406c/src/Compilation.zig#L2495
