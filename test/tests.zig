const std = @import("std");
const root = @import("../build.zig");

const debug = std.debug;
const fmt = std.fmt;
const fs = std.fs;
const mem = std.mem;

const Allocator = std.mem.Allocator;
const Child = std.process.Child;
const Build = std.build;
const FileSource = std.Build.FileSource;
const Reader = fs.File.Reader;
const RunStep = std.Build.RunStep;
const Step = Build.Step;

const Exercise = root.Exercise;

pub fn addCliTests(b: *std.Build, exercises: []const Exercise) *Step {
    const step = b.step("test-cli", "Test the command line interface");

    {
        // Test that `zig build -Dhealed -Dn=n` selects the nth exercise.
        const case_step = createCase(b, "case-1");

        const tmp_path = makeTempPath(b) catch |err| {
            return fail(step, "unable to make tmp path: {s}\n", .{@errorName(err)});
        };

        const heal_step = HealStep.create(b, exercises, tmp_path);

        for (exercises[0 .. exercises.len - 1]) |ex| {
            const n = ex.number();

            const cmd = b.addSystemCommand(&.{
                b.zig_exe,
                "build",
                "-Dhealed",
                b.fmt("-Dhealed-path={s}", .{tmp_path}),
                b.fmt("-Dn={}", .{n}),
            });
            cmd.setName(b.fmt("zig build -Dhealed -Dn={}", .{n}));
            cmd.expectExitCode(0);
            cmd.step.dependOn(&heal_step.step);

            const stderr = cmd.captureStdErr();
            const verify = CheckNamedStep.create(b, ex, stderr);
            verify.step.dependOn(&cmd.step);

            case_step.dependOn(&verify.step);
        }

        const cleanup = b.addRemoveDirTree(tmp_path);
        cleanup.step.dependOn(case_step);

        step.dependOn(&cleanup.step);
    }

    {
        // Test that `zig build -Dhealed` processes all the exercises in order.
        const case_step = createCase(b, "case-2");

        const tmp_path = makeTempPath(b) catch |err| {
            return fail(step, "unable to make tmp path: {s}\n", .{@errorName(err)});
        };

        const heal_step = HealStep.create(b, exercises, tmp_path);
        heal_step.step.dependOn(case_step);

        // TODO: when an exercise is modified, the cache is not invalidated.
        const cmd = b.addSystemCommand(&.{
            b.zig_exe,
            "build",
            "-Dhealed",
            b.fmt("-Dhealed-path={s}", .{tmp_path}),
        });
        cmd.setName("zig build -Dhealed");
        cmd.expectExitCode(0);
        cmd.step.dependOn(&heal_step.step);

        const stderr = cmd.captureStdErr();
        const verify = CheckStep.create(b, exercises, stderr);
        verify.step.dependOn(&cmd.step);

        const cleanup = b.addRemoveDirTree(tmp_path);
        cleanup.step.dependOn(&verify.step);

        step.dependOn(&cleanup.step);
    }

    {
        // Test that `zig build -Dn=n` prints the hint.
        const case_step = createCase(b, "case-3");

        for (exercises[0 .. exercises.len - 1]) |ex| {
            if (ex.skip) continue;

            if (ex.hint) |hint| {
                const n = ex.number();

                const cmd = b.addSystemCommand(&.{
                    b.zig_exe,
                    "build",
                    b.fmt("-Dn={}", .{n}),
                });
                cmd.setName(b.fmt("zig build -Dn={}", .{n}));
                cmd.expectExitCode(2);
                cmd.addCheck(.{ .expect_stderr_match = hint });

                case_step.dependOn(&cmd.step);
            }
        }

        step.dependOn(case_step);
    }

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

/// Checks the output of `zig build -Dn=n`.
const CheckNamedStep = struct {
    step: Step,
    exercise: Exercise,
    stderr: FileSource,

    pub fn create(owner: *Build, exercise: Exercise, stderr: FileSource) *CheckNamedStep {
        const self = owner.allocator.create(CheckNamedStep) catch @panic("OOM");
        self.* = .{
            .step = Step.init(.{
                .id = .custom,
                .name = "check-named",
                .owner = owner,
                .makeFn = make,
            }),
            .exercise = exercise,
            .stderr = stderr,
        };

        return self;
    }

    fn make(step: *Step, _: *std.Progress.Node) !void {
        const b = step.owner;
        const self = @fieldParentPtr(CheckNamedStep, "step", step);
        const ex = self.exercise;

        const stderr_file = try fs.cwd().openFile(
            self.stderr.getPath(b),
            .{ .mode = .read_only },
        );
        defer stderr_file.close();

        const stderr = stderr_file.reader();
        {
            // Skip the logo.
            const nlines = mem.count(u8, root.logo, "\n");
            var buf: [80]u8 = undefined;

            var lineno: usize = 0;
            while (lineno < nlines) : (lineno += 1) {
                _ = try readLine(stderr, &buf);
            }
        }
        try check_output(step, ex, stderr);
    }
};

/// Checks the output of `zig build`.
const CheckStep = struct {
    step: Step,
    exercises: []const Exercise,
    stderr: FileSource,

    pub fn create(
        owner: *Build,
        exercises: []const Exercise,
        stderr: FileSource,
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
            if (ex.number() == 1) {
                // Skip the logo.
                const nlines = mem.count(u8, root.logo, "\n");
                var buf: [80]u8 = undefined;

                var lineno: usize = 0;
                while (lineno < nlines) : (lineno += 1) {
                    _ = try readLine(stderr, &buf);
                }
            }
            try check_output(step, ex, stderr);
        }
    }
};

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
        const expect = switch (exercise.kind) {
            .exe => "PASSED:",
            .@"test" => "PASSED",
        };
        try check(step, exercise, expect, actual);
    }

    // Skip the exercise output.
    const nlines = switch (exercise.kind) {
        .exe => 1 + mem.count(u8, exercise.output, "\n") + 1,
        .@"test" => 1,
    };

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

