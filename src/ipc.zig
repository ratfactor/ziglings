/// Client side support for Zig IPC.
const std = @import("std");
const debug = std.debug;
const fs = std.fs;
const mem = std.mem;

const Allocator = mem.Allocator;
const Client = std.zig.Client;
const ErrorBundle = std.zig.ErrorBundle;
const Server = std.zig.Server;

/// This data structure must be kept in sync with zig.Server.Message.EmitBinPath.
const EmitBinPath = struct {
    flags: Flags,
    path: []const u8,

    pub const Flags = Server.Message.EmitBinPath.Flags;

    pub fn deinit(self: *EmitBinPath, allocator: Allocator) void {
        allocator.free(self.path);
        self.* = undefined;
    }
};

pub fn parseErrorBundle(allocator: Allocator, data: []const u8) !ErrorBundle {
    const EbHdr = Server.Message.ErrorBundle;
    const eb_hdr = @ptrCast(*align(1) const EbHdr, data);
    const extra_bytes =
        data[@sizeOf(EbHdr)..][0 .. @sizeOf(u32) * eb_hdr.extra_len];
    const string_bytes =
        data[@sizeOf(EbHdr) + extra_bytes.len ..][0..eb_hdr.string_bytes_len];

    // TODO: use @ptrCast when the compiler supports it
    const unaligned_extra = std.mem.bytesAsSlice(u32, extra_bytes);
    const extra_array = try allocator.alloc(u32, unaligned_extra.len);
    // TODO: use @memcpy when it supports slices
    //
    // Don't use the "multi-object for loop" syntax, in
    // order to avoid a syntax error with old Zig compilers.
    var i: usize = 0;
    while (i < extra_array.len) : (i += 1) {
        extra_array[i] = unaligned_extra[i];
    }

    return .{
        .string_bytes = try allocator.dupe(u8, string_bytes),
        .extra = extra_array,
    };
}

pub fn parseEmitBinPath(allocator: Allocator, data: []const u8) !EmitBinPath {
    const EbpHdr = Server.Message.EmitBinPath;
    const ebp_hdr = @ptrCast(*align(1) const EbpHdr, data);
    const path = try allocator.dupe(u8, data[@sizeOf(EbpHdr)..]);

    return .{
        .flags = ebp_hdr.flags,
        .path = path,
    };
}

pub fn sendMessage(file: fs.File, tag: Client.Message.Tag) !void {
    const header: Client.Message.Header = .{
        .tag = tag,
        .bytes_len = 0,
    };
    try file.writeAll(mem.asBytes(&header));
}
