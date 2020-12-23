// Oh no! This program is supposed to print "Hello world!" but it has some
// mistakes. Let's fix it.
//
// We're trying to import the Standard Library into the top level of our
// application. The standard library is not named "foo", it is named "std".
//
// Please correct the name in both places in the import here:
const foo = @import("foo");

// Zig applications start by calling a function named 'main'. It needs to be
// public so that it is accessible outside our file!
//
// Public functions are declared with the 'pub' keyword like so:
//
//     pub fn my_function() void { ... }
//
// Please make the main() function public:
fn main() void {

    // The easiest way to display our "Hello world" message in the
    // terminal is to use the std.debug.print() function.
    
    // Please fix this silly "foo" mistake here:
    foo.debug.print("Hello world!\n", .{});

    // The print function above takes two values:
    //
    //   1. A string of characters: "Hello world!\n". "\n" prints a new line.
    //
    //   2. A struct containing data to be displayed. .{} is an empty, nameless
    //      struct fulfilling the requirement. More about structs later.
    //
    //
    // Now we're ready to...What's this!? Oh, we wanted to print a Goodbye
    // message as well!
    //
    // Please fix this to use the same print function as above:
    "Goodbye!\n"
}

// Once you're done with the changes above, run `ziglings` to see if it passes.
//
// Finally, all files will contain the following comment:
//
// I AM NOT DONE
//
// Delete it when you're ready to continue to the next exercise!
