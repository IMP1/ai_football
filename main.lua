
-- global requires
local Vector3 = require 'lib_vec3'
vec3 = Vector3.new

local tlo = require 'lib_tlo'
T = tlo.deferredLocalise
-- @TODO: update tlo library to latest version.

math.signum = math.signum or function(x)
    return x>0 and 1 or x<0 and -1 or 0
end


FONTS = {
    system     = love.graphics.getFont(),
    game_title = love.graphics.newFont("res_PT_Sans-Web-Bold.ttf", 18),
    game_text  = love.graphics.newFont("res_PT_Sans-Web-Bold.ttf", 12),
}
DEFAULT_THEME = { -- @TODO: have more than one theme?
    void       = {0, 0, 0}, 
    background = {0.875, 0.875, 1},
    border     = {0.5, 0.5, 0.5},
    stripe1    = {0.75, 0.75, 1},
    stripe2    = {0.75, 0.75, 0.75},
}

local INITIAL_SCENE_CLASS = require 'scn_title'
local scene_manager = require 'scn_scn_manager'
local gui_manager   = require 'gui_gui_manager'
local gui_element   = require 'gui_element'

local function load_user_profile()

end

local function save_user_profile()

end

function love.load()
    gui_element.DEFAULT_STYLE.font = FONTS.game_text

    tlo.settings.onMissingLanguageFile   = tlo.actions.IGNORE
    tlo.settings.addMissingLanguageFiles = true

    tlo.settings.addMissingLocalisations = true

    tlo.setLanguage("en-UK")

    love.graphics.setFont(FONTS.game_title)
    love.graphics.setBackgroundColor(DEFAULT_THEME.void)

    scene_manager.setScene(INITIAL_SCENE_CLASS.new())

    scene_manager.hook()
    gui_manager.hook()
end

function love.update(dt)
    scene_manager.update(dt)
    gui_manager.update(dt)
end

function love.draw()
    scene_manager.draw()
    gui_manager.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(FONTS.system)
    love.graphics.printf("FPS: " .. love.timer.getFPS(), 0, 0, love.graphics.getWidth(), "right")
end

function love.quit()
    -- @TODO: save teams and managers and data and stuff.
    save_user_profile()
    print("Thanks for playing!")
end
