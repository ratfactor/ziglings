//
// Help! Evil alien creatures have hidden eggs all over the Earth
// and they're starting to hatch!
//
// Before you jump into battle, you'll need to know four things:
//
// 1. You can attach functions to structs:
//
//     const Foo = struct{
//         pub fn hello() void {
//             std.debug.print("Foo says hello!\n", .{});
//         }
//     }
//
// 2. A function that is a member of a struct is a "method" and is
//    called with the "dot syntax" like so:
//
//     Foo.hello();
//
// 3. The NEAT feature of methods is the special parameter named
//    "self" that takes an instance of that type of struct:
//
//     const Bar = struct{
//         number: u32,
//
//         pub fn printMe(self: *Bar) void {
//             std.debug.print("{}\n", .{self.number});
//         }
//     }
//
//    (Actually, you can name the first parameter anything, but
//    please follow convention and use "self".)
//
// 4. Now when you call the method on an INSTANCE of that struct
//    with the "dot syntax", the instance will be automatically
//    passed as the "self" parameter:
//
//     var my_bar = Bar{ .number = 2000 };
//     my_bar.printMe(); // prints "2000"
//
// Okay, you're armed.
//
// Now, please zap the alien structs until they're all gone or
// Earth will be doomed!
//
const std = @import("std");

// Look at this hideous Alien struct. Know your enemy!
const Alien = struct {
    health: u8,

    // We hate this method:
    pub fn hatch(strength: u8) Alien {
        return Alien{
            .health = strength * 5,
        };
    }

    // We love this method:
    pub fn zap(self: *Alien, damage: u8) void {
        self.health -= if (damage >= self.health) self.health else damage;
    }
};

pub fn main() void {
    // Look at all of these aliens of various strengths!
    var aliens = [_]Alien{
        Alien.hatch(2),
        Alien.hatch(1),
        Alien.hatch(3),
        Alien.hatch(3),
        Alien.hatch(5),
        Alien.hatch(3),
    };

    var aliens_alive = aliens.len;
    var heat_ray_strength: u8 = 7; // We've been given a heat ray weapon.

    // We'll keep checking to see if we've killed all the aliens yet.
    while (aliens_alive > 0) {
        aliens_alive = 0;

        // Loop through every alien...
        for (aliens) |*alien| {

            // *** Zap the Alien Here! ***
            ???.zap(heat_ray_strength);

            // If the alien's health is still above 0, it's still alive.
            if (alien.health > 0) aliens_alive += 1;
        }

        std.debug.print("{} aliens. ", .{aliens_alive});
    }

    std.debug.print("Earth is saved!\n", .{});
}
