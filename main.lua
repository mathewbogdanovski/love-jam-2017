--! file: main.lua
Gamestate = require "Libraries.hump.gamestate"

local mMenuState = {}
local mGameState = {}

function love.load()
	Object = require "Libraries.classic.classic"
	require "sprite"
	require "entity"
	e1 = Entity(100, 100, 100, 100, 100)
	e2 = Entity(300, 300, 200, 200, 100)

	Gamestate.registerEvents()
	Gamestate.switch(mMenuState)
end

function mMenuState:draw()
    e1:draw()
    e2:draw()
end

function mMenuState:update(dt)
	e1:update(dt)
    e2:update(dt)
end

function mGameState:enter()

end