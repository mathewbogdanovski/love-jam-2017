require 'entity'

BackgroundDeco = Entity:extend()

function BackgroundDeco:new(sprite, x, y, rot, layer)
    BackgroundDeco.super.new(self, sprite, x, y)
    self.layer = layer
    self.tag = 'bgDeco'

    self:SetRotation(rot)
end

function BackgroundDeco:RegisterPhysics(w, h, type)
    self.physics = nil
end