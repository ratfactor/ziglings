const std = @import("std");
const root = @import("../build.zig");

const debug = std.debug;
const fs = std.fs;

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
        debug.print("unable to make '{s}': {s}\n", .{ outdir, @errorName(err) });

        return step;
    };

    {
        const case_step = createCase(b, "case-1");

        // Test that `zig build -Dn=n -Dhealed test` selects the nth exercise.
        var i: usize = 0;
        for (exercises[0 .. exercises.len - 1]) |ex| {
            i += 1;
            if (ex.skip) continue;

            const patch = PatchStep.create(b, ex, outdir);

            const cmd = b.addSystemCommand(
                &.{ b.zig_exe, "build", b.fmt("-Dn={}", .{i}), "-Dhealed", "test" },
            );
            cmd.setName(b.fmt("zig build -D={} -Dhealed test", .{i}));
            cmd.expectExitCode(0);
            cmd.step.dependOn(&patch.step);

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

// Apply a patch to the specified exercise.
const PatchStep = struct {
    const join = fs.path.join;

    const exercises_path = "exercises";
    const patches_path = "patches/patches";

    step: Step,
    exercise: Exercise,
    outdir: []const u8,

    pub fn create(owner: *Build, exercise: Exercise, outdir: []const u8) *PatchStep {
        const self = owner.allocator.create(PatchStep) catch @panic("OOM");
        self.* = .{
            .step = Step.init(.{
                .id = .custom,
                .name = owner.fmt("patch {s}", .{exercise.main_file}),
                .owner = owner,
                .makeFn = make,
            }),
            .exercise = exercise,
            .outdir = outdir,
        };

        return self;
    }

    fn make(step: *Step, _: *std.Progress.Node) !void {
        const b = step.owner;
        const self = @fieldParentPtr(PatchStep, "step", step);
        const exercise = self.exercise;
        const name = exercise.baseName();

        // Use the POSIX patch variant.
        const file = join(b.allocator, &.{ exercises_path, exercise.main_file }) catch
            @panic("OOM");
        const patch = join(b.allocator, &.{ patches_path, b.fmt("{s}.patch", .{name}) }) catch
            @panic("OOM");
        const output = join(b.allocator, &.{ self.outdir, exercise.main_file }) catch
            @panic("OOM");

        const argv = &.{ "patch", "-i", patch, "-o", output, file };

        var child = std.process.Child.init(argv, b.allocator);
        child.stdout_behavior = .Ignore; // the POSIX standard says that stdout is not used
        _ = try child.spawnAndWait();
    }
};

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
