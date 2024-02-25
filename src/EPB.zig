const IDB = @This();

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
captured_len: u32,
original_len: u32,
data: []const u8,
options: BlockOptions,
offset: u64,

const Options = enum(u16) {
    // name, code, length, multiple allowed
    epb_flags = 2, // 4 no
    epb_hash = 3, // variable, minimum hash type-dependent yes
    epb_dropcount = 4, // 8 no
    epb_packetid = 5, // 8 no
    epb_queue = 6, // 4 no
    epb_verdict = 7, // variable, minimum verdict type-dependent yes
    _,
};

pub fn parse(file: *PcapNGFile) !BlockMeta.Block {
    // type 4 bytes
    // total len 4 bytes
    // interface id 4 bytes
    // timestamp (high) 4 bytes
    // timestamp (low) 4 bytes
    // captured packet length 4 bytes
    // original packet length 4 bytes
    const fixed_meta_len = 28;
    const offset = file.pos;
    const fixed_meta = try file.read(fixed_meta_len);
    const btype = try BlockMeta.getblocktype(fixed_meta[0..4]);
    if (btype != BlockMeta.BlockType.epb) {
        return BlockMeta.MetaError.WrongBlockType;
    }
    const total_len: u32 = @bitCast(fixed_meta[4..8].*);
    const interface_id: u32 = @bitCast(fixed_meta[8..12].*);
    const timestamp_high: u32 = @bitCast(fixed_meta[12..16].*);
    const timestamp_low: u32 = @bitCast(fixed_meta[16..20].*);
    const captured_len: u32 = @bitCast(fixed_meta[20..24].*);
    const original_len: u32 = @bitCast(fixed_meta[24..28].*);

    const data_len = block_option.paddedlen_bytes(u32, captured_len);
    const data = try file.read(data_len);
    const final_total_len = 4;
    const optionslen = total_len - fixed_meta_len - data_len - final_total_len;
    const options = .{ .bytes = try file.read(optionslen) };
    try BlockMeta.assert_final_total_len(try file.read(final_total_len), total_len);

    return BlockMeta.Block{ .epb = .{
        .total_len = total_len,
        .interface_id = interface_id,
        .timestamp_high = timestamp_high,
        .timestamp_low = timestamp_low,
        .captured_len = captured_len,
        .original_len = original_len,
        .data = data,
        .options = options,
        .offset = offset,
    } };
}
