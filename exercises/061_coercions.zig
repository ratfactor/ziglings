//
// It'll only take us a moment to learn the Zig type coercion
// rules because they're quite logical.
//
// 1. Types can always be made _more_ restrictive.
//
//    var foo: u8 = 5;
//    var p1: *u8 = &foo;
//    var p2: *const u8 = p1; // mutable to immutable
//
// 2. Numeric types can coerce to _larger_ types.
//
//    var n1: u8 = 5;
//    var n2: u16 = n1; // integer "widening"
//
//    var n3: f16 = 42.0;
//    var n4: f32 = n3; // float "widening"
//
// 3. Single-item pointers to arrays coerce to slices and
//    many-item pointers.
//
//    const arr: [3]u8 = [3]u8{5, 6, 7};
//    const s: []const u8 = &arr;  // to slice
//    const p: [*]const u8 = &arr; // to many-item pointer
//
// 4. Single-item mutable pointers can coerce to single-item
//    pointers pointing to an array of length 1. (Interesting!)
//
//    var five: u8 = 5;
//    var a_five: *[1]u8 = &five;
//
// 5. Payload types and null coerce to optionals.
//
//    var num: u8 = 5;
//    var maybe_num: ?u8 = num; // payload type
//    maybe_num = null;         // null
//
// 6. Payload types and errors coerce to error unions.
//
//    const MyError = error{Argh};
//    var char: u8 = 'x';
//    var char_or_die: MyError!u8 = char; // payload type
//    char_or_die = MyError.Argh;         // error
//
// 7. 'undefined' coerces to any type (or it wouldn't work!)
//
// 8. Compile-time numbers coerce to compatible types.
//
//    Just about every single exercise program has had an example
//    of this, but a full and proper explanation is coming your
//    way soon in the third-eye-opening subject of comptime.
//
// 9. Tagged unions coerce to the current tagged enum.
//
// 10. Enums coerce to a tagged union when that tagged field is a
//     a zero-length type that has only one value (like void).
//
// 11. Zero-bit types (like void) can be coerced into single-item
//     pointers.
//
// The last three are fairly esoteric, but you're more than
// welcome to read more about them in the official Zig language
// documentation and write your own experiments.

const print = @import("std").debug.print;

pub fn main() void {
    var letter: u8 = 'A';

    const my_letter: ?*[1]u8 = &letter;
    //               ^^^^^^^
    //           Your type here.
    // Must coerce from &letter (which is a *u8).
    // Hint: Use coercion Rules 4 and 5.

    // When it's right, this will work:
    print("Letter: {u}\n", .{my_letter.?.*[0]});
}
