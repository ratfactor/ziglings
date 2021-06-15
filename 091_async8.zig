//
// Perhaps you have been wondering why we have always called 'suspend'
// with an expression in the form of an empty block:
//
//     suspend {}
//
// well,
//
const print = @import("std").debug.print;

pub fn main() void {

    var my_beef = getBeef(0);

    print("beef? {X}!\n", .{my_beef});
}

fn getBeef(input: u32) u32 {
    suspend {}
}
