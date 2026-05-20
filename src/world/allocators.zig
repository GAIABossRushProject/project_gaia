const std = @import("std");

var gpa: std.heap.DebugAllocator(.{}) = undefined;
var is_initialized = false;

pub fn init() !void {
    std.debug.assert(!is_initialized);
    gpa = std.heap.DebugAllocator(.{}).init;

    is_initialized = true;
}

pub fn deinit() void {
    std.debug.assert(is_initialized);

    const leaked = gpa.deinit();

    if (leaked == std.heap.Check.leak) {
        @panic("memory is leaked");
    }

    is_initialized = false;
}

pub fn get() std.mem.Allocator {
    std.debug.assert(is_initialized);

    return gpa.allocator();
}
