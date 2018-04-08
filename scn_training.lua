local gui_manager = require 'lib_gui_manager'
local List = require 'lib_gui_scroll_list'

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

    table.insert(root, List.new({
        position = {256, 256},
        size     = {128, 128},
        items    = team_list,
    }))

    gui_manager.register('team_list', root)
    gui_manager.open('team_list')
end

function Training:update(dt)
    gui_manager.update(dt)
end

function Training:mouseScrolled(mx, my, dx, dy)
    gui_manager.mouseScrolled(mx, my, dx, dy)
end

function Training:draw()
    love.graphics.setColor(255, 255, 255)
    gui_manager.draw()
end

return Training
