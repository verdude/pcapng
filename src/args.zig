const std = @import("std");
const os = std.os;
const mem = std.mem;

fn is_option(arg: []const u8, long: []const u8, short: []const u8) bool {
    if (arg.len == long.len) return mem.eql(u8, arg, long);
    if (arg.len == short.len) return mem.eql(u8, arg, short);
    return false;
}

pub const CliArgs = struct {
    // -i
    idb: bool,
    count: bool,
    file: ?[]const u8,

    pub fn parse(self: *CliArgs) !void {
        var argi = std.process.ArgIteratorPosix.init();
        //var optarg_next = false;
        while (true) {
            const arg = argi.next() orelse break;
            if (is_option(arg, "--idb", "-i")) {
                self.idb = true;
            } else if (is_option(arg, "--count", "-c")) {
                self.count = true;
            } else {
                self.file = arg;
            }
        }
    }
};

pub fn init() CliArgs {
    return .{
        .idb = false,
        .count = false,
        .file = null,
    };
}

const Flags = enum { idb };
