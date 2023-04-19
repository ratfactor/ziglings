//
// The output on the console looks a bit rudimentary at first glance.
// However, if you look at the development of modern computers, you can
// see the enormous progress that has been made over the years.
// Starting with monochrome lines on flickering CRT monitors, modern
// terminal emulators offer a razor-sharp image with true color and
// nearly infinite font size thanks to modern hardware.
//
// In addition, they have mastered ligatures and can represent almost
// any character in any language. This also makes the output of programs
// on the console more atractive than ever in recent years.
//
// This makes it all the more important to format the presentation of
// results in an appealing way, because that is what users appreciate,
// quick visual comprehension of the information.
//
// C has set standards here over the years, and Zig is preparing to
// follow suit. Currently, however, it still lags a bit behind the model,
// but the Zig community is working diligently behind the scenes on
// further options.
//
// Nevertheless, it is time to take a closer look at the possibilities
// that already exist. And of course we will continue this series loosely,
// because Zig continues to grow almost daily.
//
// Since there is no proper documentation on the formatting yet, the most
// important source here is the source code:
//
//     https://github.com/ziglang/zig/blob/master/lib/std/fmt.zig#L29
//
//
// And in fact, you already discover quite a lot of useful formatting.
// These can be used in different ways, e.g. to convert numerical values
// into text and for direct output to the console or to a file. The latter
// is useful when large amounts of data are to be processed by other programs.
//
// However, we are concerned here exclusively with the output to the console.
// But since the formatting instructions for files are the same, what you
// learn applies universally.
//
// Since we basically write to debug output in Ziglings, our output usually
// looks like this:
//
// std.debug.print("Text {placeholder} another text \n", .{variable});
//
// But how is the statement just shown formatted?
//
// This actually happens in several stages. On the one hand, escape
// sequences are evaluated, there is the "\n" which means "line feed"
// in the example. Whenever this statement is found, a new line is started
// in the output. Escpape sequences can also be written one after the
// other, e.g. "\n\n" will cause two line feeds.
//
// By the way, these formattings are passed directly to the terminal
// program, i.e. escape sequences have nothing to do with Zig in this
// respect. The formatting that Zig actually performs is found in the
// curly bracket, the "placeholder", and affects the coresponding variable.
//
// And this is where it gets exciting, because numbers can have different
// sizes, be positive or negative, with a decimal point or without,
// and so on.
//
// In order to bring these then into a uniform format for the output,
// instructions can be given to the placeholder:
//
//                print("=> {x:0>4}", .{var});
//
// This instruction outputs a hexadecimal number with leading zeros.
//
//                       => 0x0017
//
// Let's move on to our exercise: we want to create a table that shows us
// the multiplication of all numbers together from 1-15. So if you search
// for the number '5' in the row and '4' in the column (or vice versa),
// the result of '5 x 4 = 20' should be displayed there.
//
//
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    // the max. size of the table
    const size = 15;

    // print the header:
    //
    // we start with a single 'X' for the diagonal,
    // that means there is no result
    print("\n X |", .{});

    // header row with all numbers from 1 to size
    for (0..size) |n| {
        print("{d:>3} ", .{n + 1});
    }
    print("\n", .{});

    // row line
    var n: u8 = 0;
    while (n <= size) : (n += 1) {
        print("---+", .{});
    }
    print("\n", .{});

    // now the actual table
    for (0..size) |a| {
        print("{d:>2} |", .{a + 1});
        for (0..size) |b| {
            // what formatting is needed here?
            print("{???} ", .{(a + 1) * (b + 1)});
        }

        // after each row we use double line feed
        print("\n\n", .{});
    }
}
