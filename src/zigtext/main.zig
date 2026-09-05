const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        try stdout.print("Usage: zigtext <file>\n", .{});
        std.process.exit(1);
    }

    const file_path = args[1];
    const content = try std.fs.cwd().readFileAlloc(allocator, file_path, 10 * 1024 * 1024);
    defer allocator.free(content);

    var lines: usize = 0;
    var words: usize = 0;
    const bytes: usize = content.len;

    var it = std.mem.splitScalar(u8, content, '\n');
    while (it.next()) |line| {
        lines += 1;
        var word_it = std.mem.splitScalar(u8, line, ' ');
        while (word_it.next()) |w| {
            if (w.len > 0) words += 1;
        }
    }

    try stdout.print("{s}: {} lines, {} words, {} bytes\n", .{ file_path, lines, words, bytes });
}
