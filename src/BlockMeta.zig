const BlockMeta = @This();
const BlockOption = @import("BlockOption.zig");
const std = @import("std");

pub const MetaError = error{
    BadTag,
    BadMagic,
    UnsupportedVersion,
    PrematureEOF,
};

pub const BlockType = enum {
    SHB,
};

pub const Endianness = enum {
    Big,
    Little,
};

pub fn getblocktype(b: *[4]u8) MetaError!BlockType {
    const tag = [4]u8{ 0x0a, 0x0d, 0x0d, 0x0a };
    if (std.mem.eql(u8, b, &tag)) {
        return BlockMeta.BlockType.SHB;
    } else {
        std.log.err("uh... why? {any}", .{b});
        return MetaError.BadTag;
    }
}

pub fn getendianness(b: *[4]u8) BlockMeta.MetaError!BlockMeta.Endianness {
    const big = [4]u8{ 0x1a, 0x2b, 0x3c, 0x4d };
    const little = [4]u8{ 0x4d, 0x3c, 0x2b, 0x1a };
    if (std.mem.eql(u8, b, &little)) {
        return BlockMeta.Endianness.Little;
    } else if (std.mem.eql(u8, b, &big)) {
        return BlockMeta.Endianness.Big;
    } else {
        return BlockMeta.MetaError.BadMagic;
    }
}
