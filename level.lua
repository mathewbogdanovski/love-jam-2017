Level = Object:extend()

require "entity"

function Level:new(stageNum)
	self.stage = stageNum
	self.entities = {}
end

function Level:draw()

end

function Level:update(dt)

end

function Level:load()
	
end