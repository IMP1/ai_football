local Vector3 = require 'lib_vec3'

local Object = {}
Object.__index = Object

function Object.new(x, y, z)
    local self = {}
    setmetatable(self, Object)

    self.position        = vec3(x, y, z)
    self.linear_velocity = vec3(0, 0, 0)
    self.orientation     = {0, vec3(0, 0, 0)}
    self.mass            = 0
    self.spin            = 0

    return self
end

function Object:update(dt)
    self.position = self.position + self.linear_velocity * dt
end

function Object:applyForce(force)
    local accelleration = force / self.mass
    self.linear_velocity = self.linear_velocity + accelleration
end

return Object