Level = Object:extend()

require "entitymanager"

local mEntityManager = nil
local mCheckWinState = false

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

	local sheep = mEntityManager:GetEntitiesByTypes({ Sheep })
	for i=1,#sheep do
		if sheep[i] ~= nil and not sheep[i]:IsKilled() then
			local sheepPos = sheep[i]:GetPosition()
			if sheepPos.x > WORLD_MAX_X then
				sheep[i]:Kill()
				mEntityManager:RemoveEntity(sheep[i])
				self.remainingSheep = self.remainingSheep + 1
				mCheckWinState = true
			elseif sheepPos.x < 0 or sheepPos.y > WORLD_MAX_Y or sheepPos.y < 0 then
				sheep[i]:Kill()
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
    self.remainingSheep = math.min(self.remainingSheep + 10, MAX_NUM_SHEEP)

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

        currCol = currCol + 1
        if currCol >= numColumns then
                currCol = 0
                currRow = currRow + 1
        end
    end

    self.remainingSheep = 0

    mEntityManager:CreateWolf(1600, 850)

    mPhysicsWorld:setCallbacks(BeginContact, EndContact, PreSolve, PostSolve)
end

function Level:Destroy()
	mEntityManager:RemoveAllEntities()
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

function Level:CheckWinState()
	local roundOver = true

	local sheep = mEntityManager:GetEntitiesByTypes({ Sheep })
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

local function KillEntityByFixture(fixture, tag)
	local entities = mEntityManager:GetEntitiesByTags({ tag })
	for i=1,#entities do
		if not entities[i]:IsKilled() and entities[i].physics.fixture == fixture then
			entities[i]:Kill()
			break
		end
	end
end

function BeginContact(a, b, coll)
	local aTag = a:getUserData()
	local bTag = b:getUserData()
	if aTag ~= bTag then
		if aTag == 'sheep' and bTag == 'enemy' then
			KillEntityByFixture(a, aTag)
			mCheckWinState = true
		elseif aTag == 'enemy' and bTag == 'sheep' then
			KillEntityByFixture(b, bTag)
			mCheckWinState = true
		end
	end
end
 
function EndContact(a, b, coll)
 
end
 
function PreSolve(a, b, coll)
 
end
 
function PostSolve(a, b, coll, normalimpulse, tangentimpulse)
 
end