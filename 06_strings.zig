//
// Now that we've learned about arrays, we can talk about strings.
// 
// We've already seen Zig string literals: "Hello world.\n"
//
// Like the C language, Zig stores strings as arrays of bytes
// encoded as UTF-8 characters terminated with a null value.
// For now, just focus on the fact that strings are arrays of
// characters!
//
const std = @import("std");

pub fn main() void {
    const ziggy = "stardust";

    // Use array square bracket syntax to get the letter 'd' from
    // the string "stardust" above.
    const d: u8 = ziggy[???];

    // Use the array repeat '**' operator to make "ha ha ha".
    const laugh = "ha " ???;

    // Use the array concatenation '++' operator to make "Major Tom".
    // (You'll need to add a space as well!)
    const major = "Major";
    const tom = "Tom";
    const major_tom = major ??? tom;

    std.debug.print("d={u} {}{}\n",.{d, laugh, major_tom});
    // Going deeper:
    // Keen eyes will notice that we've put a 'u' inside the '{}'
    // placeholder in the format string above. This tells the
    // print() function (which uses std.fmt.format() function) to
    // print out a UTF-8 character. Otherwise we'd see '100', which
    // is the decimal number corresponding with the 'd' character
    // in UTF-8.
    // While we're on this subject, 'c' (ASCII encoded character)
    // would work in place for 'u' because the first 128 characters
    // of UTF-8 are the same as ASCII!
}
