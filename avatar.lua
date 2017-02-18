require "gameConstants"
require "entity"

Avatar = Entity:extend()

function Avatar:new(image, x, y)
    Avatar.super.new(self, image, x, y)
    self.health = 100
    self.killed = false
    self.faction = GC_FACTIONS[NONE]
    self.speedMultiplier = 1.0
    self.baseSpeed = 5
end

function Avatar:SetHealth(health)
    self.health = health
    if health <= 0 then
        self.killed = true
    end
end

function Avatar:GetHealth()
    return(health)
end

function Avatar:Kill()
    self.health = 0
end

function Avatar:IsKilled()
    return(self.killed)
end

function Avatar:SetFaction(faction)
    self.faction = faction
end

function Avatar:GetFaction()
    return(self.faction)
end

function Avatar:SetSpeedMultiplier(multiplier)
    self.speedMultiplier = math.max(0, multiplier)
end

function Avatar:GetSpeedMultiplier()
    return(self.speedMultipler)
end

function Avatar:GetSpeed()
    return(self.baseSpeed * self.speedMultiplier)
end
