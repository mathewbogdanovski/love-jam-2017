--! file: sprite.lua
Sprite = Object:extend()

Vector = require "Libraries.hump.vector"

function Sprite:new(x, y, w, h)
	self.position = Vector(x, y)
	self.rotation = 0
	self.size = Vector(w, h)
end

function Sprite:update(dt)

end

function Sprite:draw()
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y)
end