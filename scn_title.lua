local Scene        = require 'scn_base'
local Game         = require 'scn_game'

local gui_manager = require 'gui_gui_manager'
local scn_manager = require 'scn_scn_manager'

local Button = require 'gui_button'

local Title = {}
setmetatable(Title, Scene)
Title.__index = Title

function Title.new()
    local self = Scene.new("title")
    setmetatable(self, Title)

    local team1 = require 'cls_team'.new("Ridge Rovers United FC", player_data.manager, {0, 0.375, 1})
    local team2 = require 'cls_team'.new("Firelight United", player_data.manager, {1, 0, 0})
    self.background_game = Game.new(team1, team2)
    self.background_game:load()

    return self
end

Title.GUI_MENU_ID = "title"

function Title:load()
    local menu = {}
    local j = 172

    table.insert(menu, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"Singleplayer",
        onclick  = function()
            local next_scene = require('scn_singleplayer').new()
            next_scene:load()
            gui_manager.register('next_scene', next_scene.menu)
            gui_manager.open('next_scene')
            gui_manager.transitions.swipe('title', {0, 0}, {-love.graphics.getWidth(), 0}, 0.2)
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
        text     = T"Multiplayer",
        onclick  = function()
            if true then -- @TODO: check for a multiplayer profile
                -- @TODO: go to multiplayer menu
            else
                -- @TODO: go to multiplayer setup.
            end
        end,
        enabled = false,
    }))
    j = j + 64

    table.insert(menu, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"My Teams",
        onclick  = function()
            print("click")
        end,
        enabled = false,
    }))
    j = j + 64

    table.insert(menu, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"Options",
        onclick  = function()
            print("click")
        end,
        enabled = false,
    }))
    j = j + 64

    table.insert(menu, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"Quit",
        onclick  = function()
            love.event.quit()
        end,
    }))

    self.menu = menu
    gui_manager.register(self.GUI_MENU_ID, menu)
    gui_manager.open(self.GUI_MENU_ID)
end 

function Title:update(dt)
    self:backgroundUpdate(dt)
end

function Title:draw()
    self:backgroundDraw()
    love.graphics.setColor(1, 1, 1)
end

function Title:backgroundUpdate(dt)
    self.background_game:update(dt)
end

function Title:backgroundDraw()
    love.graphics.setColor(1, 1, 1)
    -- self.background_game:draw()
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

return Title