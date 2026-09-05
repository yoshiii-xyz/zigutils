const std = @import("std");

const tools = [_][]const u8{
    "zigscan",
    "zignet",
    "zigfind",
    "zigproc",
    "zigtext",
    "zigpath",
    "zigenv",
    "zighash",
    "zigtime",
    "zigdiff",
    "zignum",
    "zigjson",
    "ziguuid",
    "zigbase64",
    "ziggzip",
};

pub fn build(b: *std.Build) void {
    const mode = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    for (tools) |tool| {
        const exe = b.addExecutable(.{
            .name = tool,
            .root_source_file = b.path("src/" ++ tool ++ "/main.zig"),
            .target = target,
            .optimize = mode,
        });
        exe.install();
    }
}