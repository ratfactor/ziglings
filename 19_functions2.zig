//
// Now let's use a function that takes a parameter.
//
const std = @import( "std" );

pub fn main() void {
    std.debug.print("Powers of two: {} {} {} {}\n", .{
        twoToThe(1),
        twoToThe(2),
        twoToThe(3),
        twoToThe(4),
    });
}

//
// Oops! We seem to have forgotten something here. Function
// parameters look like this:
//
//   fn myFunction( number: u8, is_lucky: bool ) {
//       ...
//   }
//
// As you can see, we declare the type of the parameter, just
// like we declare the types of variables, with a colon ":".
//
fn twoToThe(???) u32 {
    return std.math.pow(u32, 2, my_number);
}
