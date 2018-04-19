local Team = {}
Team.__index = Team

local NAMES = {"Albert", "Bertha", "Charlie", "Douglas", "Erin", "Frances", "Gerrard", "Horace"}
local name_index = 1

function Team.new(name, manager, home_colour, away_colour)
    local self = {}
    setmetatable(self, Team)

    self.name        = name
    self.manager     = manager
    self.home_colour = home_colour
    self.away_colour = away_colour
    self.ais = {}
    -- @TODO: Think about security. 
    --        Is this hack of temporarily disabling require and love.filesystem good enough?
    --        Do I need to set up a sandbox when loading the chunk?
    local saved_require = require
    require = function() end
    for _, filename in pairs(love.filesystem.getDirectoryItems("")) do 
        -- @TODO: the filepath used to be '.' but this no longer works. An empty filepath seems to do the trick
        --        but bare this in mind.
        if filename:match("ai_%w+_[%w_]+.lua") then
            local i = filename:find("_", 4)
            local j = filename:find("%.")
            local author_name = filename:sub(4, i-1)
            local ai_name = filename:sub(i+1, j-1)
            if author_name == self.manager.username then
                local ai_chunk = love.filesystem.load(filename)

                local saved_love_filesystem = love.filesystem
                love.filesystem = {}
                self.ais[ai_name] = ai_chunk()
                love.filesystem = saved_love_filesystem
            end
        end
    end
    require = saved_require
    -- @TODO: get from team management
    self.available_players = {}
    table.insert(self.available_players, 
        (require 'cls_player').new(self, NAMES[name_index], 1, self.ais["test_gk"])
    )
    name_index = name_index + 1
    table.insert(self.available_players, 
        (require 'cls_player').new(self, NAMES[name_index], 2, self.ais["test"])
    )
    name_index = name_index + 1
    table.insert(self.available_players, 
        (require 'cls_player').new(self, NAMES[name_index], 3, self.ais["idle"])
    )
    name_index = name_index + 1
  
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