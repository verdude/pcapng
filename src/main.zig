const std = @import("std");
const FixedBufferAllocator = std.heap.FixedBufferAllocator;
const BlockMeta = @import("BlockMeta.zig");
const SHB = @import("SHB.zig");
const IDB = @import("IDB.zig");
const ISB = @import("ISB.zig");
const EPB = @import("EPB.zig");
const SimpleFile = @import("pcapng_file.zig");
const ReadError = SimpleFile.ReadError;
const args = @import("args.zig");

pub const log_level: std.log.Level = .info;

pub fn main() !u8 {
    //const len: u16 = 1024;
    //var buf = [1]u8{0} ** len;
    //var fba = FixedBufferAllocator.init(&buf);
    //const alloc = fba.allocator();

    var a = args.init();
    try a.parse();
    const filename = a.file orelse return 1;

    var gpai = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = gpai.allocator();
    defer {
        const deinit_status = gpai.deinit();
        if (deinit_status == .leak) {
            std.log.err("mem leak", .{});
        }
    }

    var file = try SimpleFile.load(filename, gpa);
    const fp = &file;
    defer gpa.free(file.buf);

    _ = try SHB.parse(fp);

    while (true) {
        var tmp = try fp.read_maybe(4, false) orelse break;
        const block = switch (try BlockMeta.getblocktype(tmp[0..4])) {
            BlockMeta.BlockType.shb => try SHB.parse(fp),
            BlockMeta.BlockType.idb => try IDB.parse(fp),
            BlockMeta.BlockType.epb => try EPB.parse(fp),
            BlockMeta.BlockType.isb => isb: {
                const isb = try ISB.parse(fp);
                std.log.debug("ISB, {any}", .{isb});
                break :isb isb;
            },
        };
        _ = block;
    }
    return 0;
}
