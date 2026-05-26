const std = @import("std");
const raylib = @import("raylib");

const texture_errors = error{
    ErrorTextureNotFound,
};

pub const levelDemo = [5][5]i8{
    [_]i8{ -1, -1, -1, -1, -1 },
    [_]i8{ -1, -1, -1, -1, -1 },
    [_]i8{ -1, -1, -1, -1, -1 },
    [_]i8{ -1, -1, -1, -1, -1 },
    [_]i8{ -1, -1, -1, -1, -1 },
};

pub const  TextureMap = struct {
    textureMap: std.AutoHashMap([]const u8, raylib.Texture2D),
    allocator: std.mem.Allocator, 
    const Self = @This();

    pub fn init(allocator: std.mem.Allocator) Self{

        const tmap = std.AutoHashMap([]const u8, raylib.Texture2D).init(allocator);

        return Self{
            .textureMap = tmap,
            .allocator = allocator, 
        };

    }

    pub fn set(self: *Self, key: []const u8,  value: raylib.Texture2D) !void{

        try self.textureMap.put(key, value);
    }

    pub fn get(self: *Self, key: []const u8) ?raylib.Texture2D{

        return self.textureMap.get(key);
    }

    pub fn deinit(self: *Self) void{

        var iter = self.textureMap.valueIterator();

        for (iter.next()) |texture| {
            self.allocator.destroy(texture);
        }
        
        self.textureMap.deinit();
    }
};

const levels = union(enum) {
    demo: levelDemo,
};

pub fn select_level(level: levels) void {
    switch (level) {
        .demo => |l|{

            draw_tilemamp(l);
        } 
    }
}

pub fn draw_tilemamp(map: TextureMap,  data: [5][5]i8) void {
    for (0..5) |row| {
        for (0..5) |col| {
            const current_tile_id = data[row][col];

            if (current_tile_id == -1) {
                continue;
            }

            var current_texture: raylib.Texture2D = undefined;

            if (current_tile_id == 0){

            }


            raylib.drawTextureEx(texture: Texture, position: Vector2, rotation: f32, scale: f32, tint: Color)
        }
    
    }
}
