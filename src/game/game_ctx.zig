const std = @import("std");
const raylib = @import("raylib");
const settings = @import("settings_manager.zig");
const scene_manager = @import("scene_manager.zig");
const asset_manager = @import("asset_manager.zig");
const input_manager = @import("input_manager.zig");

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
    input_manager: input_manager.InputManager,
    bootstrap: Bootstrap,
    allocator: std.mem.Allocator,
    const Self = @This();

    pub fn init(bootstrap: *Bootstrap) !Self {
        var context = Self{
            .settings = try settings.SettingsManager.init(bootstrap.*.io, bootstrap.*.settings_path, bootstrap.*.allocator),
            .input_manager = input_manager.InputManager.init(),
            .asset_manager = asset_manager.AssetManager.init(bootstrap.*.allocator),
            .allocator = bootstrap.*.allocator,
            .bootstrap = bootstrap.*,
            .scene_manager = undefined,
        };

        context.scene_manager = scene_manager.SceneManager.init(&context);

        return context;
    }

    pub fn register_game_assets(self: *Self) !void {
        try self.asset_manager.load_asset("sam", self.bootstrap.sam_atlas_path, self.bootstrap.sam_skeleton_path);
    }

    pub fn run(self: *Self) !void {
        raylib.initWindow(
            self.settings.setting_json.value.windows.width,
            self.settings.setting_json.value.windows.height,
            "GAIA: Echoes Of Geneis",
        );

        try self.register_game_assets();

        const cf = raylib.ConfigFlags{
            .window_highdpi = true,
        };

        raylib.setConfigFlags(cf);

        raylib.setTargetFPS(self.settings.setting_json.value.fps);

        while (!raylib.windowShouldClose()) {
            raylib.beginDrawing();
            defer raylib.endDrawing();
            try self.scene_manager.update(self);

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
