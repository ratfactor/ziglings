const std = @import("std");
const root = @import("../build.zig");

const debug = std.debug;
const fmt = std.fmt;
const fs = std.fs;
const mem = std.mem;

const Allocator = std.mem.Allocator;
const Build = std.build;
const FileSource = std.Build.FileSource;
const Reader = fs.File.Reader;
const RunStep = std.Build.RunStep;
const Step = Build.Step;

const Exercise = root.Exercise;

pub fn addCliTests(b: *std.Build, exercises: []const Exercise) *Step {
    const step = b.step("test-cli", "Test the command line interface");

    // We should use a temporary path, but it will make the implementation of
    // `build.zig` more complex.
    const outdir = "patches/healed";

    fs.cwd().makePath(outdir) catch |err| {
        return fail(step, "unable to make '{s}': {s}\n", .{ outdir, @errorName(err) });
    };
    heal(b.allocator, exercises, outdir) catch |err| {
        return fail(step, "unable to heal exercises: {s}\n", .{@errorName(err)});
    };

    {
        // Test that `zig build -Dhealed -Dn=n test` selects the nth exercise.
        const case_step = createCase(b, "case-1");

        var i: usize = 0;
        for (exercises[0 .. exercises.len - 1]) |ex| {
            i += 1;
            if (ex.skip) continue;

            const cmd = b.addSystemCommand(
                &.{ b.zig_exe, "build", "-Dhealed", b.fmt("-Dn={}", .{i}), "test" },
            );
            cmd.setName(b.fmt("zig build -Dhealed -Dn={} test", .{i}));
            cmd.expectExitCode(0);

            if (ex.check_stdout)
                expectStdOutMatch(cmd, ex.output)
            else
                expectStdErrMatch(cmd, ex.output);

            case_step.dependOn(&cmd.step);
        }

        step.dependOn(case_step);
    }

    {
        // Test that `zig build -Dhealed -Dn=n test` skips disabled esercises.
        const case_step = createCase(b, "case-2");

        var i: usize = 0;
        for (exercises[0 .. exercises.len - 1]) |ex| {
            i += 1;
            if (!ex.skip) continue;

            const cmd = b.addSystemCommand(
                &.{ b.zig_exe, "build", "-Dhealed", b.fmt("-Dn={}", .{i}), "test" },
            );
            cmd.setName(b.fmt("zig build -Dhealed -Dn={} test", .{i}));
            cmd.expectExitCode(0);
            cmd.expectStdOutEqual("");
            expectStdErrMatch(cmd, b.fmt("{s} skipped", .{ex.main_file}));

            case_step.dependOn(&cmd.step);
        }

        step.dependOn(case_step);
    }

    {
        // Test that `zig build -Dhealed` process all the exercises in order.
        const case_step = createCase(b, "case-3");

        // TODO: when an exercise is modified, the cache is not invalidated.
        const cmd = b.addSystemCommand(&.{ b.zig_exe, "build", "-Dhealed" });
        cmd.setName("zig build -Dhealed");
        cmd.expectExitCode(0);

        const stderr = cmd.captureStdErr();
        const verify = CheckStep.create(b, exercises, stderr, true);
        verify.step.dependOn(&cmd.step);

        case_step.dependOn(&verify.step);

        step.dependOn(case_step);
    }

    {
        // Test that `zig build -Dhealed -Dn=1 start` process all the exercises
        // in order.
        const case_step = createCase(b, "case-4");

        // TODO: when an exercise is modified, the cache is not invalidated.
        const cmd = b.addSystemCommand(
            &.{ b.zig_exe, "build", "-Dhealed", "-Dn=1", "start" },
        );
        cmd.setName("zig build -Dhealed -Dn=1 start");
        cmd.expectExitCode(0);

        const stderr = cmd.captureStdErr();
        const verify = CheckStep.create(b, exercises, stderr, false);
        verify.step.dependOn(&cmd.step);

        case_step.dependOn(&verify.step);

        step.dependOn(case_step);
    }

    {
        // Test that `zig build -Dn=1` prints the hint.
        const case_step = createCase(b, "case-5");

        const cmd = b.addSystemCommand(&.{ b.zig_exe, "build", "-Dn=1" });
        cmd.setName("zig build -Dn=1");
        cmd.expectExitCode(1);
        expectStdErrMatch(cmd, exercises[0].hint);

        case_step.dependOn(&cmd.step);

        step.dependOn(case_step);
    }

    // Don't add the cleanup step, since it may delete outdir while a test case
    // is running.
    //const cleanup = b.addRemoveDirTree(outdir);
    //step.dependOn(&cleanup.step);

    return step;
}

fn createCase(b: *Build, name: []const u8) *Step {
    const case_step = b.allocator.create(Step) catch @panic("OOM");
    case_step.* = Step.init(.{
        .id = .custom,
        .name = name,
        .owner = b,
    });

    return case_step;
}

