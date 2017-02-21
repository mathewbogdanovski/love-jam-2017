require "catui"
Vector = require "Libraries.hump.vector"
Ripple = require "Libraries.ripple.ripple"

mGameover = false
mHighscore = 0
mLevel = nil
mSoundTags = {
    sfx = Ripple.newTag(),
    music = Ripple.newTag(),
    master = Ripple.newTag()
}
mSounds = {
    sheepSaved = Ripple.newSound('Assets/Audio/Sound/sheepsaved.ogg', {tags = {mSoundTags.sfx, mSoundTags.master}}),
    sheepKilled = Ripple.newSound('Assets/Audio/Sound/sheepkilled.ogg', {tags = {mSoundTags.sfx, mSoundTags.master}}),
    insectKilled = Ripple.newSound('Assets/Audio/Sound/insectkilled.ogg', {tags = {mSoundTags.sfx, mSoundTags.master}}),
    roundWin = Ripple.newSound('Assets/Audio/Sound/roundwin.ogg', {tags = {mSoundTags.sfx, mSoundTags.master}})
}
mMusic = {
  gameplay = Ripple.newSound('Assets/Audio/Music/gameplay.ogg', {
    bpm = 130,
    length = '150s',
    loop = true,
    tags = {mSoundTags.music, mSoundTags.master},
  })
}

Object = require "Libraries.classic.classic"
require "level"

Assets = require("Libraries.cargo.cargo").init("Assets")

local Gamestate = require "Libraries.hump.gamestate"

--Screen to world scale--
gWorldToScreenX = 1.0
gWorldToScreenY = 1.0

--States--
local mMenuState = {}
local mGameState = {}
local mPauseState = {}

local function initWindow()
    love.window.setTitle("Game name")
    love.window.setIcon(love.image.newImageData("Assets/Graphics/Sheep.png"))
    love.window.setMode(1920, 1080, { fullscreen=true, resizable=true, minwidth=400, minheight=300})

    gWorldToScreenX = love.graphics.getWidth() / WORLD_MAX_X
    gWorldToScreenY = love.graphics.getHeight() / WORLD_MAX_Y
end

local function loadHighscore()
    if not love.filesystem.exists("data") then
        love.filesystem.newFile("data")
        love.filesystem.write("data", "highscore\n=\n" .. 20)
    end
    local saveData = {}
    for lines in love.filesystem.lines("data") do
        table.insert(saveData, lines)
    end
    mHighscore = tonumber(saveData[3])
end

function love.load()
    initWindow()

    local cursor = love.mouse.newCursor("Assets/Graphics/UI/Cursor.png",5, 8)
    love.mouse.setCursor(cursor)

    mUIManager = UIManager:getInstance()
    
    mPhysicsWorld = love.physics.newWorld(0, 0, true)

    loadHighscore()

    Gamestate.registerEvents()
    Gamestate.switch(mMenuState)

    mMusic.gameplay:play()
end

function love.draw()

end

function love.update(dt)
    for _, m in pairs(mMusic) do
        m:update(dt)
    end
end

function love.resize(w, h)
    gWorldToScreenX = w / WORLD_MAX_X
    gWorldToScreenY = h / WORLD_MAX_Y
end

--------------- MENU STATE ---------------

