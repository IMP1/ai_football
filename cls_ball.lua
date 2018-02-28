local Object = require 'cls_object'

local Ball = {}
setmetatable(Ball, Object)
Ball.__index = Ball

local EPSILON = 0.001

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
        self:applyForce(vec3(0, 0, -1) * self.mass * game.pitch.gravity * dt)
    end
    if self.position.z < 0 then
        local oldZ = self.position.z - self.linear_velocity.z * dt
        local dz = self.position.z - oldZ
        local newZ = dz - oldZ * game.pitch.bounce
        self.linear_velocity.z = self.linear_velocity.z * -game.pitch.bounce
    end
    if math.abs(self.position.z) < EPSILON and math.abs(self.linear_velocity.z) < EPSILON then
        self.position.z = 0
        self.linear_velocity.z = 0
    end
    local current_speed = self.linear_velocity:magnitude()
    if current_speed > 0 then
        if self.position.z > 0 then
            local air_resistance = -self.linear_velocity:normalise() * current_speed * game.pitch.air_resistance * dt
            self:applyForce(air_resistance)
        else
            local friction = -self.linear_velocity:normalise() * current_speed * game.pitch.friction * dt
            self:applyForce(friction)
        end
    end
end

function Ball:draw(ox, oy, rotation, scale)
    -- @TODO: take offset (ox and oy) into account
    local x, y, z = unpack(self.position:rotate(0, 0, -rotation).data)

    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.circle("fill", x * scale, y * scale, self.size * scale)
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", 
        (x - z * math.cos(rotation)) * scale, (y - z * math.sin(rotation)) * scale, 
        self.size * scale)
    
    -- @TODO: test the ball's shadow.
end

return Ball