//
// Terminals have come a long way over the years. Starting with
// monochrome lines on flickering CRT monitors and continuously
// improving to today's modern terminal emulators with sharp
// images, true color, fonts, ligatures, and characters in every
// known language.
//
// Formatting our results to be appealing and allow quick visual
// comprehension of the information is what users desire. <3
//
// C set string formatting standards over the years, and Zig is
// following suit and growing daily. Due to this growth, there is
// no official documentation for standard library features such
// as string formatting.
//
// Therefore, the comments for the format() function are the only
// way to definitively learn how to format strings in Zig:
//
//     https://github.com/ziglang/zig/blob/master/lib/std/fmt.zig#L29
//
// Zig already has a very nice selection of formatting options.
// These can be used in different ways, but typically to convert
// numerical values into various text representations. The
// results can be used for direct output to a terminal or stored
// for later use or written to file. The latter is useful when
// large amounts of data are to be processed by other programs.
//
// In Ziglings, we are concerned with the output to the console.
// But since the formatting instructions for files are the same,
// what you learn applies universally.
//
// Since we write to "debug" output in Ziglings, our answers
// usually look something like this:
//
//      print("Text {placeholder} another text \n", .{foo});
//
// In addition to being replaced with foo in this example, the
// {placeholder} in the string can also have formatting applied.
// How does that work?
//
// This actually happens in several stages. In one stage, escape
// sequences are evaluated. The one we've seen the most
// (including the example above) is "\n" which means "line feed".
// Whenever this statement is found, a new line is started in the
// output. Escape sequences can also be written one after the
// other, e.g. "\n\n" will cause two line feeds.
//
// By the way, the result of these escape sequences are passed
// directly to the terminal program. Other than translating them
// into control codes, escape sequences have nothing to do with
// Zig. Zig knows nothing about "line feeds" or "tabs" or
// "bells".
//
// The formatting that Zig *does* perform itself is found in the
// curly brackets: "{placeholder}". Formatting instructions in
// the placeholder will determine how the corresponding value,
// e.g. foo, is displayed.
//
// And this is where it gets exciting, because format() accepts a
// variety of formatting instructions. It's basically a tiny
// language of its own. Here's a numeric example:
//
//     print("Catch-{x:0>4}.", .{twenty_two});
//
// This formatting instruction outputs a hexadecimal number with
// leading zeros:
//
//     Catch-0x0016.
//
// Or you can center-align a string like so:
//
//     print("{s:*^20}\n", .{"Hello!"});
//
// Output:
//
//     *******Hello!*******
//
// Let's try making use of some formatting. We've decided that
// the one thing missing from our lives is a multiplication table
// for all numbers from 1-15. We want the table to be nice and
// neat, with numbers in straight columns like so:
//
//      X |  1   2   3   4   5  ...
//     ---+---+---+---+---+---+
//      1 |  1   2   3   4   5 
//
//      2 |  2   4   6   8  10
//
//      3 |  3   6   9  12  15
//
//      4 |  4   8  12  16  20
//
//      5 |  5  10  15  20  25
//
//      ...
//
// Without string formatting, this would be a more challenging
// assignment because the number of digits in the numbers vary
// from 1 to 3. But formatting can help us with that.
//
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    // Max number to multiply
    const size = 15;

    // Print the header:
    //
    // We start with a single 'X' for the diagonal.
    print("\n X |", .{});

    // Header row with all numbers from 1 to size.
    for (0..size) |n| {
        print("{d:>3} ", .{n + 1});
    }
    print("\n", .{});

    // Header column rule line.
    var n: u8 = 0;
    while (n <= size) : (n += 1) {
        print("---+", .{});
    }
    print("\n", .{});

    // Now the actual table. (Is there anything more beautiful
    // than a well-formatted table?)
    for (0..size) |a| {
        print("{d:>2} |", .{a + 1});

        for (0..size) |b| {
            // What formatting is needed here to make our columns
            // nice and straight?
            print("{???} ", .{(a + 1) * (b + 1)});
        }

        // After each row we use double line feed:
        print("\n\n", .{});
    }
}
