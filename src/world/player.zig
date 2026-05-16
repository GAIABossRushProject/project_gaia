const std = @import("std");
const animation = @import("animation.zig");
const asset_manager = @import("../game/asset_manager.zig");
const spine = @import("../lib/spine.zig");
const raylib = @import("raylib");

pub const Player = struct {
    animateState: animation.Animate,
    const Self = @This();

    pub fn init(blueprint: asset_manager.SpineBlueprint) Self {
        var ans = try animation.Animate.init(blueprint);

        ans.set_scale(0.25, -0.25);
        return Self{
            .animateState = ans,
        };
    }

    pub fn update(self: *Self) void {
        self.animateState.sync_player_visuals(raylib.Vector2{ .x = 300, .y = 300 });
    }

    pub fn draw(self: *Self) void {
        self.animateState.draw();
    }

    pub fn deinit(self: *Self) void {
        self.animateState.deinit();
    }
};
