const std = @import("std");
const raylib = @import("raylib");
const world = @import("../../world/world.zig");
const game_ctx = @import("../../game/game_ctx.zig");

pub const DemoScene = struct {
    world: world.World,
    allocator: std.mem.Allocator,
    const Self = @This();

    pub fn init(ctx: *game_ctx.GameContext) !Self {
        const w = try world.World.init();
        return Self{
            .allocator = ctx.*,
            .world = w,
        };
    }

    pub fn update(self: *Self) void {
        self.world.update();
    }

    pub fn draw(self: *Self) void {
        self.world.draw();
    }
};
