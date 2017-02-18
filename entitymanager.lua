EntityManager = Object:extend()

require "avatar"

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
	end
	return self:AddEntity(entity)
end

function EntityManager:AddEntity(entity)
	table.insert(self.entities, entity)
	return entity
end
