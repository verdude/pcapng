const PcapNGFile = @This();

const std = @import("std");

buf: *const []const u8,
pos: u64,

const ReadError = error{ NotEnoughBytes, InvalidPosition, Woops };

pub fn load_file(filename: []const u8) !PcapNGFile {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    const filestat = try file.stat();
    const buf: []u8 = try std.heap.page_allocator.alloc(u8, filestat.size);
    const uread = try file.readAll(buf);
    if (uread < filestat.size) {
        std.log.warn("Only read {d} bytes.", .{uread});
    }
    return .{ .buf = &buf[0..], .pos = 0 };
}

pub fn read(self: *PcapNGFile, len: u64) ReadError![]const u8 {
    const end_offset = len + self.pos;
    if (self.pos >= self.buf.len) {
        return ReadError.InvalidPosition;
    }
    const s = self.buf.*[self.pos..end_offset];
    self.pos = end_offset;
    if (s.len != len) {
        return ReadError.Woops;
    }
    return s;
}
