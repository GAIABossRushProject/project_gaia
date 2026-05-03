const std = @import("std");
const spine = @import("../lib/spine.zig");
const raylib = @import("raylib");
const app_allocator = @import("../world/allocators.zig");

pub const SpineBlueprint = struct {
    atlas: [*c]spine.spAtlas,
    skeleton_data: [*c]spine.spSkeletonData,
    animation_state_data: [*c]spine.spAnimationStateData,
};

pub const AssetManager = struct {
    asset_map: std.StringHashMap(SpineBlueprint),
    const Self = @This();

    pub fn init(allocator: std.mem.Allocator) Self {
        const map = std.StringHashMap(SpineBlueprint).init(allocator);

        return Self{
            .asset_map = map,
        };
    }

    pub fn load_asset(self: *Self, asset_name: []const u8, atlas_path: [*c]const u8, skeleton_path: [*c]const u8) !void {
        const sam_atlas = spine.spAtlas_createFromFile(atlas_path, null);
        const sam_skeleton = spine.spSkeletonJson_readSkeletonDataFile(skeleton_path);
        const sam_animation_state_data = spine.spAnimationStateData_create(sam_skeleton);

        const blueprint = SpineBlueprint{
            .atlas = sam_atlas,
            .skeleton_data = sam_skeleton,
            .animation_state_data = sam_animation_state_data,
        };

        try self.asset_map.put(asset_name, blueprint);
    }

    pub fn get_blueprint(self: *Self, asset: []const u8) ?SpineBlueprint {
        return self.asset_map.get(asset);
    }

    pub fn deinit(self: *Self) void {
        var asset_iterator = self.asset_map.valueIterator();

        while (asset_iterator.next()) |entry| {
            spine.spAtlas_dispose(entry.atlas);
            spine.spAnimationStateData_dispose(entry.animation_state_data);
            spine.spSkeletonData_dispose(entry.skeleton_data);
        }

        self.asset_map.deinit();
    }
};

pub export fn _spAtlasPage_disposeTexture(atlas: [*c]spine.spAtlasPage) void {
    const texturePtr: *raylib.Texture2D = @ptrCast(@alignCast(atlas.*.rendererObject));

    raylib.unloadTexture(texturePtr.*);

    const alloc = app_allocator.get();

    alloc.destroy(texturePtr);
}

pub export fn _spAtlasPage_createTexture(atlas: [*c]spine.spAtlasPage, path: [*c]const u8) void {
    const allocator = app_allocator.get();

    const texture_alloc = allocator.create(raylib.Texture) catch |err| {
        std.debug.print("error allocating raylib texture {any}", .{err});
        @panic("cannot load texture, bailing");
    };

    const zig_path = std.mem.span(path);
    const texture_value = raylib.loadTexture(zig_path) catch |err| {
        std.debug.panic("error loading texture {any}", .{err});
    };
    std.debug.print("Loaded texture: id={d}, width={d}, height={d}, path={s}\n", .{ texture_value.id, texture_value.width, texture_value.height, zig_path });

    texture_alloc.* = texture_value;

    atlas.*.rendererObject = texture_alloc;
}

pub export fn _spUtil_readFile(path: [*c]const u8, length: [*]c_int) [*c]u8 {
    const skel_path = std.mem.span(path);

    var io = std.Io.Threaded.init(std.heap.c_allocator, .{});
    defer io.deinit();

    const skeleton_file = std.Io.Dir.cwd().readFileAlloc(
        io.io(),
        skel_path,
        std.heap.c_allocator,
        .unlimited,
    ) catch |err| {
        std.debug.print("file return error due to {any}\n", .{err});
        length[0] = 0;
        return null;
    };

    length[0] = @intCast(skeleton_file.len);

    return skeleton_file.ptr;
}
