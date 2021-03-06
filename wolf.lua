require "avatar"

Wolf = Avatar:extend()

local MAXIMUM_PLAYER_DISTANCE = 200
local MAXIMUM_SHEPHERD_DISTANCE = 250
local MINIMUM_CHASE_SPEED_MULTIPLIER = 0.7
local TARGET_SEARCH_INTERVAL = 4
local IDLE_TIME = 4

function Wolf:new(x, y)
    Wolf.super.new(self, Assets.Graphics.Wolf, x, y)
    self:SetFaction(GC_FACTIONS.WILD)
    self.layer = 10
    self.tag = 'enemy'

    self:RegisterPhysics(64, 64, "dynamic")
    self.physics.body:setFixedRotation(true)

    self.baseSpeed = math.random(70, 110)
    self.killedSprite = Assets.Graphics.DeadWolf

    self.targetTimer = 0
    self.idleTimer = IDLE_TIME
end

function Wolf:Kill()
    self.super.Kill(self)
    self:SetSpriteVerticalMirror(true)
    self:SetLayer(9)
    mSounds.wolfKilled:play()
end

function Wolf:update(dt)
    Wolf.super.update(self, dt)

    if self:IsKilled() then
        return
    end

    if self.target ~= nil then
        if self.target:IsGarbage() then
            self.target = nil
        elseif self.target:IsKilled() and self.idleTimer >= IDLE_TIME then
            self.idleTimer = 0
        end
    end

    if self.idleTimer < IDLE_TIME then
        self:MoveInDirection(Vector(0,0))
        self.idleTimer = self.idleTimer + dt
        if self.idleTimer >= IDLE_TIME then
            self.target = nil
        end
    end

    self.targetTimer = self.targetTimer + dt

    if self.target == nil or (self.targetTimer >= TARGET_SEARCH_INTERVAL and self.target ~= nil and not self.target:IsKilled()) then
        self.targetTimer = 0
        local sheep = mLevel:GetEntityManager():GetEntitiesByTypes({ Sheep })
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

    if self.idleTimer >= IDLE_TIME and self.target ~= nil and not self.target:IsKilled() then
        moveVector = self.target:GetPosition() - self:GetPosition()
    end

    local shepherds = mLevel:GetEntityManager():GetEntitiesByTypes({ Shepherd })
    local closestDist = 0
    if self.closestShepherd ~= nil then
        closestDist = self.closestShepherd:GetPosition() - self:GetPosition()
        closestDist = closestDist:len()
    end
    for i=1,#shepherds do
        if not shepherds[i]:IsKilled() and shepherds[i] ~= self.closestShepherd then
            local dist = shepherds[i]:GetPosition() - self:GetPosition()
            dist = dist:len()
            if dist < closestDist or self.closestShepherd == nil then
                self.closestShepherd = shepherds[i]
                closestDist = dist
            end
        end
    end

    if self.closestShepherd ~= nil and not self.closestShepherd:IsKilled() then
        local distanceVector = self.position - self.closestShepherd:GetPosition()
        local distance = distanceVector:len()
        if distance <= MAXIMUM_SHEPHERD_DISTANCE then
            speedMultiplier = 2.5
            moveVector = distanceVector
            if self.idleTimer >= IDLE_TIME then
                self.idleTimer = 0
            end
        end
    end

    self:SetSpeedMultiplier(speedMultiplier)
    if moveVector ~= nil then
        self:MoveInDirection(moveVector:normalized())
    end
end
