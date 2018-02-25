local Team = {}
Team.__index = Team

function Team.new(name, colour, manager)
    local self = {}
    setmetatable(self, Team)

    self.name    = name
    self.colour  = colour
    self.manager = manager or {}
    self.ais = {}
    for _, filename in pairs(love.filesystem.getDirectoryItems(".")) do
        if filename:match("ai_%w+_%w+.lua") then
            local i = filename:find("_", 4)
            local j = filename:find("%.")
            local author_name = filename:sub(4, i-1)
            local ai_name = filename:sub(i+1, j-1)
            if author_name == self.manager.username or "huwt" then
                self.ais[ai_name] = love.filesystem.load(filename)()
            end
        end
    end
    self.starting_players = {
        -- @TODO: get from team management
        (require 'cls_player').new("A", 1, self.ais["test"], self),
        (require 'cls_player').new("B", 2, self.ais["test"], self),
        (require 'cls_player').new("C", 3, self.ais["test"], self),
    }
    self.interrupts = {
        -- @TODO: get from team management
        "Press",
        "Fall back",
        "Attack",
    }

    return self
end

return Team