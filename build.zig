const std = @import("std");
const builtin = @import("builtin");
const compat = @import("src/compat.zig");
const tests = @import("test/tests.zig");

const Build = compat.Build;
const Step = compat.build.Step;
const Child = std.process.Child;

const assert = std.debug.assert;
const print = std.debug.print;

pub const Exercise = struct {
    /// main_file must have the format key_name.zig.
    /// The key will be used as a shorthand to build
    /// just one example.
    main_file: []const u8,

    /// This is the desired output of the program.
    /// A program passes if its output ends with this string.
    output: []const u8,

    /// This is an optional hint to give if the program does not succeed.
    hint: []const u8 = "",

    /// By default, we verify output against stderr.
    /// Set this to true to check stdout instead.
    check_stdout: bool = false,

    /// This exercise makes use of the async feature.
    /// We need to keep track of this, so we compile without the self hosted compiler
    @"async": bool = false,

    /// This exercise makes use of C functions
    /// We need to keep track of this, so we compile with libc
    C: bool = false,

    /// This exercise is not supported by the current Zig compiler.
    skip: bool = false,

    /// Returns the name of the main file with .zig stripped.
    pub fn baseName(self: Exercise) []const u8 {
        assert(std.mem.endsWith(u8, self.main_file, ".zig"));
        return self.main_file[0 .. self.main_file.len - 4];
    }

    /// Returns the key of the main file, the string before the '_' with
    /// "zero padding" removed.
    /// For example, "001_hello.zig" has the key "1".
    pub fn key(self: Exercise) []const u8 {
        const end_index = std.mem.indexOfScalar(u8, self.main_file, '_');
        assert(end_index != null); // main file must be key_description.zig

        // remove zero padding by advancing index past '0's
        var start_index: usize = 0;
        while (self.main_file[start_index] == '0') start_index += 1;
        return self.main_file[start_index..end_index.?];
    }

    /// Returns the exercise key as an integer.
    pub fn number(self: Exercise) usize {
        return std.fmt.parseInt(usize, self.key(), 10) catch unreachable;
    }
};

