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
const input = @import("game/input_manager.zig");
const tile_maps = @import("world/tile_maps/tile_map.zig");

pub fn main(init: std.process.Init) !void {
    const cli_args = try init.minimal.args.toSlice(init.arena.allocator());

    const sam_atlas: [*c]const u8 = "sprite-sheet/spineboy/export/spineboy-pma.atlas";
    const sam_json: [*c]const u8 = "sprite-sheet/spineboy/export/spineboy-pro.json";

    var bootstrap: game_ctx.Bootstrap = .{
        .io = init.io,
        .allocator = init.gpa,
        .settings_path = cli_args[1],
        .sam_atlas_path = sam_atlas,
        .sam_skeleton_path = sam_json,
    };

    var ctx = try game_ctx.GameContext.init(&bootstrap);

    try ctx.run();

    defer ctx.deinit();
}
