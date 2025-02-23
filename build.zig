const std = @import("std");
const buildpkg = @import("src/build/exe.zig");

pub fn build(builder: *std.Build) !void {
    // Build
    const exe = try buildpkg.malum.init(builder);

    // Run
    {
        const run_cmd = builder.addRunArtifact(exe.exe);
        if (builder.args) |args| run_cmd.addArgs(args);
        const run_step = builder.step("run", "Run the app");
        run_step.dependOn(&run_cmd.step);
    }
}
