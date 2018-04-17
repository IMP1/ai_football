local Manager = {}
Manager.__index = Manager

function Manager.new(username, name, teams)
    local self = {}
    setmetatable(self, Manager)

    self.username = username
    self.name     = name
    self.teams    = teams or {}

    return self
end

return Manager