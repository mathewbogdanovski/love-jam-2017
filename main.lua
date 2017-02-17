--! file: main.lua
require "catui"

Assets = require("Libraries.cargo.cargo").init("Assets")
Gamestate = require "Libraries.hump.gamestate"

local mMenuState = {}
local mGameState = {}
local mPauseState = {}

local function loadUIManager()
	uiManager = UIManager:getInstance()
    
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
end

function love.load()
	Object = require "Libraries.classic.classic"
	require "sprite"
	require "entity"

	--local cursor = love.mouse.newCursor("Assets/Graphics/UI/cursor.png", 0, 0)
	--love.mouse.setCursor(cursor)

	loadUIManager()

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
    uiManager:draw()
    entity:draw()
end

function mMenuState:update(dt)
	uiManager:update(dt)
	entity:update(dt)
end

function mMenuState:keypressed(key)
	if key == "escape" then
		return love.event.quit()
	end
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

function mMenuState:keypressed(key, scancode, isrepeat)
    uiManager:keyDown(key, scancode, isrepeat)
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

end

function mPauseState:update(dt)

end

function mPauseState:keypressed(key)
	if key == "escape" then
		return Gamestate.pop(mPauseState)
	end
end