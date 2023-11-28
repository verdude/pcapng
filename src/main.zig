const std = @import("std");

pub fn main() !void {
    const file = try std.fs.cwd().openFile("arc.pcapng", .{});
    defer file.close();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);

    try bw.flush();
}
