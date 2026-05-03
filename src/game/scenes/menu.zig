const std = @import("std");
const raylib = @import("raylib");

pub const MenuItems = enum {
    None,
    Demo,
    Test,
};

const total_items: u8 = 2;

pub const MenuScene = struct {
    items: MenuItems,
    cursor: Cursor,
    demoBox: raylib.Rectangle,
    selected_index: u8,
    aimBox: raylib.Rectangle,
    const Self = @This();

    pub fn init() Self {
        const demoBox = raylib.Rectangle{
            .x = 100,
            .y = 100,
            .height = 60,
            .width = 400,
        };

        const aimBox = raylib.Rectangle{
            .x = 100,
            .y = 200,
            .height = 60,
            .width = 400,
        };

        const cursor = Cursor.init();
        return Self{
            .selected_index = 1,
            .items = .None,
            .cursor = cursor,
            .demoBox = demoBox,
            .aimBox = aimBox,
        };
    }

    pub fn update(self: *Self) void {
        self.cursor.update();

        std.debug.print("current menu status is {}\n", .{self.items});

        if (self.cursor.selected_index == 1 and raylib.isKeyPressed(.enter)) {
            self.items = .Demo;

            std.debug.print("scene switched to demo\n", .{});
        }

        if (self.cursor.selected_index == 2 and raylib.isKeyPressed(.enter)) {
            self.items = .Test;

            std.debug.print("scene switched to test\n", .{});
        }
    }

    pub fn draw(self: *Self) void {
        if (self.items == .Demo) {
            raylib.drawRectangleRec(self.demoBox, .white);
            raylib.drawText(
                "Demo Scene",
                @as(i32, @intFromFloat(self.demoBox.x + 20)),
                @as(i32, @intFromFloat(self.demoBox.y)),
                30,
                .red,
            );
        } else {
            raylib.drawRectangleRec(self.demoBox, .white);
            raylib.drawText(
                "Demo Scene",
                @as(i32, @as(i32, @intFromFloat(self.demoBox.x + 20))),
                @as(i32, @as(i32, @intFromFloat(self.demoBox.y))),
                30,
                .blue,
            );
        }

        if (self.items == .Test) {
            raylib.drawRectangleRec(self.aimBox, .white);
            raylib.drawText(
                "Test Scene",
                @as(i32, @intFromFloat(self.aimBox.x + 20)),
                @as(i32, @intFromFloat(self.aimBox.y)),
                30,
                .red,
            );
        } else {
            raylib.drawRectangleRec(self.aimBox, .sky_blue);
            raylib.drawText(
                "Test Scene",
                @as(i32, @as(i32, @intFromFloat(self.aimBox.x + 20))),
                @as(i32, @as(i32, @intFromFloat(self.aimBox.y))),
                30,
                .blue,
            );
        }

        // raylib.drawRectangleRec(self.aimBox, .white);
        self.cursor.draw();
    }

    pub fn deinit(self: *Self) void {
        _ = self;
        std.log.info("destroying scene", .{});
    }
};

const Cursor = struct {
    position: raylib.Vector2,
    selected_index: u8,

    fn init() Cursor {
        const pos = raylib.Vector2{
            .x = 20,
            .y = 120,
        };

        return Cursor{
            .position = pos,
            .selected_index = 0,
        };
    }

    fn update(self: *Cursor) void {
        if (raylib.isKeyPressed(.down)) {
            self.position.y += 100;
            self.selected_index += 1;

            std.debug.print("am I updating my index?\n", .{});

            if (self.selected_index > total_items) {
                self.selected_index = 1;
                self.position.y = 120;
            }
        }

        if (raylib.isKeyPressed(.up)) {
            self.position.y -= 100;
            self.selected_index -= 1;

            if (self.selected_index < 1) {
                self.selected_index = 1;
                self.position.y = 120;
            }
        }
    }

    fn draw(self: *Cursor) void {
        raylib.drawPoly(
            raylib.Vector2{
                .y = self.position.y,
                .x = 60,
            },
            3,
            40,
            90,
            .blue,
        );
    }
};
