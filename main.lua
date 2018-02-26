FONTS = {
    system = love.graphics.getFont(),
    game_title = love.graphics.newFont("res_PT_Sans-Web-Bold.ttf", 18),
    game_text  = love.graphics.newFont("res_PT_Sans-Web-Bold.ttf", 12),
}
DEFAULT_THEME = { -- @TODO: have more than one theme?
    void       = {0, 0, 0}, 
    background = {224, 224, 255},
    border     = {128, 128, 128},
}

local INITIAL_SCENE_CLASS = require 'scn_management'
local SceneManager = require 'scn_scn_manager'

-- global requires
local Vector3 = require 'lib_vec3'
vec3 = Vector3.new

function love.load()
    love.graphics.setFont(FONTS.game_title)
    love.graphics.setBackgroundColor(DEFAULT_THEME.void)

    local team1 = require 'cls_team'.new("Ridge Rovers United FC", nil, {0, 96, 255})
    local team2 = require 'cls_team'.new("Firelight United", nil, {255, 0, 0})
    SceneManager.setScene(INITIAL_SCENE_CLASS.new(team1, team2))
end

function love.update(dt)
    SceneManager.update(dt)
end

function love.mousepressed(mx, my, key)
    SceneManager.mousepressed(mx, my, key)
end

function love.mousereleased(mx, my, key)
    SceneManager.mousereleased(mx, my, key)
end

function love.keypressed(key)
    SceneManager.keypressed(key)
end

function love.draw()
    SceneManager.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(FONTS.system)
    love.graphics.printf("FPS: " .. love.timer.getFPS(), 0, 0, love.graphics.getWidth(), "right")
end

function love.quit()
    -- @TODO: save teams and managers and data and stuff.
    print("Thanks for playing!")
end