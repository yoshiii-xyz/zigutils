const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const pattern = if (args.len > 1) args[1] else null;
    var root = try std.fs.cwd().openDir(".", .{ .iterate = true });
    defer root.close();

    var iter = root.iterate();
    while (try iter.next()) |entry| {
        if (pattern) |p| {
            if (!std.mem.containsAtLeast(u8, entry.name, 1, p)) continue;
        }
        try stdout.print("{s}\n", .{entry.name});
    }
}