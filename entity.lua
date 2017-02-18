Entity = Object:extend()

MIN_SCALE = 0.05

function Entity:new(sprite, x, y)
    self.position = Vector(x, y)
    self.rotation = 0
    self.sprite = sprite
    self.currentSprite = self.sprite
    self.mirrorSpriteHorizontal = 1.0
    self.mirrorSpriteVertical = 1.0
    self.visible = true
    self.physics = nil
    self.scale = 1.0
    self.spriteWidthRatio = 1.0
    self.spriteHeightRatio = 1.0
end

function Entity:update(dt)
    if(self.physics ~= nil) then
        self.position.x = self.physics.body:getX()
        self.position.y = self.physics.body:getY()
        self.rotation = self.physics.body:getAngle()
    end
end

function Entity:draw()
    if self.visible == true and self.scale > MIN_SCALE then
        love.graphics.draw(self.currentSprite,
                            self.position.x,
                            self.position.y,
                            self.rotation,
                            self.spriteWidthRatio * self.scale * self.mirrorSpriteHorizontal,
                            self.spriteHeightRatio * self.scale * self.mirrorSpriteVertical,
                            (self.currentSprite:getWidth()) / 2 * self.scale, 
                            (self.currentSprite:getHeight()) / 2 * self.scale)
    end
end

function Entity:SetPosition(position)
    self.position = position
    if physics ~= nil then
        self.physics.body:setPosition(position)
    end
end

function Entity:GetPosition()
    return(self.position)
end

function Entity:SetRotation(rotation)
    self.rotation = rotation % (2 * math.pi)
    if physics ~= nil then
        self.physics.body:setAngle(self.rotation)
    end
end

function Entity:GetRotation()
    return(self.rotation)
end

function Entity:SetVisible(visible)
    self.visible = visible
end

function Entity:IsVisible()
    return(self.visible)
end

function Entity:UpdatePhysics()
    --TODO: should remove/disable physics when at min scale

    self.physics.shape = love.physics.newRectangleShape(0, 0, self.spriteWidthRatio * self.scale, self.spriteHeightRatio * self.scale)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 1)
end

function Entity:RegisterPhysics(w, h, type)
    self.physics = {}
    self.physics.body = love.physics.newBody(mPhysicsWorld, self.position.x, self.position.y, type) -- types: "dynamic" "kinematic" "static"
    
    self.spriteWidthRatio = self.sprite and (w / self.sprite:getWidth()) or 1.0
    self.spriteHeightRatio = self.sprite and (h / self.sprite:getHeight()) or 1.0

    self:UpdatePhysics()
end

function Entity:RemovePhysics()
    if self:HasPhysics() then
        self.physics.fixture = nil
        self.physics.shape = nil
        self.physics.body:destroy()
        self.physics = nil
    end
end

function Entity:HasPhysics()
    return(self.physics ~= nil)
end

function Entity:SetVelocity(velocity)
    if self.physics ~= nil then
        self.physics.body:setLinearVelocity(velocity.x, velocity.y)
    else
        print('BAD: Trying to move an entity with no physics')
    end
end

function Entity:GetVelocity()
    if self.physics == nil then
        return(Vector(0,0))
    else
        return(Vector(self.physics.body:getLinearVelocity()))
    end
end

function SetScale(scale)
    if scale < MIN_SCALE then
        scale = MIN_SCALE
    end

    self.scale = scale
    self:UpdatePhysics()
end

function Entity:SetSpriteHorizontalMirror(mirrored)
    self.mirrorSpriteHorizontal = mirrored and -1.0 or 1.0
end

function Entity:SetSpriteVerticalMirror(mirrored)
    self.mirrorSpriteVertical = mirrored and -1.0 or 1.0
end