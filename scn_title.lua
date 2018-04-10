local Scene = require 'scn_base'
local Game  = require 'scn_game'

local gui_manager   = require 'lib_gui_manager'
local scene_manager = require 'scn_scn_manager'

local Button = require 'lib_gui_button'

local Title = {}
setmetatable(Title, Scene)
Title.__index = Title

function Title.new()
    local self = Scene.new("title")
    setmetatable(self, Title)
    return self
end

function Title:load()
    local team1 = require 'cls_team'.new("Ridge Rovers United FC", nil, {0, 0.375, 1})
    local team2 = require 'cls_team'.new("Firelight United", nil, {1, 0, 0})
    self.background_game = Game.new(team1, team2)
    self.background_game:load()

    gui_manager.reset()
    local title = {}
    local j = 172
    table.insert(title, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"Singleplayer",
        onclick  = function()
            if gui_manager.is_enabled('singleplayer') then return end
            gui_manager.close('multiplayer')
            gui_manager.show('singleplayer')
            gui_manager.transitions.fade('singleplayer', 0, 1, 0.2, function() gui_manager.enable('singleplayer') end)
            gui_manager.transitions.swipe('singleplayer', {0, 0}, {64, 0}, 0.2)
            gui_manager.transitions.swipe('title', {0, 0}, {-64, 0}, 0.2)
        end,
    }))
    j = j + 64
    table.insert(title, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"Multiplayer",
        onclick  = function()
            if true then -- @TODO: check for a multiplayer profile
                if gui_manager.is_enabled('multiplayer') then return end
                gui_manager.close('singleplayer')
                gui_manager.show('multiplayer')
                gui_manager.transitions.fade('multiplayer', 0, 1, 0.2, function() gui_manager.enable('multiplayer') end)
                gui_manager.transitions.swipe('multiplayer', {0, 0}, {64, 0}, 0.2)
                gui_manager.transitions.swipe('title', {0, 0}, {-64, 0}, 0.2)
            else
                -- @TODO: go to multiplayer setup.
            end
        end,
    }))
    j = j + 64
        table.insert(title, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"My Teams",
        onclick  = function()
            print("click")
        end,
    }))
    j = j + 64
    table.insert(title, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"Options",
        onclick  = function()
            print("click")
        end,
    }))
    j = j + 64
    table.insert(title, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"Quit",
        onclick  = function()
            love.event.quit()
        end,
    }))
    gui_manager.register('title', title)

    local singleplayer = {}
    local j = 236
    if true then -- @TODO: check for any existing careers.
        table.insert(singleplayer, Button.new({
            position = {344, j},
            size     = {128, 32},
            text     = T"Continue Career",
        }))
        j = j + 64
    end
    table.insert(singleplayer, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"New Career",
    }))
    j = j + 64
    table.insert(singleplayer, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"Training Grounds",
        onclick  = function()
            scene_manager.pushScene(require('scn_training').new())
        end,
    }))
    j = j + 64
    table.insert(singleplayer, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"Back",
        onclick  = function()
            gui_manager.disable('singleplayer')
            gui_manager.transitions.fade('singleplayer', 1, 0, 0.2, function() gui_manager.hide('singleplayer') end)
            gui_manager.transitions.swipe('singleplayer', {64, 0}, {0, 0}, 0.2)
            gui_manager.transitions.swipe('title', {-64, 0}, {0, 0}, 0.2)
        end,
    }))
    gui_manager.register('singleplayer', singleplayer)

    local multiplayer = {}
    local j = 172
    if true then -- @TODO: check for ongoing tournament
        table.insert(multiplayer, Button.new({
            position = {344, j},
            size     = {128, 32},
            text     = T"Continue Tournament",
        }))
        j = j + 64
    end
    table.insert(multiplayer, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"New Tournament",
    }))
    j = j + 64
    table.insert(multiplayer, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"New Friendly",
    }))
    j = j + 64
    table.insert(multiplayer, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"Profile",
    }))
    j = j + 64
    table.insert(multiplayer, Button.new({
        position = {344, j},
        size     = {128, 32},
        text     = T"Back",
        onclick  = function()
            gui_manager.switchTo('title')
        end
    }))
    j = j + 64
    gui_manager.register('multiplayer', multiplayer)

    gui_manager.open('title')
end 

function Title:update(dt)
    self:backgroundUpdate(dt)
    gui_manager.update(dt)
end

function Title:mouseReleased(mx, my)
    gui_manager.mouseReleased(mx, my)
end

function Title:draw()
    self:backgroundDraw()
    love.graphics.setColor(1, 1, 1)
    gui_manager.draw()
end

function Title:backgroundUpdate(dt)
    self.background_game:update(dt)
end

function Title:backgroundDraw()
    love.graphics.setColor(1, 1, 1)
    self.background_game:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

return Title