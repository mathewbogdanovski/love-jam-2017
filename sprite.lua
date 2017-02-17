--! file: sprite.lua
Sprite = Object:extend()

Vector = require "Libraries.hump.vector"

function Sprite:new(image, x, y, sx, sy)
	self.position = Vector(x, y)
	self.rotation = 0
	self.scale = Vector(sx, sy)
	self.image = image
end

function Sprite:update(dt)

end

function Sprite:draw()
    love.graphics.draw(self.image, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y)
end