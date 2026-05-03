const std = @import("std");
const animation = @import("animation.zig");
const asset_manager = @import("../game/asset_manager.zig");
const spine = @import("../lib/spine.zig");

pub const Player = struct {
    animateState: animation.Animate,
    const Self = @This();

    pub fn init(blueprint: asset_manager.SpineBlueprint) Self {
        const ans = animation.Animate.init(blueprint);

        return Self{
            .animateState = ans,
        };
    }

    pub fn update(self: *Self) void {
        _ = self;
    }

    pub fn draw(self: *Self) void {
        self.animateState.draw();
    }
};
