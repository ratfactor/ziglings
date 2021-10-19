//
// Using `catch` to replace an error with a default value is a bit
// of a blunt instrument since it doesn't matter what the error is.
//
// Catch lets us capture the error value and perform additional
// actions with this form:
//
//     canFail() catch |err| {
//         if (err == FishError.TunaMalfunction) {
//             ...
//         }
//     };
//
const std = @import("std");

const MyNumberError = error{
    TooSmall,
    TooBig,
};

pub fn main() void {
    // The "catch 0" below is a temporary hack to deal with
    // makeJustRight()'s returned error union (for now).
    var a: u32 = makeJustRight(44) catch 0;
    var b: u32 = makeJustRight(14) catch 0;
    var c: u32 = makeJustRight(4) catch 0;

    std.debug.print("a={}, b={}, c={}\n", .{ a, b, c });
}

// In this silly example we've split the responsibility of making
// a number just right into four (!) functions:
//
//     makeJustRight()   Calls fixTooBig(), cannot fix any errors.
//     fixTooBig()       Calls fixTooSmall(), fixes TooBig errors.
//     fixTooSmall()     Calls detectProblems(), fixes TooSmall errors.
//     detectProblems()  Returns the number or an error.
//
fn makeJustRight(n: u32) MyNumberError!u32 {
    return fixTooBig(n) catch |err| {
        return err;
    };
}

fn fixTooBig(n: u32) MyNumberError!u32 {
    return fixTooSmall(n) catch |err| {
        if (err == MyNumberError.TooBig) {
            return 20;
        }

        return err;
    };
}

fn fixTooSmall(n: u32) MyNumberError!u32 {
    // Oh dear, this is missing a lot! But don't worry, it's nearly
    // identical to fixTooBig() above.
    //
    // If we get a TooSmall error, we should return 10.
    // If we get any other error, we should return that error.
    // Otherwise, we return the u32 number.
    return detectProblems(n) catch |err| {
        if (err == MyNumberError.TooSmall) {
            return 10;
        }
        return err;
    };
}

fn detectProblems(n: u32) MyNumberError!u32 {
    if (n < 10) return MyNumberError.TooSmall;
    if (n > 20) return MyNumberError.TooBig;
    return n;
}
