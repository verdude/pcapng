const BlockMeta = @This();
const BlockOption = @import("BlockOption.zig");
const std = @import("std");
const mem = std.mem;
const SHB = @import("SHB.zig");
const IDB = @import("IDB.zig");
const EPB = @import("EPB.zig");

pub const MetaError = error{
    BadTag,
    BadArg,
    BadMagic,
    UnsupportedVersion,
    PrematureEOF,
    WrongBlockType,
    InvalidFinalTotalLen,
};

pub const BlockType = enum {
    shb,
    idb,
    epb,
};

pub const Block = union(BlockType) {
    shb: SHB,
    idb: IDB,
    epb: EPB,
};

pub const Endianness = enum {
    Big,
    Little,
};

pub fn getblocktype(b: *const [4]u8) MetaError!BlockType {
    const tag: u32 = @bitCast(b.*);
    return switch (tag) {
        0x0a0d0d0a => BlockType.shb,
        1 => BlockType.idb,
        6 => BlockType.epb,
        else => {
            std.log.err("uh... why? {d}", .{tag});
            return MetaError.BadTag;
        },
    };
}

pub fn getendianness(b: *const [4]u8) BlockMeta.MetaError!BlockMeta.Endianness {
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

pub fn assert_final_total_len(final_bytes: []const u8, initial_total_len: u32) !void {
    if (final_bytes.len != 4) {
        return MetaError.BadArg;
    }
    const final_total_len: u32 = @bitCast(final_bytes[0..4].*);
    if (final_total_len != initial_total_len) {
        return MetaError.InvalidFinalTotalLen;
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
