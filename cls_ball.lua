local Object = require 'cls_object'

local Ball = {}
setmetatable(Ball, Object)
Ball.__index = Ball

function Ball.new(x, y)
    local self = Object.new(x, y, 0)
    setmetatable(self, Ball)

    self.mass = 0.45 -- kg
    self.spin = 0
    self.size = 0.8 -- meters

    return self
end

function Ball:update(dt, game)
    Object.update(self, dt)
    if self.position.z > 0 then
        self:applyForce(vec3(0, 0, -1) * self.mass * game.pitch.gravity)
    end
    if self.position.z < 0 then
        local oldZ = self.position.z - self.linear_velocity.z * dt
        local dz = self.position.z - oldZ
        local newZ = dz - oldZ * game.pitch.bounce
        self.linear_velocity.z = self.linear_velocity.z * -game.pitch.bounce
    end
    -- @TODO: apply friction and/or air resistance
end

function Ball:draw(rotation)
    local x, y, z = unpack(self.position.data)
    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.circle("fill", x, y, self.size)
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", x + z * math.cos(rotation), y + z * math.sin(rotation), self.size)
    -- @TODO: test the ball's shadow.
end

return Ball