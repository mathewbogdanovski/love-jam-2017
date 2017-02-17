--! file: main.lua
require "catui"

Gamestate = require "Libraries.hump.gamestate"
Assets = require("Libraries.cargo.cargo").init("Assets")

local mMenuState = {}
local mGameState = {}
local mPauseState = {}

function love.load()
	Object = require "Libraries.classic.classic"
	require "sprite"
	require "entity"

	entity = Entity(Assets.Graphics.Sprites.box, 100, 100, 1, 1, 100)

	--local cursor = love.mouse.newCursor("Assets/Graphics/UI/cursor.png", 0, 0)
	--love.mouse.setCursor(cursor)

	Gamestate.registerEvents()
	Gamestate.switch(mMenuState)
end

function love.draw()

end

function love.update(dt)

end

--------------- MENU STATE ---------------

function mMenuState:draw()
    entity:draw()
end

function mMenuState:update(dt)
	entity:update(dt)
end

function mMenuState:keypressed(key)
	if key == "escape" then
		return love.event.quit()
	end
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

function mPauseState:keypressed(key)
	if key == "escape" then
		return Gamestate.pop(mPauseState)
	end
end