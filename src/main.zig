const std = @import("std");
const raylib = @import("raylib");

pub fn main() !void {
    raylib.setTargetFPS(60);

    raylib.initWindow(800, 600, "gaia: echoes of Genesis");

    while (!raylib.windowShouldClose()) {
        raylib.beginDrawing();

        defer raylib.endDrawing();

        raylib.clearBackground(.blue);
        raylib.drawText("Hello World from Gaia", 100, 300, 60, .ray_white);
    }
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
}
