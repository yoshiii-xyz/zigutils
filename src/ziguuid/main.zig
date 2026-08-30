const std = @import("std");
const builtin = @import("builtin");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const count = if (args.items.len > 1) try std.fmt.parseInt(usize, args.items[1], 10) else 1;

    for (0..count) |_| {
        var uuid: [16]u8 = undefined;
        for (0..16) |i| {
            uuid[i] = @intCast(std.crypto.random.randomIntLessThan(u8, 256));
        }
        try stdout.print("{s}\n", .{std.fmt.hex(&uuid)});
    }
}
