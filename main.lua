--! file: main.lua
require "catui"

CScreen = require "Libraries.cscreen.cscreen"
Assets = require("Libraries.cargo.cargo").init("Assets")
Gamestate = require "Libraries.hump.gamestate"

--States--
local mMenuState = {}
local mGameState = {}
local mPauseState = {}

--Game Globals--
local mEntities = {}

local function initWindow()
    CScreen.init(800, 600, true)
    love.window.setTitle("Game name")
    love.window.setIcon(love.image.newImageData("Assets/Graphics/Sprites/box.png"))
end

function love.load()
    initWindow()

    --local cursor = love.mouse.newCursor("Assets/Graphics/UI/cursor.png", 0, 0)
    --love.mouse.setCursor(cursor)

    uiManager = UIManager:getInstance()

    physicsWorld = love.physics.newWorld(0, 0, true)

    Object = require "Libraries.classic.classic"
    require "entity"
    require "avatar"

    Gamestate.registerEvents()
    Gamestate.switch(mMenuState)
end

function love.draw()

end

function love.update(dt)

end

function love.resize(width, height)
    CScreen.update(width, height)
end

--------------- MENU STATE ---------------

local function loadMainMenu()
    local content = UIContent:new()
    content:setPos(20, 20)
    content:setSize(300, 450)
    content:setContentSize(500, 500)
    uiManager.rootCtrl.coreContainer:addChild(content)

    local buttonA = UIButton:new()
    buttonA:setPos(10, 10)
    buttonA:setText("START")
    --buttonA:setIcon("Assets/Graphics/Sprites/box.png")
    buttonA:setAnchor(0, 0)

    buttonA.events:on(UI_CLICK, function()
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
    uiManager:init()
    loadMainMenu()
end

function mMenuState:draw()
    CScreen.apply()

    CScreen.cease()

    uiManager:draw()
end

function mMenuState:update(dt)
    uiManager:update(dt)
end

function mMenuState:keypressed(key)
    if key == "escape" then
        return love.event.quit()
    end
    uiManager:keyDown(key, scancode, isrepeat)
end

function mMenuState:mousemoved(x, y, dx, dy)
    uiManager:mouseMove(x, y, dx, dy)
end

function mMenuState:mousepressed(x, y, button, isTouch)
    uiManager:mouseDown(x, y, button, isTouch)
end

function mMenuState:mousereleased(x, y, button, isTouch)
    uiManager:mouseUp(x, y, button, isTouch)
end

function mMenuState:keyreleased(key)
    uiManager:keyUp(key)
end

function mMenuState:wheelmoved(x, y)
    uiManager:whellMove(x, y)
end

function mMenuState:textinput(text)
    uiManager:textInput(text)
end

--------------- GAME STATE ---------------

local function loadGameUI()

end

function mGameState:enter()
    uiManager:init()
    loadGameUI()
    local entity = Entity(Assets.Graphics.Sprites.box, 100, 100)
    entity:CreatePhysics(64, 64, "dynamic")
    entity.physics.body:setLinearVelocity(50, 0)
    table.insert(mEntities, entity)
    entity = Entity(Assets.Graphics.Sprites.box, 400, 100)
    entity:CreatePhysics(64, 64, "dynamic")
    table.insert(mEntities, entity)
end

function mGameState:draw()
    CScreen.apply()

    for i=1,#mEntities do
        mEntities[i]:draw()
    end

    CScreen.cease()
end

function mGameState:update(dt)
    uiManager:update(dt)
    physicsWorld:update(dt)

    for i=1,#mEntities do
    mEntities[i]:update(dt)
    end
end

function mGameState:keypressed(key)
    if key == "escape" then
        return Gamestate.push(mPauseState)
    end
    uiManager:keyDown(key, scancode, isrepeat)
end

function mGameState:mousemoved(x, y, dx, dy)
    uiManager:mouseMove(x, y, dx, dy)
end

function mGameState:mousepressed(x, y, button, isTouch)
    uiManager:mouseDown(x, y, button, isTouch)
end

function mGameState:mousereleased(x, y, button, isTouch)
    uiManager:mouseUp(x, y, button, isTouch)
end

function mGameState:keyreleased(key)
    uiManager:keyUp(key)
end

function mGameState:wheelmoved(x, y)
    uiManager:whellMove(x, y)
end

function mGameState:textinput(text)
    uiManager:textInput(text)
end

--------------- PAUSE STATE ---------------

local function loadPauseMenu()
    local content = UIContent:new()
    content:setPos(20, 20)
    content:setSize(300, 450)
    content:setContentSize(500, 500)
    uiManager.rootCtrl.coreContainer:addChild(content)

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
    uiManager:init()
    loadPauseMenu()
end

function mPauseState:draw()
    CScreen.apply()
    
    CScreen.cease()

    uiManager:draw()
end

function mPauseState:update(dt)
    uiManager:update(dt)
end

function mPauseState:keypressed(key)
    if key == "escape" then
        Gamestate.pop(mPauseState)
        return Gamestate.switch(mGameState)
    end
    uiManager:keyDown(key, scancode, isrepeat)
end

function mPauseState:mousemoved(x, y, dx, dy)
    uiManager:mouseMove(x, y, dx, dy)
end

function mPauseState:mousepressed(x, y, button, isTouch)
    uiManager:mouseDown(x, y, button, isTouch)
end

function mPauseState:mousereleased(x, y, button, isTouch)
    uiManager:mouseUp(x, y, button, isTouch)
end

function mPauseState:keyreleased(key)
    uiManager:keyUp(key)
end

function mPauseState:wheelmoved(x, y)
    uiManager:whellMove(x, y)
end

function mPauseState:textinput(text)
    uiManager:textInput(text)
end