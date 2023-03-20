//
// Struct types are always "anonymous" until we give them a name:
//
//     struct {};
//
// So far, we've been giving struct types a name like so:
//
//     const Foo = struct {};
//
// * The value of @typeName(Foo) is "<filename>.Foo".
//
// A struct is also given a name when you return it from a
// function:
//
//     fn Bar() type {
//         return struct {};
//     }
//
//     const MyBar = Bar();  // store the struct type
//     const bar = Bar() {}; // create instance of the struct
//
// * The value of @typeName(Bar()) is "Bar()".
// * The value of @typeName(MyBar) is "Bar()".
// * The value of @typeName(@TypeOf(bar)) is "Bar()".
//
// You can also have completely anonymous structs. The value
// of @typeName(struct {}) is "struct:<position in source>".
//
const print = @import("std").debug.print;

// This function creates a generic data structure by returning an
// anonymous struct type (which will no longer be anonymous AFTER
// it's returned from the function).
fn Circle(comptime T: type) type {
    return struct {
        center_x: T,
        center_y: T,
        radius: T,
    };
}

pub fn main() void {
    //
    // See if you can complete these two variable initialization
    // expressions to create instances of circle struct types
    // which can hold these values:
    //
    // * circle1 should hold i32 integers
    // * circle2 should hold f32 floats
    //
    var circle1 = Circle(i32){
        .center_x = 25,
        .center_y = 70,
        .radius = 15,
    };

    var circle2 = Circle(f32){
        .center_x = 25.234,
        .center_y = 70.999,
        .radius = 15.714,
    };

    print("[{s}: {},{},{}] ", .{
        stripFname(@typeName(@TypeOf(circle1))),
        circle1.center_x,
        circle1.center_y,
        circle1.radius,
    });

    print("[{s}: {d:.1},{d:.1},{d:.1}]\n", .{
        stripFname(@typeName(@TypeOf(circle2))),
        circle2.center_x,
        circle2.center_y,
        circle2.radius,
    });
}

// Perhaps you remember the "narcissistic fix" for the type name
// in Ex. 065? We're going to do the same thing here: use a hard-
// coded slice to return the type name. That's just so our output
// looks prettier. Indulge your vanity. Programmers are beautiful.
fn stripFname(mytype: []const u8) []const u8 {
    return mytype[22..];
}
// The above would be an instant red flag in a "real" program.
