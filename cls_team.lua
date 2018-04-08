local Team = {}
Team.__index = Team

function Team.new(name, manager, home_colour)
    local self = {}
    setmetatable(self, Team)

    self.name    = name
    self.manager = manager or {}
    self.home_colour  = home_colour
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
    self.available_players = {
        (require 'cls_player').new(self, "A", 1, self.ais["test"]),
        (require 'cls_player').new(self, "B", 2, self.ais["idle"]),
        (require 'cls_player').new(self, "C", 3, self.ais["idle"]),
    } -- @TODO: get from team management
    self.starting_players = {} -- @TODO: get from team management
    for _, player in pairs(self.available_players) do table.insert(self.starting_players, player) end
    self.interrupts = {
        -- @TODO: get from team management
        "Press",
        "Fall back",
        "Attack",
    }

    return self
end

return Team