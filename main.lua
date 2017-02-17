--! file: main.lua
require "catui"

Assets = require("Libraries.cargo.cargo").init("Assets")
Gamestate = require "Libraries.hump.gamestate"

local mMenuState = {}
local mGameState = {}
local mPauseState = {}

local function loadMainMenu()
	mainMenuMgr = UIManager:getInstance()
    local content = UIContent:new()
    content:setPos(20, 20)
    content:setSize(300, 450)
    content:setContentSize(500, 500)
    mainMenuMgr.rootCtrl.coreContainer:addChild(content)
    local buttonA = UIButton:new()
    buttonA:setPos(10, 10)
    buttonA:setText("START")
    buttonA:setIcon("Assets/Graphics/Sprites/box.png")
    buttonA:setAnchor(0, 0)
    content:addChild(buttonA)
end

local function loadPauseMenu()
	pauseMenuMgr = UIManager:getInstance()
    local content = UIContent:new()
    content:setPos(20, 20)
    content:setSize(300, 450)
    content:setContentSize(500, 500)
    pauseMenuMgr.rootCtrl.coreContainer:addChild(content)
end

function love.load()
	Object = require "Libraries.classic.classic"
	require "sprite"
	require "entity"

	--local cursor = love.mouse.newCursor("Assets/Graphics/UI/cursor.png", 0, 0)
	--love.mouse.setCursor(cursor)

	loadMainMenu()
	loadPauseMenu()

	entity = Entity(Assets.Graphics.Sprites.box, 100, 100, 1, 1, 100)

	Gamestate.registerEvents()
	Gamestate.switch(mMenuState)
end

function love.draw()

end

function love.update(dt)

end

--------------- MENU STATE ---------------

function mMenuState:draw()
    mainMenuMgr:draw()
    entity:draw()
end

function mMenuState:update(dt)
	mainMenuMgr:update(dt)
	entity:update(dt)
end

function mMenuState:keypressed(key)
	if key == "escape" then
		return love.event.quit()
	end
end

function mMenuState:mousemoved(x, y, dx, dy)
    mainMenuMgr:mouseMove(x, y, dx, dy)
end

function mMenuState:mousepressed(x, y, button, isTouch)
    mainMenuMgr:mouseDown(x, y, button, isTouch)
end

function mMenuState:mousereleased(x, y, button, isTouch)
    mainMenuMgr:mouseUp(x, y, button, isTouch)
end

function mMenuState:keypressed(key, scancode, isrepeat)
    mainMenuMgr:keyDown(key, scancode, isrepeat)
end

function mMenuState:keyreleased(key)
    mainMenuMgr:keyUp(key)
end

function mMenuState:wheelmoved(x, y)
    mainMenuMgr:whellMove(x, y)
end

function mMenuState:textinput(text)
    mainMenuMgr:textInput(text)
end

--------------- GAME STATE ---------------

function mGameState:enter()

end

function mGameState:keypressed(key)
	if key == "escape" then
		return Gamestate.push(mPauseState)
	end
end

--------------- PAUSE STATE ---------------

function mPauseState:enter()

end

function mPauseState:draw()
	pauseMenuMgr:draw()
end

function mPauseState:update(dt)
	pauseMenuMgr:update(dt)
end

function mPauseState:keypressed(key)
	if key == "escape" then
		return Gamestate.pop(mPauseState)
	end
end

function mPauseState:mousemoved(x, y, dx, dy)
    pauseMenuMgr:mouseMove(x, y, dx, dy)
end

function mPauseState:mousepressed(x, y, button, isTouch)
    pauseMenuMgr:mouseDown(x, y, button, isTouch)
end

function mPauseState:mousereleased(x, y, button, isTouch)
    pauseMenuMgr:mouseUp(x, y, button, isTouch)
end

function mPauseState:keypressed(key, scancode, isrepeat)
    pauseMenuMgr:keyDown(key, scancode, isrepeat)
end

function mPauseState:keyreleased(key)
    pauseMenuMgr:keyUp(key)
end

function mPauseState:wheelmoved(x, y)
    pauseMenuMgr:whellMove(x, y)
end

function mPauseState:textinput(text)
    pauseMenuMgr:textInput(text)
end