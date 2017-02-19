require "gameConstants"

Entity = Object:extend()

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
    self.debugPhysics = false
    self.layer = 0
    self.tag = 'entity'
end

function Entity:update(dt)
    if self:HasPhysics() then
        self.position.x = self.physics.body:getX() * PHYSICS_TO_WORLD_X
        self.position.y = self.physics.body:getY() * PHYSICS_TO_WORLD_Y
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
                            self.sprite:getWidth() / 2, 
                            self.sprite:getHeight() / 2)

        if self:HasPhysics() and self.debugPhysics == true then
            love.graphics.push()
                love.graphics.translate(self.position.x, self.position.y)
                love.graphics.rotate(self.rotation)
                love.graphics.rectangle("line", 
                                          -self.physics.width / 2 * self.scale * PHYSICS_TO_WORLD_X, 
                                          -self.physics.height / 2 * self.scale * PHYSICS_TO_WORLD_Y, 
                                          self.physics.width * self.scale * PHYSICS_TO_WORLD_X, 
                                          self.physics.height * self.scale * PHYSICS_TO_WORLD_Y)
            love.graphics.pop()
        end
    end
end

function Entity:SetPosition(position)
    self.position = position
    if self:HasPhysics() then
        self.physics.body:setPosition(position)
    end
end

function Entity:GetPosition()
    return(self.position)
end

function Entity:SetRotation(rotation)
    self.rotation = rotation % (2 * math.pi)
    if self:HasPhysics() then
        self.physics.body:setAngle(self.rotation)
    end
end

function Entity:GetRotation()
    return(self.rotation)
end

function Entity:SetScale(scale)
    if scale < MIN_SCALE then
        scale = MIN_SCALE
    end
    self.scale = scale

    if self:HasPhysics() then
        self:UpdatePhysics()
    end
end

function Entity:GetScale()
    return(self.scale)
end

function Entity:SetSpriteSize(w, h)
    self.spriteWidthRatio = self.sprite and (w / self.sprite:getWidth()) or 1.0
    self.spriteHeightRatio = self.sprite and (h / self.sprite:getHeight()) or 1.0
end

function Entity:GetSpriteSize()
    return(Vector(self.spriteWidthRatio * self.sprite:getWidth(), self.spriteHeightRatio * self.sprite:getHeight()))
end

function Entity:GetScaledSpriteSize()
    return(self:GetSpriteSize() * self.scale)
end

function Entity:SetVisible(visible)
    self.visible = visible
end

function Entity:IsVisible()
    return(self.visible)
end

function Entity:SetLayer(layer)
    self.layer = layer
    Level:GetEntityManager():SortEntities()
end

function Entity:GetLayer()
    return(self.layer)
end

function Entity:GetTag()
    return(self.tag)
end

function Entity:RegisterPhysics(w, h, type)
    self.physics = {}
    self.physics.body = love.physics.newBody(mPhysicsWorld, self.position.x, self.position.y, type) -- types: "dynamic" "kinematic" "static"
    self.physics.width = w
    self.physics.height = h
    self:UpdatePhysics()
end

function Entity:UpdatePhysics()
    --TODO: should remove/disable physics when at min scale
    self.physics.shape = love.physics.newRectangleShape(0, 0, self.physics.width * self.scale, self.physics.height * self.scale)

    if self.physics.fixture ~= nil then
        self.physics.fixture:destroy()
    end
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 1)
    self.physics.fixture:setUserData(self.tag)
end

function Entity:SetPhysicsSize(w, h)
    if self:HasPhysics()
     then
        self.physics.width = w
        self.physics.height = h
        self:UpdatePhysics()
    else
        print('Tried to set physics size on an entity with no physics')
    end
end

function Entity:SetSpriteSizeFromPhysics()
    if self:HasPhysics() then
        self.spriteWidthRatio = self.currentSprite and (self.physics.width * PHYSICS_TO_WORLD_X / self.sprite:getWidth()) or 1.0
        self.spriteHeightRatio = self.currentSprite and (self.physics.height * PHYSICS_TO_WORLD_Y / self.sprite:getHeight()) or 1.0
    else
        print('Tried to set sprite size from physics on an entity with no physics')
    end
end

function Entity:SetPhysicsSizeFromSprite()
    if self:HasPhysics() then
        self.physics.width = self.spriteWidthRatio * self.sprite:getWidth() / love.graphics.getWidth() * WORLD_MAX_X
        self.physics.height = self.spriteHeightRatio * self.sprite:getHeight() / love.graphics.getHeight() * WORLD_MAX_Y
        self:UpdatePhysics()
    else
        print('Tried to set physics size on an entity with no physics')
    end
end

function Entity:RemovePhysics()
    if self:HasPhysics() then
        self.physics.fixture:destroy()
        self.physics.body:destroy()
        self.physics = nil
    end
end

function Entity:HasPhysics()
    return(self.physics ~= nil)
end

function Entity:SetVelocity(velocity)
    if self:HasPhysics() then
        self.physics.body:setLinearVelocity(velocity.x, velocity.y)
    else
        print('BAD: Trying to move an entity with no physics')
    end
end

function Entity:GetVelocity()
    if self:HasPhysics() then
        return(Vector(self.physics.body:getLinearVelocity()))
    end
    return(Vector(0,0))
end

function Entity:SetSpriteHorizontalMirror(mirrored)
    self.mirrorSpriteHorizontal = mirrored and -1.0 or 1.0
end

function Entity:SetSpriteVerticalMirror(mirrored)
    self.mirrorSpriteVertical = mirrored and -1.0 or 1.0
end