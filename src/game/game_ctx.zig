const std = @import("std");
const raylib = @import("raylib");
const settings = @import("settings_manager.zig");
const scene_manager = @import("scene_manager.zig");
const asset_manager = @import("asset_manager.zig");

const game_errors = error{
    ErrorBadSettings,
};

pub const Bootstrap = struct {
    io: std.Io,
    allocator: std.mem.Allocator,
    settings_path: []const u8,
    sam_atlas_path: [*c]const u8,
    sam_skeleton_path: [*c]const u8,
};

pub const GameContext = struct {
    settings: settings.SettingsManager,
    scene_manager: scene_manager.SceneManager,
    asset_manager: asset_manager.AssetManager,
    allocator: std.mem.Allocator,
    const Self = @This();

    pub fn init(bootstrap: *Bootstrap) !Self {
        const s = try settings.SettingsManager.init(bootstrap.*.io, bootstrap.*.settings_path, bootstrap.*.allocator);
        const sm = scene_manager.SceneManager.init();
        const am = asset_manager.AssetManager.init(bootstrap.*.allocator);

        return Self{
            .settings = s,
            .scene_manager = sm,
            .asset_manager = am,
            .allocator = bootstrap.*.allocator,
        };
    }

    pub fn run(self: *Self) void {
        raylib.initWindow(
            self.settings.setting_json.value.windows.width,
            self.settings.setting_json.value.windows.height,
            "GAIA: Echoes Of Geneis",
        );

        raylib.setTargetFPS(self.settings.setting_json.value.fps);

        while (!raylib.windowShouldClose()) {
            raylib.beginDrawing();
            defer raylib.endDrawing();
            try self.scene_manager.update();

            raylib.clearBackground(.black);
            try self.scene_manager.draw();
        }
    }

    pub fn deinit(self: *Self) void {
        self.scene_manager.deinit();
        self.settings.deinit();
        self.asset_manager.deinit();
    }
};
