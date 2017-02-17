--! file: physicsentity.lua
PhysicsEntity = Entity:extend()

function PhysicsEntity:new(image, x, y, w, h)
	PhysicsEntity.super.new(self, image, x, y)
	self.body = love.physics.newBody(physicsWorld, x, y, "dynamic")
	self.shape = love.physics.newRectangleShape(0, 0, 50, 100)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
end

function PhysicsEntity:update(dt)
	PhysicsEntity.super.update(dt)
	self.position.x = self.body:getX()
	self.position.y = self.body:getY()
end