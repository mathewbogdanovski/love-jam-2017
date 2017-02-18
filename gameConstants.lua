WORLD_MAX_X, WORLD_MAX_Y = love.graphics.getDimensions()
PHYSICS_TO_WORLD_X = love.graphics.getWidth() / WORLD_MAX_X
PHYSICS_TO_WORLD_Y = love.graphics.getHeight() / WORLD_MAX_Y

GC_FACTIONS = {
    NONE = 0,
    PLAYER = 1,
    WILD = 2
}