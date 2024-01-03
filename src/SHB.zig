const SHB = @This();

const std = @import("std");
const mem = std.mem;
const BlockMeta = @import("BlockMeta.zig");
const BlockOption = @import("BlockOption.zig");

block_type: BlockMeta.BlockType = BlockMeta.BlockType.SHB,
total_len: u32,
magic: BlockMeta.Endianness,
version: BlockMeta.PcapngVersion,
section_length: i64,
options: []BlockOption,

pub fn parse(reader: std.fs.File.Reader, alloc: mem.Allocator) !SHB {
    const fixed_meta_len = 4 * 6;
    const fixed_meta = try alloc.alloc(u8, fixed_meta_len);
    const uread = try reader.read(fixed_meta);
    if (uread != fixed_meta_len) {
        std.log.err("uh, not enough bits?", .{});
    }
    const version = BlockMeta.PcapngVersion{
        .major = @bitCast(fixed_meta[12..14].*),
        .minor = @bitCast(fixed_meta[14..16].*),
    };
    if (!version.supported()) {
        std.log.err(
            "Unsupported Version in SHB: {s}!",
            .{try version.tostring(alloc)},
        );
        return BlockMeta.MetaError.UnsupportedVersion;
    }
    const blocklen: u32 = @bitCast(fixed_meta[4..8].*);
    const optionslen = blocklen - fixed_meta_len - 4;
    const optionsbuf = try alloc.alloc(u8, optionslen);
    const ouread = try reader.read(optionsbuf);
    if (ouread < optionslen) {
        std.log.err(
            "uh... didn't read enough: {d} should be {d}",
            .{ ouread, optionslen },
        );
        return BlockMeta.MetaError.PrematureEOF;
    }
    var options = std.ArrayList(BlockOption).init(alloc);
    var i: u64 = 0;
    while (i < optionsbuf.len) {
        const option = try BlockOption.loadoption(optionsbuf[i..]);
        std.debug.assert(option.length > 0);
        i += option.length;
        try options.append(option);
    }
    return .{
        .block_type = try BlockMeta.getblocktype(fixed_meta[0..4]),
        .total_len = blocklen,
        .magic = try BlockMeta.getendianness(fixed_meta[8..12]),
        .version = version,
        .section_length = @bitCast(fixed_meta[16..24].*),
        .options = try options.toOwnedSlice(),
    };
}
