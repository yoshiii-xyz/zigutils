const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const count = if (args.len > 1) try std.fmt.parseInt(usize, args[1], 10) else 1;

    for (0..count) |_| {
        var uuid: [16]u8 = undefined;
        for (0..16) |i| {
            uuid[i] = std.crypto.random.int(u8);
        }
        try stdout.print("{x}\n", .{std.fmt.fmtSliceHexLower(&uuid)});
    }
}