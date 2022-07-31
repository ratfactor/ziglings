//
// As with integers, you can pass a pointer to a struct when you
// will wish to modify that struct. Pointers are also useful when
// you need to store a reference to a struct (a "link" to it).
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
// We can write functions that take pointers to structs as
// arguments. This foo() function modifies struct v:
//
//     fn foo(v: *Vertex) void {
//         v.x += 2;
//         v.y += 3;
//         v.z += 7;
//     }
//
// And call them like so:
//
//     foo(&v1);
//
// Let's revisit our RPG example and make a printCharacter() function
// that takes a Character by reference and prints it...*and*
// prints a linked "mentor" Character, if there is one.
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
    health: u8 = 100, // You can provide default values
    experience: u32,

    // I need to use the '?' here to allow for a null value. But
    // I don't explain it until later. Please don't tell anyone.
    mentor: ?*Character = null,
};

pub fn main() void {
    var mighty_krodor = Character{
        .class = Class.wizard,
        .gold = 10000,
        .experience = 2340,
    };

    var glorp = Character{ // Glorp!
        .class = Class.wizard,
        .gold = 10,
        .experience = 20,
        .mentor = &mighty_krodor, // Glorp's mentor is the Mighty Krodor
    };

    // FIX ME!
    // Please pass Glorp to printCharacter():
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

    // Checking an "optional" value and capturing it will be
    // explained later (this pairs with the '?' mentioned above.)
    if (c.mentor) |mentor| {
        std.debug.print("  Mentor: ", .{});
        printCharacter(mentor);
    }
}
