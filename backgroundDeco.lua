require 'entity'

BackgroundDeco = Entity:extend()

function BackgroundDeco:new(sprite, x, y, layer)
    BackgroundDeco.super.new(self, sprite, x, y)
    self.layer = layer
    self.tag = 'bgDeco'
end

function BackgroundDeco:RegisterPhysics(w, h, type)
    self.physics = nil
end