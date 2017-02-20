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
    self.layer = 1
    self.tag = 'sheep'

    self:RegisterPhysics(50, 50, "dynamic")
    self.physics.body:setFixedRotation(true)

    self.attackDamage = 0
    self.baseSpeed = 50
    self.idleTime = math.random(MIN_IDLE_TIME, MAX_IDLE_TIME)
    self.idleTimer = 0
    self.killedSprite = Assets.Graphics.SheepDead
end

function Sheep:Kill()
    self.super.Kill(self)
    self:SetSpriteVerticalMirror(true)
    self:SetLayer(0)
    mSounds.sheepKilled:play()
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

function Sheep:draw()
    love.graphics.push()
        if self.attackDamage ~= 0 then
            love.graphics.setColor(0, 0, 255, 255)
        end
        Sheep.super.draw(self)
        love.graphics.setColor(255, 255, 255, 255)
    love.graphics.pop()
end
