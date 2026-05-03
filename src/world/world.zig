const std = @import("std");
const raylib = @import("raylib");
const player = @import("player.zig");
const game_context = @import("../game/game_ctx.zig");
const asset_manager = @import("../game/asset_manager.zig");

const world_errors = error{
    ErrorCouldNotLoadPlayerAssets,
};

pub const World = struct {
    player: player.Player,
    const Self = @This();

    pub fn init(asset: *asset_manager.AssetManager) !Self {
        if (asset.get_blueprint("sam")) |blueprint| {
            const p = player.Player.init(blueprint);
            return Self{
                .player = p,
            };
        } else {
            return world_errors.ErrorCouldNotLoadPlayerAssets;
        }
    }

    pub fn update(self: *Self) void {
        self.player.update();
    }

    pub fn draw(self: *Self) void {
        self.player.draw();
    }
};
