const std = @import("std");

fn writeIndent(writer: anytype, depth: usize) !void {
    for (0..depth) |_| {
        try writer.writeAll("  ");
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        try stdout.print("Usage: zigjson <file>\n", .{});
        std.process.exit(1);
    }

    const file_path = args[1];
    const content = try std.fs.cwd().readFileAlloc(allocator, file_path, 10 * 1024 * 1024);
    defer allocator.free(content);

    var depth: usize = 0;
    for (content) |c| {
        switch (c) {
            '{', '[' => {
                depth += 1;
                try writeIndent(stdout, depth - 1);
                try stdout.print("{c}\n", .{c});
            },
            '}', ']' => {
                depth -= 1;
                try writeIndent(stdout, depth);
                try stdout.print("{c}\n", .{c});
            },
            '"' => {
                try stdout.print("{c}", .{c});
            },
            else => try stdout.print("{c}", .{c}),
        }
    }
}