//
// Anonymous struct literal syntax can also be used to compose an
// "anonymous list" with an array type destination:
//
//     const foo: [3]u32 = .{10, 20, 30};
//
// Otherwise it's a "tuple":
//
//     const bar = .{10, 20, 30};
//
// The only difference is the destination type.
//
const print = @import("std").debug.print;

pub fn main() void {
    // Please make 'hello' a string-like array of u8 WITHOUT
    // changing the value literal.
    //
    // Don't change this part:
    //
    //     = .{'h', 'e', 'l', 'l', 'o'};
    //
    const hello: [5]u8 = .{ 'h', 'e', 'l', 'l', 'o' };
    print("I say {s}!\n", .{hello});
}
