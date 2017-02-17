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

	--local cursor = love.mouse.newCursor("Assets/Graphics/UI/cursor.png", 0, 0)
	--love.mouse.setCursor(cursor)

	Gamestate.registerEvents()
	Gamestate.switch(mMenuState)
end

function love.draw()

end

function love.update(dt)

end

function mMenuState:draw()
    e1:draw()
    e2:draw()
end

function mMenuState:update(dt)
	e1:update(dt)
    e2:update(dt)
end

function mMenuState:keypressed(key)

end

function mGameState:enter()

end