const std = @import("std");
const Allocator = std.mem.Allocator;
const ArgIterator = std.process.ArgIterator;
const FixedBufferAllocator = std.heap.FixedBufferAllocator;
const BlockMeta = @import("BlockMeta.zig");
const SHB = @import("SHB.zig");
const IDB = @import("IDB.zig");
const EPB = @import("EPB.zig");
const PcapNGFile = @import("pcapng_file.zig");

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
    const alloc = fba.allocator();

    const filename = getfirstarg(alloc) orelse {
        std.log.err("Missing arg.", .{});
        return 1;
    };

    var gpai = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = gpai.allocator();
    defer {
        const deinit_status = gpai.deinit();
        if (deinit_status == .leak) {
            std.log.err("mem leak", .{});
        }
    }

    var file = try PcapNGFile.load_file(filename, gpa);
    defer gpa.free(file.buf);

    _ = try SHB.parse(&file, alloc);

    while (true) {
        var tmp: []const u8 = try file.read(4);
        file.pos -= 4;
        const block = switch (try BlockMeta.getblocktype(tmp[0..4])) {
            BlockMeta.BlockType.shb => try SHB.parse(&file, alloc),
            BlockMeta.BlockType.idb => try IDB.parse(&file, alloc),
            BlockMeta.BlockType.epb => try EPB.parse(&file, alloc),
        };
        std.log.debug("Block: {any}", .{block});
    }
    return 0;
}
