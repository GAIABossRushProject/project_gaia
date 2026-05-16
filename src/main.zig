const std = @import("std");
const raylib = @import("raylib");
const spine = @import("lib/spine.zig");
const player = @import("world/player.zig");
const menu = @import("game/scenes/menu.zig");
const animation = @import("world/animation.zig");
const demo = @import("game/scenes/demo.zig");
// const allocator = @import("world/allocators.zig");
const game_ctx = @import("game/game_ctx.zig");
const settings = @import("game/settings_manager.zig");
const world = @import("world/world.zig");

pub fn main(init: std.process.Init) !void {
    const cli_args = try init.minimal.args.toSlice(init.arena.allocator());

    std.debug.print("the 0th arg is {s}\n", .{cli_args[1]});

    const sam_atlas = @embedFile("sprite-sheet/spineboy/export/spineboy-pma.atlas");
    const sam_json = @embedFile("sprite-sheet/spineboy/export/spineboy-pro.json");

    const c_sam_atlas = try init.gpa.dupeZ(u8, sam_atlas);
    defer init.gpa.free(c_sam_atlas);

    const c_sam_json = try init.gpa.dupeZ(u8, sam_json);
    defer init.gpa.free(c_sam_json);

    var bootstrap: game_ctx.Bootstrap = .{
        .io = init.io,
        .allocator = init.gpa,
        .settings_path = cli_args[1],
        .sam_atlas_path = c_sam_atlas,
        .sam_skeleton_path = c_sam_json,
    };

    std.log.info("value in bootstramp {any}", .{bootstrap});

    var ctx = try game_ctx.GameContext.init(&bootstrap);

    try ctx.run();

    defer ctx.deinit();
}
