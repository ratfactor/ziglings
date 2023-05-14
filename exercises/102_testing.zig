//
// A big advantage of Zig is the integration of its own test system.
// This allows the philosophy of Test Driven Development (TDD) to be
// implemented perfectly. Zig even goes one step further than other
// languages, the tests can be included directly in the source file.
//
// This has several advantages. On the one hand it is much clearer to
// have everything in one file, both the source code and the associated
// test code. On the other hand, it is much easier for third parties
// to understand what exactly a function is supposed to do if they can
// simply look at the test inside the source and compare both.
//
// Especially if you want to understand how e.g. the standard library
// of Zig works, this approach is very helpful. Furthermore it is very
// practical, if you want to report a bug to the Zig community, to
// illustrate it with a small example including a test.
//
// Therefore, in this exercise we will deal with the basics of testing
// in Zig. Basically, tests work as follows: you pass certain parameters
// to a function, for which you get a return - the result. This is then
// compared with the EXPECTED value. If both values match, the test is
// passed, otherwise an error message is displayed.
//
//          testing.expect(foo(param1, param2) == expected);
//
// Also other comparisons are possible, deviations or also errors can
// be provoked, which must lead to an appropriate behavior of the
// function, so that the test is passed.
//
// Tests can be run via Zig build system or applied directly to
// individual modules using "zig test xyz.zig".
//
// Both can be used script-driven to execute tests automatically, e.g.
// after checking into a Git repository. Something we also make extensive
// use of here at Ziglings.
//
const std = @import("std");
const testing = std.testing;

// This is a simple function
// that builds a sum from the
// passed parameters and returns.
fn add(a: f16, b: f16) f16 {
    return a + b;
}

// The associated test.
// It always starts with the keyword "test",
// followed by a description of the tasks
// of the test. This is followed by the
// test cases in curly brackets.
test "add" {

    // The first test checks if the sum
    // of '41' and '1' gives '42', which
    // is correct.
    try testing.expect(add(41, 1) == 42);

    // Another way to perform this test
    // is as follows:
    try testing.expectEqual(add(41, 1), 42);

    // This time a test with the addition
    // of a negative number:
    try testing.expect(add(5, -4) == 1);

    // And a floating point operation:
    try testing.expect(add(1.5, 1.5) == 3);
}

// Another simple function
// that returns the result
// of subtracting the two
// parameters.
fn sub(a: f16, b: f16) f16 {
    return a - b;
}

// The corresponding test
// is not much different
// from the previous one.
// Except that it contains
// an error that you need
// to correct.
test "sub" {
    try testing.expect(sub(10, 5) == 6);

    try testing.expect(sub(3, 1.5) == 1.5);
}

// This function divides the
// numerator by the denominator.
// Here it is important that the
// denominator must not be zero.
// This is checked and if it
// occurs an error is returned.
fn divide(a: f16, b: f16) !f16 {
    if (b == 0) return error.DivisionByZero;
    return a / b;
}

test "divide" {
    try testing.expect(divide(2, 2) catch unreachable == 1);
    try testing.expect(divide(-1, -1) catch unreachable == 1);
    try testing.expect(divide(10, 2) catch unreachable == 5);
    try testing.expect(divide(1, 3) catch unreachable == 0.3333333333333333);

    // Now we test if the function returns an error
    // if we pass a zero as denominator.
    // But which error needs to be tested?
    try testing.expectError(error.???, divide(15, 0));
}
