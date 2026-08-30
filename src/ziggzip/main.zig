const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.items.len < 2) {
        try stdout.print("Usage: ziggzip <file>\n", .{});
        std.process.exit(1);
    }

    const file_path = args.items[1];
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    var gzip_reader = try std.compress.gzip.gzipReader(allocator, file.reader());
    defer gzip_reader.deinit();

    var buf: [4096]u8 = undefined;
    while (try gzip_reader.read(&buf) > 0) {}
    try stdout.print("Read: {s}\n", .{file_path});
}
