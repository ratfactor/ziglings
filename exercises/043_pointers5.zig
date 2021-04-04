//
// Passing integer pointers around is generally not something you're going
// to do. Integers are cheap to copy.
//
// But you know what IS useful? Pointers to structs:
//
//     const Vertex = struct{ x: u32, y: u32, z: u32 };
//
//     var v1 = Vertex{ .x=3, .y=2, .z=5 };
//
//     var pv: *Vertex = &v1;   // <-- a pointer to our struct
//
// Note that you don't need to dereference the "pv" pointer to access
// the struct's fields:
//
//     YES: pv.x
//     NO:  pv.*.x
//
// We can write functions that take pointer arguments:
//
//     fn foo(v: *Vertex) void {
//         v.x += 2;
//         v.y += 3;
//         v.z += 7;
//     }
//
// And pass references to them:
//
//     foo(&v1);
//
//
// Let's revisit our RPG example and make a printCharacter() function
// that takes a Character pointer.
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
    health: u8 = 100, // <--- You can also provide fields a default value!
    experience: u32,
};

pub fn main() void {
    var glorp = Character{
        .class = Class.wizard,
        .gold = 10,
        .experience = 20,
    };

    // FIX ME!
    // Please pass our Character "glorp" to printCharacter():
    printCharacter(???);
}

// Note how this function's "c" parameter is a pointer to a Character struct.
fn printCharacter(c: *Character) void {

    // Here's something you haven't seen before: when switching an enum, you
    // don't have to write the full enum name. Zig understands that ".wizard"
    // means "Class.wizard" when we switch on a Class enum value:
    const class_name = switch (c.class) {
        .wizard => "Wizard",
        .thief => "Thief",
        .bard => "Bard",
        .warrior => "Warrior",
    };

    std.debug.print("{s} (G:{} H:{} XP:{})\n", .{
        class_name,
        c.gold,
        c.health,
        c.experience,
    });
}
