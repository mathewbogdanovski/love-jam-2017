require "avatar"

Insect = Avatar:extend()

local MAXIMUM_PLAYER_DISTANCE = 200
local MAXIMUM_SHEPHERD_DISTANCE = 250
local MINIMUM_CHASE_SPEED_MULTIPLIER = 0.7
local TARGET_SEARCH_INTERVAL = 4
local IDLE_AFTER_KILL_TIME = 6

function Insect:new(x, y)
    Insect.super.new(self, Assets.Graphics.box, x, y)
    self:SetFaction(GC_FACTIONS.WILD)
    self.layer = 10
    self.tag = 'enemy'

    self:RegisterPhysics(30, 30, "dynamic")
    self.physics.body:setFixedRotation(true)

    self.baseSpeed = math.random(30, 60)
    self.killedSprite = Assets.Graphics.SheepDead

    self.targetTimer = 0
    self.idleTimer = 0

    self.attackDamage = 50
    self.attackSpeed = 2.5
end

function Insect:Kill()
    self.super.Kill(self)
    self:SetSpriteVerticalMirror(true)
    self:SetLayer(9)
end

function Insect:update(dt)
    Insect.super.update(self, dt)

    if self:IsKilled() then
        return
    end

    if self.target ~= nil then
        if self.target:IsGarbage() then
            self.target = nil
        elseif self.target:IsKilled() then
            self:MoveInDirection(Vector(0,0))
            self.idleTimer = self.idleTimer + dt
            if self.idleTimer >= IDLE_AFTER_KILL_TIME then
                self.idleTimer = 0
                self.target = nil
            end
        end
    end

    self.targetTimer = self.targetTimer + dt

    if self.target == nil or (self.targetTimer >= TARGET_SEARCH_INTERVAL and self.target ~= nil and not self.target:IsKilled()) then
        self.targetTimer = 0
        local sheep = mLevel:GetEntityManager():GetEntitiesByTags({ 'sheep' })
        local closestSheep = nil
        local closestDist = 0
        for i=1,#sheep do
            if not sheep[i]:IsKilled() and sheep[i] ~= closestSheep then
                local dist = sheep[i]:GetPosition() - self:GetPosition()
                dist = dist:len()
                if dist < closestDist or closestSheep == nil then
                    closestSheep = sheep[i]
                    closestDist = dist
                end
            end
        end
        self.target = closestSheep
    end

    local moveVector = nil
    local speedMultiplier = 1

    if self.target ~= nil and not self.target:IsKilled() then
        moveVector = self.target:GetPosition() - self:GetPosition()
    end

    self:SetSpeedMultiplier(speedMultiplier)
    if moveVector ~= nil then
        self:MoveInDirection(moveVector:normalized())
    end
end
