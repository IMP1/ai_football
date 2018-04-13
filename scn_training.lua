local gui_manager = require 'gui_gui_manager'

local List          = require 'gui_scroll_list'
local Button        = require 'gui_button'
local Text          = require 'gui_text'
local TextInput     = require 'gui_text_input'
local ColourPalette = require 'gui_colour_palette'

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
    gui_manager.reset()

    local root = {}
    local team_list = {}
    -- @TODO: load list of teams

    local cx, cy = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2
    local w = 192
    table.insert(root, Button.new({
        position = {cx - w/2, 128},
        size     = {w, 32},
        text     = T"Create New Team",
        onclick  = function()
            gui_manager.close('team_list')
            gui_manager.open('new_team')
        end,
    }))
    table.insert(root, Text.new({
        position = {cx - w/2, 224},
        size     = {w, 32},
        text     = T"My Teams",
    }))
    table.insert(root, List.new({
        position = {cx - w/2, 256},
        size     = {w, 128},
        items    = team_list,
    }))

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
    table.insert(new_team, TextInput.new({
        position    = {cx - w/2, 192},
        size        = {w, 24},
        placeholder = nil,
    }))
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
        position = {cx - w/2, 344},
        size     = {w, 32},
        text     = T"Create Team",
        onclick  = function()

        end,
    }))
    table.insert(new_team, away_colour)
    table.insert(new_team, home_colour)

    gui_manager.register('team_list', root)
    gui_manager.register('new_team', new_team)
    gui_manager.open('team_list')
end

function Training:draw()
    love.graphics.setColor(1, 1, 1)
end

return Training
