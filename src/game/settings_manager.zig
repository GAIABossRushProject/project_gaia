const std = @import("std");

pub const SettingJson = struct {
    windows: windows,
    fps: i32,
};

pub const windows = struct {
    height: u16,
    width: u16,
};

pub const SettingsManager = struct {
    setting_json: std.json.Parsed(SettingJson),
    settings_file: []u8,
    allocator: std.mem.Allocator,
    const Self = @This();

    pub fn init(io: std.Io, path: []const u8, allocator: std.mem.Allocator) !Self {
        const settings_file = try std.Io.Dir.cwd().readFileAlloc(
            io,
            path,
            allocator,
            std.Io.Limit.limited(1024),
        );

        const json = try std.json.parseFromSlice(
            SettingJson,
            allocator,
            settings_file,
            .{},
        );

        return Self{
            .setting_json = json,
            .settings_file = settings_file,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Self) void {
        self.setting_json.deinit();
        self.allocator.free(self.settings_file);
    }
};
