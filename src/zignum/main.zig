const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        try stdout.print("Usage: zignum <number>\n", .{});
        std.process.exit(1);
    }

    const n = try std.fmt.parseInt(i64, args[1], 10);
    try stdout.print("Input: {}\n", .{n});
    try stdout.print("Double: {}\n", .{n * 2});
    try stdout.print("Square: {}\n", .{n * n});
    try stdout.print("Is even: {}\n", .{@mod(n, 2) == 0});
}