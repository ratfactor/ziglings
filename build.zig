const std = @import("std");
const builtin = @import("builtin");
const Builder = std.build.Builder;
const Step = std.build.Step;
const assert = std.debug.assert;
const print = std.debug.print;

// When changing this version, be sure to also update README.md in two places:
//     1) Getting Started
//     2) Version Changes
const needed_version = std.SemanticVersion.parse("0.10.0-dev.1427") catch unreachable;

const Exercise = struct {
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
};

const exercises = [_]Exercise{
    .{
        .main_file = "001_hello.zig",
        .output = "Hello world",
        .hint = "DON'T PANIC!\nRead the error above.\nSee how it has something to do with 'main'?\nOpen up the source file as noted and read the comments.\nYou can do this!",
    },
    .{
        .main_file = "002_std.zig",
        .output = "Standard Library",
    },
    .{
        .main_file = "003_assignment.zig",
        .output = "55 314159 -11",
        .hint = "There are three mistakes in this one!",
    },
    .{
        .main_file = "004_arrays.zig",
        .output = "Fourth: 7, Length: 8",
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
        .output = "13",
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
        .output = "2 4 8 16",
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
        .output = "I compiled",
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
        .output = "Wizard (G:10 H:100 XP:20)",
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
        .output = "1101 + 0101 = 0010 (true). Furthermore, 11110000 backwards is 00001111.",
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
    .{
        .main_file = "084_async.zig",
        .output = "foo() A",
        .hint = "Read the facts. Use the facts.",
    },
    .{
        .main_file = "085_async2.zig",
        .output = "Hello async!",
    },
    .{
        .main_file = "086_async3.zig",
        .output = "5 4 3 2 1",
    },
    .{
        .main_file = "087_async4.zig",
        .output = "1 2 3 4 5",
    },
    .{
        .main_file = "088_async5.zig",
        .output = "Example Title.",
    },
    .{
        .main_file = "089_async6.zig",
        .output = ".com: Example Title, .org: Example Title.",
    },
    .{
        .main_file = "090_async7.zig",
        .output = "beef? BEEF!",
    },
    .{
        .main_file = "091_async8.zig",
        .output = "ABCDEF",
    },
};

/// Check the zig version to make sure it can compile the examples properly.
/// This will compile with Zig 0.6.0 and later.
fn checkVersion() bool {
    if (!@hasDecl(builtin, "zig_version")) {
        return false;
    }

    const version = builtin.zig_version;
    const order = version.order(needed_version);
    return order != .lt;
}

pub fn build(b: *Builder) void {
    // Use a comptime branch for the version check.
    // If this fails, code after this block is not compiled.
    // It is parsed though, so versions of zig from before 0.6.0
    // cannot do the version check and will just fail to compile.
    // We could fix this by moving the ziglings code to a separate file,
    // but 0.5.0 was a long time ago, it is unlikely that anyone who
    // attempts these exercises is still using it.
    if (comptime !checkVersion()) {
        // very old versions of Zig used warn instead of print.
        const stderrPrintFn = if (@hasDecl(std.debug, "print")) std.debug.print else std.debug.warn;
        stderrPrintFn(
            \\ERROR: Sorry, it looks like your version of zig is too old. :-(
            \\
            \\Ziglings requires development build
            \\
            \\    {}
            \\
            \\or higher. Please download a development ("master") build from
            \\
            \\    https://ziglang.org/download/
            \\
            \\
        , .{needed_version});
        std.os.exit(0);
    }

    use_color_escapes = false;
    switch (b.color) {
        .on => use_color_escapes = true,
        .off => use_color_escapes = false,
        .auto => {
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
        },
    }

    if (use_color_escapes) {
        red_text = "\x1b[31m";
        green_text = "\x1b[32m";
        bold_text = "\x1b[1m";
        reset_text = "\x1b[0m";
    }

    const header_step = b.addLog(
        \\
        \\         _       _ _
        \\     ___(_) __ _| (_)_ __   __ _ ___
        \\    |_  | |/ _' | | | '_ \ / _' / __|
        \\     / /| | (_| | | | | | | (_| \__ \
        \\    /___|_|\__, |_|_|_| |_|\__, |___/
        \\           |___/           |___/
        \\
        \\
    , .{});

    const verify_all = b.step("ziglings", "Check all ziglings");
    verify_all.dependOn(&header_step.step);
    b.default_step = verify_all;

    var prev_chain_verify = verify_all;

    const use_healed = b.option(bool, "healed", "Run exercises from patches/healed") orelse false;

    for (exercises) |ex| {
        const base_name = ex.baseName();
        const file_path = std.fs.path.join(b.allocator, &[_][]const u8{
            if (use_healed) "patches/healed" else "exercises", ex.main_file,
        }) catch unreachable;
        const build_step = b.addExecutable(base_name, file_path);
        build_step.install();

        const verify_step = ZiglingStep.create(b, ex, use_healed);

        const key = ex.key();

        const named_test = b.step(b.fmt("{s}_test", .{key}), b.fmt("Run {s} without checking output", .{ex.main_file}));
        const run_step = build_step.run();
        named_test.dependOn(&run_step.step);

        const named_install = b.step(b.fmt("{s}_install", .{key}), b.fmt("Install {s} to zig-cache/bin", .{ex.main_file}));
        named_install.dependOn(&build_step.install_step.?.step);

        const named_verify = b.step(key, b.fmt("Check {s} only", .{ex.main_file}));
        named_verify.dependOn(&verify_step.step);

        const chain_verify = b.allocator.create(Step) catch unreachable;
        chain_verify.* = Step.initNoOp(.custom, b.fmt("chain {s}", .{key}), b.allocator);
        chain_verify.dependOn(&verify_step.step);

        const named_chain = b.step(b.fmt("{s}_start", .{key}), b.fmt("Check all solutions starting at {s}", .{ex.main_file}));
        named_chain.dependOn(&header_step.step);
        named_chain.dependOn(chain_verify);

        prev_chain_verify.dependOn(chain_verify);
        prev_chain_verify = chain_verify;
    }
}

var use_color_escapes = false;
var red_text: []const u8 = "";
var green_text: []const u8 = "";
var bold_text: []const u8 = "";
var reset_text: []const u8 = "";

const ZiglingStep = struct {
    step: Step,
    exercise: Exercise,
    builder: *Builder,
    use_healed: bool,

    pub fn create(builder: *Builder, exercise: Exercise, use_healed: bool) *@This() {
        const self = builder.allocator.create(@This()) catch unreachable;
        self.* = .{
            .step = Step.init(.custom, exercise.main_file, builder.allocator, make),
            .exercise = exercise,
            .builder = builder,
            .use_healed = use_healed,
        };
        return self;
    }

    fn make(step: *Step) anyerror!void {
        const self = @fieldParentPtr(@This(), "step", step);
        self.makeInternal() catch {
            if (self.exercise.hint.len > 0) {
                print("\n{s}HINT: {s}{s}", .{ bold_text, self.exercise.hint, reset_text });
            }

            print("\n{s}Edit exercises/{s} and run this again.{s}", .{ red_text, self.exercise.main_file, reset_text });
            print("\n{s}To continue from this zigling, use this command:{s}\n    {s}zig build {s}{s}\n", .{ red_text, reset_text, bold_text, self.exercise.key(), reset_text });
            std.os.exit(0);
        };
    }

    fn makeInternal(self: *@This()) !void {
        print("Compiling {s}...\n", .{self.exercise.main_file});

        const exe_file = try self.doCompile();

        print("Checking {s}...\n", .{self.exercise.main_file});

        const cwd = self.builder.build_root;

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
        if (std.mem.indexOf(u8, output, self.exercise.output) == null) {
            print(
                \\
                \\{s}----------- Expected this output -----------{s}
                \\{s}
                \\{s}----------- but found -----------{s}
                \\{s}
                \\{s}-----------{s}
                \\
            , .{ red_text, reset_text, self.exercise.output, red_text, reset_text, output, red_text, reset_text });
            return error.InvalidOutput;
        }

        print("{s}PASSED:\n{s}{s}\n", .{ green_text, output, reset_text });
    }

    // The normal compile step calls os.exit, so we can't use it as a library :(
    // This is a stripped down copy of std.build.LibExeObjStep.make.
    fn doCompile(self: *@This()) ![]const u8 {
        const builder = self.builder;

        var zig_args = std.ArrayList([]const u8).init(builder.allocator);
        defer zig_args.deinit();

        zig_args.append(builder.zig_exe) catch unreachable;
        zig_args.append("build-exe") catch unreachable;

        if (builder.color != .auto) {
            zig_args.append("--color") catch unreachable;
            zig_args.append(@tagName(builder.color)) catch unreachable;
        }

        const zig_file = std.fs.path.join(builder.allocator, &[_][]const u8{ if (self.use_healed) "patches/healed" else "exercises", self.exercise.main_file }) catch unreachable;
        zig_args.append(builder.pathFromRoot(zig_file)) catch unreachable;

        zig_args.append("--cache-dir") catch unreachable;
        zig_args.append(builder.pathFromRoot(builder.cache_root)) catch unreachable;

        zig_args.append("--enable-cache") catch unreachable;

        const argv = zig_args.items;
        var code: u8 = undefined;
        const output_dir_nl = builder.execAllowFail(argv, &code, .Inherit) catch |err| {
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
        const build_output_dir = std.mem.trimRight(u8, output_dir_nl, "\r\n");

        const target_info = std.zig.system.NativeTargetInfo.detect(
            builder.allocator,
            .{},
        ) catch unreachable;
        const target = target_info.target;

        const file_name = std.zig.binNameAlloc(builder.allocator, .{
            .root_name = self.exercise.baseName(),
            .target = target,
            .output_mode = .Exe,
            .link_mode = .Static,
            .version = null,
        }) catch unreachable;

        return std.fs.path.join(builder.allocator, &[_][]const u8{
            build_output_dir, file_name,
        });
    }
};
