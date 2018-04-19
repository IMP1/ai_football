local Camera  = require 'lib_camera'
local GameObj = require 'cls_game'

local TICK_TIMER = 0.5

local INTERRUPT_CONTROLS = {
    "q", "w", "e", "r", "t",
    "a", "s", "d", "f", "g",
}

local PLAYER_CONTROLS = {
    "1", "2", "3", "4", "5", "6", 
    "7", "8", "9", "0", "-", "=", 
}

local DESELECT_PLAYER = "escape"

local Scene = require 'scn_base'
local Game = {}
setmetatable(Game, Scene)
Game.__index = Game

function Game.new(home_team, away_team, pitch)
    local self = Scene.new("match")
    setmetatable(self, Game)

    self.camera = Camera.new()
    self.game   = GameObj.new(home_team, away_team, pitch)

    self.interrupt_player = nil

    return self
end

function Game:load()
    print("Game Starting")
    print(self.game.teams[1].name .. "(home)")
    for _, p in ipairs(self.game.players) do
        if p.team == self.game.teams[1] then
            print("\t" .. p.name)
        end
    end
    print("\n")
    if self.game.directions[1] < 0 then
        print("<---")
    else
        print("--->")
    end
    print("VS")
    if self.game.directions[2] < 0 then
        print("<---")
    else
        print("--->")
    end
    print("\n")
    print(self.game.teams[2].name .. "(away)")
    for _, p in ipairs(self.game.players) do
        if p.team == self.game.teams[2] then
            print("\t" .. p.name)
        end
    end
    print("\n")
    self.game:begin()
    self.camera:centreOn(0, 0)
end

function Game:keyPressed(key)
    self:input(key, 1)
end

function Game:input(key, team_index)
    for i, k in pairs(PLAYER_CONTROLS) do
        if k == key then
            self.interrupt_player = self.team_players[team_index][i]
        end
    end
    if key == DESELECT_PLAYER then
        self.interrupt_player = nil
    end
    for i, k in pairs(INTERRUPT_CONTROLS) do
        if k == key then
            self:interrupt(i, self.game.teams[team_index])
        end
    end
end

function Game:update(dt)
    self.game:update(dt)
end

function Game:draw()

    local scale = 7
    local rotation = -math.pi / 2

    self.camera:set()
    self.game:draw(scale, rotation)
    self.camera:unset()

    love.graphics.print(tostring(self.game.ball.position), 0, 0)
end

return Game