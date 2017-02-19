EntityManager = Object:extend()

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
    for i,entity in ipairs(self.entities) do
        entity:update(dt)
    end
end

function EntityManager:CreateEmptyEntity(x, y, physics, w, h)
    local entity = Entity(Assets.Graphics.transparent, x, y)
    if physics == true then
        if w == nil then
            w = 64
        end
        if h == nil then
            h = 64
        end
        entity:RegisterPhysics(w, h, "static")
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

function EntityManager:RemoveEntity(entity)
    for i=#self.entities,1,-1 do
        if entity == self.entities[i] then
            table.remove(self.entities, i)
            break
        end
    end
end

function EntityManager:RemoveAllEntities()
    for i=#self.entities,1,-1 do
        if self.entities[i] ~= nil then
            self.entities[i]:RemovePhysics()
            table.remove(self.entities, i)
        end
    end
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