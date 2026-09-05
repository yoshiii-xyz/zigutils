const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        try stdout.print("Usage: zignet <host>\n", .{});
        std.process.exit(1);
    }

    const host = args[1];
    const sock = std.net.tcpConnectToHost(allocator, host, 80) catch |err| {
        try stdout.print("Error: {}\n", .{err});
        std.process.exit(1);
    };
    defer sock.close();
    try sock.writer().print("GET / HTTP/1.1\r\nHost: {s}\r\nConnection: close\r\n\r\n", .{host});
    var buf: [4096]u8 = undefined;
    const n = try sock.read(&buf);
    try stdout.print("{s}", .{buf[0..n]});
}
