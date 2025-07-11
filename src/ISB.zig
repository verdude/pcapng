const ISB = @This();

const std = @import("std");
const mem = std.mem;
const BlockMeta = @import("BlockMeta.zig");
const LinkType = @import("link_types.zig").LinkType;
const block_option = @import("BlockOption.zig");
const PcapNGFile = @import("pcapng_file.zig");
const BlockOptions = block_option.BlockOptions;

total_len: u32,
interface_id: u32,
timestamp_high: u32,
timestamp_low: u32,
options: BlockOptions,
offset: u64,

const Options = enum(u16) {
    // name, code, length, multiple allowed
    isb_starttime = 2, // 8 no
    isb_endtime = 3, // 8 no
    isb_ifrecv = 4, // 8 no
    isb_ifdrop = 5, // 8 no
    isb_filteraccept = 6, // 8 no
    isb_osdrop = 7, // 8 no
    isb_usrdeliv = 8, // 8 no
    _,
};

pub fn parse(file: *PcapNGFile) !BlockMeta.Block {
    // type 4 bytes
    // total len 4 bytes
    // interface id 4 bytes
    // timestamp (high) 4 bytes
    // timestamp (low) 4 bytes
    const fixed_meta_len = 20;
    const offset = file.pos;
    const fixed_meta = try file.read(fixed_meta_len);
    const btype = try BlockMeta.getblocktype(fixed_meta[0..4]);
    if (btype != BlockMeta.BlockType.isb) {
        return BlockMeta.MetaError.WrongBlockType;
    }
    const total_len: u32 = @bitCast(fixed_meta[4..8].*);
    const interface_id: u32 = @bitCast(fixed_meta[8..12].*);
    const timestamp_high: u32 = @bitCast(fixed_meta[12..16].*);
    const timestamp_low: u32 = @bitCast(fixed_meta[16..20].*);

    const final_total_len = 4;
    const optionslen = total_len - fixed_meta_len - final_total_len;
    const options = BlockOptions{ .bytes = try file.read(optionslen) };
    try BlockMeta.assert_final_total_len(try file.read(final_total_len), total_len);

    return BlockMeta.Block{ .isb = .{
        .total_len = total_len,
        .interface_id = interface_id,
        .timestamp_high = timestamp_high,
        .timestamp_low = timestamp_low,
        .options = options,
        .offset = offset,
    } };
}
