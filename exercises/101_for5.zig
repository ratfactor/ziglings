//
// The 'for' loop is not just limited to looping over one or two
// items. Let's try an example with a whole bunch!
//
// But first, there's one last thing we've avoided mentioning
// until now: The special range that leaves off the last value:
//
//     for ( things, 0.. ) |t, i| { ... }
//
// That's how we tell Zig that we want to get a numeric value for
// every item in "things", starting with 0.
//
// A nice feature of these index ranges is that you can have them
// start with any number you choose. The first value of "i" in
// this example will be 500, then 501, 502, etc.:
//
//     for ( things, 500.. ) |t, i| { ... }
//
// Remember our RPG characters? They had the following
// properties, which we stored in a struct type:
//
//     class
//     gold
//     experience
//
// What we're going to do now is store the same RPG character
// data, but in a separate array for each property.
//
// It might look a little awkward, but let's bear with it.
//
// We've started writing a program to print a numbered list of
// characters with each of their properties, but it needs a
// little help:
//
const std = @import("std");
const print = std.debug.print;

// This is the same character class enum we've seen before.
const Class = enum {
    wizard,
    thief,
    bard,
    warrior,
};

pub fn main() void {
    // Here are the three "property" arrays:
    const classes = [4]Class{ .wizard, .bard, .bard, .warrior };
    const gold = [4]u16{ 25, 11, 5, 7392 };
    const experience = [4]u8{ 40, 17, 55, 21 };

    // We would like to number our list starting with 1, not 0.
    // How do we do that?
    for (classes, gold, experience, ???) |c, g, e, i| {
        const class_name = switch (c) {
            .wizard => "Wizard",
            .thief => "Thief",
            .bard => "Bard",
            .warrior => "Warrior",
        };

        std.debug.print("{d}. {s} (Gold: {d}, XP: {d})\n", .{
            i,
            class_name,
            g,
            e,
        });
    }
}
//
// By the way, storing our character data in arrays like this
// isn't *just* a silly way to demonstrate multi-object 'for'
// loops.
//
// It's *also* a silly way to introduce a concept called
// "data-oriented design".
//
// Let's use a metaphor to build up an intuition for what this is
// all about:
//
// Let's say you've been tasked with grabbing three glass
// marbles, three spoons, and three feathers from a magic bag.
// But you can't use your hands to grab them. Instead, you must
// use a marble scoop, spoon magnet, and feather tongs to grab
// each type of object.
//
// Now, would you rather the magic bag:
//
// A. Grouped the items in clusters so you have to pick up one
//    marble, then one spoon, then one feather?
//
//    OR
//
// B. Grouped the items by type so you can pick up all of the
//    marbles at once, then all the spoons, then all of the
//    feathers?
//
// If this metaphor is working, hopefully it's clear that the 'B'
// option would be much more efficient.
//
// Well, it probably comes as little surprise that storing and
// using data in a sequential and uniform fashion is also more
// efficient for modern CPUs.
//
// Decades of OOP practices have steered people towards grouping
// different data types together into mixed-type "objects" with
// the intent that these are easier on the human mind.
// Data-oriented design groups data by type in a way that is
// easier on the computer.
//
// With clever language design, maybe we can have both.
//
// In the Zig community, you may see the difference in groupings
// presented with the terms "Array of Structs" (AoS) versus
// "Struct of Arrays" (SoA).
//
// To envision these two designs in action, imagine an array of
// RPG character structs, each containing three different data
// types (AoS) versus a single RPG character struct containing
// three arrays of one data type each, like those in the exercise
// above (SoA).
//
