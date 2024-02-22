const std = @import("std");
const Allocator = std.mem.Allocator;
const ArgIterator = std.process.ArgIterator;
const FixedBufferAllocator = std.heap.FixedBufferAllocator;
const BlockMeta = @import("BlockMeta.zig");
const SHB = @import("SHB.zig");
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
    //var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    //const gpalloc = gpa.allocator();
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

    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    const filestat = try file.stat();
    const filebuf: []u8 = try gpa.alloc(u8, filestat.size);
    const uread = try file.readAll(filebuf);
    if (uread < filestat.size) {
        std.log.warn("Only read {d} bytes.", .{uread});
    } else {
        std.log.debug("Read {d} bytes.", .{uread});
    }
    var ngfile: PcapNGFile = .{ .buf = &filebuf, .pos = 0 };

    defer gpa.free(ngfile.buf.*);

    _ = try SHB.parse(&ngfile, alloc);
    while (true) {
        var tmp: []const u8 = try ngfile.read(8);
        var next_block = try BlockMeta.getblocktype(tmp[0..4]);
        std.log.debug("Next: {any}", .{next_block});
    }
    return 0;
}
