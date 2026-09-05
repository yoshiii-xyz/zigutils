const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const path = if (args.len > 1) args[1] else ".";
    const cwd = std.fs.cwd();
    const stat = cwd.statFile(path) catch null;
    if (stat) |s| {
        try stdout.print("Path: {s}\n", .{path});
        try stdout.print("Is file: {}\n", .{s.kind == .file});
        try stdout.print("Is dir: {}\n", .{s.kind == .directory});
        try stdout.print("Size: {} bytes\n", .{s.size});
    }
}