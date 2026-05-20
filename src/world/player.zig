const std = @import("std");
const animation = @import("animation.zig");
const asset_manager = @import("../game/asset_manager.zig");
const spine = @import("../lib/spine.zig");
const raylib = @import("raylib");
const types = @import("types.zig");

const MovementState = enum {
    IDLE,
    RUN_RIGHT,
    RUN_LEFT,
    // JUMP,
};

const ActionState = enum {
    NONE,
    SHOOT,
    CHARGE,
};

pub const Player = struct {
    animateState: animation.Animate,
    action_state: ActionState,
    movement_state: MovementState,
    position: raylib.Vector2,
    const Self = @This();

    pub fn init(blueprint: asset_manager.SpineBlueprint, position: raylib.Vector2) !Self {
        var ans = try animation.Animate.init(blueprint);

        ans.set_scale(0.25, -0.25);
        return Self{
            .animateState = ans,
            .position = position,
            .movement_state = .IDLE,
            .action_state = .NONE,
        };
    }

    pub fn update(self: *Self, player_intent: types.PlayerIntent, dt: f32) void {
        self.position.x += player_intent.movement_x * dt;

        if (player_intent.movement_x > 0) {
            self.movement_state = .RUN_RIGHT;
        } else if (player_intent.movement_x < 0) {
            self.movement_state = .RUN_LEFT;
        } else self.movement_state = .IDLE;

        switch (self.movement_state) {
            .IDLE => {
                self.animateState.set_lower_body("idle", self.position, false, true);
            },
            .RUN_RIGHT => {
                self.animateState.set_lower_body("run", self.position, false, true);
            },
            .RUN_LEFT => {
                self.animateState.set_lower_body("run", self.position, true, true);
            },
        }

        self.animateState.ticker();

        self.animateState.sync_player_visuals(self.position);
    }

    pub fn draw(self: *Self) void {
        self.animateState.draw();
    }

    pub fn deinit(self: *Self) void {
        self.animateState.deinit();
    }
};

fn get_movement() MovementState {
    if (!raylib.isKeyDown(.a) and
        !raylib.isKeyDown(.d) and
        !raylib.isKeyDown(.left) and
        !raylib.isKeyDown(.right) and
        !raylib.isKeyDown(.space))
    {
        return .IDLE;
    }
}
