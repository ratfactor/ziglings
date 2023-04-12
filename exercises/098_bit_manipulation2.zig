//
// Another useful practice for bit manipulation is setting bits as flags.
// This is especially useful when processing lists of something and storing
// the states of the entries, e.g. a list of numbers and for each prime
// number a flag is set.
//
// As an example, let's take the Pangram exercise from Exercism:
// https://exercism.org/tracks/zig/exercises/pangram
//
// A pangram is a sentence using every letter of the alphabet at least once.
// It is case insensitive, so it doesn't matter if a letter is lower-case
// or upper-case. The best known English pangram is:
//
//           "The quick brown fox jumps over the lazy dog."
//
// There are several ways to select the letters that appear in the pangram
// (and it doesn't matter if they appear once or several times).
//
// For example, you could take an array of bool and set the value to 'true'
// for each letter in the order of the alphabet (a=0; b=1; etc.) found in
// the sentence. However, this is neither memory efficient nor particularly
// fast. Instead we take a simpler way, very similar in principle, we define
// a variable with at least 26 bits (e.g. u32) and also set the bit for each
// letter found at the corresponding position.
//
// Zig provides functions for this in the standard library, but we prefer to
// solve it without these extras, after all we want to learn something.
//
const std = @import("std");
const ascii = std.ascii;
const print = std.debug.print;

pub fn main() !void {
    // let's check the pangram
    print("Is this a pangram? {?}!\n", .{isPangram("The quick brown fox jumps over the lazy dog.")});
}

fn isPangram(str: []const u8) bool {
    // first we check if the string has at least 26 characters
    if (str.len < 26) return false;

    // we uses a 32 bit variable of which we need 26 bit
    var bits: u32 = 0;

    // loop about all characters in the string
    for (str) |c| {
        // if the character is an alphabetical character
        if (ascii.isASCII(c) and ascii.isAlphabetic(c)) {
            // then we set the bit at the position
            //
            // to do this, we use a little trick:
            // since the letters in the ASCI table start at 65
            // and are numbered by, we simply subtract the first
            // letter (in this case the 'a') from the character
            // found, and thus get the position of the desired bit
            bits |= @as(u32, 1) << @truncate(u5, ascii.toLower(c) - 'a');
        }
    }
    // last we return the comparison if all 26 bits are set,
    // and if so, we know the given string is a pangram
    //
    // but what do we have to compare?
    return bits == 0x..???;
}
