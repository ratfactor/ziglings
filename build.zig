const std = @import("std");
const Builder = std.build.Builder;
const Step = std.build.Step;
const assert = std.debug.assert;
const print = std.debug.print;

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

    /// Returns the key of the main file, which is the text before the _.
    /// For example, "01_hello.zig" has the key "01".
    pub fn key(self: Exercise) []const u8 {
        const end_index = std.mem.indexOfScalar(u8, self.main_file, '_');
        assert(end_index != null); // main file must be key_description.zig
        return self.main_file[0..end_index.?];
    }
};

const exercises = [_]Exercise{
    .{
        .main_file = "01_hello.zig",
        .output = "Hello world",
        .hint = "Note the error: the source file has a hint for fixing 'main'.",
    },
    .{
        .main_file = "02_std.zig",
        .output = "Standard Library",
    },
    .{
        .main_file = "03_assignment.zig",
        .output = "55 314159 -11",
        .hint = "There are three mistakes in this one!",
    },
    .{
        .main_file = "04_arrays.zig",
        .output = "Fourth: 7, Length: 8",
        .hint = "There are two things to complete here.",
    },
    .{
        .main_file = "05_arrays2.zig",
        .output = "LEET: 1337, Bits: 100110011001",
        .hint = "Fill in the two arrays.",
    },
    .{
        .main_file = "06_strings.zig",
        .output = "d=d ha ha ha Major Tom",
        .hint = "Each '???' needs something filled in.",
    },
    .{
        .main_file = "07_strings2.zig",
        .output = "Ziggy",
        .hint = "Please fix the lyrics!",
    },
    .{
        .main_file = "08_quiz.zig",
        .output = "Program in Zig",
        .hint = "See if you can fix the program!",
    },
    .{
        .main_file = "09_if.zig",
        .output = "Foo is 1!",
    },
    .{
        .main_file = "10_if2.zig",
        .output = "price is $17",
    },
    .{
        .main_file = "11_while.zig",
        .output = "n=1024",
        .hint = "You probably want a 'less than' condition.",
    },
    .{
        .main_file = "12_while2.zig",
        .output = "n=1024",
        .hint = "It might help to look back at the previous exercise.",
    },
    .{
        .main_file = "13_while3.zig",
        .output = "1 2 4 7 8 11 13 14 16 17 19",
    },
    .{
        .main_file = "14_while4.zig",
        .output = "n=4",
    },
    .{
        .main_file = "15_for.zig",
        .output = "A Dramatic Story: :-)  :-)  :-(  :-|  :-)  The End.",
    },
    .{
        .main_file = "16_for2.zig",
        .output = "13",
    },
    .{
        .main_file = "17_quiz2.zig",
        .output = "8, Fizz, Buzz, 11, Fizz, 13, 14, FizzBuzz, 16",
        .hint = "This is a famous game!",
    },
    .{
        .main_file = "18_functions.zig",
        .output = "Question: 42",
        .hint = "Can you help write the function?",
    },
    .{
        .main_file = "19_functions2.zig",
        .output = "2 4 8 16",
    },
    .{
        .main_file = "20_quiz3.zig",
        .output = "32 64 128 256",
        .hint = "Unexpected pop quiz! Help!",
    },
    .{
        .main_file = "21_errors.zig",
        .output = "2<4. 3<4. 4=4. 5>4. 6>4.",
        .hint = "What's the deal with fours?",
    },
    .{
        .main_file = "22_errors2.zig",
        .output = "I compiled",
        .hint = "Get the error union type right to allow this to compile.",
    },
    .{
        .main_file = "23_errors3.zig",
        .output = "a=64, b=22",
    },
    .{
        .main_file = "24_errors4.zig",
        .output = "a=20, b=14, c=10",
    },
    .{
        .main_file = "25_errors5.zig",
        .output = "a=0, b=19, c=0",
    },
    .{
        .main_file = "26_hello2.zig",
        .output = "Hello world",
        .hint = "Try using a try!",
        .check_stdout = true,
    },
    .{
        .main_file = "27_defer.zig",
        .output = "One Two",
    },
    .{
        .main_file = "28_defer2.zig",
        .output = "(Goat) (Cat) (Dog) (Dog) (Goat) (Unknown) done.",
    },
    .{
        .main_file = "29_errdefer.zig",
        .output = "Getting number...got 5. Getting number...failed!",
    },
    .{
        .main_file = "30_switch.zig",
        .output = "ZIG?",
    },
    .{
        .main_file = "31_switch2.zig",
        .output = "ZIG!",
    },
    .{
        .main_file = "32_unreachable.zig",
        .output = "1 2 3 9 8 7",
    },
    .{
        .main_file = "33_iferror.zig",
        .output = "2<4. 3<4. 4=4. 5>4. 6>4.",
        .hint = "Seriously, what's the deal with fours?",
    },
    .{
        .main_file = "34_quiz4.zig",
        .output = "my_num=42",
        .hint = "Can you make this work?",
        .check_stdout = true,
    },
    .{
        .main_file = "35_enums.zig",
        .output = "1 2 3 9 8 7",
        .hint = "This problem seems familiar...",
    },
    .{
        .main_file = "36_enums2.zig",
        .output = "#0000ff",
        .hint = "I'm feeling blue about this.",
    },
    .{
        .main_file = "37_structs.zig",
        .output = "Your wizard has 90 health and 25 gold.",
    },
    .{
        .main_file = "38_structs2.zig",
        .output = "Character 2 - G:10 H:100 XP:20",
    },
    .{
        .main_file = "39_pointers.zig",
        .output = "num1: 5, num2: 5",
        .hint = "Pointers aren't so bad.",
    },
    .{
        .main_file = "40_pointers2.zig",
        .output = "a: 12, b: 12",
    },
    .{
        .main_file = "41_pointers3.zig",
        .output = "foo=6, bar=11",
    },
    .{
        .main_file = "42_pointers4.zig",
        .output = "num: 5, more_nums: 1 1 5 1",
    },
    .{
        .main_file = "43_pointers5.zig",
        .output = "Wizard (G:10 H:100 XP:20)",
    },
    .{
        .main_file = "44_quiz5.zig",
        .output = "Elephant A. Elephant B. Elephant C.",
        .hint = "Oh no! We forgot Elephant B!",
    },
    .{
        .main_file = "45_optionals.zig",
        .output = "The Ultimate Answer: 42.",
    },
    .{
        .main_file = "46_optionals2.zig",
        .output = "Elephant A. Elephant B. Elephant C.",
        .hint = "Elephants!",
    },
    // super-simple struct method
    // use struct method for elephant tails
    // quiz: add elephant trunk (like tail)!
};

