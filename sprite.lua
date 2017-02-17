--! file: sprite.lua
Sprite = Object:extend()

Vector = require "Libraries.hump.vector"

function Sprite:new(image, x, y)
	self.position = Vector(x, y)
	self.rotation = 0
	self.image = image
end

function Sprite:update(dt)

end

function Sprite:draw()
    love.graphics.draw(self.image, self.position.x, self.position.y, self.rotation)
end

function Sprite:SetPosition(position)
	self.position = position
end

function Sprite:SetRotation(rotation)
	self.rotation = rotation
end