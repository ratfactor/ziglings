//
// As a matter of fact, you can put 'comptime' in front of any
// expression to force it to be run at compile time.
//
// Execute a function:
//
//     comptime llama();
//
// Get a value:
//
//     bar = comptime baz();
//
// Execute a whole block:
//
//     comptime {
//         bar = baz + biff();
//         llama(bar);
//     }
//
// Get a value from a block:
//
//     var llama = comptime bar: {
//         const baz = biff() + bonk();
//         break :bar baz;
//     }
//
const print = @import("std").debug.print;

const llama_count = 5;
const llamas = [llama_count]u32{ 5, 10, 15, 20, 25 };

pub fn main() void {
    // We meant to fetch the last llama. Please fix this simple
    // mistake so the assertion no longer fails.
    const my_llama = getLlama(4);

    print("My llama value is {}.\n", .{my_llama});
}

fn getLlama(comptime i: usize) u32 {
    // We've put a guard assert() at the top of this function to
    // prevent mistakes. The 'comptime' keyword here means that
    // the mistake will be caught when we compile!
    //
    // Without 'comptime', this would still work, but the
    // assertion would fail at runtime with a PANIC, and that's
    // not as nice.
    //
    // Unfortunately, we're going to get an error right now
    // because the 'i' parameter needs to be guaranteed to be
    // known at compile time. What can you do with the 'i'
    // parameter above to make this so?
    comptime assert(i < llama_count);

    return llamas[i];
}

// Fun fact: this assert() function is identical to
// std.debug.assert() from the Zig Standard Library.
fn assert(ok: bool) void {
    if (!ok) unreachable;
}
//
// Bonus fun fact: I accidentally replaced all instances of 'foo'
// with 'llama' in this exercise and I have no regrets!
