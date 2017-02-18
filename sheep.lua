require "avatar"

Sheep = Avatar:extend()

local MAXIMUM_PLAYER_DISTANCE_SQUARED = 10000
local MIN_IDLE_TIME = 1
local MAX_IDLE_TIME = 3

function Sheep:new(x, y)
    Sheep.super.new(self, Assets.Graphics.Sheep, x, y)
    self:SetFaction(GC_FACTIONS.PLAYER)

    self:RegisterPhysics(64, 64, "dynamic")
    self:SetSpriteSizeFromPhysics()
    self.debugPhysics = true

    self.baseSpeed = 50
    self.idleTime = math.random(MIN_IDLE_TIME, MAX_IDLE_TIME)
    self.idleTimer = self.idleTime
end

function Sheep:update(dt)
    Sheep.super.update(self, dt)

    local mousePosition = Vector(love.mouse:getX(), love.mouse:getY())
    local distanceVector = self.position - mousePosition
    if distanceVector:len2() <= MAXIMUM_PLAYER_DISTANCE_SQUARED then
        self:MoveInDirection(distanceVector:normalized())
    else
        self.idleTimer = self.idleTimer + dt
        if self.idleTimer >= self.idleTime then
            self.idleTimer = 0
            self.idleTime = math.random(MIN_IDLE_TIME, MAX_IDLE_TIME)
            local newDirection = Vector(0, 0)
            if math.random() < 0.6 then
                newDirection = Vector(math.random(-100, 100), math.random(-100, 100))
                newDirection = newDirection:normalized()
            end
            self:MoveInDirection(newDirection)
        end
    end
end
