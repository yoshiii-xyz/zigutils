const std = @import("std");
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        try stdout.print("Usage: zighash <file>\n", .{});
        std.process.exit(1);
    }

    const file_path = args[1];
    const data = try std.fs.cwd().readFileAlloc(allocator, file_path, 10 * 1024 * 1024);
    defer allocator.free(data);

    var md5_ctx = std.crypto.hash.Md5.init(.{});
    var sha256_ctx = std.crypto.hash.sha2.Sha256.init(.{});

    std.crypto.hash.Md5.update(&md5_ctx, data);
    std.crypto.hash.sha2.Sha256.update(&sha256_ctx, data);

    var md5_out: [16]u8 = undefined;
    std.crypto.hash.Md5.final(&md5_ctx, &md5_out);

    var sha256_out: [32]u8 = undefined;
    std.crypto.hash.sha2.Sha256.final(&sha256_ctx, &sha256_out);

    try stdout.print("md5:    {x}\n", .{std.fmt.fmtSliceHexLower(&md5_out)});
    try stdout.print("sha256: {x}\n", .{std.fmt.fmtSliceHexLower(&sha256_out)});
}
