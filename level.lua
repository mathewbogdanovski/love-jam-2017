Level = Object:extend()

require "entitymanager"
require "gameConstants"

local mEntityManager = nil
local mCheckWinState = false

function Level:new()
    mEntityManager = EntityManager()

    self.stage = 1
    self.levelLoaded = false
    self.timeElapsed = 0
    self.remainingSheep = 10
    self.score = 0

    self:SelectInsectTime()

    self.bgSprite = Assets.Graphics.Background
    self.bgDecoSprites = {}
    table.insert(self.bgDecoSprites, Assets.Graphics.Flower)
end

function Level:draw()
    if not self.levelLoaded then
        return
    end

    love.graphics.draw(self.bgSprite, 0, 0, 0, gWorldToScreenX, gWorldToScreenY, 0, 0)
    mEntityManager:draw()
end

function Level:update(dt)
    if not self.levelLoaded then
        return
    end

    mEntityManager:update(dt)

    self.timeElapsed = (self.timeElapsed + dt)

    self.insectTimer = self.insectTimer + dt
    if self.insectTimer >= self.insectTime then
        self:SelectInsectTime()
        local numInsects = math.min(3, math.random(1 + self.stage / 30, 1 + self.stage * 0.1))
        for i=1,numInsects do
            local pos = self:GetRandomBorderPosition(30)
            mEntityManager:CreateInsect(pos.x, pos.y)
        end
    end

    local sheep = mEntityManager:GetEntitiesByTags({ 'sheep' })
    for i=1,#sheep do
        if sheep[i] ~= nil and not sheep[i]:IsKilled() then
            local sheepPos = sheep[i]:GetPosition()
            if sheepPos.x > WORLD_MAX_X then
                mEntityManager:RemoveEntity(sheep[i])
                self.remainingSheep = self.remainingSheep + 1
                self.score = self.score + 1
                mSounds.sheepSaved:play()
                UpdateScore()
                mCheckWinState = true
            elseif sheepPos.x < 0 or sheepPos.y > WORLD_MAX_Y or sheepPos.y < 0 then
                mEntityManager:RemoveEntity(sheep[i])
                mCheckWinState = true
            end
        end
    end

    if mCheckWinState == true then
        CheckWinState()
        mCheckWinState = false
    end
end

