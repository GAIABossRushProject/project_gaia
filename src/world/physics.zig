const std = @import("std");
const raylib = @import("raylib");

pub const ActorPhysics = struct {
    position: raylib.Vector2,
    velocity: raylib.Vector2,
    solid_body: raylib.Rectangle,
    current_scale: f32,
    collider_scale_width: f32,
    collider_scale_height: f32,
    is_grounded: bool,
    is_jumping: bool,
    const Self = @This();

    pub fn init(x: f32, y: f32, base_w: f32, base_h: f32) Self {
        const pos = raylib.Vector2{
            .x = x,
            .y = y,
        };

        const vel = raylib.Vector2{
            .x = 300,
            .y = 300,
        };

        const body_scale: f32 = 1.0;

        const current_height = base_h * body_scale;
        const current_width = base_w * body_scale;

        const rec = raylib.Rectangle{
            .x = pos.x - (current_width / 2.0),
            .y = pos.y - current_height,
            .height = current_height,
            .width = current_width,
        };

        return Self{
            .position = pos,
            .velocity = vel,
            .is_grounded = true,
            .is_jumping = false,
            .solid_body = rec,
            .current_scale = body_scale,
            .collider_scale_width = base_w,
            .collider_scale_height = base_h,
        };
    }

    pub fn set_size(self: *Self, update_scale: f32) void {
        self.current_scale = update_scale;
        self.solid_body.height = self.collider_scale_height * self.current_scale;
        self.solid_body.width = self.collider_scale_width * self.current_scale;

        self.solid_body.x = self.position.x - (self.solid_body.width / 2.0);
        self.solid_body.y = self.position.y - self.solid_body.height;
    }

    pub fn draw_body(self: *Self) void {
        raylib.drawRectangleRec(self.solid_body, .lime);
    }
};
