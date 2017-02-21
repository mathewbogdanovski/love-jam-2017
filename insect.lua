require "avatar"

Insect = Avatar:extend()

local TARGET_SEARCH_INTERVAL = 4
local SPLASH_RADIUS = 170

function Insect:new(x, y)
    Insect.super.new(self, Assets.Graphics.Insect, x, y)
    self:SetFaction(GC_FACTIONS.WILD)
    self.layer = 10
    self.tag = 'enemy'

    self:RegisterPhysics(30, 30, "dynamic")
    self.physics.body:setFixedRotation(true)

    self.baseSpeed = math.random(70 + mLevel:GetStageNum() * 5, 110 + mLevel:GetStageNum() * 5)
    self.killedSprite = Assets.Graphics.InsectDead

    self.targetTimer = 0
    self.idleTimer = 0

    self.attackDamage = 0
    self.attackSpeed = 2.5
end

function Insect:Kill()
    self.super.Kill(self)
    self:SetSpriteVerticalMirror(true)
    self:SetLayer(9)
    mSounds.insectKilled:play()
end

function Insect:Attack(target)
    self.super.Attack(self, target)

    local shouldDie = false
    local sheep = mLevel:GetEntityManager():GetEntitiesByTypes({ Sheep })
    for i=1,#sheep do
        if not sheep[i]:IsKilled() then
            local distanceVector = sheep[i]:GetPosition() - self:GetPosition()
            if distanceVector:len() <= SPLASH_RADIUS then
                sheep[i]:SetSick()
                shouldDie = true
            end
        end
    end

    if shouldDie == true then
        self:Kill()
    end
end

function Insect:update(dt)
    Insect.super.update(self, dt)

    if self:IsKilled() then
        return
    end

    if self.target ~= nil and (self.target:IsGarbage() or self.target:IsKilled()) then
        self.target = nil
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

    if self.target ~= nil and not self.target:IsKilled() then
        moveVector = self.target:GetPosition() - self:GetPosition()
    end

    self:SetSpeedMultiplier(speedMultiplier)
    if moveVector ~= nil then
        self:MoveInDirection(moveVector:normalized())
    end
end
