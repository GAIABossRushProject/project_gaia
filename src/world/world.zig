const std = @import("std");
const raylib = @import("raylib");
const player = @import("player.zig");
const game_context = @import("../game/game_ctx.zig");
const asset_manager = @import("../game/asset_manager.zig");
const types = @import("types.zig");
const tile_map = @import("tile_maps/")

const world_errors = error{
    ErrorCouldNotLoadPlayerAssets,
};

pub const World = struct {
    player: player.Player,
    tile_map: 
    const Self = @This();

    pub fn init(asset: *asset_manager.AssetManager, player_position: raylib.Vector2,tile_map:) world_errors!Self {
        if (asset.get_blueprint("sam")) |blueprint| {
            const p = try player.Player.init(blueprint, player_position);
            return Self{
                .player = p,
            };
        } else {
            return error.ErrorCouldNotLoadPlayerAssets;
        }
    }

    pub fn update(self: *Self, player_intent: types.PlayerIntent) void {
        self.player.update(player_intent, raylib.getFrameTime());
    }

    pub fn draw(self: *Self) void {
        self.player.draw();
    }

    pub fn deinit(self: *Self) void {
        std.log.debug("destroying player", .{});
        self.player.deinit();
    }
};
