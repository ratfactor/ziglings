const std = @import("std");
const testing = std.testing;

fn add(a: u16, b: u16) u16 {
    return a + b;
}

test "simple test" {
    try testing.expect(add(41, 1) == 42);
}
