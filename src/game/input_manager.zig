const std = @import("std");
const raylib = @import("raylib");

const PlayerMovement = enum {
    RIGHT,
    LEFT,
    UP,
    DOWN,
    JUMP,
};

const Combat = enum { Shoot, Charge_Shoot };

const TitleScreen = enum {
    Confirm,
};

pub const InputManager = struct {
    key_bindings: [@typeInfo(PlayerMovement).@"enum".fields.len]?raylib.KeyboardKey,
    confirm_binding: [@typeInfo(TitleScreen).@"enum".fields.len]?raylib.KeyboardKey,
    action_binding: [@typeInfo(Combat).@"enum".fields.len]?raylib.KeyboardKey,
    const Self = @This();

    pub fn init() Self {
        var manager = Self{
            .key_bindings = [_]?raylib.KeyboardKey{null} ** @typeInfo(PlayerMovement).@"enum".fields.len,
            .confirm_binding = [_]?raylib.KeyboardKey{null} ** @typeInfo(TitleScreen).@"enum".fields.len,
            .action_binding = [_]?raylib.KeyboardKey{null} ** @typeInfo(Combat).@"enum".fields.len,
        };

        manager.bind(.RIGHT, .d);
        manager.bind(.LEFT, .a);
        manager.bind(.JUMP, .space);
        manager.bind(.UP, .w);
        manager.bind(.DOWN, .s);
        manager.bind_confirm(.Confirm, .space);
        manager.bind_combat(.Shoot, .g);

        return manager;
    }

    pub fn bind(self: *Self, movement: PlayerMovement, key: raylib.KeyboardKey) void {
        self.key_bindings[@intFromEnum(movement)] = key;
    }

    pub fn bind_confirm(self: *Self, confirm: TitleScreen, key: raylib.KeyboardKey) void {
        self.confirm_binding[@intFromEnum(confirm)] = key;
    }

    pub fn bind_combat(self: *Self, combat: Combat, key: raylib.KeyboardKey) void {
        self.action_binding[@intFromEnum(combat)] = key;
    }

    pub fn confirmDown(self: *Self, confirm: TitleScreen) bool {
        const bounded = self.confirm_binding[@intFromEnum(confirm)];

        if (bounded) |key| {
            return raylib.isKeyDown(key);
        }

        return false;
    }

    pub fn movementDown(self: *Self, movement: PlayerMovement) bool {
        const bound_key = self.key_bindings[@intFromEnum(movement)];

        if (bound_key) |key| {
            return raylib.isKeyDown(key);
        }

        return false;
    }

    pub fn actionPressed(self: *Self, combat: Combat) bool {
        const bound_key = self.action_binding[@intFromEnum(combat)];
        if (bound_key) |key| {
            return raylib.isKeyPressed(key);
        }

        return false;
    }
};