/// Check the zig version to make sure it can compile the examples properly.
/// This will compile with Zig 0.6.0 and later.
fn checkVersion() bool {
    if (!@hasDecl(std.builtin, "zig_version")) {
        return false;
    }

    const needed_version = std.SemanticVersion.parse("0.8.0-dev.1065") catch unreachable;
    const version = std.builtin.zig_version;
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
            \\    0.8.0-dev.1065
            \\
            \\or higher. Please download a development ("master") build from
            \\https://ziglang.org/download/
            \\
        , .{});
        std.os.exit(0);
    }

    use_color_escapes = false;
    switch (b.color) {
        .on => use_color_escapes = true,
        .off => use_color_escapes = false,
        .auto => {
            if (std.io.getStdErr().supportsAnsiEscapeCodes()) {
                use_color_escapes = true;
            } else if (std.builtin.os.tag == .windows) {
                const w32 = struct {
                    const WINAPI = std.os.windows.WINAPI;
                    const DWORD = std.os.windows.DWORD;
                    const ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004;
                    const STD_ERROR_HANDLE = @bitCast(DWORD, @as(i32, -12));
                    extern "kernel32" fn GetStdHandle(id: DWORD) callconv(WINAPI) ?*c_void;
                    extern "kernel32" fn GetConsoleMode(console: ?*c_void, out_mode: *DWORD) callconv(WINAPI) u32;
                    extern "kernel32" fn SetConsoleMode(console: ?*c_void, mode: DWORD) callconv(WINAPI) u32;
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
        chain_verify.* = Step.initNoOp(.Custom, b.fmt("chain {s}", .{key}), b.allocator);
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
            .step = Step.init(.Custom, exercise.main_file, builder.allocator, make),
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

        const child = std.ChildProcess.init(&argv, self.builder.allocator) catch unreachable;
        defer child.deinit();

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

        print("{s}PASSED: {s}{s}\n", .{ green_text, output, reset_text });
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

        const zig_file = std.fs.path.join(builder.allocator, &[_][]const u8{ 
            if (self.use_healed) "patches/healed" else "exercises", self.exercise.main_file }) catch unreachable;
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
