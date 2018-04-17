local gui_manager = require 'gui_gui_manager'
local scn_manager = require 'scn_scn_manager'

local List          = require 'gui_scroll_list'
local Button        = require 'gui_button'
local Text          = require 'gui_text'
local TextInput     = require 'gui_text_input'
local ColourPalette = require 'gui_colour_palette'

local Team = require 'cls_team'

local Scene = require 'scn_base'

local Training = {}
setmetatable(Training, Scene)
Training.__index = Training

function Training.new()
    local self = Scene.new("Training")
    setmetatable(self, Training)

    return self
end

function Training:load()
    local root = {}

    local cx, cy = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2
    local w = 192

    local team_list
    table.insert(root, Button.new({
        position = {cx + 4, 288 + 48},
        size     = {w - 4, 32},
        text     = T"Back",
        onclick  = function()
            local next_scene = require('scn_singleplayer').new()
            next_scene:load()
            gui_manager.register('next_scene', next_scene.menu)
            gui_manager.open('next_scene')
            gui_manager.transitions.fade('team_list', 1, 0, 0.2)
            gui_manager.transitions.swipe('next_scene', {-love.graphics.getWidth(), 0}, {0, 0}, 0.2, function()
                scn_manager.popScene()
                gui_manager.remove('next_scene')
            end)
        end,
    }))

    table.insert(root, Button.new({
        position = {cx + 4, 192},
        size     = {w - 4, 32},
        text     = T"Create New Team",
        onclick  = function()
            gui_manager.close('team_list')
            gui_manager.open('new_team')
        end,
    }))

    table.insert(root, Text.new({
        position = {cx - w, 160},
        size     = {w - 4, 32},
        text     = T"My Teams",
    }))
    local edit_button = Button.new({
        position = {cx + 4, 240},
        size     = {w - 4, 32},
        text     = T"Edit",
        onclick  = function()
            local team = team_list.selected_item.data.team
            gui_manager.close("team_list")
            scn_manager.clearTo(require('scn_management').new(team))
        end,
    })
    edit_button.enabled = false
    table.insert(root, edit_button)
    local test_button = Button.new({
        position = {cx + 4, 288},
        size     = {w - 4, 32},
        text     = T"Test",
        onclick  = function() 
            -- @TODO: use value of team_list to get the team
            --        and then go to a scn_game scene for that 
            --        team against a house-built ai team
        end,
    })
    test_button.enabled = false
    table.insert(root, test_button)

    local teams = {}
    for _, team in ipairs(player_data.manager.teams) do
        table.insert(teams, Text.new({
            position = {0, #teams * 32},
            size     = {w, 24},
            text     = team.name,
            data     = {team = team},
        }))
    end
    team_list = List.new({
        position = {cx - w, 192},
        size     = {w - 4, 48 * 3 + 32},
        items    = teams,
        onselect = function()
            edit_button.enabled = true
            test_button.enabled = true
            -- @TODO: enable the edit and test buttons
        end,
    })
    table.insert(root, team_list)

    local new_team = {}
    table.insert(new_team, Text.new({
        position = {cx-w/2, 128},
        size     = {w, 32},
        text     = T"New Team",    
    }))
    table.insert(new_team, Text.new({
        position = {cx-w/2, 192 - 24},
        size     = {w, 24},
        text     = T"Team Name",    
    }))
    local name_input = TextInput.new({
        position    = {cx - w/2, 192},
        size        = {w, 24},
        placeholder = nil,
    })
    table.insert(new_team, name_input)
    table.insert(new_team, Text.new({
        position = {cx-3*w/4, 224},
        size     = {w, 24},
        text     = T"Home Colour",    
    }))
    table.insert(new_team, Text.new({
        position = {cx-w/4, 224},
        size     = {w, 24},
        text     = T"Away Colour",    
    }))
    local home_colour = ColourPalette.new({
        position = {cx - w/2 + 24, 256},
        size     = {w, w},
        value    = {1, 1, 1}
    })
    local away_colour = ColourPalette.new({
        position = {cx + 24, 256},
        size     = {w, w},
    })
    home_colour.onopen = function()
        away_colour.open    = false
        away_colour.enabled = false
        away_colour.opacity = 0
    end
    home_colour.onclose = function()
        away_colour.opacity = 1
        away_colour.enabled = true
    end
    table.insert(new_team, Button.new({
        position = {cx - w/2, 328},
        size     = {w / 2 - 4, 32},
        text     = T"Cancel",
        onclick  = function()
            gui_manager.close('new_team')
            gui_manager.open('team_list')
        end,
    }))
    table.insert(new_team, Button.new({
        position = {cx + 4, 328},
        size     = {w / 2 - 4, 32},
        text     = T"Create Team",
        onclick  = function()
            local name = name_input.value
            local manager = player_data.manager
            local home_colour = home_colour.value
            local away_colour = away_colour.value
            local team = Team.new(name, manager, home_colour, away_colour)

            table.insert(player_data.manager.teams, team)
            table.insert(team_list.items, Text.new({
                position = {0, #team_list.items * 32},
                size     = {w, 24},
                text     = name,
                data     = {team = team},
            }))

            gui_manager.close('new_team')
            gui_manager.open('team_list')
        end,
    }))
    table.insert(new_team, away_colour)
    table.insert(new_team, home_colour)

    gui_manager.register('team_list', root)
    gui_manager.register('new_team', new_team)
    gui_manager.open('team_list')

    self.menu = root
end

function Training:draw()
    love.graphics.setColor(1, 1, 1)
end

return Training
