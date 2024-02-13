const std = @import("std");
const Allocator = std.mem.Allocator;
const ArgIterator = std.process.ArgIterator;
const FixedBufferAllocator = std.heap.FixedBufferAllocator;
const BlockMeta = @import("BlockMeta.zig");
const SHB = @import("SHB.zig");

pub const log_level: std.log.Level = .info;

fn getfirstarg(alloc: Allocator) ?[]const u8 {
    var args = try ArgIterator.initWithAllocator(alloc);
    defer args.deinit();

    _ = args.next();
    return args.next();
}

pub fn main() !u8 {
    const len: u16 = 1024;
    var buf = [1]u8{0} ** len;
    var fba = FixedBufferAllocator.init(&buf);
    //var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    //const gpalloc = gpa.allocator();
    const alloc = fba.allocator();

    const filename = getfirstarg(alloc) orelse {
        std.log.err("Missing arg.", .{});
        return 1;
    };
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    //const filestat = file.stat();
    const reader = file.reader();
    fba.reset();
    _ = try SHB.parse(reader, alloc);
    const tmp = try alloc.alloc(u8, 8);
    while (true) {
        const nread = try reader.read(tmp);
        if (nread != 8) {
            return error{OhNoTooShort}.OhNoTooShort;
        }
        var next_block = try BlockMeta.getblocktype(tmp[0..4]);
        std.log.debug("Next: {any}", .{next_block});
    }
    return 0;
}
