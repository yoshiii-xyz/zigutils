const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.items.len < 2) {
        try stdout.print("Usage: zignet <host>\n", .{});
        std.process.exit(1);
    }

    const host = args.items[1];
    var sock = std.net.Stream.connect(std.net.Address.parse(host, 80) catch |err| {
        try stdout.print("Error: {}\n", .{err});
        std.process.exit(1);
    }) catch null;
    if (sock) |s| {
        defer s.close();
        try s.writer().print("GET / HTTP/1.1\r\nHost: {s}\r\nConnection: close\r\n\r\n", .{host});
        var buf: [4096]u8 = undefined;
        const n = s.read(&buf) catch 0;
        try stdout.print("{s}", .{buf[0..n]});
    }
}
