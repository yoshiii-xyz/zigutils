# zigutils

A collection of fast, minimal Linux utilities written in Zig.

## Tools

- `zigscan` - Scan a directory and show file sizes and types
- `zignet` - Connect to a host and fetch HTTP headers
- `zigfind` - Find files and directories by name pattern
- `zigproc` - List running processes from /proc
- `zigtext` - Count lines, words, and bytes in a text file
- `zigpath` - Show detailed path information and components
- `zigenv` - Dump environment variables with filtering
- `zighash` - Compute MD5 and SHA256 hashes of files
- `zigtime` - Show current Unix timestamp and ISO 8601 time
- `zigdiff` - Compare two files and show byte differences
- `zignum` - Simple number utility (double, square, even/odd)
- `zigjson` - Pretty-print JSON files
- `ziguuid` - Generate random UUIDs
- `zigbase64` - Encode strings to Base64
- `ziggzip` - Read and decompress gzip files

## Install

Use Zig 0.14.0 for the commands below.

```console
zig build --release=fast
sudo cp zig-out/bin/<tool> /usr/local/bin/
```

## Usage

Each tool is a standalone binary. Run with no arguments for usage help.

```console
zigscan /home/user
zigtext README.md
zighash file.tar.gz
```
