const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const proc_dir = "/proc";
    var dir = try std.fs.cwd().openDir(proc_dir, .{ .iterate = true });
    defer dir.close();

    var iter = dir.iterate();
    while (try iter.next()) |entry| {
        if (entry.kind != .directory) continue;
        const pid = std.fmt.parseInt(u32, entry.name, 10) catch null;
        if (pid) |_| {
            var stat_path_buf: [32]u8 = undefined;
            const stat_path = std.fmt.bufPrint(&stat_path_buf, "{s}/stat", .{entry.name}) catch continue;
            const stat = dir.openFile(stat_path, .{}) catch null;
            if (stat) |f| {
                defer f.close();
                var buf: [4096]u8 = undefined;
                const n = f.read(&buf) catch 0;
                if (n > 0) {
                    const line = std.mem.sliceTo(buf[0..n], '\n');
                    try stdout.print("{s: <8} {s}\n", .{ entry.name, line });
                }
            }
        }
    }
}
