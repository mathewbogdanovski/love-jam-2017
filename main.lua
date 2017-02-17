--! file: main.lua
Gamestate = require "Libraries.hump.gamestate"
Assets = require("Libraries.cargo.cargo").init("Assets")

local mMenuState = {}
local mGameState = {}

function love.load()
	Object = require "Libraries.classic.classic"
	require "sprite"
	require "entity"
	e1 = Entity(Assets.Graphics.Sprites.box, 100, 100, 1, 1, 100)
	e2 = Entity(Assets.Graphics.Sprites.box, 300, 300, 1, 1, 100)

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