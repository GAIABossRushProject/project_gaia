const std = @import("std");
const raylib = @import("raylib");
const world = @import("../../world/world.zig");
const game_ctx = @import("../../game/game_ctx.zig");
const input_manager = @import("../../game/input_manager.zig");
const types = @import("../../world/types.zig");

pub const DemoScene = struct {
    world: world.World,
    allocator: std.mem.Allocator,
    input_manager: input_manager.InputManager,
    const Self = @This();

    pub fn init(ctx: *game_ctx.GameContext) !Self {
        const w = try world.World.init(&ctx.asset_manager, raylib.Vector2{ .x = 300, .y = 300 });
        return Self{
            .allocator = ctx.*.allocator,
            .world = w,
            .input_manager = ctx.input_manager,
        };
    }

    pub fn update(self: *Self) void {
        var intent = types.PlayerIntent{
            .movement_x = 0.0,
            .movement_y = 0.0,
            .jump_pressed = self.input_manager.movementDown(.JUMP),
            .shoot_pressed = false,
            .aim_x = 0.0,
            .aim_y = 0.0,
        };

        if (self.input_manager.movementDown(.RIGHT)) {
            intent.movement_x += 1.0;
            intent.aim_x += 1.0;
        }

        if (self.input_manager.movementDown(.LEFT)) {
            intent.movement_x -= 1.0;
            intent.aim_x -= 1.0;
        }

        if (self.input_manager.actionPressed(.Shoot)) {
            intent.shoot_pressed = true;
        }

        if (self.input_manager.movementDown(.UP)) {
            intent.aim_y += 1.0;
        }

        if (self.input_manager.movementDown(.DOWN)) {
            intent.aim_y -= 1.0;
        }

        self.world.update(intent);
    }

    pub fn draw(self: *Self) void {
        self.world.draw();
    }

    pub fn deinit(self: *Self) void {
        self.world.deinit();
    }
};
