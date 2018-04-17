local Scene = require 'scn_base'

local gui_manager   = require 'gui_gui_manager'
local scn_manager = require 'scn_scn_manager'

local Button = require 'gui_button'

local Singleplayer = {}
setmetatable(Singleplayer, Scene)
Singleplayer.__index = Singleplayer

Singleplayer.GUI_MENU_ID = "singleplayer"

function Singleplayer.new()
    local self = Scene.new("singleplayer")
    setmetatable(self, Singleplayer)
    return self
end

function Singleplayer:load()
    local menu = {}
    local j = 172
    if true then -- @TODO: check for any existing careers.
        table.insert(menu, Button.new({
            position = {344, j},
            size     = {128, 32},
            text     = T"Continue Career",
            enabled  = false,
        }))
        j = j + 64
    end
    table.insert(menu, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"New Career",
        enabled  = false,
    }))
    j = j + 64
    table.insert(menu, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"Training Grounds",
        onclick  = function()
            local next_scene = require('scn_training').new()
            next_scene:load()
            gui_manager.register('next_scene', next_scene.menu)
            gui_manager.open('next_scene')
            gui_manager.transitions.swipe(self.GUI_MENU_ID, {0, 0}, {-love.graphics.getWidth(), 0}, 0.2)
            gui_manager.transitions.fade('next_scene', 0, 1, 0.2, function() 
                scn_manager.pushScene(next_scene)
                gui_manager.remove('next_scene')
            end)
        end,
    }))
    j = j + 64
    table.insert(menu, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"Back",
        onclick  = function()
            local prev_scene = scn_manager.peekScene()
            gui_manager.register('prev_scene', prev_scene.menu)
            gui_manager.open('prev_scene')
            gui_manager.transitions.fade(self.GUI_MENU_ID, 1, 0, 0.2)
            gui_manager.transitions.swipe('prev_scene', {-love.graphics.getWidth(), 0}, {0, 0}, 0.2, function()
                scn_manager.popScene()
                gui_manager.remove('prev_scene')
                gui_manager.reset(prev_scene.GUI_MENU_ID)
            end)
        end,
    }))
    gui_manager.register(self.GUI_MENU_ID, menu)
    gui_manager.open(self.GUI_MENU_ID, menu)
    self.menu = menu
end

return Singleplayer