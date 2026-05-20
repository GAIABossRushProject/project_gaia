const std = @import("std");
const raylib = @import("raylib");

const PlayerMovement = enum {
    RIGHT,
    LEFT,
    JUMP,
};

pub const InputManager = struct {
    key_bindings: [@typeInfo(PlayerMovement).@"enum".fields.len]?raylib.KeyboardKey,
    const Self = @This();

    pub fn init() Self {
        var manager = Self{
            .key_bindings = [_]?raylib.KeyboardKey{null} ** @typeInfo(PlayerMovement).@"enum".fields.len,
        };

        manager.bind(.RIGHT, .d);
        manager.bind(.LEFT, .a);
        manager.bind(.JUMP, .space);

        return manager;
    }

    pub fn bind(self: *Self, movement: PlayerMovement, key: raylib.KeyboardKey) void {
        self.key_bindings[@intFromEnum(movement)] = key;
    }

    pub fn movementDown(self: *Self, movement: PlayerMovement) bool {
        const bound_key = self.key_bindings[@intFromEnum(movement)];

        if (bound_key) |key| {
            return raylib.isKeyDown(key);
        }

        return false;
    }
};
