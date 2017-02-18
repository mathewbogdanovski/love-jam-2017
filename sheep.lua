require "avatar"

Sheep = Avatar:extend()

function Sheep:new(x, y)
    Avatar.super.new(self, Assets.Graphics.Sheep, x, y)
    self:SetFaction(GC_FACTIONS.PLAYER)
    self:CreatePhysics(64, 64, "dynamic")
end
