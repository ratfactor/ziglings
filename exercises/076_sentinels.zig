//
// A sentinel value indicates the end of data. Let's imagine a
// sequence of lowercase letters where uppercase 'S' is the
// sentinel, indicating the end of the sequence:
//
//     abcdefS
//
// If our sequence also allows for uppercase letters, 'S' would
// make a terrible sentinel since it could no longer be a regular
// value in the sequence:
//
//     abcdQRST
//          ^-- Oops! The last letter in the sequence is R!
//
// A popular choice for indicating the end of a string is the
// value 0. ASCII and Unicode call this the "Null Character".
//
// Zig supports sentinel-terminated arrays, slices, and pointers:
//
//     const a: [4:0]u32       =  [4:0]u32{1, 2, 3, 4};
//     const b: [:0]const u32  = &[4:0]u32{1, 2, 3, 4};
//     const c: [*:0]const u32 = &[4:0]u32{1, 2, 3, 4};
//
// Array 'a' stores 5 u32 values, the last of which is 0.
// However the compiler takes care of this housekeeping detail
// for you. You can treat 'a' as a normal array with just 4
// items.
//
// Slice 'b' is only allowed to point to zero-terminated arrays
// but otherwise works just like a normal slice.
//
// Pointer 'c' is exactly like the many-item pointers we learned
// about in exercise 054, but it is guaranteed to end in 0.
// Because of this guarantee, we can safely find the end of this
// many-item pointer without knowing its length. (We CAN'T do
// that with regular many-item pointers!).
//
// Important: the sentinel value must be of the same type as the
// data being terminated!
//
const print = @import("std").debug.print;
const sentinel = @import("std").meta.sentinel;

pub fn main() void {
    // Here's a zero-terminated array of u32 values:
    var nums = [_:0]u32{ 1, 2, 3, 4, 5, 6 };

    // And here's a zero-terminated many-item pointer:
    var ptr: [*:0]u32 = &nums;

    // For fun, let's replace the value at position 3 with the
    // sentinel value 0. This seems kind of naughty.
    nums[3] = 0;

    // So now we have a zero-terminated array and a many-item
    // pointer that reference the same data: a sequence of
    // numbers that both ends in and CONTAINS the sentinel value.
    //
    // Attempting to loop through and print both of these should
    // demonstrate how they are similar and different.
    //
    // (It turns out that the array prints completely, including
    // the sentinel 0 in the middle. The many-item pointer stops
    // at the first sentinel value.)
    printSequence(nums);
    printSequence(ptr);

    print("\n", .{});
}

// Here's our generic sequence printing function. It's nearly
// complete, but there are a couple of missing bits. Please fix
// them!
fn printSequence(my_seq: anytype) void {
    const my_typeinfo = @typeInfo(@TypeOf(my_seq));

    // The TypeInfo contained in my_type is a union. We use a
    // switch to handle printing the Array or Pointer fields,
    // depending on which type of my_seq was passed in:
    switch (my_typeinfo) {
        .Array => {
            print("Array:", .{});

            // Loop through the items in my_seq.
            for (???) |s| {
                print("{}", .{s});
            }
        },
        .Pointer => {
            // Check this out - it's pretty cool:
            const my_sentinel = sentinel(@TypeOf(my_seq));
            print("Many-item pointer:", .{});

            // Loop through the items in my_seq until we hit the
            // sentinel value.
            var i: usize = 0;
            while (??? != my_sentinel) {
                print("{}", .{my_seq[i]});
                i += 1;
            }
        },
        else => unreachable,
    }
    print(". ", .{});
}
