Level = Object:extend()

require "entitymanager"

local mEntityManager = nil

function Level:new(stageNum)
	mEntityManager = EntityManager()
	self.stage = stageNum
	self:load()
end

function Level:draw()
	mEntityManager:draw()
end

function Level:update(dt)
	mEntityManager:update(dt)
end

function Level:load()
	local entity = mEntityManager:CreateSheep(10, 10)
	entity.physics.body:setLinearVelocity(50, 0)
	
	mEntityManager:CreateSheep(400, 10)
end