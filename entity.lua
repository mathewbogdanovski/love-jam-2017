--! file: entity.lua
Entity = Sprite:extend()

Vector = require "Libraries.hump.vector"

function Entity:new(image, x, y, sx, sy, s)
	Entity.super.new(self, image, x, y, sx, sy)
    self.speed = s
    self.direction = Vector(1, 0)
end

function Entity:update(dt)
	Entity.super.update(dt)
    self.position = self.position + (self.direction * self.speed * dt)
end

function Entity:SetSpeed(speed)
	self.speed = speed
end

function Entity:SetDirection(direction)
	self.direction = direction
end