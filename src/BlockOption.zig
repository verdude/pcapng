const BlockOption = @This();

const std = @import("std");
const BlockMeta = @import("BlockMeta.zig");

const Type = enum(u16) {
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

const Option = struct {
    type: Type,
    length: u16,
    value: []u8,
};

fn readoption(optsbuf: []const u8) !BlockOption {
    const tipe: BlockOption.Type = @bitCast(optsbuf[0..2].*);
    std.log.info("Got block option type: {any}", .{tipe});
    return BlockMeta.MetaError.BadMagic;
}
