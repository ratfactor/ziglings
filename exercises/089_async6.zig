//
// The power and purpose of async/await becomes more apparent
// when we do multiple things concurrently. Foo and Bar do not
// depend on each other and can happen at the same time, but End
// requires that they both be finished.
//
//               +---------+
//               |  Start  |
//               +---------+
//                  /    \
//                 /      \
//        +---------+    +---------+
//        |   Foo   |    |   Bar   |
//        +---------+    +---------+
//                 \      /
//                  \    /
//               +---------+
//               |   End   |
//               +---------+
//
// We can express this in Zig like so:
//
//     fn foo() u32 { ... }
//     fn bar() u32 { ... }
//
//     // Start
//
//     var foo_frame = async foo();
//     var bar_frame = async bar();
//
//     var foo_value = await foo_frame;
//     var bar_value = await bar_frame;
//
//     // End
//
// Please await TWO page titles!
//
const print = @import("std").debug.print;

pub fn main() void {
    var com_frame = async getPageTitle("http://example.com");
    var org_frame = async getPageTitle("http://example.org");

    var com_title = com_frame;
    var org_title = org_frame;

    print(".com: {s}, .org: {s}.\n", .{ com_title, org_title });
}

fn getPageTitle(url: []const u8) []const u8 {
    // Please PRETEND this is actually making a network request.
    _ = url;
    return "Example Title";
}