/// Fails with a custom error message.
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

/// A variant of `std.Build.Step.fail` that does not return an error so that it
/// can be used in the configuration phase.  It returns a FailStep, so that the
/// error will be cleanly handled by the build runner.
fn fail(step: *Step, comptime format: []const u8, args: anytype) *Step {
    const b = step.owner;

    const fail_step = FailStep.create(b, b.fmt(format, args));
    step.dependOn(&fail_step.step);

    return step;
}

/// Heals the exercises.
const HealStep = struct {
    step: Step,
    exercises: []const Exercise,
    work_path: []const u8,

    pub fn create(owner: *Build, exercises: []const Exercise, work_path: []const u8) *HealStep {
        const self = owner.allocator.create(HealStep) catch @panic("OOM");
        self.* = .{
            .step = Step.init(.{
                .id = .custom,
                .name = "heal",
                .owner = owner,
                .makeFn = make,
            }),
            .exercises = exercises,
            .work_path = work_path,
        };

        return self;
    }

    fn make(step: *Step, _: *std.Progress.Node) !void {
        const b = step.owner;
        const self = @fieldParentPtr(HealStep, "step", step);

        return heal(b.allocator, self.exercises, self.work_path);
    }
};

/// Heals all the exercises.
fn heal(allocator: Allocator, exercises: []const Exercise, work_path: []const u8) !void {
    const sep = std.fs.path.sep_str;
    const join = fs.path.join;

    const exercises_path = "exercises";
    const patches_path = "patches" ++ sep ++ "patches";

    for (exercises) |ex| {
        const name = ex.name();

        const file = try join(allocator, &.{ exercises_path, ex.main_file });
        const patch = b: {
            const patch_name = try fmt.allocPrint(allocator, "{s}.patch", .{name});
            break :b try join(allocator, &.{ patches_path, patch_name });
        };
        const output = try join(allocator, &.{ work_path, ex.main_file });

        const argv = &.{ "patch", "-i", patch, "-o", output, "-s", file };

        var child = Child.init(argv, allocator);
        _ = try child.spawnAndWait();
    }
}

/// This function is the same as the one in std.Build.makeTempPath, with the
/// difference that returns an error when the temp path cannot be created.
pub fn makeTempPath(b: *Build) ![]const u8 {
    const rand_int = std.crypto.random.int(u64);
    const tmp_dir_sub_path = "tmp" ++ fs.path.sep_str ++ Build.hex64(rand_int);
    const path = b.cache_root.join(b.allocator, &.{tmp_dir_sub_path}) catch
        @panic("OOM");
    try b.cache_root.handle.makePath(tmp_dir_sub_path);

    return path;
}
