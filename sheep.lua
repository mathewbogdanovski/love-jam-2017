require "avatar"

Sheep = Avatar:extend()

local MAXIMUM_PLAYER_DISTANCE = 100
local MAXIMUM_CHASE_SPEED_MULTIPLIER = 2
local MINIMUM_CHASE_SPEED_MULTIPLIER = 0.7
local MIN_IDLE_TIME = 1
local MAX_IDLE_TIME = 3

function Sheep:new(x, y)
    Sheep.super.new(self, Assets.Graphics.Sheep, x, y)
    self:SetFaction(GC_FACTIONS.PLAYER)
    self.layer = 10
    self.tag = 'sheep'

    self:RegisterPhysics(50, 50, "dynamic")
    self.physics.body:setFixedRotation(true)

    self.attackDamage = 0
    self.baseSpeed = 50
    self.idleTime = math.random(MIN_IDLE_TIME, MAX_IDLE_TIME)
    self.idleTimer = 0
    self.killedSprite = Assets.Graphics.SheepDead
    self.sick = false
end

function Sheep:Kill()
    self.super.Kill(self)
    self:SetSpriteVerticalMirror(true)
    self:SetLayer(9)
    mSounds.sheepKilled:play()
end

function Sheep:SetSick()
    self.sick = true
end

function Sheep:update(dt)
    Sheep.super.update(self, dt)

    if self:IsKilled() then
        return
    end

    local mouseMoved = false
    if love.mouse.isDown(1) == true then
        local mousePosition = Vector(love.mouse:getX() / gWorldToScreenX, love.mouse:getY() / gWorldToScreenY)
        local distanceVector = self.position - mousePosition
        local distance = distanceVector:len()
        if distance <= MAXIMUM_PLAYER_DISTANCE then
            local speedMultiplier = 200 / distance
            speedMultiplier = math.min(MAXIMUM_CHASE_SPEED_MULTIPLIER, speedMultiplier)
            speedMultiplier = math.max(MINIMUM_CHASE_SPEED_MULTIPLIER, speedMultiplier)
            self:SetSpeedMultiplier(speedMultiplier)
            self:MoveInDirection(distanceVector:normalized())
            mouseMoved = true
        end
    end

    if not mouseMoved then
        if self.sick == true then
            if self.wolf == nil or self.wolf:IsKilled() or self.wolf:IsGarbage() then
                local wolves = mLevel:GetEntityManager():GetEntitiesByTypes({ Wolf })
                if #wolves > 0 then
                    local randIndex = math.random(1, #wolves)
                    self.wolf = wolves[randIndex]
                end
            end
            local direction = Vector(0, 0)
            if self.wolf ~= nil and not self.wolf:IsKilled() then
                direction = self.wolf:GetPosition() - self:GetPosition()
            end
            self:SetSpeedMultiplier(1)
            self:MoveInDirection(direction:normalized())
        else
            self.idleTimer = self.idleTimer + dt
            if self.idleTimer >= self.idleTime then
                self.idleTimer = 0
                self.idleTime = math.random(MIN_IDLE_TIME, MAX_IDLE_TIME)
                local newDirection = Vector(0, 0)
                if math.random() < 0.5 then
                    newDirection = Vector(math.random(20, 100), math.random(-100, 100))
                    newDirection = newDirection:normalized()
                end
                self:SetSpeedMultiplier(1)
                self:MoveInDirection(newDirection)
            end
        end
    end
end

function Sheep:draw()
    love.graphics.push()
        if self.sick == true then
            love.graphics.setColor(0, 255, 0, 255)
        end
        Sheep.super.draw(self)
        love.graphics.setColor(255, 255, 255, 255)
    love.graphics.pop()
end
