local INITIAL_SCENE_CLASS = require 'scn_game'
local SceneManager = require 'scn_scn_manager'

-- global requires
local Vector3 = require 'lib_vec3'
vec3 = Vector3.new

function love.load()
    local team1 = require 'cls_team'.new("Ridge Rovers", {0, 96, 255})
    local team2 = require 'cls_team'.new("Firelight United", {255, 0, 0})
    SceneManager.setScene(INITIAL_SCENE_CLASS.new(team1, team2))
end

-- @TODO: put this on github.

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
    love.graphics.printf("FPS: " .. love.timer.getFPS(), 0, 0, love.graphics.getWidth(), "right")
end

function love.quit()
    -- @TODO: save teams and managers and data and stuff.
    print("Thanks for playing!")
end