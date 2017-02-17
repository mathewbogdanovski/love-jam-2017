--! file: entity.lua
Entity = Sprite:extend()

Vector = require "Libraries.hump.vector"

function Entity:new(image, x, y)
	Entity.super.new(self, image, x, y)
end

function Entity:update(dt)
	Entity.super.update(dt)
end