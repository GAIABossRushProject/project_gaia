const std = @import("std");
const title = @import("scenes/title.zig");
const menu = @import("scenes/menu.zig");
const demo = @import("scenes/demo.zig");
const game_ctx = @import("game_ctx.zig");
// const vexia = @import("vexia/phase1.zig");
// const menu = @import("menu.zig");
// const game_over = @import("game_over.zig");
// const aim_demo = @import("aim_testing.zig");

pub const SceneUnion = union(enum) {
    title_scene: title.TitleScreen,
    menu_scene: menu.MenuScene,
    demo_scene: demo.DemoScene,
    // vexia_phase1: vexia.VexiaPhase1,
    // game_over: game_over.GameOver,
    // aim_test: aim_demo.AimTest,
};

pub const SceneManager = struct {
    current_scene: SceneUnion,

    const Self = @This();

    pub fn init(ctx: *game_ctx.GameContext) Self {
        return Self{
            .current_scene = .{ .title_scene = title.TitleScreen.init(ctx) },
        };
    }

    pub fn update(self: *Self, ctx: *game_ctx.GameContext) !void {
        switch (self.current_scene) {
            .title_scene => |*scene| {
                scene.update();
                if (scene.exit()) {
                    std.debug.print("exit has been reached\n", .{});
                    scene.deinit();
                    self.current_scene = .{ .menu_scene = menu.MenuScene.init() };
                }
            },
            .menu_scene => |*scene| {
                scene.update();

                if (scene.items == .Demo) {
                    const d = try demo.DemoScene.init(ctx);
                    self.current_scene = .{
                        .demo_scene = d,
                    };
                }
            },
            .demo_scene => |*scene| {
                scene.update();
            },
        }
        //     .test_scene => |*scene| {
        //         scene.update();
        //
        //         if (scene.player.dead) {
        //             scene.deinit();
        //
        //             const go = game_over.GameOver.init();
        //
        //             self.current_scene = .{ .game_over = go };
        //         }
        //     },
        //     .menu_scene => |*scene| {
        //         if (scene.get_state() == .ItemDemo) {
        //             const d = try demo.DemoScene.init();
        //             self.current_scene = .{ .test_scene = d };
        //         }
        //
        //         if (scene.get_state() == .ItemPhase1) {
        //             self.current_scene = .{ .vexia_phase1 = vexia.VexiaPhase1.init() };
        //         }
        //
        //         if (scene.get_state() == .ItemAimDemo) {
        //             const at = try aim_demo.AimTest.init();
        //             self.current_scene = .{ .aim_test = at };
        //         }
        //         scene.update();
        //     },
        //     .vexia_phase1 => |*scene| {
        //         scene.update();
        //
        //         if (scene.sam.dead) {
        //             scene.deinit();
        //
        //             const go = game_over.GameOver.init();
        //
        //             self.current_scene = .{ .game_over = go };
        //         }
        //     },
        //     .game_over => |*scene| {
        //         scene.update();
        //     },
        //     .aim_test => |*scene| {
        //         scene.update();
        //     },
        // }
    }

    pub fn draw(self: *Self) !void {
        switch (self.current_scene) {
            .title_scene => |*scene| {
                scene.draw();
            },
            .menu_scene => |*scene| {
                scene.draw();
            },
            .demo_scene => |*scene| {
                scene.draw();
            },
            // .vexia_phase1 => |*scene| {
            //     try scene.draw();
            // },
            // .game_over => |*scene| {
            //     scene.draw();
            // },
            // .aim_test => |*scene| {
            //     scene.update();
            // },
        }
    }

    pub fn deinit(self: *Self) void {
        std.debug.print("scene during destruction {}\n", .{self.current_scene});
        switch (self.current_scene) {
            .title_scene => |*scene| {
                scene.deinit();
            },
            .menu_scene => |*scene| {
                scene.deinit();
            },
            .demo_scene => |*scene| {
                scene.deinit();
            },
            // .vexia_phase1 => |*scene| {
            //     scene.deinit();
            // },
            // .menu_scene => |*scene| {
            //     scene.deinit();
            // },
            // .game_over => |*scene| {
            //     scene.deinit();
            // },
            // .aim_test => |*scene| {
            //     scene.deinit();
            // },
        }
    }
};
