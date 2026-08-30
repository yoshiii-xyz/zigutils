const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.items.len < 2) {
        try stdout.print("Usage: zigbase64 <string>\n", .{});
        std.process.exit(1);
    }

    const input = args.items[1];
    const encoded = try std.base64.standard.encode(allocator, input);
    defer allocator.free(encoded);

    try stdout.print("{s}\n", .{encoded});
}
