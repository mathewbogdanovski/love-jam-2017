Level = Object:extend()

require "entitymanager"

local mEntityManager = nil

function Level:new(stageNum)
    mEntityManager = EntityManager()
    self.stage = stageNum
    self:load()
    self.timeElapsed = 0
end

function Level:draw()
    mEntityManager:draw()
end

function Level:update(dt)
    mEntityManager:update(dt)

    self.timeElapsed = (self.timeElapsed + dt)

    if self.timeElapsed > 5 then
        mEntityManager:GetEntities()[1]:Kill()
    end
end

function Level:load()
    mEntityManager:CreateSheep(200, 100)
    mEntityManager:CreateSheep(400, 100)
end