local Scene = require 'scn_base'

local Management = {}
setmetatable(Management, Scene)
Management.__index = Management

function Management.new()
    local self = Scene.new("management")
    setmetatable(self, Management)
    return self
end

function Management:draw()
    
end

return Management