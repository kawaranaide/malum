const std = @import("std");
const assert = std.debug.assert;
const builtin = @import("builtin");
const options = @import("build_options");

pub const version = options.app_version;
pub const version_string = options.app_version_string;

/// The optimization mode as a string.
pub const mode_string = mode: {
    const m = @tagName(builtin.mode);
    if (std.mem.lastIndexOfScalar(u8, m, '.')) |i| break :mode m[i..];
    break :mode m;
};

pub const artifact = Artifact.detect();

pub const Artifact = enum {
    exe,
    lib,

    pub fn detect() Artifact {
        return switch (builtin.output_mode) {
            .Exe => .exe,
            .Lib => .lib,
            else => {
                @compileLog(builtin.output_mode);
                @compileError("unsupported artifact output mode");
            },
        };
    }
};

const entrypoint = @import("cli/main.zig");

pub const main = entrypoint;
