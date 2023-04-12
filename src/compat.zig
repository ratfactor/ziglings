/// Compatibility support for very old versions of Zig and recent versions before
/// commit efa25e7d5 (Merge pull request #14498 from ziglang/zig-build-api).
///
/// Versions of Zig from before 0.6.0 cannot do the version check and will just
/// fail to compile, but 0.5.0 was a long time ago, it is unlikely that anyone
/// who attempts these exercises is still using it.
const std = @import("std");
const builtin = @import("builtin");

const debug = std.debug;

// Very old versions of Zig used warn instead of print.
const print = if (@hasDecl(debug, "print")) debug.print else debug.warn;

// When changing this version, be sure to also update README.md in two places:
//     1) Getting Started
//     2) Version Changes
const needed_version_str = "0.11.0-dev.2560";

fn isCompatible() bool {
    if (!@hasDecl(builtin, "zig_version") or !@hasDecl(std, "SemanticVersion")) {
        return false;
    }

    const needed_version = std.SemanticVersion.parse(needed_version_str) catch unreachable;
    const version = builtin.zig_version;
    const order = version.order(needed_version);

    return order != .lt;
}

pub fn die() noreturn {
    const error_message =
        \\ERROR: Sorry, it looks like your version of zig is too old. :-(
        \\
        \\Ziglings requires development build
        \\
        \\    {s}
        \\
        \\or higher. Please download a development ("master") build from
        \\
        \\    https://ziglang.org/download/
        \\
        \\
    ;

    print(error_message, .{needed_version_str});

    // Use exit code 2, to differentiate from a normal Zig compiler error.
    std.os.exit(2);
}

// A separate function is required because very old versions of Zig doesn't
// support labeled block expressions.
pub const is_compatible: bool = isCompatible();

/// This is the type to be used only for the build function definition, since
/// the type must be compatible with the build runner.
///
/// Don't use std.Build.Builder, since it is deprecated and may be removed in
/// future.
pub const Build = if (is_compatible) std.Build else std.build.Builder;

/// This is the type to be used for accessing the build namespace.
pub const build = if (is_compatible) std.Build else std.build;
