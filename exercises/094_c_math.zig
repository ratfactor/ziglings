//
// Often, C functions are used where no equivalent Zig function exists
// yet. Since the integration of a C function is very simple, as already
// seen in the last exercise, it naturally offers itself to use the
// very large variety of C functions for our own programs.
// As an example:
//
// Let's say we have a given angle of 765.2 degrees. If we want to
// normalize that, it means that we have to subtract X * 360 degrees
// to get the correct angle. How could we do that? A good method is
// to use the modulo function. But if we write "765.2 % 360", it won't
// work, because the standard modulo function works only with integer
// values. In the C library "math", there is a function called "fmod";
// the "f" stands for floating and means that we can solve modulo for
// real numbers. With this function, it should be possible to normalize
// our angle. Let's go.

const std = @import("std");

const c = @cImport({
    // What do wee need here?
    @cInclude("math.h");
});

pub fn main() !void {
    const angle = 765.2;
    const circle = 360;

    // Here we call the C function 'fmod' to get our normalized angle.
    const result = c.fmod(angle, circle);

    // We use formatters for the desired precision and to truncate the decimal places
    std.debug.print("The normalized angle of {d: >3.1} degrees is {d: >3.1} degrees.\n", .{ angle, result });
}
