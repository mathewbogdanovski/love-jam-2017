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

    local entities = mEntityManager:GetEntities()
    if self.timeElapsed > 5 and not entities[1]:IsKilled() then
        entities[1]:Kill()
    end
end

function Level:load()
    mEntityManager:CreateSheep(300, 250)
    mEntityManager:CreateSheep(500, 250)
end