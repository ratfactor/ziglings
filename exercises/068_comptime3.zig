//
// You can also put 'comptime' before a function parameter to
// enforce that the argument passed to the function must be known
// at compile time. We've actually been using a function like
// this the entire time, std.debug.print():
//
//     fn print(comptime fmt: []const u8, args: anytype) void
//
// Notice that the format string parameter 'fmt' is marked as
// 'comptime'.  One of the neat benefits of this is that the
// format string can be checked for errors at compile time rather
// than crashing at runtime.
//
// (The actual formatting is done by std.fmt.format() and it
// contains a complete format string parser that runs entirely at
// compile time!)
//
const print = @import("std").debug.print;

// This struct is the model of a model boat. We can transform it
// to any scale we would like: 1:2 is half-size, 1:32 is
// thirty-two times smaller than the real thing, and so forth.
const Schooner = struct {
    name: []const u8,
    scale: u32 = 1,
    hull_length: u32 = 143,
    bowsprit_length: u32 = 34,
    mainmast_height: u32 = 95,

    fn scaleMe(self: *Schooner, comptime scale: u32) void {
        comptime var my_scale = scale;

        // We did something neat here: we've anticipated the
        // possibility of accidentally attempting to create a
        // scale of 1:0. Rather than having this result in a
        // divide-by-zero error at runtime, we've turned this
        // into a compile error.
        //
        // This is probably the correct solution most of the
        // time. But our model boat model program is very casual
        // and we just want it to "do what I mean" and keep
        // working.
        //
        // Please change this so that it sets a 0 scale to 1
        // instead.
        if (my_scale == 0) @compileError("Scale 1:0 is not valid!");

        self.scale = my_scale;
        self.hull_length /= my_scale;
        self.bowsprit_length /= my_scale;
        self.mainmast_height /= my_scale;
    }

    fn printMe(self: Schooner) void {
        print("{s} (1:{}, {} x {})\n", .{
            self.name,
            self.scale,
            self.hull_length,
            self.mainmast_height,
        });
    }
};

pub fn main() void {
    var whale = Schooner{ .name = "Whale" };
    var shark = Schooner{ .name = "Shark" };
    var minnow = Schooner{ .name = "Minnow" };

    // Hey, we can't just pass this runtime variable as an
    // argument to the scaleMe() method. What would let us do
    // that?
    var scale: u32 = undefined;

    scale = 32; // 1:32 scale

    minnow.scaleMe(scale);
    minnow.printMe();

    scale -= 16; // 1:16 scale

    shark.scaleMe(scale);
    shark.printMe();

    scale -= 16; // 1:0 scale (oops, but DON'T FIX THIS!)

    whale.scaleMe(scale);
    whale.printMe();
}
//
// Going deeper:
//
// What would happen if you DID attempt to build a model in the
// scale of 1:0?
//
//    A) You're already done!
//    B) You would suffer a mental divide-by-zero error.
//    C) You would construct a singularity and destroy the
//       planet.
//
// And how about a model in the scale of 0:1?
//
//    A) You're already done!
//    B) You'd arrange nothing carefully into the form of the
//       original nothing but infinitely larger.
//    C) You would construct a singularity and destroy the
//       planet.
//
// Answers can be found on the back of the Ziglings packaging.
