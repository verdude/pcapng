const std = @import("std");
const BlockMeta = @import("BlockMeta.zig");
const PcapNGFile = @import("pcapng_file.zig");

const Type = enum(u16) {
    opt_endofopt = 0,
    opt_comment = 1,
    opt_custom_safe_copy_string = 2988,
    opt_custom_safe_copy_octets = 2989,
    opt_custom_no_copy_string = 19372,
    opt_custom_no_copy_octets = 19373,
};

pub const BlockOptions = struct {
    bytes: []const u8,
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
            std.log.debug("option type {any}", .{self.type});
            const botypeval: []const u8 = switch (self.type) {
                .common => @tagName(self.type.common),
                .block_specific => @tagName(self.type.block_specific),
            };
            std.log.info("BlockOptionType[{s},{s},{d}] {s}", .{ @tagName(self.type), botypeval, self.length, self.value });
        }
    };
}

pub fn paddedlen_bytes(comptime T: type, n: T) T {
    return n + (4 - (n & 3) | 4 ^ 4);
}

const BlockOptionError = error{
    UnknownOptionType,
    LengthMismatch,
};

pub fn loadoption(optsbuf: []const u8, comptime T: type) !BlockOption(T) {
    const n: u16 = @bitCast(optsbuf[0..2].*);
    const tag_type: ?Type = std.meta.intToEnum(Type, n) catch null;
    const BT = BlockOptionType(T);
    const local = n & 0x8000 != 0; // msb set == local/non-portable option
    const tag_value_len_bytes = 4;
    var ot: BT = undefined;

    if (local) {
        std.log.debug("local use option", .{});
    }
    if (tag_type) |unwrapped| {
        ot = BT{ .common = unwrapped };
    } else {
        ot = BT{ .block_specific = std.meta.intToEnum(T, n) catch {
            std.log.debug("unknown option type: {d}", .{n});
            return BlockOptionError.UnknownOptionType;
        } };
    }

    const len: u16 = @bitCast(optsbuf[2..4].*);
    const padded_len = paddedlen_bytes(u16, len);
    if (padded_len > optsbuf.len - tag_value_len_bytes) {
        std.log.debug(
            "Expected len: {d}, found: {d}",
            .{ padded_len + tag_value_len_bytes, optsbuf.len },
        );
        return BlockOptionError.LengthMismatch;
    }

    return BlockOption(T){
        .type = ot,
        .length = padded_len + tag_value_len_bytes,
        .value = optsbuf[tag_value_len_bytes .. tag_value_len_bytes + len],
    };
}

pub fn loadoptions(
    file: *PcapNGFile,
    optionslen: u64,
    comptime T: type,
) !BlockOptions {
    const block_options = .{
        .bytes = try file.read(optionslen),
    };
    var i: u64 = 0;
    while (i < block_options.bytes.len) {
        const option = try loadoption(block_options.bytes[i..], T);
        if (option.length == 0) {
            std.log.debug("Found end of options.", .{});
            break;
        }
        i += option.length;
        option.print();
    }
    return block_options;
}

test "paddedlen_bytes 0 should be 0" {
    var n = paddedlen_bytes(u16, 0);
    try std.testing.expectEqual(n, 0);
}

test "paddedlen_bytes 1-4 should be 4" {
    var n: u16 = undefined;
    var i: u16 = 1;
    while (i < 5) : (i += 1) {
        n = paddedlen_bytes(u16, i);
        try std.testing.expectEqual(n, 4);
    }
}

test "paddedlen_bytes 5-8 should be 8" {
    var j: u32 = 5;
    var m: u32 = 0;
    while (j < 9) : (j += 1) {
        m = paddedlen_bytes(u32, j);
        try std.testing.expectEqual(m, 8);
    }
}
