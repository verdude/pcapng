const PcapNGFile = @This();

const std = @import("std");

buf: []const u8,
pos: u64,

const ReadError = error{ NotEnoughBytes, InvalidPosition, Woops };

pub fn load_file(filename: []const u8, alloc: std.mem.Allocator) !PcapNGFile {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    const filestat = try file.stat();
    const buf: []u8 = try alloc.alloc(u8, filestat.size);
    const uread = try file.readAll(buf);
    if (uread < filestat.size) {
        std.log.warn("Only read {d} bytes.", .{uread});
    } else {
        std.log.debug("Read {d} bytes.", .{uread});
    }
    return .{ .buf = buf, .pos = 0 };
}

pub fn read(self: *PcapNGFile, len: u64) ReadError![]const u8 {
    const end_offset = len + self.pos;
    if (self.pos >= self.buf.len) {
        return ReadError.InvalidPosition;
    }
    const slice = self.buf[self.pos..end_offset];
    self.pos = end_offset;
    return slice;
}
