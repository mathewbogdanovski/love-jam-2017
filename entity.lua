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
    self.debugPhysics = false
    self.layer = 0
    self.tag = 'entity'
    self.isGarbage = false
end

function Entity:update(dt)
    if self:HasPhysics() then
        self.position.x = self.physics.body:getX()
        self.position.y = self.physics.body:getY()
    end
end

function Entity:draw()
    if self.visible == true and self.scale > MIN_SCALE then
        love.graphics.draw(self.currentSprite,
                            self.position.x * gWorldToScreenX,
                            self.position.y * gWorldToScreenY,
                            self.rotation,
                            self.scale * self.mirrorSpriteHorizontal * gWorldToScreenX,
                            self.scale * self.mirrorSpriteVertical * gWorldToScreenY,
                            self.currentSprite:getWidth() / 2, 
                            self.currentSprite:getHeight() / 2)

        if self:HasPhysics() and self.debugPhysics == true then
            love.graphics.push()
                love.graphics.translate(self.physics.body:getX() * gWorldToScreenX,
                                         self.physics.body:getY() * gWorldToScreenY)
                                        love.graphics.rotate(self.physics.body:getAngle())
                                        love.graphics.rectangle("line", 
                                        -self.physics.width / 2 * self.scale * gWorldToScreenX, 
                                        -self.physics.height / 2 * self.scale * gWorldToScreenY, 
                                        self.physics.width * self.scale * gWorldToScreenX, 
                                        self.physics.height * self.scale * gWorldToScreenY)
            love.graphics.pop()
        end
    end
end

function Entity:IsGarbage()
    return(self.isGarbage)
end

function Entity:MarkAsGarbage()
    self.isGarbage = true
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
    local twoPi = 2 * math.pi
    self.rotation = (rotation  + twoPi) % (twoPi)
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

function Entity:SetVisible(visible)
    self.visible = visible
end

function Entity:IsVisible()
    return(self.visible)
end

function Entity:SetLayer(layer)
    self.layer = layer
    mLevel:GetEntityManager():SortEntities()
end

function Entity:GetLayer()
    return(self.layer)
end

function Entity:SetTag(tag)
    self.tag = tag
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
    if self.physics == nil then
        return
    end
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

function Entity:RaycastMouse()
    if self:HasPhysics() == true then
        return(self.physics.shape:testPoint(
                    self.physics.body:getX(),
                    self.physics.body:getY(),
                    self.physics.body:getAngle(),
                    love.mouse:getX() / gWorldToScreenX,
                    love.mouse:getY() / gWorldToScreenY))
    end
    return(false)
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