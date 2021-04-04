//
// Grouping values in structs is not merely convenient. It also allows
// us to treat the values as a single item when storing them, passing
// them to functions, etc.
//
// This exercise demonstrates how we can store structs in an array and
// how doing so lets us print them using a loop.
//
const std = @import("std");

const Class = enum {
    wizard,
    thief,
    bard,
    warrior,
};

const Character = struct {
    class: Class,
    gold: u32,
    health: u8,
    experience: u32,
};

pub fn main() void {
    var chars: [2]Character = undefined;

    // Glorp the Wise
    chars[0] = Character{
        .class = Class.wizard,
        .gold = 20,
        .health = 100,
        .experience = 10,
    };

    // Please add "Zump the Loud" with the following properties:
    //
    //     class      bard
    //     gold       10
    //     health     100
    //     experience 20
    //
    // Feel free to run this program without adding Zump. What does
    // it do and why?

    // Printing all RPG characters in a loop:
    for (chars) |c, num| {
        std.debug.print("Character {} - G:{} H:{} XP:{}\n", .{
            num + 1, c.gold, c.health, c.experience,
        });
    }
}

// If you tried running the program without adding Zump as mentioned
// above, you get what appear to be "garbage" values. In debug mode
// (which is the default), Zig writes the repeating pattern "10101010"
// in binary (or 0xAA in hex) to all undefined locations to make them
// easier to spot when debugging.
