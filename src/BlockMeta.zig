const BlockMeta = @This();
const BlockOption = @import("BlockOption.zig");
const std = @import("std");
const mem = std.mem;

pub const MetaError = error{
    BadTag,
    BadMagic,
    UnsupportedVersion,
    PrematureEOF,
    WrongBlockType,
};

pub const BlockType = enum {
    SHB,
    IDB,
};

pub const Endianness = enum {
    Big,
    Little,
};

pub fn getblocktype(b: *const [4]u8) MetaError!BlockType {
    const tag: u32 = @bitCast(b.*);
    return switch (tag) {
        0x0a0d0d0a => BlockType.SHB,
        1 => BlockType.IDB,
        else => {
            std.log.err("uh... why? {d}", .{tag});
            return MetaError.BadTag;
        },
    };
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

pub const PcapngVersion = struct {
    major: u16,
    minor: u16,
    pub fn tostring(self: PcapngVersion, a: mem.Allocator) ![]const u8 {
        return try std.fmt.allocPrint(
            a,
            "{d}.{d}",
            .{ self.major, self.minor },
        );
    }
    pub fn supported(self: PcapngVersion) bool {
        return self.major == 1 and self.minor == 0;
    }
};
