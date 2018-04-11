local gui_manager = require 'lib_gui_manager'

local List          = require 'lib_gui_scroll_list'
local Button        = require 'lib_gui_button'
local Text          = require 'lib_gui_text'
local TextInput     = require 'lib_gui_text_input'
local ColourPalette = require 'lib_gui_colour_palette'

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
        position = {cx-w/2, 224},
        size     = {w, 32},
        text     = T"New Team",    
    }))
    table.insert(new_team, ColourPalette.new({
        position = {cx - w/2, 256},
        size     = {w, w},
    }))

    gui_manager.register('team_list', root)
    gui_manager.register('new_team', new_team)
    gui_manager.open('team_list')
end

function Training:draw()
    love.graphics.setColor(1, 1, 1)
end

return Training
