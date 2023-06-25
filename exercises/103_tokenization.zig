//
// The functionality of the standard library is becoming increasingly
// important in Zig. On the one hand, it is helpful to look at how
// the individual functions are implemented. Because this is wonderfully
// suitable as a template for your own functions. On the other hand,
// these standard functions are part of the basic equipment of Zig.
//
// This means that they are always available on every system.
// Therefore it is worthwhile to deal with them also in Ziglings.
// It's a great way to learn important skills. For example, it is
// often necessary to process large amounts of data from files.
// And for this sequential reading and processing, Zig provides some
// useful functions, which we will take a closer look at in the coming
// exercises.
//
// A nice example of this has been published on the Zig homepage,
// replacing the somewhat dusty 'Hello world!
//
// Nothing against 'Hello world!', but it just doesn't do justice
// to the elegance of Zig and that's a pity, if someone takes a short,
// first look at the homepage and doesn't get 'enchanted'. And for that
// the present example is simply better suited and we will therefore
// use it as an introduction to tokenizing, because it is wonderfully
// suited to understand the basic principles.
//
// In the following exercises we will also read and process data from
// large files and at the latest then it will be clear to everyone how
// useful all this is.
//
// Let's start with the analysis of the example from the Zig homepage
// and explain the most important things.
//
//    const std = @import("std");
//
//    // Here a function from the Standard library is defined,
//    // which transfers numbers from a string into the respective
//    // integer values.
//    const parseInt = std.fmt.parseInt;
//
//    // Defining a test case
//    test "parse integers" {
//
//        // Four numbers are passed in a string.
//        // Please note that the individual values are separated
//        // either by a space or a comma.
//        const input = "123 67 89,99";
//
//        // In order to be able to process the input values,
//        // memory is required. An allocator is defined here for
//        // this purpose.
//        const ally = std.testing.allocator;
//
//        // The allocator is used to initialize an array into which
//        // the numbers are stored.
//        var list = std.ArrayList(u32).init(ally);
//
//        // This way you can never forget what is urgently needed
//        // and the compiler doesn't grumble either.
//        defer list.deinit();
//
//        // Now it gets exciting:
//        // A standard tokenizer is called (Zig has several) and
//        // used to locate the positions of the respective separators
//        // (we remember, space and comma) and pass them to an iterator.
//        var it = std.mem.tokenize(u8, input, " ,");
//
//        // The iterator can now be processed in a loop and the
//        // individual numbers can be transferred.
//        while (it.next()) |num| {
//            // But be careful: The numbers are still only available
//            // as strings. This is where the integer parser comes
//            // into play, converting them into real integer values.
//            const n = try parseInt(u32, num, 10);
//
//            // Finally the individual values are stored in the array.
//            try list.append(n);
//        }
//
//        // For the subsequent test, a second static array is created,
//        // which is directly filled with the expected values.
//        const expected = [_]u32{ 123, 67, 89, 99 };
//
//        // Now the numbers converted from the string can be compared
//        // with the expected ones, so that the test is completed
//        // successfully.
//        for (expected, list.items) |exp, actual| {
//            try std.testing.expectEqual(exp, actual);
//        }
//    }
//
// So much for the example from the homepage.
// Let's summarize the basic steps again:
//
// - We have a set of data in sequential order, separated from each other
//   by means of various characters.
//
// - For further processing, for example in an array, this data must be
//   read in, separated and, if necessary, converted into the target format.
//
// - We need a buffer that is large enough to hold the data.
//
// - This buffer can be created either statically at compile time, if the
//   amount of data is already known, or dynamically at runtime by using
//   a memory allocator.
//
// - The data are divided by means of Tokenizer at the respective
//   separators and stored in the reserved memory. This usually also
//   includes conversion to the target format.
//
// - Now the data can be conveniently processed further in the correct format.
//
// These steps are basically always the same.
// Whether the data is read from a file or entered by the user via the
// keyboard, for example, is irrelevant. Only subtleties are distinguished
// and that's why Zig has different tokenizers. But more about this in
// later exercises.
//
// Now we also want to write a small program to tokenize some data,
// after all we need some practice. Suppose we want to count the words
// of this little poem:
//
// 	My name is Ozymandias, King of Kings;
// 	Look on my Works, ye Mighty, and despair!
// 	 by Percy Bysshe Shelley
//
//
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {

    // our input
    const poem =
        \\My name is Ozymandias, King of Kings;
        \\Look on my Works, ye Mighty, and despair!
    ;

    // now the tokenizer, but what do we need here?
    var it = std.mem.tokenize(u8, poem, ???);

    // print all words and count them
    var cnt: usize = 0;
    while (it.next()) |word| {
        cnt += 1;
        print("{s}\n", .{word});
    }

    // print the result
    print("This little poem has {d} words!\n", .{cnt});
}
