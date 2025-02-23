const std = @import("std");
const warn = std.debug.warn;

const Nix = struct {
    const Self = @This();

    const useNet: bool = true;
    const refresh: bool = false;
    const showVersion: bool = false;

    const args = enum {
        help,
        version,
        offline,
        refresh,
    };

    const flags = struct {
        .{
            .name = Self.args.help,
            .long = "help",
        },

        .{
            .name = Self.args.version,
            .long = "version",
        },

        .{
            .name = Self.args.offline,
            .long = "offline",
        },

        .{
            .name = Self.args.refresh,
            .long = "refresh",
        },
    };
};

pub fn main() anyerror!u8 {
    for (std.os.argv) |arg| {
        std.debug.print("  {s}\n", .{arg});
    }
    return 1;
}
