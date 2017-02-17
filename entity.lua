--! file: entity.lua
Entity = Sprite:extend()

Vector = require "Libraries.hump.vector"

function Entity:new(x, y, w, h, s)
	Entity.super.new(self, x, y, w, h)
    self.speed = s
    self.direction = Vector(1, 0)
end

function Entity:update(dt)
	Entity.super.update(dt)
    self.position = self.position + (self.direction * self.speed * dt)
end