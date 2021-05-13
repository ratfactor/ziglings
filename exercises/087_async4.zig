//
// It has probably not escaped your attention that we are no
// longer capturing a return value from foo() because the 'async'
// keyword returns the frame instead.
//
// One way to solve this is to use a global variable.
//
// See if you can make this program print "1 2 3 4 5".
//
const print = @import("std").debug.print;

var global_counter: i32 = 0;

pub fn main() void {
    var foo_frame = async foo();

    while (global_counter <= 5) {
        print("{} ", .{global_counter});
        ???
    }

    print("\n", .{});
}

fn foo() void {
    while (true) {
        ???
        ???
    }
}
