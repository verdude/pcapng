const std = @import("std");
const FixedBufferAllocator = std.heap.FixedBufferAllocator;
const BlockMeta = @import("BlockMeta.zig");
const SHB = @import("SHB.zig");
const IDB = @import("IDB.zig");
const ISB = @import("ISB.zig");
const EPB = @import("EPB.zig");
const PcapNGFile = @import("pcapng_file.zig");
const ReadError = PcapNGFile.ReadError;
const args = @import("args.zig");

pub const log_level: std.log.Level = .info;

pub fn main() !u8 {
    const len: u16 = 1024;
    var buf = [1]u8{0} ** len;
    var fba = FixedBufferAllocator.init(&buf);
    const alloc = fba.allocator();

    const filename = args.getfirstarg(alloc) orelse {
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

    _ = try SHB.parse(&file);

    while (true) {
        var tmp = try file.read_maybe(4) orelse break;
        // ehh
        file.pos -= 4;
        const block = switch (try BlockMeta.getblocktype(tmp[0..4])) {
            BlockMeta.BlockType.shb => try SHB.parse(&file),
            BlockMeta.BlockType.idb => try IDB.parse(&file),
            BlockMeta.BlockType.epb => try EPB.parse(&file),
            BlockMeta.BlockType.isb => try ISB.parse(&file),
        };
        _ = block;
    }
    return 0;
}
