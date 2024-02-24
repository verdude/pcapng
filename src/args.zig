const std = @import("std");
const os = std.os;

const Args = struct {};

const Flags = enum {};

fn getfirstarg(alloc: std.mem.Allocator) ?[]const u8 {
    var args = try std.process.ArgIterator.initWithAllocator(alloc);
    defer args.deinit();

    _ = args.next();
    return args.next();
}
