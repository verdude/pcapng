const IDB = @This();

const std = @import("std");
const mem = std.mem;
const BlockMeta = @import("BlockMeta.zig");

const Options = enum(u16) {
    _,
};

pub fn parse(reader: std.fs.File.Reader, alloc: mem.Allocator) !IDB {
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
}