// Check the output of `zig build` or `zig build -Dn=1 start`.
const CheckStep = struct {
    step: Step,
    exercises: []const Exercise,
    stderr: FileSource,
    has_logo: bool,

    pub fn create(
        owner: *Build,
        exercises: []const Exercise,
        stderr: FileSource,
        has_logo: bool,
    ) *CheckStep {
        const self = owner.allocator.create(CheckStep) catch @panic("OOM");
        self.* = .{
            .step = Step.init(.{
                .id = .custom,
                .name = "check",
                .owner = owner,
                .makeFn = make,
            }),
            .exercises = exercises,
            .stderr = stderr,
            .has_logo = has_logo,
        };

        return self;
    }

    fn make(step: *Step, _: *std.Progress.Node) !void {
        const b = step.owner;
        const self = @fieldParentPtr(CheckStep, "step", step);
        const exercises = self.exercises;

        const stderr_file = try fs.cwd().openFile(
            self.stderr.getPath(b),
            .{ .mode = .read_only },
        );
        defer stderr_file.close();

        const stderr = stderr_file.reader();
        for (exercises) |ex| {
            if (ex.number() == 1 and self.has_logo) {
                // Skip the logo.
                var buf: [80]u8 = undefined;

                var lineno: usize = 0;
                while (lineno < 8) : (lineno += 1) {
                    _ = try readLine(stderr, &buf);
                }
            }
            try check_output(step, ex, stderr);
        }
    }

    fn check_output(step: *Step, exercise: Exercise, reader: Reader) !void {
        const b = step.owner;

        var buf: [1024]u8 = undefined;
        if (exercise.skip) {
            {
                const actual = try readLine(reader, &buf) orelse "EOF";
                const expect = b.fmt("Skipping {s}", .{exercise.main_file});
                try check(step, exercise, expect, actual);
            }

            {
                const actual = try readLine(reader, &buf) orelse "EOF";
                try check(step, exercise, "", actual);
            }

            return;
        }

        {
            const actual = try readLine(reader, &buf) orelse "EOF";
            const expect = b.fmt("Compiling {s}...", .{exercise.main_file});
            try check(step, exercise, expect, actual);
        }

        {
            const actual = try readLine(reader, &buf) orelse "EOF";
            const expect = b.fmt("Checking {s}...", .{exercise.main_file});
            try check(step, exercise, expect, actual);
        }

        {
            const actual = try readLine(reader, &buf) orelse "EOF";
            const expect = "PASSED:";
            try check(step, exercise, expect, actual);
        }

        // Skip the exercise output.
        const nlines = 1 + mem.count(u8, exercise.output, "\n") + 1;
        var lineno: usize = 0;
        while (lineno < nlines) : (lineno += 1) {
            _ = try readLine(reader, &buf) orelse @panic("EOF");
        }
    }

    fn check(
        step: *Step,
        exercise: Exercise,
        expect: []const u8,
        actual: []const u8,
    ) !void {
        if (!mem.eql(u8, expect, actual)) {
            return step.fail("{s}: expected to see \"{s}\", found \"{s}\"", .{
                exercise.main_file,
                expect,
                actual,
            });
        }
    }

    fn readLine(reader: fs.File.Reader, buf: []u8) !?[]const u8 {
        if (try reader.readUntilDelimiterOrEof(buf, '\n')) |line| {
            return mem.trimRight(u8, line, " \r\n");
        }

        return null;
    }
};

// A step that will fail.
const FailStep = struct {
    step: Step,
    error_msg: []const u8,

    pub fn create(owner: *Build, error_msg: []const u8) *FailStep {
        const self = owner.allocator.create(FailStep) catch @panic("OOM");
        self.* = .{
            .step = Step.init(.{
                .id = .custom,
                .name = "fail",
                .owner = owner,
                .makeFn = make,
            }),
            .error_msg = error_msg,
        };

        return self;
    }

    fn make(step: *Step, _: *std.Progress.Node) !void {
        const b = step.owner;
        const self = @fieldParentPtr(FailStep, "step", step);

        try step.result_error_msgs.append(b.allocator, self.error_msg);
        return error.MakeFailed;
    }
};

// A variant of `std.Build.Step.fail` that does not return an error so that it
// can be used in the configuration phase.  It returns a FailStep, so that the
// error will be cleanly handled by the build runner.
fn fail(step: *Step, comptime format: []const u8, args: anytype) *Step {
    const b = step.owner;

    const fail_step = FailStep.create(b, b.fmt(format, args));
    step.dependOn(&fail_step.step);

    return step;
}

// Heals all the exercises.
fn heal(allocator: Allocator, exercises: []const Exercise, outdir: []const u8) !void {
    const join = fs.path.join;

    const exercises_path = "exercises";
    const patches_path = "patches/patches";

    for (exercises) |ex| {
        const name = ex.baseName();

        // Use the POSIX patch variant.
        const file = try join(allocator, &.{ exercises_path, ex.main_file });
        const patch = b: {
            const patch_name = try fmt.allocPrint(allocator, "{s}.patch", .{name});
            break :b try join(allocator, &.{ patches_path, patch_name });
        };
        const output = try join(allocator, &.{ outdir, ex.main_file });

        const argv = &.{ "patch", "-i", patch, "-o", output, file };

        var child = std.process.Child.init(argv, allocator);
        child.stdout_behavior = .Ignore; // the POSIX standard says that stdout is not used
        _ = try child.spawnAndWait();
    }
}

//
// Missing functions from std.Build.RunStep
//

/// Adds a check for stderr match. Does not add any other checks.
pub fn expectStdErrMatch(self: *RunStep, bytes: []const u8) void {
    const new_check: RunStep.StdIo.Check = .{
        .expect_stderr_match = self.step.owner.dupe(bytes),
    };
    self.addCheck(new_check);
}

/// Adds a check for stdout match as well as a check for exit code 0, if
/// there is not already an expected termination check.
pub fn expectStdOutMatch(self: *RunStep, bytes: []const u8) void {
    const new_check: RunStep.StdIo.Check = .{
        .expect_stdout_match = self.step.owner.dupe(bytes),
    };
    self.addCheck(new_check);
    if (!self.hasTermCheck()) {
        self.expectExitCode(0);
    }
}
