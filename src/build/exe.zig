pub const malum = @This();
const std = @import("std");

exe: *std.Build.Step.Compile,

/// The install step for the executable.
install_step: *std.Build.Step.InstallArtifact,

pub fn init(b: *std.Build) !malum {
    const exe: *std.Build.Step.Compile = b.addExecutable(.{
        .name = "malum",
        .root_source_file = b.path("src/main.zig"),
        .target = b.host,
    });
    const install_step = b.addInstallArtifact(exe, .{});

    return .{
        .exe = exe,
        .install_step = install_step,
    };
}

pub fn install(self: *const malum) void {
    const b = self.install_step.step.owner;
    b.getInstallStep().dependOn(&self.install_step.step);
}
