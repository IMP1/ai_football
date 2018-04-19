local Api   = require 'cls_api'
local Ball  = require 'cls_ball'
local Timer = require 'cls_timer'
local Pitch = require 'cls_pitch'

local Game = {}
Game.__index = Game

function Game.new(home_team, away_team, pitch)
    local self = {}
    setmetatable(self, Game)

    self.pitch = pitch or Pitch.new()
    self.teams = {home_team, away_team}
    self.players = {}

    for _, player in pairs(home_team.starting_players) do
        table.insert(self.players, player)
    end
    for _, player in pairs(away_team.starting_players) do
        table.insert(self.players, player)
    end

    self.player_with_ball = nil
    self.last_player_to_kick = nil
    
    self.directions = {1, -1}
    self.timer = Timer.new()
    self.ball = Ball.new(0, 0, 0)
    self.score = {0, 0}
    self.goals = {}

    return self
end

function Game:begin()
    Api.game_object = self
    self.timer = Timer.new()
    self:kickOff(self.teams[1])
end

function Game:kickOff(team_kicking_off)
    self.ball.position = vec3(0, 0, 0)
    self.ball.linear_velocity = vec3(0, 0, 0)

    for _, player in pairs(self.players) do
        local pos, direction = player.ai.start_position(Api.new_player(player, true), 
                                                        Api.new_game(self), 
                                                        Api.new_team(team_kicking_off))
        assert(pos, "Player '" .. player.name .. "' has not been given a starting position.")
        -- @TODO: ensure players are in their own half
        -- @TODO: ensure opposing team are not in the centre circle
        player.position = pos
        if direction then -- @TODO: remove this check and enforce directions
            player.orientation[1] = direction
        end
    end

    
    self.kick_off = true
end

function Game:teamGoingInDirection(dir)
    -- @TODO: tidy this up.
    if dir > 0 and self.directions[1] == 1 then
        return 1
    elseif dir > 0 and self.directions[2] == 1 then
        return 2
    elseif dir < 0 and self.directions[1] == 1 then
        return 2
    elseif dir < 0 and self.directions[2] == 1 then
        return 1
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
    local shout = team.interrupts[interrupt_index]
    if self.interrupt_player and self.interrupt_player.team == team then
        print("Shouting '" .. shout .. "' at " .. self.interrupt_player.name)
        self.interrupt_player:interrupt(self, shout)
    else
        for _, player in pairs(self.players) do
            if player.team == team then
                print("Shouting '" .. shout .. "' at the team")
                player:interrupt(self, shout)
            end
        end
    end
end

function Game:goal(team, scorer)
    if scorer.team == self.teams[team] then
        print(scorer.name .. " has scored.")
    else
        print(scorer.name .. " has scored an own goal.")
    end
    local other_team = 2 + (team - 1) * -1
    self.score[team] = self.score[team] + 1
    -- table.insert(self.goals, Goal.new(self.timer.time))
    self:kickOff(self.teams[other_team])
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
        print("ball @", unpack(self.ball.position.data))
        local scoring_team = self:teamGoingInDirection(self.ball.position.y)
        self:goal(scoring_team, self.last_player_to_kick)
    end
end

function Game:tick()
    -- @TODO: Have this be safer. Make a sandbox and run the ai in that?
    for _, player in pairs(self.players) do
        player.ai.tick(Api.new_player(player, true), Api.new_game(self))
    end
end

function Game:draw(scale, rotation)
    self.pitch:draw(0, 0, rotation, scale)
    for _, player in pairs(self.players) do
        player:draw(0, 0, rotation, scale)
    end
    self.ball:draw(0, 0, rotation, scale)
end


return Game