local function loadCommonUI(content)
    local instructions = "Safely escort the shepherds and sheep across the fields (to the right) for as long as possible. \n\n Left click to herd. Hold shift to herd faster. \n Right click to squash bugs. \n Sheep follow closest shepherds. Wolves are afraid of shepherds."
    local instructionsLabel = UILabel:new("Assets/Fonts/expressway rg.ttf", instructions, 24)
    instructionsLabel:setPos(350, 25)
    instructionsLabel:setAnchor(0, 0)
    instructionsLabel:setSize(800, 600)
    instructionsLabel:setAutoSize(false)
    instructionsLabel:setFontColor({0, 100, 0, 255})
    mUIManager.rootCtrl.coreContainer:addChild(instructionsLabel)

    local titleLabel = UILabel:new("Assets/Fonts/expressway rg.ttf", "Shepherd's Hand", 30)
    titleLabel:setPos(30, 0)
    titleLabel:setAnchor(0, 0)
    titleLabel:setSize(300, 100)
    titleLabel:setAutoSize(false)
    content:addChild(titleLabel)

    local highscoreLabel = UILabel:new("Assets/Fonts/expressway rg.ttf", "High Score: " .. mHighscore, 24)
    highscoreLabel:setPos(65, 150)
    highscoreLabel:setAnchor(0, 0)
    highscoreLabel:setSize(300, 100)
    highscoreLabel:setAutoSize(false)
    content:addChild(highscoreLabel)

    if mGameover == true then
        highscoreLabel = UILabel:new("Assets/Fonts/expressway rg.ttf", "Game Over\nFinal Score \n        " .. mLevel:GetScore() .. '  ', 30)
        highscoreLabel:setFontColor({255, 255, 255, 255})
        highscoreLabel:setPos(60, 250)
        highscoreLabel:setAnchor(0, 0)
        highscoreLabel:setSize(300, 100)
        highscoreLabel:setAutoSize(false)
        content:addChild(highscoreLabel)
        mGameover = false
    end
end

local function loadMainMenu()
    local content = UIContent:new()
    content:setPos(20, 20)
    content:setSize(300, 450)
    content:setContentSize(500, 500)
    mUIManager.rootCtrl.coreContainer:addChild(content)

    local buttonA = UIButton:new()
    buttonA:setPos(100, 50)
    buttonA:setText("START")
    --buttonA:setIcon("Assets/Graphics/Sprites/box.png")
    buttonA:setAnchor(0, 0)

    buttonA.events:on(UI_CLICK, function()
        if mLevel ~= nil then
            mLevel:Destroy()
        end
        mLevel = Level()
        mLevel:SetStageNum(1)
        mLevel:Load()
        Gamestate.switch(mGameState)
    end, buttonA)

    content:addChild(buttonA)

    local buttonB = UIButton:new()
    buttonB:setPos(100, 90)
    buttonB:setText("QUIT")
    buttonB:setAnchor(0, 0)

    buttonB.events:on(UI_CLICK, function()
        love.event.quit()
    end, buttonB)

    content:addChild(buttonB)

    loadCommonUI(content)
end

function mMenuState:enter()
    mUIManager:init()
    loadMainMenu()
end

function mMenuState:draw()
    mUIManager:draw()
end

function mMenuState:update(dt)
    mUIManager:update(dt)
end

function mMenuState:keypressed(key)
    if key == "escape" then
        return love.event.quit()
    end
    mUIManager:keyDown(key, scancode, isrepeat)
end

function mMenuState:mousemoved(x, y, dx, dy)
    mUIManager:mouseMove(x, y, dx, dy)
end

function mMenuState:mousepressed(x, y, button, isTouch)
    mUIManager:mouseDown(x, y, button, isTouch)
end

function mMenuState:mousereleased(x, y, button, isTouch)
    mUIManager:mouseUp(x, y, button, isTouch)
end

function mMenuState:keyreleased(key)
    mUIManager:keyUp(key)
end

function mMenuState:wheelmoved(x, y)
    mUIManager:whellMove(x, y)
end

function mMenuState:textinput(text)
    mUIManager:textInput(text)
end

--------------- GAME STATE ---------------

local mScoreLabel = nil

local function loadGameUI()
    mScoreLabel = UILabel:new("Assets/Fonts/expressway rg.ttf", "Score: " .. mLevel:GetScore(), 24)
    mScoreLabel:setAnchor(0, 0)
    mScoreLabel:setSize(100, 100)
    mScoreLabel:setAutoSize(false)
    mUIManager.rootCtrl.coreContainer:addChild(mScoreLabel)
