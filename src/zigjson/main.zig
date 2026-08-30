const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.items.len < 2) {
        try stdout.print("Usage: zigjson <file>\n", .{});
        std.process.exit(1);
    }

    const file_path = args.items[1];
    const content = try std.fs.cwd().readFileAlloc(allocator, file_path, 10 * 1024 * 1024);
    defer allocator.free(content);

    var depth: usize = 0;
    for (content) |c| {
        switch (c) {
            '{', '[' => {
                depth += 1;
                try stdout.print("{s}{c}\n", .{std.mem.repeat(u8, "  ", depth - 1), c});
            },
            '}', ']' => {
                depth -= 1;
                try stdout.print("{s}{c}\n", .{std.mem.repeat(u8, "  ", depth), c});
            },
            '"' => {
                try stdout.print("{c", .{c});
            },
            else => try stdout.print("{c}", .{c}),
        }
    }
}