function Level:Load()
    mEntityManager:RemoveAllEntities()

    self.levelLoaded = true

    math.randomseed(os.time())
    local numBackgroundDecos = math.random(20, 30)

    if #self.bgDecoSprites > 0 then
        for i = 1, numBackgroundDecos do
            local posX = math.random(0, WORLD_MAX_X)
            local posY = math.random(0, WORLD_MAX_Y)
            local idx = math.random(1, #self.bgDecoSprites)
            mEntityManager:CreateBackgroundDeco(self.bgDecoSprites[idx], posX, posY)
        end
    end

    --sheep
    self.remainingSheep = math.min(self.remainingSheep + 2, MAX_NUM_SHEEP)
    local fighterSheep = self.remainingSheep / 4

    local xOffset = 50
    local yOffset = 50
    local spawnWidth = 300
    local spawnHeight = 300
    local numColumns = math.ceil((spawnWidth / spawnHeight) * math.sqrt(self.remainingSheep))
    local numRows = math.floor(self.remainingSheep / numColumns)

    local widthIncrement = spawnWidth / numColumns
    local heightIncrement = spawnHeight / numRows
    local currRow = 0
    local currCol = 0

    for i = 1, self.remainingSheep do
        mEntityManager:CreateSheep(
            xOffset + (currCol * widthIncrement) + widthIncrement / 2, 
            yOffset + (currRow * heightIncrement) + heightIncrement / 2)

        if fighterSheep > 0 then
            fighterSheep = fighterSheep - 1
            mEntityManager:CreateShepherd(
	            xOffset + (currCol * widthIncrement) + widthIncrement / 2, 
	            yOffset + (currRow * heightIncrement) + heightIncrement / 2)
        else

        end

        currCol = currCol + 1
        if currCol >= numColumns then
                currCol = 0
                currRow = currRow + 1
        end
    end

    self.remainingSheep = 0

    --enemies
    local yValue = 100
    local numWolves = self.stage - 1
    for i=1,numWolves do
        mEntityManager:CreateWolf(1600, yValue)
        yValue = yValue + 100
        if yValue >= WORLD_MAX_Y then
            break
        end
    end
    self:SelectInsectTime()

    --walls
    mEntityManager:CreateEmptyEntity(WORLD_MAX_X / 2, 0, true, WORLD_MAX_X, 1)
    mEntityManager:CreateEmptyEntity(WORLD_MAX_X / 2, WORLD_MAX_Y, true, WORLD_MAX_X, 1)
    mEntityManager:CreateEmptyEntity(0, WORLD_MAX_Y / 2, true, 1, WORLD_MAX_Y)

    mPhysicsWorld:setCallbacks(BeginContact, EndContact, PreSolve, PostSolve)
end

function Level:Destroy()
    mEntityManager:RemoveAllEntities()
end

function Level:SelectInsectTime()
	self.insectTimer = 0
	self.insectTime = math.random(math.max(0, 11.0 - self.stage * 0.5), math.max(20.0 / self.stage, 14.0 - self.stage * 0.5))
end

function Level:GetRandomBorderPosition(offset)
    local position = Vector(0, 0)
    local horizontal = math.random() > 0.5
    if horizontal == true then
        if math.random() > 0.5 then
            position.x = offset
        else
            position.x = WORLD_MAX_X - offset
        end
        position.y = math.random(offset, WORLD_MAX_Y - offset)
    else
        if math.random() > 0.5 then
            position.y = offset
        else
            position.y = WORLD_MAX_Y - offset
        end
        position.x = math.random(offset, WORLD_MAX_X - offset)
    end
    return(position)
end

function Level:GetEntityManager()
    return(mEntityManager)
end

function Level:SetStageNum(stageNum)
    self.stage = stageNum
end

function Level:GetStageNum()
    return(self.stage)
end

function Level:GetScore()
    return(self.score)
end

function Level:CheckWinState()
    local roundOver = true

    local sheep = mEntityManager:GetEntitiesByTags({ 'sheep' })
    for i=1,#sheep do
        if sheep[i] ~= nil and not sheep[i]:IsKilled() then
            roundOver = false
            break
        end
    end

    return(roundOver)
end

function Level:EndRound()
    if self.remainingSheep > 0 then
        self:OnRoundWin()
        return true
    else
        self:OnGameOver()
        return false
    end
end

function Level:OnRoundWin()
    mSounds.roundWin:play()
    self:SetStageNum(self:GetStageNum() + 1)
    self:Load()
end

function Level:OnGameOver()

end

local function GetEntitiesByFixtures(a, b)
    local entities = mEntityManager:GetEntities()
    local entityA, entityB = nil, nil
    for i=1,#entities do
        if entities[i].physics ~= nil then
            if entities[i].physics.fixture == a then
                entityA = entities[i]
            elseif entities[i].physics.fixture == b then
                entityB = entities[i]
            end
        end
        if entityA ~= nil and entityB ~= nil then
            return entityA, entityB
        end
    end
end

function BeginContact(a, b, coll)
    if a:getUserData() ~= b:getUserData() then
        local entityA, entityB = GetEntitiesByFixtures(a, b)
        if entityA ~= nil and entityA:is(Avatar) and entityB ~= nil and entityB:is(Avatar) then
            if entityA:GetFaction() ~= entityB:GetFaction() then
                entityA:Attack(entityB)
                entityB:Attack(entityA)
                mCheckWinState = true
            end
        end
    end
end
 
function EndContact(a, b, coll)
 
end
 
function PreSolve(a, b, coll)
 
end
 
function PostSolve(a, b, coll, normalimpulse, tangentimpulse)
 
end