const exercises = [_]Exercise{
    .{
        .main_file = "001_hello.zig",
        .output = "Hello world!",
        .hint = "DON'T PANIC!\nRead the error above.\nSee how it has something to do with 'main'?\nOpen up the source file as noted and read the comments.\nYou can do this!",
    },
    .{
        .main_file = "002_std.zig",
        .output = "Standard Library.",
    },
    .{
        .main_file = "003_assignment.zig",
        .output = "55 314159 -11",
        .hint = "There are three mistakes in this one!",
    },
    .{
        .main_file = "004_arrays.zig",
        .output = "First: 2, Fourth: 7, Length: 8",
        .hint = "There are two things to complete here.",
    },
    .{
        .main_file = "005_arrays2.zig",
        .output = "LEET: 1337, Bits: 100110011001",
        .hint = "Fill in the two arrays.",
    },
    .{
        .main_file = "006_strings.zig",
        .output = "d=d ha ha ha Major Tom",
        .hint = "Each '???' needs something filled in.",
    },
    .{
        .main_file = "007_strings2.zig",
        .output = "Ziggy played guitar\nJamming good with Andrew Kelley\nAnd the Spiders from Mars",
        .hint = "Please fix the lyrics!",
    },
    .{
        .main_file = "008_quiz.zig",
        .output = "Program in Zig!",
        .hint = "See if you can fix the program!",
    },
    .{
        .main_file = "009_if.zig",
        .output = "Foo is 1!",
    },
    .{
        .main_file = "010_if2.zig",
        .output = "With the discount, the price is $17.",
    },
    .{
        .main_file = "011_while.zig",
        .output = "2 4 8 16 32 64 128 256 512 n=1024",
        .hint = "You probably want a 'less than' condition.",
    },
    .{
        .main_file = "012_while2.zig",
        .output = "2 4 8 16 32 64 128 256 512 n=1024",
        .hint = "It might help to look back at the previous exercise.",
    },
    .{
        .main_file = "013_while3.zig",
        .output = "1 2 4 7 8 11 13 14 16 17 19",
    },
    .{
        .main_file = "014_while4.zig",
        .output = "n=4",
    },
    .{
        .main_file = "015_for.zig",
        .output = "A Dramatic Story: :-)  :-)  :-(  :-|  :-)  The End.",
    },
    .{
        .main_file = "016_for2.zig",
        .output = "The value of bits '1101': 13.",
    },
    .{
        .main_file = "017_quiz2.zig",
        .output = "1, 2, Fizz, 4, Buzz, Fizz, 7, 8, Fizz, Buzz, 11, Fizz, 13, 14, FizzBuzz, 16,",
        .hint = "This is a famous game!",
    },
    .{
        .main_file = "018_functions.zig",
        .output = "Answer to the Ultimate Question: 42",
        .hint = "Can you help write the function?",
    },
    .{
        .main_file = "019_functions2.zig",
        .output = "Powers of two: 2 4 8 16",
    },
    .{
        .main_file = "020_quiz3.zig",
        .output = "32 64 128 256",
        .hint = "Unexpected pop quiz! Help!",
    },
    .{
        .main_file = "021_errors.zig",
        .output = "2<4. 3<4. 4=4. 5>4. 6>4.",
        .hint = "What's the deal with fours?",
    },
    .{
        .main_file = "022_errors2.zig",
        .output = "I compiled!",
        .hint = "Get the error union type right to allow this to compile.",
    },
    .{
        .main_file = "023_errors3.zig",
        .output = "a=64, b=22",
    },
    .{
        .main_file = "024_errors4.zig",
        .output = "a=20, b=14, c=10",
    },
    .{
        .main_file = "025_errors5.zig",
        .output = "a=0, b=19, c=0",
    },
    .{
        .main_file = "026_hello2.zig",
        .output = "Hello world!",
        .hint = "Try using a try!",
        .check_stdout = true,
    },
    .{
        .main_file = "027_defer.zig",
        .output = "One Two",
    },
    .{
        .main_file = "028_defer2.zig",
        .output = "(Goat) (Cat) (Dog) (Dog) (Goat) (Unknown) done.",
    },
    .{
        .main_file = "029_errdefer.zig",
        .output = "Getting number...got 5. Getting number...failed!",
    },
    .{
        .main_file = "030_switch.zig",
        .output = "ZIG?",
    },
    .{
        .main_file = "031_switch2.zig",
        .output = "ZIG!",
    },
    .{
        .main_file = "032_unreachable.zig",
        .output = "1 2 3 9 8 7",
    },
    .{
        .main_file = "033_iferror.zig",
        .output = "2<4. 3<4. 4=4. 5>4. 6>4.",
        .hint = "Seriously, what's the deal with fours?",
    },
    .{
        .main_file = "034_quiz4.zig",
        .output = "my_num=42",
        .hint = "Can you make this work?",
        .check_stdout = true,
    },
    .{
        .main_file = "035_enums.zig",
        .output = "1 2 3 9 8 7",
        .hint = "This problem seems familiar...",
    },
    .{
        .main_file = "036_enums2.zig",
        .output = "<p>\n  <span style=\"color: #ff0000\">Red</span>\n  <span style=\"color: #00ff00\">Green</span>\n  <span style=\"color: #0000ff\">Blue</span>\n</p>",
        .hint = "I'm feeling blue about this.",
    },
    .{
        .main_file = "037_structs.zig",
        .output = "Your wizard has 90 health and 25 gold.",
    },
    .{
        .main_file = "038_structs2.zig",
        .output = "Character 1 - G:20 H:100 XP:10\nCharacter 2 - G:10 H:100 XP:20",
    },
    .{
        .main_file = "039_pointers.zig",
        .output = "num1: 5, num2: 5",
        .hint = "Pointers aren't so bad.",
    },
    .{
        .main_file = "040_pointers2.zig",
        .output = "a: 12, b: 12",
    },
    .{
        .main_file = "041_pointers3.zig",
        .output = "foo=6, bar=11",
    },
    .{
        .main_file = "042_pointers4.zig",
        .output = "num: 5, more_nums: 1 1 5 1",
    },
    .{
        .main_file = "043_pointers5.zig",
        .output = "Wizard (G:10 H:100 XP:20)\n  Mentor: Wizard (G:10000 H:100 XP:2340)",
    },
    .{
        .main_file = "044_quiz5.zig",
        .output = "Elephant A. Elephant B. Elephant C.",
        .hint = "Oh no! We forgot Elephant B!",
    },
    .{
        .main_file = "045_optionals.zig",
        .output = "The Ultimate Answer: 42.",
    },
    .{
        .main_file = "046_optionals2.zig",
        .output = "Elephant A. Elephant B. Elephant C.",
        .hint = "Elephants again!",
    },
    .{
        .main_file = "047_methods.zig",
        .output = "5 aliens. 4 aliens. 1 aliens. 0 aliens. Earth is saved!",
        .hint = "Use the heat ray. And the method!",
    },
    .{
        .main_file = "048_methods2.zig",
        .output = "A  B  C",
        .hint = "This just needs one little fix.",
    },
    .{
        .main_file = "049_quiz6.zig",
        .output = "A  B  C  Cv Bv Av",
        .hint = "Now you're writing Zig!",
    },
    .{
        .main_file = "050_no_value.zig",
        .output = "That is not dead which can eternal lie / And with strange aeons even death may die.",
    },
    .{
        .main_file = "051_values.zig",
        .output = "1:false!. 2:true!. 3:true!. XP before:0, after:200.",
    },
    .{
        .main_file = "052_slices.zig",
        .output = "Hand1: A 4 K 8 \nHand2: 5 2 Q J",
    },
    .{
        .main_file = "053_slices2.zig",
        .output = "'all your base are belong to us.' 'for great justice.'",
    },
    .{
        .main_file = "054_manypointers.zig",
        .output = "Memory is a resource.",
    },
    .{
        .main_file = "055_unions.zig",
        .output = "Insect report! Ant alive is: true. Bee visited 15 flowers.",
    },
    .{
        .main_file = "056_unions2.zig",
        .output = "Insect report! Ant alive is: true. Bee visited 16 flowers.",
    },
    .{
        .main_file = "057_unions3.zig",
        .output = "Insect report! Ant alive is: true. Bee visited 17 flowers.",
    },
    .{
        .main_file = "058_quiz7.zig",
        .output = "Archer's Point--2->Bridge--1->Dogwood Grove--3->Cottage--2->East Pond--1->Fox Pond",
        .hint = "This is the biggest program we've seen yet. But you can do it!",
    },
    .{
        .main_file = "059_integers.zig",
        .output = "Zig is cool.",
    },
    .{
        .main_file = "060_floats.zig",
        .output = "Shuttle liftoff weight: 1995796kg",
    },
    .{
        .main_file = "061_coercions.zig",
        .output = "Letter: A",
    },
    .{
        .main_file = "062_loop_expressions.zig",
        .output = "Current language: Zig",
        .hint = "Surely the current language is 'Zig'!",
    },
    .{
        .main_file = "063_labels.zig",
        .output = "Enjoy your Cheesy Chili!",
    },
    .{
        .main_file = "064_builtins.zig",
        .output = "1101 + 0101 = 0010 (true). Without overflow: 00010010. Furthermore, 11110000 backwards is 00001111.",
    },
    .{
        .main_file = "065_builtins2.zig",
        .output = "A Narcissus loves all Narcissuses. He has room in his heart for: me myself.",
    },
    .{
        .main_file = "066_comptime.zig",
        .output = "Immutable: 12345, 987.654; Mutable: 54321, 456.789; Types: comptime_int, comptime_float, u32, f32",
        .hint = "It may help to read this one out loud to your favorite stuffed animal until it sinks in completely.",
    },
    .{
        .main_file = "067_comptime2.zig",
        .output = "A BB CCC DDDD",
    },
    .{
        .main_file = "068_comptime3.zig",
        .output = "Minnow (1:32, 4 x 2)\nShark (1:16, 8 x 5)\nWhale (1:1, 143 x 95)\n",
    },
    .{
        .main_file = "069_comptime4.zig",
        .output = "s1={ 1, 2, 3 }, s2={ 1, 2, 3, 4, 5 }, s3={ 1, 2, 3, 4, 5, 6, 7 }",
    },
    .{
        .main_file = "070_comptime5.zig",
        .output = "\"Quack.\" ducky1: true, \"Squeek!\" ducky2: true, ducky3: false",
        .hint = "Have you kept the wizard hat on?",
    },
    .{
        .main_file = "071_comptime6.zig",
        .output = "Narcissus has room in his heart for: me myself.",
    },
    .{
        .main_file = "072_comptime7.zig",
        .output = "26",
    },
    .{
        .main_file = "073_comptime8.zig",
        .output = "My llama value is 25.",
    },
    .{
        .main_file = "074_comptime9.zig",
        .output = "My llama value is 2.",
    },
    .{
        .main_file = "075_quiz8.zig",
        .output = "Archer's Point--2->Bridge--1->Dogwood Grove--3->Cottage--2->East Pond--1->Fox Pond",
        .hint = "Roll up those sleeves. You get to WRITE some code for this one.",
    },
    .{
        .main_file = "076_sentinels.zig",
        .output = "Array:123056. Many-item pointer:123.",
    },
    .{
        .main_file = "077_sentinels2.zig",
        .output = "Weird Data!",
    },
    .{
        .main_file = "078_sentinels3.zig",
        .output = "Weird Data!",
    },
    .{
        .main_file = "079_quoted_identifiers.zig",
        .output = "Sweet freedom: 55, false.",
        .hint = "Help us, Zig Programmer, you're our only hope!",
    },
    .{
        .main_file = "080_anonymous_structs.zig",
        .output = "[Circle(i32): 25,70,15] [Circle(f32): 25.2,71.0,15.7]",
    },
    .{
        .main_file = "081_anonymous_structs2.zig",
        .output = "x:205 y:187 radius:12",
    },
    .{
        .main_file = "082_anonymous_structs3.zig",
        .output = "\"0\"(bool):true \"1\"(bool):false \"2\"(i32):42 \"3\"(f32):3.14159202e+00",
        .hint = "This one is a challenge! But you have everything you need.",
    },
    .{
        .main_file = "083_anonymous_lists.zig",
        .output = "I say hello!",
    },

    // Skipped because of https://github.com/ratfactor/ziglings/issues/163
    // direct link: https://github.com/ziglang/zig/issues/6025
    .{
        .main_file = "084_async.zig",
        .output = "foo() A",
        .hint = "Read the facts. Use the facts.",
        .@"async" = true,
        .skip = true,
    },
    .{
        .main_file = "085_async2.zig",
        .output = "Hello async!",
        .@"async" = true,
        .skip = true,
    },
    .{
        .main_file = "086_async3.zig",
        .output = "5 4 3 2 1",
        .@"async" = true,
        .skip = true,
    },
    .{
        .main_file = "087_async4.zig",
        .output = "1 2 3 4 5",
        .@"async" = true,
        .skip = true,
    },
    .{
        .main_file = "088_async5.zig",
        .output = "Example Title.",
        .@"async" = true,
        .skip = true,
    },
    .{
        .main_file = "089_async6.zig",
        .output = ".com: Example Title, .org: Example Title.",
        .@"async" = true,
        .skip = true,
    },
    .{
        .main_file = "090_async7.zig",
        .output = "beef? BEEF!",
        .@"async" = true,
        .skip = true,
    },
    .{
        .main_file = "091_async8.zig",
        .output = "ABCDEF",
        .@"async" = true,
        .skip = true,
    },

    .{
        .main_file = "092_interfaces.zig",
        .output = "Daily Insect Report:\nAnt is alive.\nBee visited 17 flowers.\nGrasshopper hopped 32 meters.",
    },
    .{
        .main_file = "093_hello_c.zig",
        .output = "Hello C from Zig! - C result is 17 chars written.",
        .C = true,
    },
    .{
        .main_file = "094_c_math.zig",
        .output = "The normalized angle of 765.2 degrees is 45.2 degrees.",
        .C = true,
    },
    .{
        .main_file = "095_for_loops.zig",
        .output = "1 2 4 7 8 11 13 14 16 17 19",
    },
    .{
        .main_file = "096_memory_allocation.zig",
        .output = "Running Average: 0.30 0.25 0.20 0.18 0.22",
    },
    .{
        .main_file = "097_bit_manipulation.zig",
        .output = "x = 0; y = 1",
    },
    .{
        .main_file = "098_bit_manipulation2.zig",
        .output = "Is this a pangram? true!",
    },
    .{
        .main_file = "999_the_end.zig",
        .output = "\nThis is the end for now!\nWe hope you had fun and were able to learn a lot, so visit us again when the next exercises are available.",
    },
};

