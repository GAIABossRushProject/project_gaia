const std = @import("std");
const raylib = @import("raylib");

pub const TitleScreen = struct {
    should_draw_text: bool,
    timer: f32,
    delay: f32,
    display_cooldown: f32,
    threshold: u8,
    is_exit: bool,

    const Self = @This();

    pub fn init() Self {
        std.log.info("loading title screen", .{});

        return Self{
            .should_draw_text = false,
            .delay = 2.0,
            .timer = 0.0,
            .display_cooldown = 2.0,
            .threshold = 0,
            .is_exit = false,
        };
    }

    pub fn update(self: *Self) void {
        if (!self.should_draw_text) {
            self.timer += raylib.getFrameTime();
            if (self.timer >= self.delay) {
                std.log.info("time is set to {d}", .{self.timer});
                self.should_draw_text = true;
                self.timer = 0.0;
            }
        } else {
            std.log.info("am I set to true now and about to set to false", .{});
            self.timer += raylib.getFrameTime();

            if (self.timer >= self.display_cooldown) {
                self.should_draw_text = false;
                self.timer = 0.0;
            }
        }

        if (raylib.isKeyDown(.space)) {
            self.is_exit = true;
        }
    }

    pub fn draw(self: *Self) void {
        if (self.should_draw_text) {
            raylib.drawText("Insert Coins(s)", 300, 300, 20, .ray_white);
        }
        raylib.drawText("GAIA: Echoes of Genesis", 200, 200, 30, .ray_white);
    }

    pub fn exit(self: *Self) bool {
        return self.is_exit;
    }

    pub fn deinit(self: *Self) void {
        _ = self;
        std.debug.print("exiting title screen...", .{});
    }
};
