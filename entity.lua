Entity = Object:extend()

function Entity:new(image, x, y)
    self.position = Vector(x, y)
    self.rotation = 0
    self.image = image
    self.imageSize = Vector(self.image:getWidth(), self.image:getHeight())
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
        love.graphics.draw(self.image, self.position.x, self.position.y, self.rotation, self.imageSize.x / self.image:getWidth(), self.imageSize.y / self.image:getHeight(), self.imageSize.x / 2, self.imageSize.y / 2)
    end
end

function Entity:SetPosition(position)
    if physics ~= nil then
        self.physics.body:setPosition(position)
    else
        self.position = position
    end
end

function Entity:GetPosition()
    return(self.position)
end

function Entity:SetRotation(rotation)
    local finalRotation = rotation % (2 * math.pi)
    if physics ~= nil then
        self.physics.body:setAngle(rotation)
    else
        self.rotation = rotation
    end
end

function Entity:GetRotation()
    return(self.rotation)
end

function Entity:SetImageSize(size)
    if physics == nil then
        self.imageSize = size
    else
        print('BAD: Trying to force image size on a physics controlled entity')
    end
end

function Entity:GetImageSize()
    return(self.imageSize)
end

function Entity:SetVisible(visible)
    self.visible = visible
end

function Entity:IsVisible()
    return(self.visible)
end

function Entity:CreatePhysics(w, h, type)
    self.physics = {}
    self.physics.body = love.physics.newBody(mPhysicsWorld, self.position.x, self.position.y, type) -- types: "dynamic" "kinematic" "static" 
    self.physics.shape = love.physics.newRectangleShape(0, 0, w, h)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 1)

    self.imageSize.x = w
    self.imageSize.y = h
end

function Entity:HasPhysics()
    return(self.physics ~= nil)
end

function Entity:SetVelocity(x, y)
    if self.physics ~= nil then
        self.physics.body:setLinearVelocity(x, y)
    else
        print('BAD: Trying to move an entity with no physics')
    end
end