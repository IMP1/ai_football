
-- global requires
local Vector3 = require 'lib_vec3'
vec3 = Vector3.new

local tlo = require 'lib_tlo'
T = tlo.deferredLocalise
-- @TODO: update tlo library to latest version.

math.signum = math.signum or function(x)
    return x>0 and 1 or x<0 and -1 or 0
end

player_data = {}

FONTS = {
    system     = love.graphics.getFont(),
    game_title = love.graphics.newFont("res_PT_Sans-Web-Bold.ttf", 18),
    game_text  = love.graphics.newFont("res_PT_Sans-Web-Bold.ttf", 12),
}
-- @TODO: have this as a local variable, and just set values of the gui elements in main?
DEFAULT_THEME = {
    void       = {0, 0, 0}, 
    background = {0.875, 0.875, 1},
    border     = {0.5, 0.5, 0.5},
    stripe1    = {0.75, 0.75, 1},
    stripe2    = {0.75, 0.75, 0.75},
}

local SAVE_DATA_FILENAME = "save.dat"

local INITIAL_SCENE_CLASS = require 'scn_title'
local Manager = require 'cls_manager'
local scene_manager = require 'scn_scn_manager'
local gui_manager   = require 'gui_gui_manager'
local gui_element   = require 'gui_element'


local function load_user_profile()
    -- @TODO: decide on a better name for this variable
    local player = {}
    if love.filesystem.exists(SAVE_DATA_FILENAME) then
        -- @TODO: load data from file.
        -- @TODO: worry about data fucking shit up?
        --        presumabley this will be a love.filesystem.load() or
        --        a read followed by a string exec. This *should* just
        --        be a table of simple values. So maybe a sandbox for this?
    else
        -- @TODO: generate default data.
        player.manager = Manager.new("huwt", "Huw T")
    end 
    player_data = player
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

    scene_manager.hook()
    gui_manager.hook()

    load_user_profile()
    scene_manager.setScene(INITIAL_SCENE_CLASS.new())
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
