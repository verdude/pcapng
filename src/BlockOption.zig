const std = @import("std");
const BlockMeta = @import("BlockMeta.zig");

const Type = enum(u16) {
    opt_endofopt = 0,
    opt_comment = 1,
    opt_custom_safe_copy_string = 2988,
    opt_custom_safe_copy_octets = 2989,
    opt_custom_no_copy_string = 19372,
    opt_custom_no_copy_octets = 19373,
};

pub fn BlockOptionType(comptime T: type) type {
    return union {
        common: Type,
        block_specific: T,
    };
}

pub fn BlockOption(comptime T: type) type {
    return struct {
        type: BlockOptionType(T),
        length: u16,
        value: []const u8,
    };
}

const err = error.UnknownOptionType;

pub fn loadoption(optsbuf: []const u8, comptime T: type) !BlockOption(T) {
    const n: u16 = @bitCast(optsbuf[0..2].*);
    const t: ?Type = std.meta.intToEnum(Type, n) catch null;
    const BO = BlockOptionType(T);
    var ot: BO = undefined;
    if (t) |unwrapped| {
        ot = BO{ .common = unwrapped };
    } else {
        std.log.debug("unknown option type: {d}", .{n});
        ot = BO{ .block_specific = std.meta.intToEnum(T, n) catch {
            return err;
        } };
    }
    return BlockOption(T){
        .type = ot,
        .length = @bitCast(optsbuf[2..4].*),
        .value = optsbuf[4..],
    };
}
