require "avatar"

Sheep = Avatar:extend()

local MAXIMUM_PLAYER_DISTANCE_SQUARED = 100
local MIN_IDLE_TIME = 1
local MAX_IDLE_TIME = 3

function Sheep:new(x, y)
    Sheep.super.new(self, Assets.Graphics.Sheep, x, y)
    self:SetFaction(GC_FACTIONS.PLAYER)
    self.layer = 1
    self.tag = 'sheep'

    self:RegisterPhysics(50, 50, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.debugPhysics = true

    self.baseSpeed = 50
    self.idleTime = math.random(MIN_IDLE_TIME, MAX_IDLE_TIME)
    self.idleTimer = 0
    self.killedSprite = Assets.Graphics.SheepDead
end

function Sheep:Kill()
    self.super.Kill(self)
    self:SetSpriteVerticalMirror(true)
    self:SetLayer(0)
end

function Sheep:update(dt)
    Sheep.super.update(self, dt)

    if self:IsKilled() then
        return
    end

    local mousePosition = Vector(love.mouse:getX() / gWorldToScreenX, love.mouse:getY() / gWorldToScreenY)
    local distanceVector = self.position - mousePosition
    local distance = distanceVector:len()
    if distance <= MAXIMUM_PLAYER_DISTANCE_SQUARED then
        self:SetSpeedMultiplier(100 / distance)
        self:MoveInDirection(distanceVector:normalized())
    else
        self.idleTimer = self.idleTimer + dt
        if self.idleTimer >= self.idleTime then
            self.idleTimer = 0
            self.idleTime = math.random(MIN_IDLE_TIME, MAX_IDLE_TIME)
            local newDirection = Vector(0, 0)
            if math.random() < 0.2 then
                newDirection = Vector(math.random(-100, 100), math.random(-100, 100))
                newDirection = newDirection:normalized()
            end
            self:SetSpeedMultiplier(1)
            self:MoveInDirection(newDirection)
        end
    end
end