// Read a file named "completed_to.txt" in the current work directory, where the build process writes the number
// of the last completed exercise as a 3 digit 0-padded string e.g. "001". Will fail if the file doesn't
// exist or if or the number is formatted incorrectly, so use `catch 0` to default to running all the exercises.
pub fn filter_exercises(allocator: std.mem.Allocator) !u16 {
    var buf: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const cwd = try std.os.getcwd(&buf);

    const path = try std.fs.path.join(allocator, &[_][]const u8{
        cwd, "completed_to.txt",
    });
    var up_to: [3]u8 = undefined;
    const number_text_file = try std.fs.openFileAbsolute(path, .{});
    _ = try number_text_file.read(&up_to);
    print(
        \\Starting checks from exercise: {s}
        \\delete completed_to.txt to check every exercise
        \\or run `zig build -Dn=19 start` to start from the given exercise
        \\
    , .{up_to});

    var start_index: usize = 0;
    if (std.mem.eql(u8, &up_to, "000")) start_index = 2 else {
        while (up_to[start_index] == '0') start_index += 1;
    }
    var up_to_short = up_to[start_index..3];
    const up_to_int = std.fmt.parseInt(u16, up_to_short, 10) catch 0;
    return up_to_int;
}

pub fn build(b: *Build) !void {
    if (!compat.is_compatible) compat.die();
    if (!validate_exercises()) std.os.exit(1);

    use_color_escapes = false;
    if (std.io.getStdErr().supportsAnsiEscapeCodes()) {
        use_color_escapes = true;
    } else if (builtin.os.tag == .windows) {
        const w32 = struct {
            const WINAPI = std.os.windows.WINAPI;
            const DWORD = std.os.windows.DWORD;
            const ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004;
            const STD_ERROR_HANDLE = @bitCast(DWORD, @as(i32, -12));
            extern "kernel32" fn GetStdHandle(id: DWORD) callconv(WINAPI) ?*anyopaque;
            extern "kernel32" fn GetConsoleMode(console: ?*anyopaque, out_mode: *DWORD) callconv(WINAPI) u32;
            extern "kernel32" fn SetConsoleMode(console: ?*anyopaque, mode: DWORD) callconv(WINAPI) u32;
        };
        const handle = w32.GetStdHandle(w32.STD_ERROR_HANDLE);
        var mode: w32.DWORD = 0;
        if (w32.GetConsoleMode(handle, &mode) != 0) {
            mode |= w32.ENABLE_VIRTUAL_TERMINAL_PROCESSING;
            use_color_escapes = w32.SetConsoleMode(handle, mode) != 0;
        }
    }

    if (use_color_escapes) {
        red_text = "\x1b[31m";
        green_text = "\x1b[32m";
        bold_text = "\x1b[1m";
        reset_text = "\x1b[0m";
    }

    const logo =
        \\
        \\         _       _ _
        \\     ___(_) __ _| (_)_ __   __ _ ___
        \\    |_  | |/ _' | | | '_ \ / _' / __|
        \\     / /| | (_| | | | | | | (_| \__ \
        \\    /___|_|\__, |_|_|_| |_|\__, |___/
        \\           |___/           |___/
        \\
        \\
    ;

    const use_healed = b.option(bool, "healed", "Run exercises from patches/healed") orelse false;
    const exno: ?usize = b.option(usize, "n", "Select exercise");

    const header_step = PrintStep.create(b, logo);

    if (exno) |n| {
        if (n == 0 or n > exercises.len - 1) {
            print("unknown exercise number: {}\n", .{n});
            std.os.exit(1);
        }

        const ex = exercises[n - 1];
        const base_name = ex.baseName();
        const file_path = std.fs.path.join(b.allocator, &[_][]const u8{
            if (use_healed) "patches/healed" else "exercises", ex.main_file,
        }) catch unreachable;

        const build_step = b.addExecutable(.{ .name = base_name, .root_source_file = .{ .path = file_path } });
        if (ex.C) {
            build_step.linkLibC();
        }
        b.installArtifact(build_step);

        const run_step = b.addRunArtifact(build_step);

        const test_step = b.step("test", b.fmt("Run {s} without checking output", .{ex.main_file}));
        if (ex.skip) {
            const skip_step = SkipStep.create(b, ex);
            test_step.dependOn(&skip_step.step);
        } else {
            test_step.dependOn(&run_step.step);
        }

        const install_step = b.step("install", b.fmt("Install {s} to prefix path", .{ex.main_file}));
        install_step.dependOn(b.getInstallStep());

        const uninstall_step = b.step("uninstall", b.fmt("Uninstall {s} from prefix path", .{ex.main_file}));
        uninstall_step.dependOn(b.getUninstallStep());

        const verify_step = ZiglingStep.create(b, ex, use_healed);

        const zigling_step = b.step("zigling", b.fmt("Check the solution of {s}", .{ex.main_file}));
        zigling_step.dependOn(&verify_step.step);
        b.default_step = zigling_step;

        const start_step = b.step("start", b.fmt("Check all solutions starting at {s}", .{ex.main_file}));

        var prev_step = verify_step;
        for (exercises) |exn| {
            const nth = exn.number();
            if (nth > n) {
                const verify_stepn = ZiglingStep.create(b, exn, use_healed);
                verify_stepn.step.dependOn(&prev_step.step);

                prev_step = verify_stepn;
            }
        }
        start_step.dependOn(&prev_step.step);

        return;
    } else if (use_healed and false) {
        const test_step = b.step("test", "Test the healed exercises");
        b.default_step = test_step;

        for (exercises) |ex| {
            const base_name = ex.baseName();
            const file_path = std.fs.path.join(b.allocator, &[_][]const u8{
                "patches/healed", ex.main_file,
            }) catch unreachable;

            const build_step = b.addExecutable(.{ .name = base_name, .root_source_file = .{ .path = file_path } });
            if (ex.C) {
                build_step.linkLibC();
            }
            b.installArtifact(build_step);

            const run_step = b.addRunArtifact(build_step);
            if (ex.skip) {
                const skip_step = SkipStep.create(b, ex);
                test_step.dependOn(&skip_step.step);
            } else {
                test_step.dependOn(&run_step.step);
            }
        }

        return;
    }

    const ziglings_step = b.step("ziglings", "Check all ziglings");
    b.default_step = ziglings_step;

    var prev_step = &header_step.step;

    const exercises_start = filter_exercises(b.allocator) catch 0;
    for (exercises[exercises_start..]) |ex| {
        const base_name = ex.baseName();
        const file_path = std.fs.path.join(b.allocator, &[_][]const u8{
            "exercises", ex.main_file,
        }) catch unreachable;

        const build_step = b.addExecutable(.{ .name = base_name, .root_source_file = .{ .path = file_path } });
        b.installArtifact(build_step);

        const verify_stepn = ZiglingStep.create(b, ex, use_healed);
        verify_stepn.step.dependOn(prev_step);

        prev_step = &verify_stepn.step;
    }
    ziglings_step.dependOn(prev_step);

    const test_step = b.step("test", "Run all the tests");
    test_step.dependOn(tests.addCliTests(b, &exercises));
}

var use_color_escapes = false;
var red_text: []const u8 = "";
var green_text: []const u8 = "";
var bold_text: []const u8 = "";
var reset_text: []const u8 = "";

const ZiglingStep = struct {
    step: Step,
    exercise: Exercise,
    builder: *Build,
    use_healed: bool,

    pub fn create(builder: *Build, exercise: Exercise, use_healed: bool) *@This() {
        const self = builder.allocator.create(@This()) catch unreachable;
        self.* = .{
            .step = Step.init(Step.Options{ .id = .custom, .name = exercise.main_file, .owner = builder, .makeFn = make }),
            .exercise = exercise,
            .builder = builder,
            .use_healed = use_healed,
        };
        return self;
    }

    fn make(step: *Step, prog_node: *std.Progress.Node) anyerror!void {
        const self = @fieldParentPtr(@This(), "step", step);

        if (self.exercise.skip) {
            print("Skipping {s}\n\n", .{self.exercise.main_file});

            return;
        }
        self.makeInternal(prog_node) catch {
            if (self.exercise.hint.len > 0) {
                print("\n{s}HINT: {s}{s}", .{ bold_text, self.exercise.hint, reset_text });
            }

            print("\n{s}Edit exercises/{s} and run this again.{s}", .{ red_text, self.exercise.main_file, reset_text });
            print("\n{s}To continue from this zigling, use this command:{s}\n    {s}zig build -Dn={s}{s}\n", .{ red_text, reset_text, bold_text, self.exercise.key(), reset_text });
            std.os.exit(1);
        };
    }

    fn makeInternal(self: *@This(), prog_node: *std.Progress.Node) !void {
        print("Compiling {s}...\n", .{self.exercise.main_file});

        const exe_file = try self.doCompile(prog_node);

        print("Checking {s}...\n", .{self.exercise.main_file});

        const cwd = self.builder.build_root.path.?;

        const argv = [_][]const u8{exe_file};

        var child = std.ChildProcess.init(&argv, self.builder.allocator);

        child.cwd = cwd;
        child.env_map = self.builder.env_map;

        child.stdin_behavior = .Inherit;
        if (self.exercise.check_stdout) {
            child.stdout_behavior = .Pipe;
            child.stderr_behavior = .Inherit;
        } else {
            child.stdout_behavior = .Inherit;
            child.stderr_behavior = .Pipe;
        }

        child.spawn() catch |err| {
            print("{s}Unable to spawn {s}: {s}{s}\n", .{ red_text, argv[0], @errorName(err), reset_text });
            return err;
        };

        // Allow up to 1 MB of stdout capture
        const max_output_len = 1 * 1024 * 1024;
        const output = if (self.exercise.check_stdout)
            try child.stdout.?.reader().readAllAlloc(self.builder.allocator, max_output_len)
        else
            try child.stderr.?.reader().readAllAlloc(self.builder.allocator, max_output_len);

        // at this point stdout is closed, wait for the process to terminate
        const term = child.wait() catch |err| {
            print("{s}Unable to spawn {s}: {s}{s}\n", .{ red_text, argv[0], @errorName(err), reset_text });
            return err;
        };

        // make sure it exited cleanly.
        switch (term) {
            .Exited => |code| {
                if (code != 0) {
                    print("{s}{s} exited with error code {d} (expected {d}){s}\n", .{ red_text, self.exercise.main_file, code, 0, reset_text });
                    return error.BadExitCode;
                }
            },
            else => {
                print("{s}{s} terminated unexpectedly{s}\n", .{ red_text, self.exercise.main_file, reset_text });
                return error.UnexpectedTermination;
            },
        }

        // validate the output
        const trimOutput = std.mem.trimRight(u8, output, " \r\n");
        const trimExerciseOutput = std.mem.trimRight(u8, self.exercise.output, " \r\n");
        if (std.mem.indexOf(u8, trimOutput, trimExerciseOutput) == null or trimOutput.len != trimExerciseOutput.len) {
            print(
                \\
                \\{s}----------- Expected this output -----------{s}
                \\"{s}"
                \\{s}----------- but found -----------{s}
                \\"{s}"
                \\{s}-----------{s}
                \\
            , .{ red_text, reset_text, trimExerciseOutput, red_text, reset_text, trimOutput, red_text, reset_text });
            return error.InvalidOutput;
        }

        print("{s}PASSED:\n{s}{s}\n", .{ green_text, output, reset_text });
        const path = try std.fs.path.join(self.builder.allocator, &[_][]const u8{ cwd, "completed_to.txt" });
        var file = try std.fs.createFileAbsolute(path, .{});
        defer file.close();
        var writer = file.writer();
        try writer.print("{s}", .{self.exercise.main_file[0..3]});
    }

    // The normal compile step calls os.exit, so we can't use it as a library :(
    // This is a stripped down copy of std.build.LibExeObjStep.make.
    fn doCompile(self: *@This(), prog_node: *std.Progress.Node) ![]const u8 {
        const builder = self.builder;

        var zig_args = std.ArrayList([]const u8).init(builder.allocator);
        defer zig_args.deinit();

        zig_args.append(builder.zig_exe) catch unreachable;
        zig_args.append("build-exe") catch unreachable;

        // Enable the stage 1 compiler if using the async feature
        // disabled because of https://github.com/ratfactor/ziglings/issues/163
        // if (self.exercise.@"async") {
        //     zig_args.append("-fstage1") catch unreachable;
        // }

        // Enable C support for exercises that use C functions
        if (self.exercise.C) {
            zig_args.append("-lc") catch unreachable;
        }

        const zig_file = std.fs.path.join(builder.allocator, &[_][]const u8{ if (self.use_healed) "patches/healed" else "exercises", self.exercise.main_file }) catch unreachable;
        zig_args.append(builder.pathFromRoot(zig_file)) catch unreachable;

        zig_args.append("--cache-dir") catch unreachable;
        zig_args.append(builder.pathFromRoot(builder.cache_root.path.?)) catch unreachable;

        zig_args.append("--listen=-") catch unreachable;

        const argv = zig_args.items;
        var code: u8 = undefined;
        const file_name = self.eval(argv, &code, prog_node) catch |err| {
            switch (err) {
                error.FileNotFound => {
                    print("{s}{s}: Unable to spawn the following command: file not found{s}\n", .{ red_text, self.exercise.main_file, reset_text });
                    for (argv) |v| print("{s} ", .{v});
                    print("\n", .{});
                },
                error.ExitCodeFailure => {
                    print("{s}{s}: The following command exited with error code {}:{s}\n", .{ red_text, self.exercise.main_file, code, reset_text });
                    for (argv) |v| print("{s} ", .{v});
                    print("\n", .{});
                },
                error.ProcessTerminated => {
                    print("{s}{s}: The following command terminated unexpectedly:{s}\n", .{ red_text, self.exercise.main_file, reset_text });
                    for (argv) |v| print("{s} ", .{v});
                    print("\n", .{});
                },
                else => {},
            }

            return err;
        };

        return file_name;
    }

    // Code adapted from `std.Build.execAllowFail and `std.Build.Step.evalZigProcess`.
    pub fn eval(
        self: *ZiglingStep,
        argv: []const []const u8,
        out_code: *u8,
        prog_node: *std.Progress.Node,
    ) ![]const u8 {
        assert(argv.len != 0);
        const b = self.step.owner;
        const allocator = b.allocator;

        var child = Child.init(argv, allocator);
        child.env_map = b.env_map;
        child.stdin_behavior = .Pipe;
        child.stdout_behavior = .Pipe;
        child.stderr_behavior = .Pipe;

        try child.spawn();

        var poller = std.io.poll(allocator, enum { stdout, stderr }, .{
            .stdout = child.stdout.?,
            .stderr = child.stderr.?,
        });
        defer poller.deinit();

        try sendMessage(child.stdin.?, .update);
        try sendMessage(child.stdin.?, .exit);

        const Header = std.zig.Server.Message.Header;
        var result: ?[]const u8 = null;

        var node_name: std.ArrayListUnmanaged(u8) = .{};
        defer node_name.deinit(allocator);
        var sub_prog_node = prog_node.start("", 0);
        defer sub_prog_node.end();

        const stdout = poller.fifo(.stdout);

        poll: while (true) {
            while (stdout.readableLength() < @sizeOf(Header)) {
                if (!(try poller.poll())) break :poll;
            }
            const header = stdout.reader().readStruct(Header) catch unreachable;
            while (stdout.readableLength() < header.bytes_len) {
                if (!(try poller.poll())) break :poll;
            }
            const body = stdout.readableSliceOfLen(header.bytes_len);

            switch (header.tag) {
                .zig_version => {
                    if (!std.mem.eql(u8, builtin.zig_version_string, body))
                        return error.ZigVersionMismatch;
                },
                .error_bundle => {
                    const EbHdr = std.zig.Server.Message.ErrorBundle;
                    const eb_hdr = @ptrCast(*align(1) const EbHdr, body);
                    const extra_bytes =
                        body[@sizeOf(EbHdr)..][0 .. @sizeOf(u32) * eb_hdr.extra_len];
                    const string_bytes =
                        body[@sizeOf(EbHdr) + extra_bytes.len ..][0..eb_hdr.string_bytes_len];
                    // TODO: use @ptrCast when the compiler supports it
                    const unaligned_extra = std.mem.bytesAsSlice(u32, extra_bytes);
                    const extra_array = try allocator.alloc(u32, unaligned_extra.len);
                    // TODO: use @memcpy when it supports slices
                    for (extra_array, unaligned_extra) |*dst, src| dst.* = src;
                    const error_bundle: std.zig.ErrorBundle = .{
                        .string_bytes = try allocator.dupe(u8, string_bytes),
                        .extra = extra_array,
                    };

                    // Print the compiler error bundle now.
                    // TODO: use the same ttyconf from the builder.
                    const ttyconf: std.debug.TTY.Config = if (use_color_escapes)
                        .escape_codes
                    else
                        .no_color;
                    error_bundle.renderToStdErr(
                        .{ .ttyconf = ttyconf },
                    );
                },
                .progress => {
                    node_name.clearRetainingCapacity();
                    try node_name.appendSlice(allocator, body);
                    sub_prog_node.setName(node_name.items);
                },
                .emit_bin_path => {
                    const EbpHdr = std.zig.Server.Message.EmitBinPath;

                    // TODO: add cache support?
                    //const ebp_hdr = @ptrCast(*align(1) const EbpHdr, body);
                    //s.result_cached = ebp_hdr.flags.cache_hit;

                    result = try allocator.dupe(u8, body[@sizeOf(EbpHdr)..]);
                },
                else => {}, // ignore other messages
            }

            stdout.discard(body.len);
        }

        const stderr = poller.fifo(.stderr);
        if (stderr.readableLength() > 0) {
            // Print the additional log and verbose messages now.
            const messages = try stderr.toOwnedSlice();
            print("{s}\n", .{messages});
        }

        // Send EOF to stdin.
        child.stdin.?.close();
        child.stdin = null;

        // Keep the errors compatible with std.Build.execAllowFail.
        const term = try child.wait();
        switch (term) {
            .Exited => |code| {
                if (code != 0) {
                    out_code.* = @truncate(u8, code);

                    return error.ExitCodeFailure;
                }
            },
            .Signal, .Stopped, .Unknown => |code| {
                out_code.* = @truncate(u8, code);

                return error.ProcessTerminated;
            },
        }

        return result orelse return error.ZigIPCError;
    }
};

fn sendMessage(file: std.fs.File, tag: std.zig.Client.Message.Tag) !void {
    const header: std.zig.Client.Message.Header = .{
        .tag = tag,
        .bytes_len = 0,
    };
    try file.writeAll(std.mem.asBytes(&header));
}

// Print a message to stderr.
const PrintStep = struct {
    step: Step,
    message: []const u8,

    pub fn create(owner: *Build, message: []const u8) *PrintStep {
        const self = owner.allocator.create(PrintStep) catch @panic("OOM");
        self.* = .{
            .step = Step.init(.{
                .id = .custom,
                .name = "print",
                .owner = owner,
                .makeFn = make,
            }),
            .message = message,
        };

        return self;
    }

    fn make(step: *Step, prog_node: *std.Progress.Node) !void {
        _ = prog_node;
        const p = @fieldParentPtr(PrintStep, "step", step);

        print("{s}", .{p.message});
    }
};

// Skip an exercise.
const SkipStep = struct {
    step: Step,
    exercise: Exercise,

    pub fn create(owner: *Build, exercise: Exercise) *SkipStep {
        const self = owner.allocator.create(SkipStep) catch @panic("OOM");
        self.* = .{
            .step = Step.init(.{
                .id = .custom,
                .name = owner.fmt("skip {s}", .{exercise.main_file}),
                .owner = owner,
                .makeFn = make,
            }),
            .exercise = exercise,
        };

        return self;
    }

    fn make(step: *Step, prog_node: *std.Progress.Node) !void {
        _ = prog_node;
        const p = @fieldParentPtr(SkipStep, "step", step);

        if (p.exercise.skip) {
            print("{s} skipped\n", .{p.exercise.main_file});
        }
    }
};

// Check that each exercise number, excluding the last, forms the sequence `[1, exercise.len)`.
fn validate_exercises() bool {
    // Don't use the "multi-object for loop" syntax, in order to avoid a syntax error with old Zig
    // compilers.
    var i: usize = 0;
    for (exercises[0 .. exercises.len - 1]) |ex| {
        i += 1;
        if (ex.number() != i) {
            print(
                "exercise {s} has an incorrect number: expected {}, got {s}\n",
                .{ ex.main_file, i, ex.key() },
            );

            return false;
        }
    }

    return true;
}
