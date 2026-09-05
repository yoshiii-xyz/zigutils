const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const filter = if (args.len > 1) args[1] else null;

    var env_map = try std.process.getEnvMap(allocator);
    defer env_map.deinit();

    var it = env_map.iterator();
    while (it.next()) |kv| {
        if (filter) |f| {
            if (!std.mem.containsAtLeast(u8, kv.key_ptr.*, 1, f)) continue;
        }
        try stdout.print("{s}={s}\n", .{ kv.key_ptr.*, kv.value_ptr.* });
    }
}
