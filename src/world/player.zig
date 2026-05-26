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
    // CHARGE,
};

pub const Player = struct {
    animateState: animation.Animate,
    action_state: ActionState,
    movement_state: MovementState,
    position: raylib.Vector2,
    is_left: bool,
    const Self = @This();

    pub fn init(blueprint: asset_manager.SpineBlueprint, position: raylib.Vector2) !Self {
        var ans = try animation.Animate.init(blueprint);

        ans.set_scale(0.25, -0.25);
        return Self{
            .animateState = ans,
            .position = position,
            .movement_state = .IDLE,
            .action_state = .NONE,
            .is_left = false,
        };
    }

    pub fn update(self: *Self, player_intent: types.PlayerIntent, dt: f32) void {
        self.position.x += player_intent.movement_x * dt;

        if (player_intent.movement_x > 0) {
            self.movement_state = .RUN_RIGHT;
            self.is_left = false;
        } else if (player_intent.movement_x < 0) {
            self.movement_state = .RUN_LEFT;
            self.is_left = true;
        } else self.movement_state = .IDLE;

        switch (self.movement_state) {
            .IDLE => {
                self.animateState.set_lower_body("idle", self.position, self.is_left, true);
            },
            .RUN_RIGHT => {
                self.position.x += 4;
                self.animateState.set_lower_body("run", self.position, self.is_left, true);
            },
            .RUN_LEFT => {
                self.position.x -= 4;
                self.animateState.set_lower_body("run", self.position, self.is_left, true);
            },
        }

        if (player_intent.shoot_pressed) {
            self.action_state = .SHOOT;
        } else {
            self.action_state = .NONE;
        }

        switch (self.action_state) {
            .NONE => {
                self.animateState.set_empty();
            },
            .SHOOT => {
                const aim = calculate_aim_vect(player_intent.aim_x, player_intent.aim_y, self.is_left);
                self.animateState.set_upper_body(self.position, "aim", true, aim);
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

pub fn calculate_aim_vect(x: f32, y: f32, is_left: bool) raylib.Vector2 {
    var dir_x = x;
    const dir_y = y;

    if (dir_x == 0.0 and dir_y == 0.0) {
        dir_x = if (is_left) -1.0 else 1.0;
    }
    const length = std.math.sqrt((dir_x * dir_x) + (dir_y * dir_y));

    var norm_x: f32 = 0.0;
    var norm_y: f32 = 0.0;

    if (length > 0.0) {
        norm_x = dir_x / length;
        norm_y = dir_y / length;
    }

    const distance: f32 = 500;

    var final_x = norm_x * distance;
    var final_y = norm_y * distance;

    if (is_left) {
        final_x = -final_x;
    }

    const shoulder_height: f32 = 270.0;

    final_y += shoulder_height;

    return raylib.Vector2{
        .x = final_x,
        .y = final_y,
    };
}
