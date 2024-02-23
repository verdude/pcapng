const IDB = @This();

const std = @import("std");
const mem = std.mem;
const BlockMeta = @import("BlockMeta.zig");
const LinkType = @import("link_types.zig").LinkType;
const block_option = @import("BlockOption.zig");
const PcapNGFile = @import("pcapng_file.zig");
const BlockOption = block_option.BlockOption;

total_len: u32,
link_type: LinkType,
snap_len: u32,
options: []const BlockOption(Options),
offset: u64,

const Options = enum(u16) {
    // name, code, length, multiple allowed
    if_name = 2, // variable no
    if_description = 3, // variable no
    if_IPv4addr = 4, // 8 yes
    if_IPv6addr = 5, // 17 yes
    if_MACaddr = 6, // 6 no
    if_EUIaddr = 7, // 8 no
    if_speed = 8, // 8 no
    if_tsresol = 9, // 1 no
    if_tzone = 10, // 4 no
    if_filter = 11, // variable, minimum 1 no
    if_os = 12, // variable no
    if_fcslen = 13, // 1 no
    if_tsoffset = 14, // 8 no
    if_hardware = 15, // variable no
    if_txspeed = 16, // 8 no
    if_rxspeed = 17, // 8 no
    _,
};

pub fn parse(file: *PcapNGFile, alloc: mem.Allocator) !BlockMeta.Block {
    // type 4 bytes
    // total len 4 bytes
    // link type 2 bytes
    // reserved 2 bytes - 0s MUST ignore...
    // snaplen 4 bytes
    const fixed_meta_len = 16;
    const offset = file.pos;
    const fixed_meta = try file.read(fixed_meta_len);
    const btype = try BlockMeta.getblocktype(fixed_meta[0..4]);
    if (btype != BlockMeta.BlockType.idb) {
        return BlockMeta.MetaError.WrongBlockType;
    }
    const total_len: u32 = @bitCast(fixed_meta[4..8].*);
    const ltype_bits: u16 = @bitCast(fixed_meta[8..10].*);
    const link_type: LinkType = try std.meta.intToEnum(LinkType, ltype_bits);
    const snaplen: u32 = @bitCast(fixed_meta[12..16].*);
    const optionslen = total_len - fixed_meta_len;

    return BlockMeta.Block{ .idb = .{
        .total_len = total_len,
        .link_type = link_type,
        .snap_len = snaplen,
        .options = try block_option.loadoptions(file, optionslen, Options, alloc),
        .offset = offset,
    } };
}
