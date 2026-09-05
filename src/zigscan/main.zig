const std = @import("std");
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stderr = std.io.getStdErr().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        try stderr.print("Usage: zigscan <directory>\n", .{});
        std.process.exit(1);
    }

    const dir_path = args[1];
    var dir = try std.fs.cwd().openDir(dir_path, .{ .iterate = true });
    defer dir.close();

    var iter = dir.iterate();
    var total_size: u64 = 0;
    var file_count: usize = 0;
    var dir_count: usize = 0;

    while (try iter.next()) |entry| {
        if (entry.kind == .file) {
            file_count += 1;
            const stat = dir.statFile(entry.name) catch null;
            if (stat) |s| total_size += s.size;
        } else if (entry.kind == .directory) {
            dir_count += 1;
        }
        try stdout.print("{s: <10} {s: >10} {s}\n", .{
            if (entry.kind == .directory) "dir" else "file",
            if (entry.kind == .file) blk: {
                const stat = dir.statFile(entry.name) catch null;
                break :blk if (stat) |s| try std.fmt.allocPrint(allocator, "{}", .{s.size}) else "?";
            } else "—",
            entry.name,
        });
    }

    try stdout.print("\nTotal: {} files, {} dirs, {} bytes\n", .{ file_count, dir_count, total_size });
}
