const std = @import("std");
const builtin = @import("builtin");

const Build = std.Build;
const CompileStep = Build.CompileStep;
const Step = Build.Step;
const Child = std.process.Child;

const assert = std.debug.assert;
const join = std.fs.path.join;
const print = std.debug.print;

comptime {
    const required_zig = "0.13.0";
    const current_zig = builtin.zig_version;
    const min_zig = std.SemanticVersion.parse(required_zig) catch unreachable;
    if (current_zig.order(min_zig) == .lt) {
        const error_message =
            \\Sorry, it looks like your version of zig is too old. :-(
            \\
            \\malum requires zig
            \\
            \\{}
            \\
            \\or higher.
            \\
            \\The required version is provided in the nix shell.
            \\
            \\To enter type: nix develop
        ;
        @compileError(std.fmt.comptimePrint(error_message, .{min_zig}));
    }
}

/// Intial release is set for x86_64-linux
/// with further systems to come after
const release_targets = [_]std.Target.Query{
    .{ .cpu_arch = .x86_64, .os_tag = .linux },
};

pub fn build(b: *std.Build) !void {
    // Modules
    const opt_module = b.createModule(.{
        .root_source_file = b.path("src/lib/opt.zig"),
    });

    // Build
    const exe = b.addExecutable(.{
        .name = "malum",
        .root_source_file = b.path("src/cli/main.zig"),
        .target = b.host,
    });
    exe.root_module.addImport("opt", opt_module);
    b.installArtifact(exe);

    // Run
    const run_exe = b.addRunArtifact(exe);

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);
}
