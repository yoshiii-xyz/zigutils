const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const proc_dir = "/proc";
    var dir = try std.fs.cwd().openDir(proc_dir, .{ .iterate = true });
    defer dir.close();

    var iter = dir.iterate();
    while (try iter.next()) |entry| {
        if (entry.kind != .directory) continue;
        const pid = std.fmt.parseInt(u32, entry.name, 10) catch null;
        if (pid) |_| {
            const stat = dir.openFile(entry.name ++ "/stat", .{}) catch null;
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
