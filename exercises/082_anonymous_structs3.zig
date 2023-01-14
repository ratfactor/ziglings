//
// You can even create anonymous struct literals without field
// names:
//
//     .{
//         false,
//         @as(u32, 15),
//         @as(f64, 67.12)
//     }
//
// We call these "tuples", which is a term used by many
// programming languages for a data type with fields referenced
// by index order rather than name. To make this possible, the Zig
// compiler automatically assigns numeric field names 0, 1, 2,
// etc. to the struct.
//
// Since bare numbers are not legal identifiers (foo.0 is a
// syntax error), we have to quote them with the @"" syntax.
// Example:
//
//     const foo = .{ true, false };
//
//     print("{} {}\n", .{foo.@"0", foo.@"1"});
//
// The example above prints "true false".
//
// Hey, WAIT A SECOND...
//
// If a .{} thing is what the print function wants, do we need to
// break our "tuple" apart and put it in another one? No! It's
// redundant! This will print the same thing:
//
//     print("{} {}\n", foo);
//
// Aha! So now we know that print() takes a "tuple". Things are
// really starting to come together now.
//
const print = @import("std").debug.print;

pub fn main() void {
    // A "tuple":
    const foo = .{
        true,
        false,
        @as(i32, 42),
        @as(f32, 3.141592),
    };

    // We'll be implementing this:
    printTuple(foo);

    // This is just for fun, because we can:
    const nothing = .{};
    print("\n", nothing);
}

// Let's make our own generic "tuple" printer. This should take a
// "tuple" and print out each field in the following format:
//
//     "name"(type):value
//
// Example:
//
//     "0"(bool):true
//
// You'll be putting this together. But don't worry, everything
// you need is documented in the comments.
fn printTuple(tuple: anytype) void {
    // 1. Get a list of fields in the input 'tuple'
    // parameter. You'll need:
    //
    //     @TypeOf() - takes a value, returns its type.
    //
    //     @typeInfo() - takes a type, returns a TypeInfo union
    //                   with fields specific to that type.
    //
    //     The list of a struct type's fields can be found in
    //     TypeInfo's Struct.fields.
    //
    //     Example:
    //
    //         @typeInfo(Circle).Struct.fields
    //
    // This will be an array of StructFields.
    const fields = ???;

    // 2. Loop through each field. This must be done at compile
    // time.
    //
    //     Hint: remember 'inline' loops?
    //
    for (fields) |field| {
        // 3. Print the field's name, type, and value.
        //
        //     Each 'field' in this loop is one of these:
        //
        //         pub const StructField = struct {
        //             name: []const u8,
        //             type: type,
        //             default_value: anytype,
        //             is_comptime: bool,
        //             alignment: comptime_int,
        //         };
        //
        //     You'll need this builtin:
        //
        //         @field(lhs: anytype, comptime field_name: []const u8)
        //
        //     The first parameter is the value to be accessed,
        //     the second parameter is a string with the name of
        //     the field you wish to access. The value of the
        //     field is returned.
        //
        //     Example:
        //
        //         @field(foo, "x"); // returns the value at foo.x
        //
        // The first field should print as: "0"(bool):true
        print("\"{s}\"({any}):{any} ", .{
            field.???,
            field.???,
            ???,
        });
    }
}
