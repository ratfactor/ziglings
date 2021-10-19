//
// If you thought the last exercise was a deep dive, hold onto your
// hat because we are about to descend into the computer's molten
// core.
//
// (Shouting) DOWN HERE, THE BITS AND BYTES FLOW FROM RAM TO THE CPU
// LIKE A HOT, DENSE FLUID. THE FORCES ARE INCREDIBLE. BUT HOW DOES
// ALL OF THIS RELATE TO THE DATA IN OUR ZIG PROGRAMS? LET'S HEAD
// BACK UP TO THE TEXT EDITOR AND FIND OUT.
//
// Ah, that's better. Now we can look at some familiar Zig code.
//
// @import() adds the imported code to your own. In this case, code
// from the standard library is added to your program and compiled
// with it. All of this will be loaded into RAM when it runs. Oh, and
// that thing we name "const std"? That's a struct!
//
const std = @import("std");

// Remember our old RPG Character struct? A struct is really just a
// very convenient way to deal with memory. These fields (gold,
// health, experience) are all values of a particular size. Add them
// together and you have the size of the struct as a whole.

const Character = struct {
    gold: u32 = 0,
    health: u8 = 100,
    experience: u32 = 0,
};

// Here we create a character called "the_narrator" that is a constant
// (immutable) instance of a Character struct. It is stored in your
// program as data, and like the instruction code, it is loaded into
// RAM when your program runs. The relative location of this data in
// memory is hard-coded and neither the address nor the value changes.

const the_narrator = Character{
    .gold = 12,
    .health = 99,
    .experience = 9000,
};

// This "global_wizard" character is very similar. The address for
// this data won't change, but the data itself can since this is a var
// and not a const.

var global_wizard = Character{};

// A function is instruction code at a particular address. Function
// parameters in Zig are always immutable. They are stored in "the
// stack". A stack is a type of data structure and "the stack" is a
// specific bit of RAM reserved for your program. The CPU has special
// support for adding and removing things from "the stack", so it is
// an extremely efficient place for memory storage.
//
// Also, when a function executes, the input arguments are often
// loaded into the beating heart of the CPU itself in registers.
//
// Our main() function here has no input parameters, but it will have
// a stack entry (called a "frame").

pub fn main() void {

    // Here, the "glorp" character will be allocated on the stack
    // because each instance of glorp is mutable and therefore unique
    // to the invocation of this function.

    var glorp = Character{
        .gold = 30,
    };

    // The "reward_xp" value is interesting. It's an immutable
    // value, so even though it is local, it can be put in global
    // data and shared between all invocations. But being such a
    // small value, it may also simply be inlined as a literal
    // value in your instruction code where it is used.  It's up
    // to the compiler.

    const reward_xp: u32 = 200;

    // Now let's circle back around to that "std" struct we imported
    // at the top. Since it's just a regular Zig value once it's
    // imported, we can also assign new names for its fields and
    // declarations. "debug" refers to another struct and "print" is a
    // public function namespaced within THAT struct.
    //
    // Let's assign the std.debug.print function to a const named
    // "print" so that we can use this new name later!

    const print = std.debug.print;

    // Now let's look at assigning and pointing to values in Zig.
    //
    // We'll try three different ways of making a new name to access
    // our glorp Character and change one of its values.
    //
    // "glorp_access1" is incorrectly named! We asked Zig to set aside
    // memory for another Character struct. So when we assign glorp to
    // glorp_access1 here, we're actually assigning all of the fields
    // to make a copy! Now we have two separate characters.
    //
    // You don't need to fix this. But notice what gets printed in
    // your program's output for this one compared to the other two
    // assignments below!

    var glorp_access1: Character = glorp;
    glorp_access1.gold = 111;
    print("1:{}!. ", .{glorp.gold == glorp_access1.gold});

    // NOTE:
    //
    //     If we tried to do this with a const Character instead of a
    //     var, changing the gold field would give us a compiler error
    //     because const values are immutable!
    //
    // "glorp_access2" will do what we want. It points to the original
    // glorp's address. Also remember that we get one implicit
    // dereference with struct fields, so accessing the "gold" field
    // from glorp_access2 looks just like accessing it from glorp
    // itself.

    var glorp_access2: *Character = &glorp;
    glorp_access2.gold = 222;
    print("2:{}!. ", .{glorp.gold == glorp_access2.gold});

    // "glorp_access3" is interesting. It's also a pointer, but it's a
    // const. Won't that disallow changing the gold value? No! As you
    // may recall from our earlier pointer experiments, a constant
    // pointer can't change what it's POINTING AT, but the value at
    // the address it points to is still mutable! So we CAN change it.

    const glorp_access3: *Character = &glorp;
    glorp_access3.gold = 333;
    print("3:{}!. ", .{glorp.gold == glorp_access3.gold});

    // NOTE:
    //
    //     If we tried to do this with a *const Character pointer,
    //     that would NOT work and we would get a compiler error
    //     because the VALUE becomes immutable!
    //
    // Moving along...
    //
    // Passing arguments to functions is pretty much exactly like
    // making an assignment to a const (since Zig enforces that ALL
    // function parameters are const).
    //
    // Knowing this, see if you can make levelUp() work as expected -
    // it should add the specified amount to the supplied character's
    // experience points.
    //
    print("XP before:{}, ", .{glorp.experience});

    // Fix 1 of 2 goes here:
    levelUp(&glorp, reward_xp);

    print("after:{}.\n", .{glorp.experience});
}

// Fix 2 of 2 goes here:
fn levelUp(character_access: *Character, xp: u32) void {
    character_access.experience += xp;
}

// And there's more!
//
// Data segments (allocated at compile time) and "the stack"
// (allocated at run time) aren't the only places where program data
// can be stored in memory. They're just the most efficient. Sometimes
// we don't know how much memory our program will need until the
// program is running. Also, there is a limit to the size of stack
// memory allotted to programs (often set by your operating system).
// For these occasions, we have "the heap".
//
// You can use as much heap memory as you like (within physical
// limitations, of course), but it's much less efficient to manage
// because there is no built-in CPU support for adding and removing
// items as we have with the stack. Also, depending on the type of
// allocation, your program MAY have to do expensive work to manage
// the use of heap memory. We'll learn about heap allocators later.
//
// Whew! This has been a lot of information. You'll be pleased to know
// that the next exercise gets us back to learning Zig language
// features we can use right away to do more things!
