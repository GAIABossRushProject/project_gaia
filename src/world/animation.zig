const std = @import("std");
const raylib = @import("raylib");
const spine = @import("../lib/spine.zig");
const app_allocator = @import("allocators.zig");
const rlgl = raylib.gl;
const physics = @import("physics.zig");
const asset_mananger = @import("../game/asset_manager.zig");
//
pub const Animate = struct {
    animationState: [*c]spine.spAnimationState,
    animationStateData: [*c]spine.spAnimationStateData,
    skeleton_data: [*c]spine.spSkeletonData,
    current_animation: [*c]const u8,
    physics: physics.ActorPhysics,
    aim_vec: raylib.Vector2,
    current_scale: f32,

    const Self = @This();

    pub fn init(blueprint: asset_mananger.SpineBlueprint) !Self {
        const skeleton = spine.spSkeleton_create(blueprint.skeleton_data);
        const animationStateData = spine.spAnimationStateData_create(skeleton);
        const animationState = spine.spAnimationState_create(animationStateData);

        skeleton.*.scaleY = -0.25;
        skeleton.*.scaleX = 0.25;

        const scale = 0.25;

        // spine.spSkeletonJson_dispose(parser);

        return Self{
            // .physics = p.*,
            .animationState = animationState,
            .skeleton = skeleton,
            .current_animation = "default",
            .animationStateData = animationStateData,
            .current_scale = scale,
            .aim_vec = raylib.Vector2{
                .x = 0,
                .y = 0,
            },
        };
    }
    //
    pub fn set_scale(self: *Self, scale_x: f32, scale_y: f32) void {
        self.skeleton.*.scaleX = scale_x;
        self.skeleton.*.scaleY = scale_y;

        self.current_scale = scale_x;
    }

    pub fn update(self: *Self, position: raylib.Vector2, desired_animation: [*c]const u8, is_left: bool, adjustment: f32) void {
        sync_player_visuals(self, position, adjustment);
        advance_animation(self, desired_animation, is_left);
    }

    pub fn sync_player_visuals(self: *Self, positon: raylib.Vector2, adjustment: f32) void {
        _ = adjustment;
        self.skeleton.*.x = positon.x;
        self.skeleton.*.y = positon.y;
    }

    pub fn advance_animation(self: *Self, desired_animation: [*c]const u8, is_left: bool) void {
        if (is_left) {
            self.skeleton.*.scaleX = -self.current_scale;
        } else {
            self.skeleton.*.scaleX = self.current_scale;
        }

        const z_desire: []const u8 = std.mem.span(desired_animation);
        const z_current: []const u8 = std.mem.span(self.current_animation);
        if (!std.mem.eql(u8, z_desire, z_current)) {
            self.current_animation = desired_animation;

            const curret_animation = std.mem.span(self.current_animation);

            if (std.mem.eql(u8, curret_animation, "jump") or
                std.mem.eql(u8, curret_animation, "hit") or
                std.mem.eql(u8, curret_animation, "death"))
            {
                _ = spine.spAnimationState_setAnimationByName(self.animationState, 0, desired_animation, 0);
            } else {
                _ = spine.spAnimationState_setAnimationByName(self.animationState, 0, desired_animation, 1);
            }
        }
        spine.spAnimationState_update(self.animationState, raylib.getFrameTime());
    }

    pub fn update_upper_body(
        self: *Self,
        position: raylib.Vector2,
        desired_animation: [*c]const u8,
        aim_vec: raylib.Vector2,
        adjustment: f32,
        loop: bool,
    ) void {
        self.sync_player_visuals(
            position,
            adjustment,
        );
        const loop_int: c_int = if (loop) 0 else 1;

        _ = spine.spAnimationState_setAnimationByName(self.animationState, 1, desired_animation, loop_int);

        self.aim_vec = aim_vec;
    }

    pub fn draw(self: *Self) void {
        // rlgl.rlDisableScissorTest();
        // const bone = spine.spSkeleton_findBone(self.skeleton, "hip");
        // const aim = spine.spSkeleton_findBone(self.skeleton, "crosshair");
        //
        _ = spine.spAnimationState_apply(self.animationState, self.skeleton);

        // if (bone != null) {
        //     bone.*.x = 0;
        //     bone.*.y = bone.*.data.*.y;
        // }
        //
        // if (aim != null) {
        //     aim.*.x = self.aim_vec.x;
        //     aim.*.y = self.aim_vec.y;
        // }

        spine.spSkeleton_updateWorldTransform(self.skeleton, spine.SP_PHYSICS_UPDATE);
        rlgl.rlDisableBackfaceCulling();
        const bm = rlgl.rlBlendMode;
        rlgl.rlSetBlendMode(@intFromEnum(bm.rl_blend_alpha_premultiply));
        var i: u8 = 0;
        while (i < self.skeleton.*.slotsCount) {
            const attachment = self.skeleton.*.drawOrder[i].*.attachment;
            const slot = self.skeleton.*.drawOrder[i];

            if (attachment == null) {
                i += 1;
                continue;
            }

            if (attachment.*.type == spine.SP_ATTACHMENT_REGION) {
                const regionAttacment: [*c]spine.spRegionAttachment = @ptrCast(attachment);

                var vertices: [8]f32 = undefined;

                spine.spRegionAttachment_computeWorldVertices(
                    regionAttacment,
                    slot,
                    &vertices,
                    0,
                    2,
                );

                const atlasRegion: [*c]spine.spAtlasRegion = @ptrCast(@alignCast(regionAttacment.*.rendererObject));

                const page = atlasRegion.*.page;
                const rlTexture = page.*.rendererObject;

                const texture: *raylib.Texture2D = @ptrCast(@alignCast(rlTexture));

                rlgl.rlSetTexture(texture.id);

                rlgl.rlBegin(rlgl.rl_quads);

                rlgl.rlColor4ub(
                    @intFromFloat(slot.*.color.r * 255.0),
                    @intFromFloat(slot.*.color.g * 255.0),
                    @intFromFloat(slot.*.color.b * 255.0),
                    @intFromFloat(slot.*.color.a * 255.0),
                );

                rlgl.rlTexCoord2f(regionAttacment.*.uvs[0], regionAttacment.*.uvs[1]);
                rlgl.rlVertex2f(vertices[0], vertices[1]);

                rlgl.rlTexCoord2f(regionAttacment.*.uvs[2], regionAttacment.*.uvs[3]);
                rlgl.rlVertex2f(vertices[2], vertices[3]);
                rlgl.rlTexCoord2f(regionAttacment.*.uvs[4], regionAttacment.*.uvs[5]);
                rlgl.rlVertex2f(vertices[4], vertices[5]);
                rlgl.rlTexCoord2f(regionAttacment.*.uvs[6], regionAttacment.*.uvs[7]);
                rlgl.rlVertex2f(vertices[6], vertices[7]);
                rlgl.rlEnd();
                rlgl.rlDrawRenderBatchActive();
            }

            if (attachment.*.type == spine.SP_ATTACHMENT_MESH) {
                var j: u32 = 0;
                const mesh: [*c]spine.spMeshAttachment = @ptrCast(attachment);
                const vertex_attachment: [*c]spine.spVertexAttachment = &mesh.*.super;

                var world_verticies: [2048]f32 = undefined;

                spine.spVertexAttachment_computeWorldVertices(
                    vertex_attachment,
                    slot,
                    0,
                    vertex_attachment.*.worldVerticesLength,
                    &world_verticies,
                    0,
                    2,
                );

                const region_attachment: [*c]spine.spAtlasRegion = @ptrCast(@alignCast(mesh.*.region));

                const page = region_attachment.*.page;
                const rlTexture = page.*.rendererObject;

                const texture: *raylib.Texture2D = @ptrCast(@alignCast(rlTexture));

                rlgl.rlSetTexture(texture.id);

                rlgl.rlBegin(rlgl.rl_quads);

                while (j < mesh.*.trianglesCount) {
                    rlgl.rlColor4ub(
                        @intFromFloat(slot.*.color.r * 255.0),
                        @intFromFloat(slot.*.color.g * 255.0),
                        @intFromFloat(slot.*.color.b * 255.0),
                        @intFromFloat(slot.*.color.a * 255.0),
                    );
                    const index: u16 = mesh.*.triangles[j];
                    const vertex_index: usize = @intCast(index * 2);

                    rlgl.rlTexCoord2f(mesh.*.uvs[vertex_index], mesh.*.uvs[vertex_index + 1]);
                    rlgl.rlVertex2f(
                        world_verticies[vertex_index],
                        world_verticies[vertex_index + 1],
                    );

                    j += 1;
                }
                rlgl.rlEnd();
                rlgl.rlDrawRenderBatchActive();
            }

            i += 1;
        }

        rlgl.rlSetBlendMode(@intFromEnum(bm.rl_blend_alpha));
        // rlgl.rlEnableBackfaceCulling();
    }

    pub fn deinit(self: *Self) void {
        spine.spAnimationState_dispose(self.animationState);
        spine.spSkeleton_dispose(self.skeleton);
        spine.spAnimationStateData_dispose(self.animationStateData);
        spine.spSkeletonData_dispose(self.skeleton_data);
        spine.spAtlas_dispose(self.atlas);
    }
};
