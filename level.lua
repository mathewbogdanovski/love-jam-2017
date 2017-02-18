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
	mEntityManager:CreateSheep(200, 100)
	mEntityManager:CreateSheep(400, 100)
end