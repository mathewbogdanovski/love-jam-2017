Entity = Object:extend()

Vector = require "Libraries.hump.vector"

function Entity:new(image, x, y)
    self.position = Vector(x, y)
    self.rotation = 0
    self.imageScale = Vector(1.0, 1.0)
    self.image = image
    self.visible = true
    self.physics = nil
end

function Entity:update(dt)
    if(self.physics ~= nil) then
        self.position.x = self.physics.body:getX()
        self.position.y = self.physics.body:getY()
        self.rotation = self.physics.body:getAngle()
    end
end

function Entity:draw()
    if self.visible == true then
        love.graphics.draw(self.image, self.position.x, self.position.y, self.rotation, self.imageScale.x, self.imageScale.y)
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

function Entity:CreatePhysics(w, h, type)
    self.physics = {}
    self.physics.body = love.physics.newBody(physicsWorld, self.position.x, self.position.y, type) -- types: "dynamic" "kinematic" "static" 
    self.physics.shape = love.physics.newRectangleShape(0, 0, w, h)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 1)

    self.imageScale.x = w  / self.image:getWidth()
    self.imageScale.y = h / self.image:getHeight()
end

function Entity:HasPhysics()
    return(self.physics ~= nil)
end