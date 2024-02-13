const IDB = @This();

const std = @import("std");
const mem = std.mem;
const BlockMeta = @import("BlockMeta.zig");
const LinkType = @import("link_types.zig").LinkType;

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

pub fn parse(reader: std.fs.File.Reader, alloc: mem.Allocator) !IDB {
    // type 4 bytes
    // total len 4 bytes
    // link type 2 bytes
    // reserved 2 bytes - 0s MUST ignore...
    // snaplen 4 bytes
    const fixed_meta_len = 16;
    const fixed_meta = try alloc.alloc(u8, fixed_meta_len);
    const uread = try reader.read(fixed_meta_len);
    if (uread != fixed_meta_len) {
        return error{NotEnoughBits};
    }
    const btype = try BlockMeta.getblocktype(fixed_meta[0..4]);
    if (btype != BlockMeta.BlockType.IDB) {
        return BlockMeta.MetaError.WrongBlockType;
    }
    const block_type: u32 = @bitCast(fixed_meta[0..4]);
    const total_len: u32 = @bitCast(fixed_meta[4..8]);
    const ltype_bits: u16 = @bitCast(fixed_meta[8..10]);
    const link_type: LinkType = try std.meta.intToEnum(LinkType, ltype_bits);
    const snaplen: u32 = @bitCast(fixed_meta[12..]);
}
