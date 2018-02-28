local Scene = require 'scn_base'

local Camera = require 'lib_camera'

local Api    = require 'cls_api'
local Ball   = require 'cls_ball'
local Player = require 'cls_player'
local Pitch  = require 'cls_pitch'
local Timer  = require 'cls_timer'

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

local Game = {}
setmetatable(Game, Scene)
Game.__index = Game

function Game.new(home_team, away_team, pitch)
    local self = Scene.new("match")
    setmetatable(self, Game)

    self.camera = Camera.new()
    self.pitch = pitch or Pitch.new()
    self.teams = {home_team, away_team}
    self.players = {}
    self.team_players = {}
    for i, team in pairs(self.teams) do
        self.team_players[i] = {}
        for _, player in pairs(team.starting_players) do
            table.insert(self.team_players[i], player)
            table.insert(self.players, player)
        end
    end
        -- Player.new("Josh Moos",    require 'ai_huwt_basic', home_team),
    --     Player.new("Huw Taylor",   require 'ai_huwt_basic', home_team),
    --     Player.new("Molly Ascher", require 'ai_huwt_basic', home_team),
    --     Player.new("Josh Lawson",  require 'ai_huwt_basic', away_team),
    -- }
    self.directions = {1, -1}
    self.kick_off = 1
    self.player_with_ball = nil
    
    return self
end

function Game:load()
    Api.game_object = self
    self:start()
end

function Game:start()
    self.ball = Ball.new(0, 0, 0)
    self.timer = Timer.new()
    for _, player in pairs(self.players) do
        local pos, direction = player.ai.start_position(Api.new_player(player, true), Api.new_game(self))
        assert(pos, "Player '" .. player.name .. "' has not been given a starting position.")
        player.position = pos
    end
    local x, y, z = unpack(self.ball.position.data)
    self.camera:centreOn(x, y)
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
            self:interrupt(i, self.teams[team_index])
        end
    end
end

function Game:nearestPlayerTo(position)
    local min_dist_squared = nil
    local nearest_player = nil

    for _, player in pairs(self.players) do
        local dist = (position - player.position):magnitudeSquared()
        if not min_dist_squared or dist < min_dist_squared then
            min_dist_squared = dist
            nearest_player = player
        end
    end
    return nearest_player
end

function Game:challengeForBall(player)
    self:changeBallOwnership(player)
end

function Game:changeBallOwnership(player)
    if player then
        print(player.name, player.team.name, "now has the ball.")
    else
        print("nobody now has the ball.")
    end
    -- @QUESTION: Should this just blindly accept this from any player?
    -- It should only be called from within game logic, and not from AI.
    if player then
        player.has_ball = true
    end
    if self.player_with_ball then
        self.player_with_ball.has_ball = false
    end
    self.player_with_ball = player
end

function Game:interrupt(interrupt_index, team)
    if not team.interrupts[interrupt_index] then return end
    if self.interrupt_player and self.interrupt_player.team == team then
        print("Shouting '" .. team.interrupts[interrupt_index] .. "' at " .. self.interrupt_player.name)
        self.interrupt_player:interrupt(interrupt_index)
    else
        for _, player in pairs(self.players) do
            if player.team == team then
                print("Shouting '" .. team.interrupts[interrupt_index] .. "' at the team")
                player:interrupt(interrupt_index)
            end
        end
    end
end

function Game:update(dt)
    self.timer:update(dt)
    for i = 1, self.timer:ticks() do
        self:tick()
    end

    for _, player in pairs(self.players) do
        player:update(dt, self)
    end
    self.ball:update(dt, self)
    if self.pitch:isInGoal(self.ball.position) then
        print("GOAL GOALGOALGOAL!")
        self:load()
    end
end

function Game:tick()
    for _, player in pairs(self.players) do
        player.ai.tick(Api.new_player(player, true), Api.new_game(self))
    end
end

function Game:draw()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    self.camera:set()
    self.pitch:draw(0, 0, math.pi / 2, 7)
    love.graphics.push()
    love.graphics.rotate(math.pi / 2)
    love.graphics.scale(7)
    for i, team in pairs(self.teams) do
        love.graphics.setColor(team.home_colour)
        local y = self.pitch.pitch_width * ((i-1)*2-1) / 3
        love.graphics.line(y-4, -10 * self.directions[i], y, 10 * self.directions[i])
        love.graphics.line(y+4, -10 * self.directions[i], y, 10 * self.directions[i])
    end
    love.graphics.pop()
    for _, player in pairs(self.players) do
        player:draw(0, 0, math.pi / 2, 7)
    end
    self.ball:draw(0, 0, math.pi / 2, 7)
    self.camera:unset()

    love.graphics.print(tostring(self.ball.position), 0, 0)
end

return Game