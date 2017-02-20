require "avatar"

Parasite = Avatar:extend()

local TARGET_SEARCH_INTERVAL = 4

function Parasite:new(x, y)
    Parasite.super.new(self, Assets.Graphics.box, x, y)
    self:SetFaction(GC_FACTIONS.WILD)
    self.layer = 10
    self.tag = 'enemy'

    self:RegisterPhysics(30, 30, "dynamic")
    self.physics.body:setFixedRotation(true)

    self.baseSpeed = math.random(10, 20)
    self.killedSprite = Assets.Graphics.SheepDead

    self.attackDamage = 0
    self.targetTimer = 0
    self.idleTimer = 0
end

function Parasite:Kill()
    self.super.Kill(self)
    self:SetSpriteVerticalMirror(true)
    self:SetLayer(9)
end

function Parasite:Attack(target)
    self.super.Attack(self, target)

    local sheep = mLevel:GetEntityManager():GetEntitiesByTypes({ Sheep })
    for i=1,#sheep do
        if not sheep[i]:IsKilled() then
            local distanceVector = sheep[i]:GetPosition() - self:GetPosition()
            if distanceVector:len() <= SPLASH_RADIUS then
                sheep[i]:SetSick()
            end
        end
    end

    self:Kill()
end

function Parasite:update(dt)
    Parasite.super.update(self, dt)

    if self:IsKilled() then
        return
    end

    if self.target ~= nil then
        if self.target:IsGarbage() or self.target:IsKilled() then
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

    if self.target ~= nil and not self.target:IsKilled() then
        moveVector = self.target:GetPosition() - self:GetPosition()
    end

    self:SetSpeedMultiplier(speedMultiplier)
    if moveVector ~= nil then
        self:MoveInDirection(moveVector:normalized())
    end
end
