const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        try stdout.print("Usage: zigbase64 <string>\n", .{});
        std.process.exit(1);
    }

    const input = args[1];
    const encoded = try allocator.alloc(u8, std.base64.standard.Encoder.calcSize(input.len));
    defer allocator.free(encoded);
    _ = std.base64.standard.Encoder.encode(encoded, input);

    try stdout.print("{s}\n", .{encoded});
}