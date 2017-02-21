require "avatar"

Shepherd = Avatar:extend()

local MAXIMUM_PLAYER_DISTANCE = 100
local MAXIMUM_CHASE_SPEED_MULTIPLIER = 2
local MINIMUM_CHASE_SPEED_MULTIPLIER = 0.7
local MIN_IDLE_TIME = 1
local MAX_IDLE_TIME = 3

function Shepherd:new(x, y)
    Shepherd.super.new(self, Assets.Graphics.Shepherd, x, y)
    self:SetFaction(GC_FACTIONS.PLAYER)
    self.layer = 10
    self.tag = 'sheep'

    self:RegisterPhysics(70, 70, "dynamic")
    self.physics.body:setFixedRotation(true)

    self.attackDamage = 50
    self.baseSpeed = 50
    self.idleTime = math.random(MIN_IDLE_TIME, MAX_IDLE_TIME)
    self.idleTimer = 0
    self.killedSprite = Assets.Graphics.ShepherdDead
end

function Shepherd:Kill()
    Shepherd.super.Kill(self)
    self:SetSpriteVerticalMirror(true)
    self:SetLayer(9)
    mSounds.sheepKilled:play()
end

function Shepherd:update(dt)
    Shepherd.super.update(self, dt)

    if self:IsKilled() then
        return
    end

    local mouseMoved = false
    if love.mouse.isDown(2) == true then
        local mousePosition = Vector(love.mouse:getX() / gWorldToScreenX, love.mouse:getY() / gWorldToScreenY)
        local distanceVector = self.position - mousePosition
        local distance = distanceVector:len()
        if distance <= MAXIMUM_PLAYER_DISTANCE then
            local speedMultiplier = 200 / distance
            speedMultiplier = math.min(MAXIMUM_CHASE_SPEED_MULTIPLIER, speedMultiplier)
            speedMultiplier = math.max(MINIMUM_CHASE_SPEED_MULTIPLIER, speedMultiplier)
            if love.keyboard.isDown('lshift') then
                speedMultiplier = speedMultiplier * 2.5
            end
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
