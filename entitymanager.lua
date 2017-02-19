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

function EntityManager:GetEntities()
    return(self.entities)
end

function EntityManager:GetEntitiesByTypes(objectTypes)
	local entities = {}
	for i,entity in ipairs(self.entities) do
		for j,objectType in ipairs(objectTypes) do
			if entity:is(objectType) then
				table.insert(entities, entity)
				break
			end
		end
	end
	return(entities)
end

function EntityManager:GetEntitiesByTags(tags)
	local entities = {}
	for i,entity in ipairs(self.entities) do
		for j,tag in ipairs(tags) do
			if entity.tag == tag then
				table.insert(entities, entity)
				break
			end
		end
	end
	return(entities)
end