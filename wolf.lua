require "avatar"

Wolf = Avatar:extend()

local MAXIMUM_PLAYER_DISTANCE_SQUARED = 100

function Wolf:new(x, y)
    Wolf.super.new(self, Assets.Graphics.Sprites.box, x, y)
    self:SetFaction(GC_FACTIONS.WILD)
    self.layer = 1
    self.tag = 'enemy'

    self:RegisterPhysics(64, 64, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.debugPhysics = true

    self.baseSpeed = 50
    self.killedSprite = Assets.Graphics.SheepDead
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

    if self.target == nil or self.target:IsKilled() then
        local sheep = Level:GetEntityManager():GetEntitiesByTypes({ Sheep })
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

    if self.target ~= nil and not self.target:IsKilled() then
        local distanceVector = self.target:GetPosition() - self:GetPosition()
        self:MoveInDirection(distanceVector:normalized())
    end

    local mousePosition = Vector(love.mouse:getX() / gWorldToScreenX, love.mouse:getY() / gWorldToScreenY)
    local distanceVector = self.position - mousePosition
    local distance = distanceVector:len()
    if distance <= MAXIMUM_PLAYER_DISTANCE_SQUARED then
        self:SetSpeedMultiplier(100 / distance)
        self:MoveInDirection(distanceVector:normalized())
    end
end
