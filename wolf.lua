require "avatar"

Wolf = Avatar:extend()

local MAXIMUM_PLAYER_DISTANCE = 200
local MAXIMUM_SHEPHERD_DISTANCE = 250
local MINIMUM_CHASE_SPEED_MULTIPLIER = 0.7
local TARGET_SEARCH_INTERVAL = 4
local IDLE_AFTER_KILL_TIME = 6

function Wolf:new(x, y)
    Wolf.super.new(self, Assets.Graphics.box, x, y)
    self:SetFaction(GC_FACTIONS.WILD)
    self.layer = 1
    self.tag = 'enemy'

    self:RegisterPhysics(64, 64, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.debugPhysics = true

    self.baseSpeed = math.random(30, 50)
    self.killedSprite = Assets.Graphics.SheepDead

    self.targetTimer = 0
    self.idleTimer = 0
end

function Wolf:Kill()
    self.super.Kill(self)
    self:SetSpriteVerticalMirror(true)
    self:SetLayer(0)
end

function Wolf:update(dt)
    Wolf.super.update(self, dt)

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

    local shepherds = mLevel:GetEntityManager():GetEntitiesByTags({ 'shepherd' })
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
        end
    end

    local mousePosition = Vector(love.mouse:getX() / gWorldToScreenX, love.mouse:getY() / gWorldToScreenY)
    local distanceVector = self.position - mousePosition
    local distance = distanceVector:len()
    if distance <= MAXIMUM_PLAYER_DISTANCE then
        speedMultiplier = math.max(MINIMUM_CHASE_SPEED_MULTIPLIER, 400 / distance)
        moveVector = distanceVector
    end

    self:SetSpeedMultiplier(speedMultiplier)
    if moveVector ~= nil then
        self:MoveInDirection(moveVector:normalized())
    end
end
