Entity = Object:extend()

Vector = require "Libraries.hump.vector"

function Entity:new(image, x, y)
    self.position = Vector(x, y)
    self.rotation = 0
    self.image = image
    self.visible = true
    self.physics = nil
end

function Entity:update(dt)

end

function Entity:draw()
    if self.visible == true then
        love.graphics.draw(self.image, self.position.x, self.position.y, self.rotation)
    end
end

function Entity:SetPosition(position)
    self.position = position
end

function Entity:GetPosition()
    return(self.position)
end

function Entity:SetRotation(rotation)
    self.rotation = rotation % (2 * math.pi)
end

function Entity:GetRotation()
    return(self.rotation)
end

function Entity:SetVisibile(visible)
    self.visible = visible
end

function Entity:IsVisible()
    return(self.visible)
end

function Entity:HasPhysics()
    return(self.physics ~= nil)
end