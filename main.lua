--! file: main.lua
require "catui"

Vector = require "Libraries.hump.vector"

Object = require "Libraries.classic.classic"
require "level"

Assets = require("Libraries.cargo.cargo").init("Assets")

local Gamestate = require "Libraries.hump.gamestate"

--States--
local mMenuState = {}
local mGameState = {}
local mPauseState = {}

--Game Globals--
local mLevel = nil

local function initWindow()
    love.window.setTitle("Game name")
    love.window.setIcon(love.image.newImageData("Assets/Graphics/Sheep.png"))
    love.graphics.setBackgroundColor(0, 100, 0, 255)
end

function love.load()
    initWindow()

    --local cursor = love.mouse.newCursor("Assets/Graphics/UI/cursor.png", 0, 0)
    --love.mouse.setCursor(cursor)

    mUIManager = UIManager:getInstance()
    
    mPhysicsWorld = love.physics.newWorld(0, 0, true)

    Gamestate.registerEvents()
    Gamestate.switch(mMenuState)
end

function love.draw()

end

function love.update(dt)

end

function love.resize(w, h)
    PHYSICS_TO_WORLD_X = w / WORLD_MAX_X
    PHYSICS_TO_WORLD_Y = h / WORLD_MAX_Y
end

--------------- MENU STATE ---------------

local function loadMainMenu()
    local content = UIContent:new()
    content:setPos(20, 20)
    content:setSize(300, 450)
    content:setContentSize(500, 500)
    mUIManager.rootCtrl.coreContainer:addChild(content)

    local buttonA = UIButton:new()
    buttonA:setPos(10, 10)
    buttonA:setText("START")
    --buttonA:setIcon("Assets/Graphics/Sprites/box.png")
    buttonA:setAnchor(0, 0)

    buttonA.events:on(UI_CLICK, function()
        mLevel = Level()
        mLevel:SetStageNum(1)
        mLevel:Load()
        Gamestate.switch(mGameState)
    end, buttonA)

    content:addChild(buttonA)

    local buttonB = UIButton:new()
    buttonB:setPos(10, 50)
    buttonB:setText("QUIT")
    buttonB:setAnchor(0, 0)

    buttonB.events:on(UI_CLICK, function()
        love.event.quit()
    end, buttonB)

    content:addChild(buttonB)
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

local function loadGameUI()

end

function mGameState:enter()
    mUIManager:init()
    loadGameUI()
end

function mGameState:draw()
    mLevel:draw()
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

--------------- PAUSE STATE ---------------

local function loadPauseMenu()
    local content = UIContent:new()
    content:setPos(20, 20)
    content:setSize(300, 450)
    content:setContentSize(500, 500)
    mUIManager.rootCtrl.coreContainer:addChild(content)

    local buttonA = UIButton:new()
    buttonA:setPos(10, 10)
    buttonA:setText("MAIN MENU")
    --buttonA:setIcon("Assets/Graphics/Sprites/box.png")
    buttonA:setAnchor(0, 0)

    buttonA.events:on(UI_CLICK, function()
        Gamestate.switch(mMenuState)
    end, buttonA)

    content:addChild(buttonA)
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