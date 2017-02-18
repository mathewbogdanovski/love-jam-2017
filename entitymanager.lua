EntityManager = Object:extend()

require "sheep"

function EntityManager:new()
    self.entities = {}
end

function EntityManager:draw()
    for i,entity in ipairs(self.entities) do
    entity:draw()
    end
end

function EntityManager:update(dt)
    for i,entity in ipairs(self.entities) do
        entity:update(dt)
    end
end

function EntityManager:CreateBoxEntity(x, y, physics)
    local entity = Entity(Assets.Graphics.Sprites.Box, x, y)
    if physics then
        entity:RegisterPhysics(64, 64, "dynamic")
    end
    return self:AddEntity(entity)
end

function EntityManager:CreateSheep(x, y)
    local sheep = Sheep(x, y)
    return self:AddEntity(sheep)
end

function EntityManager:AddEntity(entity)
    table.insert(self.entities, entity)
    return entity
end