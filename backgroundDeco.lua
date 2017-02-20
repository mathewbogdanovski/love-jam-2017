require 'entity'

BackgroundDeco = Entity:extend()

function BackgroundDeco:new(sprite, x,y)
    BackgroundDeco.super.new(self, sprite, x, y)
    self.layer = 0
    self.tag = 'bgDeco'
end

function BackgroundDeco:RegisterPhysics(w, h, type)
    self.physics = nil
end