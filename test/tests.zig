const std = @import("std");
const root = @import("../build.zig");

const debug = std.debug;
const fmt = std.fmt;
const fs = std.fs;

const Allocator = std.mem.Allocator;
const Build = std.build;
const Step = Build.Step;
const RunStep = std.Build.RunStep;

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
        const case_step = createCase(b, "case-1");

        // Test that `zig build -Dn=n -Dhealed test` selects the nth exercise.
        var i: usize = 0;
        for (exercises[0 .. exercises.len - 1]) |ex| {
            i += 1;
            if (ex.skip) continue;

            const cmd = b.addSystemCommand(
                &.{ b.zig_exe, "build", b.fmt("-Dn={}", .{i}), "-Dhealed", "test" },
            );
            cmd.setName(b.fmt("zig build -D={} -Dhealed test", .{i}));
            cmd.expectExitCode(0);

            // Some exercise output has an extra space character.
            if (ex.check_stdout)
                expectStdOutMatch(cmd, ex.output)
            else
                expectStdErrMatch(cmd, ex.output);

            case_step.dependOn(&cmd.step);
        }

        step.dependOn(case_step);
    }

    {
        const case_step = createCase(b, "case-2");

        // Test that `zig build -Dn=n -Dhealed test` skips disabled esercises.
        var i: usize = 0;
        for (exercises[0 .. exercises.len - 1]) |ex| {
            i += 1;
            if (!ex.skip) continue;

            const cmd = b.addSystemCommand(
                &.{ b.zig_exe, "build", b.fmt("-Dn={}", .{i}), "-Dhealed", "test" },
            );
            cmd.setName(b.fmt("zig build -D={} -Dhealed test", .{i}));
            cmd.expectExitCode(0);
            cmd.expectStdOutEqual("");
            expectStdErrMatch(cmd, b.fmt("{s} skipped", .{ex.main_file}));

            case_step.dependOn(&cmd.step);
        }

        step.dependOn(case_step);
    }

    const cleanup = b.addRemoveDirTree(outdir);
    step.dependOn(&cleanup.step);

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
