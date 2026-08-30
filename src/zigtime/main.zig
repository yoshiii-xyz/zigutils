const std = @import("std");
const builtin = @import("builtin");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const now = std.time.timestamp();
    const epoch = std.time.timestamp();

    try stdout.print("Unix timestamp: {}\n", .{epoch});
    try stdout.print("ISO 8601: {s}\n", .{std.time.format(allocator, std.time.ISO8601, epoch) catch "?"});
}
