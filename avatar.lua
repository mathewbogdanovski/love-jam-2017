require "entity"

Avatar = Entity:extend()

function Avatar:new(image, x, y)
    Avatar.super.new(self, image, x, y)
    self.health = 100
    self.killed = false
    self.faction = GC_FACTIONS.NONE
    self.speedMultiplier = 1.0
    self.baseSpeed = 5
    self.killedSprite = nil
    self.attackDamage = 100
    self.attackSpeed = 1
    self.attackTimer = 0
end

function Avatar:update(dt)
    Avatar.super.update(self, dt)
    if self.attackTimer < self.attackSpeed then
        self.attackTimer = self.attackTimer + dt
    end
end

function Avatar:SetHealth(health)
    self.health = health
    if health <= 0 then
        self:Kill()
    end
end

function Avatar:TakeDamage(damage)
    self:SetHealth(self.health - damage)
end

function Avatar:GetHealth()
    return(health)
end

function Avatar:Kill()
    self.health = 0
    self.killed = true

    if self.killedSprite ~= nil then
        self.currentSprite = self.killedSprite
    end
    self:RemovePhysics()
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

function Avatar:MoveInDirection(direction)
    self:SetVelocity(self:GetSpeed() * direction)

    if direction.x < 0 then
        self:SetSpriteHorizontalMirror(false)
    elseif direction.x > 0 then
        self:SetSpriteHorizontalMirror(true)
    end
end

function Avatar:Attack(target)
    if target ~= nil and target:is(Avatar) and self.attackTimer >= self.attackSpeed then
        target:TakeDamage(self.attackDamage)
    end
end