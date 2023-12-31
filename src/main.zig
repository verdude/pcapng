const std = @import("std");
const Allocator = std.mem.Allocator;
const ArgIterator = std.process.ArgIterator;
const FixedBufferAllocator = std.heap.FixedBufferAllocator;

fn getfirstarg(alloc: Allocator) ?[]const u8 {
    var args = try ArgIterator.initWithAllocator(alloc);
    defer args.deinit();

    _ = args.next();
    return args.next();
}

pub fn main() !u8 {
    var buf: [512]u8 = undefined;
    var fba = FixedBufferAllocator.init(&buf);
    const alloc = fba.allocator();

    const filename = getfirstarg(alloc) orelse {
        std.log.err("Very bad news.", .{});
        return 1;
    };
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    return 0;
}
