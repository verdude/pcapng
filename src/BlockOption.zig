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
    return union(enum) {
        common: Type,
        block_specific: T,
    };
}

pub fn BlockOption(comptime T: type) type {
    return struct {
        type: BlockOptionType(T),
        length: u16,
        value: []const u8,

        pub fn print(self: BlockOption(T)) void {
            std.log.info("BlockOptionType[{s}] {s}", .{ @tagName(self.type), self.value });
        }
    };
}

const BlockOptionError = error{
    UnknownOptionType,
    LengthMismatch,
};

pub fn loadoption(optsbuf: []const u8, comptime T: type) !BlockOption(T) {
    const n: u16 = @bitCast(optsbuf[0..2].*);
    const tag_type: ?Type = std.meta.intToEnum(Type, n) catch null;
    const BT = BlockOptionType(T);
    var ot: BT = undefined;

    if (tag_type) |unwrapped| {
        ot = BT{ .common = unwrapped };
    } else {
        ot = BT{ .block_specific = std.meta.intToEnum(T, n) catch {
            std.log.debug("unknown option type: {d}", .{n});
            return BlockOptionError.UnknownOptionType;
        } };
    }

    const len: u16 = @bitCast(optsbuf[2..4].*);
    if (len != optsbuf[4..].len) {
        std.log.err("Expected len: {d}, found: {d}", .{ len, optsbuf[4..].len });
        //return BlockOptionError.LengthMismatch;
    }

    return BlockOption(T){
        .type = ot,
        .length = len,
        .value = optsbuf[4..],
    };
}