end

function mGameState:enter()
    mUIManager:init()
    loadGameUI()
end

function mGameState:draw()
    mLevel:draw()
    mUIManager:draw()
end

function mGameState:update(dt)
    mUIManager:update(dt)
    mPhysicsWorld:update(dt)
    mLevel:update(dt)
end

function mGameState:keypressed(key)
    if key == "escape" then
        return Gamestate.push(mPauseState)
    end
    mUIManager:keyDown(key, scancode, isrepeat)
end

function mGameState:mousemoved(x, y, dx, dy)
    mUIManager:mouseMove(x, y, dx, dy)
end

function mGameState:mousepressed(x, y, button, isTouch)
    mUIManager:mouseDown(x, y, button, isTouch)

    if button == 2 then
        local insects = mLevel:GetEntityManager():GetEntitiesByTypes({ Insect })
        for i=1,#insects do
            if insects[i]:RaycastMouse() == true then
                insects[i]:Kill()
            end
        end
    end
end

function mGameState:mousereleased(x, y, button, isTouch)
    mUIManager:mouseUp(x, y, button, isTouch)
end

function mGameState:keyreleased(key)
    mUIManager:keyUp(key)
end

function mGameState:wheelmoved(x, y)
    mUIManager:whellMove(x, y)
end

function mGameState:textinput(text)
    mUIManager:textInput(text)
end

UpdateScore = function()
    mScoreLabel:setText("Score: " .. mLevel:GetScore())
end

CheckWinState = function()
    if mLevel:CheckWinState() == true then
        if mLevel:GetScore() > mHighscore then
            mHighscore = mLevel:GetScore()
            love.filesystem.write("data", "highscore\n=\n" .. mHighscore)
        end
        if mLevel:EndRound() == true then
        else
            mGameover = true
            Gamestate.switch(mMenuState)
        end
    end
end

--------------- PAUSE STATE ---------------

local function loadPauseMenu()
    local content = UIContent:new()
    content:setPos(20, 20)
    content:setSize(300, 450)
    content:setContentSize(500, 500)
    mUIManager.rootCtrl.coreContainer:addChild(content)

    local buttonA = UIButton:new()
    buttonA:setPos(100, 50)
    buttonA:setText("RESUME")
    buttonA:setAnchor(0, 0)

    buttonA.events:on(UI_CLICK, function()
        Gamestate.pop(mPauseState)
        Gamestate.switch(mGameState)
    end, buttonA)

    content:addChild(buttonA)

    local buttonB = UIButton:new()
    buttonB:setPos(100, 90)
    buttonB:setText("MAIN MENU")
    buttonB:setAnchor(0, 0)

    buttonB.events:on(UI_CLICK, function()
        Gamestate.switch(mMenuState)
    end, buttonB)

    content:addChild(buttonB)

    loadCommonUI(content)
end

function mPauseState:enter()
    mUIManager:init()
    loadPauseMenu()
end

function mPauseState:draw()
    mUIManager:draw()
end

function mPauseState:update(dt)
    mUIManager:update(dt)
end

function mPauseState:keypressed(key)
    if key == "escape" then
        Gamestate.pop(mPauseState)
        return Gamestate.switch(mGameState)
    end
    mUIManager:keyDown(key, scancode, isrepeat)
end

function mPauseState:mousemoved(x, y, dx, dy)
    mUIManager:mouseMove(x, y, dx, dy)
end

function mPauseState:mousepressed(x, y, button, isTouch)
    mUIManager:mouseDown(x, y, button, isTouch)
end

function mPauseState:mousereleased(x, y, button, isTouch)
    mUIManager:mouseUp(x, y, button, isTouch)
end

function mPauseState:keyreleased(key)
    mUIManager:keyUp(key)
end

function mPauseState:wheelmoved(x, y)
    mUIManager:whellMove(x, y)
end

function mPauseState:textinput(text)
    mUIManager:textInput(text)
end