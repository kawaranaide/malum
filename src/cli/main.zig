const std = @import("std");
const opt = @import("opt");
const warn = std.debug.warn;

const Nix = struct {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();

    const Self = @This();

    const useNet: bool = true;
    const refresh: bool = false;
    const helpRequested: bool = false;
    const showVersion: bool = false;

    const Args = enum {
        help,
        version,
        offline,
        refresh,
    };

    const flags = [_]opt.Flag(Args){
        .{
            .name = Args.help,
            .long = "help",
        },

        .{
            .name = Args.version,
            .long = "version",
        },

        .{
            .name = Args.offline,
            .long = "offline",
        },

        .{
            .name = Args.refresh,
            .long = "refresh",
        },
    };
};

pub fn main() anyerror!u8 {
    const nix: Nix = .{};
    var iterator = opt.FlagIterator(nix.flags).init(nix.flags[0..]);

    while (iterator.next_flag() catch {
        return 0;
    }) |flag| {
        switch (flag.name) {
            Nix.Args.help => {
                warn("to be implemented");
                return 0;
            },
            Nix.Args.version => {
                warn("to be implemented");
                return 0;
            },
            Nix.Args.offline => {
                warn("to be implemented");
                return 0;
            },
            Nix.Args.refresh => {
                warn("to be implemented");
                return 0;
            },
        }
    }
}
