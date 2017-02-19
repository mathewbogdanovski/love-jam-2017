EntityManager = Object:extend()

gSort_Entities_Callback = false

require "sheep"
require "wolf"

function EntityManager:new()
    self.entities = {}
end

function EntityManager:draw()
    for i,entity in ipairs(self.entities) do
        entity:draw()
    end
end

function EntityManager:update(dt)
	if gSort_Entities_Callback == true then
		self:SortEntities()
		gSort_Entities_Callback = false
	end

    for i,entity in ipairs(self.entities) do
        entity:update(dt)
    end
end

function EntityManager:CreateBoxEntity(x, y, physics)
    local entity = Entity(Assets.Graphics.Sprites.Box, x, y)
    if physics then
        entity:RegisterPhysics(64, 64, "dynamic")
        entity:SetSpriteSizeFromPhysics()
    end
    return self:AddEntity(entity)
end

function EntityManager:CreateSheep(x, y)
    local sheep = Sheep(x, y)
    return self:AddEntity(sheep)
end

function EntityManager:CreateWolf(x, y)
	local wolf = Wolf(x, y)
	return self:AddEntity(wolf)
end

function EntityManager:AddEntity(entity)
    table.insert(self.entities, entity)
    self:SortEntities()
    return entity
end

function SortEntityLayers(a,b)
  return(a:GetLayer() < b:GetLayer())
end

function EntityManager:SortEntities()
	table.sort(self.entities, SortEntityLayers)
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
            if entity:GetTag() == tag then
                table.insert(entities, entity)
                break
            end
        end
    end
    return(entities)
end