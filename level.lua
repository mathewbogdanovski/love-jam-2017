Level = Object:extend()

require "entitymanager"

local mEntityManager = nil

function Level:new()
    mEntityManager = EntityManager()

    self.stage = 1
    self.levelLoaded = false
    self.timeElapsed = 0
    self.remainingSheep = 10
end

function Level:draw()
    if not self.levelLoaded then
        return
    end

    mEntityManager:draw()
end

function Level:update(dt)
    if not self.levelLoaded then
        return
    end

    mEntityManager:update(dt)

    self.timeElapsed = (self.timeElapsed + dt)
end

function Level:Load()
    self.levelLoaded = true
    self.remainingSheep = math.min(self.remainingSheep + 10, MAX_NUM_SHEEP)

    --TODO: temp way of creating spawning bounds
    local spawnBounds = { x1 = 0,
                            x2 = 300,
                            y1 = 100,
                            y2 = 600 }

    local spawnWidth = (spawnBounds.x2 - spawnBounds.x1)
    local spawnHeight = (spawnBounds.y2 - spawnBounds.y1)
    local numColumns = math.ceil(spawnWidth / spawnHeight * math.sqrt(self.remainingSheep))
    local numRows = math.floor(self.remainingSheep / numColumns)
    
    local widthIncrement = spawnWidth / numRows
    local heightIncrement = spawnHeight / numColumns
    local currRow = 0
    local currCol = 0
    for i = 1, self.remainingSheep do
        mEntityManager:CreateSheep(
            (currCol * widthIncrement) + widthIncrement / 2, 
            (currRow * heightIncrement) + heightIncrement / 2)

        if currCol >= numColumns then
                currCol = 0
                currRow = currRow + 1
        else
                currCol = currCol + 1
        end
    end
end

function Level:GetEntityManager()
    return(mEntityManager)
end

function Level:SetStageNum(stageNum)
    self.stage = stageNum
end