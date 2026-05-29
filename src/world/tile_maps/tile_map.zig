const std = @import("std");
const raylib = @import("raylib");

const level_errors = error{
    ErrorEmptyLevelData,
    TileNotFound,
};

pub const TiledData = struct {
    compressionlevel: i8,
    height: u8,
    infinite: bool,
    layers: []layers,
    nextlayerid: u8,
    nextobjectid: u8,
    orientation: []const u8,
    renderorder: []const u8,
    tiledversion: []const u8,
    tilesets: []tilesets,
    tileheight: u16,
    tilewidth: u16,
    version: []const u8,
    type: []const u8,
    width: u8,
};

pub const layers = struct {
    data: []i8,
    height: u8,
    id: u16,
    name: []const u8,
    type: []const u8,
    visible: bool,
    opacity: u8,
    width: u8,
    x: u8,
    y: u8,
};

pub const tilesets = struct {
    firstgid: u8,
    source: []const u8,
};

pub const TileSet = struct {
    columns: u32,
    grid: struct {
        height: u32,
        orientation: []const u8,
        width: u32,
    },
    margin: u32,
    name: []const u8,
    spaceing: u32,
    tiledversion: []const u8,
    tileheight: u32,
    tiles: []tiles,
    tilewidth: u32,
    type: []const u8,
    version: []const u8,
};

const tiles = struct {
    id: u32,
    image: []const u8,
    imageheight: u32,
    imagewidth: u32,
};

pub const TileMap = struct {
    tile_map_data: []u8,
    tileset_data: []u8,
    texture_map: TextureMap,
    allocator: std.mem.Allocator,
    tile_map_tmj: std.json.Parsed(TiledData),
    tileset_tmj: std.json.Parsed(TileSet),
    current_texture: ?raylib.Texture2D,
    texlure_hasmap: std.AutoHashMap(u8, raylib.Texture2D),
    const Self = @This();

    pub fn init(
        io: std.Io,
        allocator: std.mem.Allocator,
        tile_map_name: []const u8,
        tileset_name: []const u8,
    ) !Self {
        const tile_map_file = try std.Io.Dir.cwd().readFileAlloc(
            io,
            tile_map_name,
            allocator,
            .unlimited,
        );

        const tileset_file = try std.Io.Dir.cwd().readFileAlloc(
            io,
            tileset_name,
            allocator,
            .unlimited,
        );

        const parsed_tile_map = try std.json.parseFromSlice(
            TiledData,
            allocator,
            tile_map_file,
            .{ .ignore_unknown_fields = true },
        );

        const texture_map: TextureMap = TextureMap.init(allocator);

        return Self{
            .tile_map_data = tile_map_file,
            .tileset_data = tileset_file,
            .parsed_json = parsed_tile_map,
            .allocator = allocator,
            .texture_map = texture_map,
            .current_texture = null,
        };
    }

    pub fn render_map(self: *Self) !void {
        if (self.parsed_json.value.layers.len) {
            return error.ErrorEmptyLevelData;
        }

        const map_width = self.parsed_json.value.layers[0].width;
        const data = self.parsed_json.value.layers[0].data;
        const tile_width = self.parsed_json.value.tilewidth;
        const tile_height = self.parsed_json.value.tileheight;

        for (0..data.len) |index| {
            const grid_x = index % map_width;
            const grid_y = index / map_width;

            const pixel_x = grid_x * tile_width;
            const pixel_y = grid_y * tile_height;

            raylib.Vector2{
                .x = @as(f32, @floatFromInt(pixel_x)),
                .y = @as(f32, @floatFromInt(pixel_y)),
            };

            std.debug.print("pixel_x {d}", .{pixel_x});
            std.debug.print("pixel_y {d}", .{pixel_y});

            if (data[index] == 0) {
                continue;
            }
        }
    }

    pub fn deinit(self: *Self) void {
        self.allocator.free(self.tile_map_data);
        self.allocator.free(self.tileset_data);

        self.tile_map_tmj.deinit();
        self.tileset_tmj.deinit();
    }
};

pub const TextureMap = struct {
    map: std.AutoHashMap(u8, raylib.Texture2D),
    allocator: std.mem.Allocator,
    const Self = @This();

    pub fn init(allocator: std.mem.Allocator) Self {
        const level_map = std.AutoHashMap(u8, raylib.Texture2D).init(allocator);

        return Self{
            .map = level_map,
            .allocator = allocator,
        };
    }

    pub fn put_level_texture(self: *Self, key: u8, path: []const u8) !void {
        const texture = try raylib.loadTexture(path);
        try self.map.put(key, texture);
    }

    pub fn get_texture_by_texture(self: *Self, key: u8) ?raylib.Texture2D {
        return self.map.get(key);
    }

    pub fn deinit(self: *Self) void {
        defer self.map.deinit();
        var iter = self.map.valueIterator();

        for (iter.next()) |texture| {
            self.allocator.free(texture);
        }
    }
};

test "test tile map" {
    const io = std.testing.io;
    const allocator = std.testing.allocator;

    var tm = try TileMap.init(
        io,
        allocator,
        "levels/demo_map.tmj",
        "levels/industrial.tsj",
    );

    try tm.render_map();

    defer tm.deinit();
}
