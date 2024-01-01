const std = @import("std");
const Allocator = std.mem.Allocator;
const ArgIterator = std.process.ArgIterator;
const FixedBufferAllocator = std.heap.FixedBufferAllocator;

const MetaError = error{
    BadTag,
    BadMagic,
};
const Endianness = enum {
    Big,
    Little,
};
const PcapngVersion = struct {
    major: u16,
    minor: u16,

    pub fn tostring(self: PcapngVersion, alloc: Allocator) ![]const u8 {
        return try std.fmt.allocPrint(alloc, "{d}.{d}", .{ self.major, self.minor });
    }

    pub fn supported(self: PcapngVersion) bool {
        return self.major == 1 and self.minor == 0;
    }
};
const BlockType = enum {
    SHB,
};
const BlockOptionType = enum(u16) {
    opt_endofopt = 0,
    opt_comment = 1,
    shb_hardware = 2,
    shb_os = 3,
    shb_userappl = 4,
    opt_custom_safe_copy_string = 2988,
    opt_custom_safe_copy_octets = 2989,
    opt_custom_no_copy_string = 19372,
    opt_custom_no_copy_octets = 19373,
};
const BlockOption = struct {
    type: BlockOptionType,
    length: u16,
    value: []u8,
};

fn readoption(optsbuf: []const u8) MetaError!BlockOption {
    const tipe: BlockOptionType = @bitCast(optsbuf[0..2].*);
    std.log.info("Got block option type: {any}", .{tipe});
    return MetaError.BadMagic;
}

fn getfirstarg(alloc: Allocator) ?[]const u8 {
    var args = try ArgIterator.initWithAllocator(alloc);
    defer args.deinit();

    _ = args.next();
    return args.next();
}

fn getblocktype(b: *[4]u8) MetaError!BlockType {
    const tag = [4]u8{ 0x0a, 0x0d, 0x0d, 0x0a };
    if (std.mem.eql(u8, b, &tag)) {
        return BlockType.SHB;
    } else {
        std.log.err("uh... why? {any}", .{b});
        return MetaError.BadTag;
    }
}

fn getendianness(b: *[4]u8) MetaError!Endianness {
    const big = [4]u8{ 0x1a, 0x2b, 0x3c, 0x4d };
    const little = [4]u8{ 0x4d, 0x3c, 0x2b, 0x1a };
    if (std.mem.eql(u8, b, &little)) {
        return Endianness.Little;
    } else if (std.mem.eql(u8, b, &big)) {
        return Endianness.Big;
    } else {
        return MetaError.BadMagic;
    }
}

pub fn main() !u8 {
    const len: u8 = 255;
    var buf = [1]u8{0} ** len;
    var fba = FixedBufferAllocator.init(&buf);
    const alloc = fba.allocator();

    const filename = getfirstarg(alloc) orelse {
        std.log.err("Missing arg.", .{});
        return 1;
    };
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    //const filestat = file.stat();
    const reader = file.reader();
    const shb_fixed_meta_len = 4 * 6;
    const shb_fixed_meta = try alloc.alloc(u8, shb_fixed_meta_len);
    const uread = try reader.read(shb_fixed_meta);
    if (uread != shb_fixed_meta_len) {
        std.log.err("uh", .{});
    }
    const blocktype: BlockType = try getblocktype(shb_fixed_meta[0..4]);
    std.log.info("BlockType: {any}", .{blocktype});
    const totallen: u32 = @bitCast(shb_fixed_meta[4..8].*);
    std.log.info("Block Length: {d}", .{totallen});
    const magic = try getendianness(shb_fixed_meta[8..12]);
    std.log.info("Magic: {any}", .{magic});
    const version = PcapngVersion{
        .major = @bitCast(shb_fixed_meta[12..14].*),
        .minor = @bitCast(shb_fixed_meta[14..16].*),
    };
    if (!version.supported()) {
        std.log.err("Unsupported Version On Block: {s}!", .{try version.tostring(alloc)});
        return 1;
    } else {
        std.log.info("Block Version: {s}", .{try version.tostring(alloc)});
    }
    const sectionlength: i64 = @bitCast(shb_fixed_meta[16..24].*);
    std.log.info("sectionlength: {d}", .{sectionlength});
    const optionslen = totallen - shb_fixed_meta_len;
    const optionsbuf = try alloc.alloc(u8, optionslen);
    const ouread = try reader.read(optionsbuf);
    if (ouread < optionslen) {
        std.log.err("uh... didn't read enough: {d} should be {d}", .{ ouread, optionslen });
        return 1;
    } else {
        std.log.info("Read a bunch of options: {s}", .{optionsbuf});
    }

    return 0;
}
