const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 3) {
        try stdout.print("Usage: zigdiff <file1> <file2>\n", .{});
        std.process.exit(1);
    }

    const a = try std.fs.cwd().readFileAlloc(allocator, args[1], 10 * 1024 * 1024);
    defer allocator.free(a);
    const b = try std.fs.cwd().readFileAlloc(allocator, args[2], 10 * 1024 * 1024);
    defer allocator.free(b);

    const len = @min(a.len, b.len);
    var diff_count: usize = 0;
    for (0..len) |i| {
        if (a[i] != b[i]) {
            diff_count += 1;
        }
    }

    try stdout.print("Files differ at {} bytes\n", .{diff_count});
    try stdout.print("File 1: {} bytes\n", .{a.len});
    try stdout.print("File 2: {} bytes\n", .{b.len});
}