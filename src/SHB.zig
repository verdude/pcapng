const SHB = @This();

const std = @import("std");
const mem = std.mem;
const BlockMeta = @import("BlockMeta.zig");

const PcapngVersion = struct {
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

pub fn parse(reader: std.fs.File.Reader, alloc: mem.Allocator) !void {
    const shb_fixed_meta_len = 4 * 6;
    const shb_fixed_meta = try alloc.alloc(u8, shb_fixed_meta_len);
    const uread = try reader.read(shb_fixed_meta);
    if (uread != shb_fixed_meta_len) {
        std.log.err("uh", .{});
    }
    const blocktype: BlockMeta.BlockType = try BlockMeta.getblocktype(shb_fixed_meta[0..4]);
    std.log.info("BlockType: {any}", .{blocktype});
    const totallen: u32 = @bitCast(shb_fixed_meta[4..8].*);
    std.log.info("Block Length: {d}", .{totallen});
    const magic = try BlockMeta.getendianness(shb_fixed_meta[8..12]);
    std.log.info("Magic: {any}", .{magic});
    const version = PcapngVersion{
        .major = @bitCast(shb_fixed_meta[12..14].*),
        .minor = @bitCast(shb_fixed_meta[14..16].*),
    };
    if (!version.supported()) {
        std.log.err(
            "Unsupported Version On Block: {s}!",
            .{try version.tostring(alloc)},
        );
        return BlockMeta.MetaError.UnsupportedVersion;
    } else {
        std.log.info("Block Version: {s}", .{try version.tostring(alloc)});
    }
    const sectionlength: i64 = @bitCast(shb_fixed_meta[16..24].*);
    std.log.info("sectionlength: {d}", .{sectionlength});
    const optionslen = totallen - shb_fixed_meta_len - 4;
    const optionsbuf = try alloc.alloc(u8, optionslen);
    const ouread = try reader.read(optionsbuf);
    if (ouread < optionslen) {
        std.log.err("uh... didn't read enough: {d} should be {d}", .{ ouread, optionslen });
        return BlockMeta.MetaError.PrematureEOF;
    } else {
        std.log.info("Read a bunch of options: {s}", .{optionsbuf});
    }
}
