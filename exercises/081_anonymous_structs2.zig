//
// An anonymous struct value LITERAL (not to be confused with a
// struct TYPE) uses '.{}' syntax:
//
//     .{
//          .center_x = 15,
//          .center_y = 12,
//          .radius = 6,
//     }
//
// These literals are always evaluated entirely at compile-time.
// The example above could be coerced into the i32 variant of the
// "circle struct" from the last exercise.
//
// Or you can let them remain entirely anonymous as in this
// example:
//
//     fn bar(foo: anytype) void {
//         print("a:{} b:{}\n", .{foo.a, foo.b});
//     }
//
//     bar(.{
//         .a = true,
//         .b = false,
//     });
//
// The example above prints "a:true b:false".
//
const print = @import("std").debug.print;

pub fn main() void {
    printCircle(.{
        .center_x = @as(u32, 205),
        .center_y = @as(u32, 187),
        .radius = @as(u32, 12),
    });
}

// Please complete this function which prints an anonymous struct
// representing a circle.
fn printCircle(???) void {
    print("x:{} y:{} radius:{}\n", .{
        circle.center_x,
        circle.center_y,
        circle.radius,
    });
}
