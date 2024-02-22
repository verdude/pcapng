const SHB = @This();

const std = @import("std");
const mem = std.mem;
const BlockMeta = @import("BlockMeta.zig");
const block_option = @import("BlockOption.zig");
const PcapNGFile = @import("pcapng_file.zig");
const BlockOption = block_option.BlockOption;
const BlockOptionType = block_option.BlockOptionType;

const Options = enum(u16) {
    shb_hardware = 2,
    shb_os = 3,
    shb_userappl = 4,
    _,

    pub fn examine(self: Options) void {
        switch (self) {
            .shb_hardware => std.log.info("hardware", .{}),
            .shb_os => std.log.info("os", .{}),
            .shb_userappl => std.log.info("userappl", .{}),
            ._ => std.log.info("unknown", .{}),
        }
    }
};

block_type: BlockMeta.BlockType = BlockMeta.BlockType.SHB,
total_len: u32,
magic: BlockMeta.Endianness,
version: BlockMeta.PcapngVersion,
section_length: i64,
options: []BlockOption(Options),

pub fn parse(file: *PcapNGFile, alloc: mem.Allocator) !SHB {
    const fixed_meta_len = 4 * 6;
    var fixed_meta: []const u8 = try file.read(fixed_meta_len);
    const btype = try BlockMeta.getblocktype(fixed_meta[0..4]);
    if (btype != BlockMeta.BlockType.SHB) {
        return BlockMeta.MetaError.WrongBlockType;
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
    std.log.debug("SHB Block Len: {d}", .{blocklen});
    const optionslen = blocklen - fixed_meta_len;
    const optionsbuf = try file.read(optionslen);
    var options: std.ArrayList(BlockOption(Options)) = std.ArrayList(BlockOption(Options)).init(alloc);
    var i: u64 = 0;
    while (i < optionsbuf.len - 4) {
        const option = try block_option.loadoption(optionsbuf[i..], Options);
        if (option.length == 0) {
            std.log.debug("Found end of options.", .{});
            break;
        }
        i += option.length;
        try options.append(option);
        option.print();
    }
    return .{
        .block_type = btype,
        .total_len = blocklen,
        .magic = try BlockMeta.getendianness(fixed_meta[8..12]),
        .version = version,
        .section_length = @bitCast(fixed_meta[16..24].*),
        .options = try options.toOwnedSlice(),
    };
}
