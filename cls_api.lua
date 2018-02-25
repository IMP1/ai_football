local api = {}

api.keys = {}

function api.new_manager(manager_obj)
    local m = {}

    m.name     = nil -- @TODO
    m.username = nil -- @TODO

    return m
end

function api.new_ball(ball_obj)
    local b = {}

    b.position   = ball_obj.position
    b.velocity   = ball_obj.linear_velocity
    
     -- @TODO
    b.is_in_play = nil

    return b
end

local player = {}
player.__index = player

local this_player = {}
setmetatable(this_player, player)
this_player.__index = this_player

function api.new_player(player_obj, controllable)
    local p = {}
    if controllable then
        setmetatable(p, this_player)
    else
        setmetatable(p, player)
    end

    p.name      = player_obj.name
    p.position  = player_obj.position
    p.velocity  = player_obj.linear_velocity
    p.direction = player_obj.orientation[1]
    p.has_ball  = player_obj.has_ball

     -- @TODO
    p.stats = nil
    p.is_contesting_ball = nil
    p.team = api.new_team(player_obj.team)

    api.keys[p] = player_obj

    return p
end


function this_player:shout(command)
end

function this_player:kick(direction, force, curve)
    api.game_object.ball:applyForce(direction:normalise() * force)
end

function this_player:moveTowards(position)
    local player_obj = api.keys[self]
    player_obj:moveTowards(position)
end

function this_player:dribble(direction, speed)
end

function api.new_pitch(pitch_obj)
    local p = {}

    p.name = pitch_obj.name
    p.dimensions = {
        pitch_size        = {
            pitch_obj.pitch_length, pitch_obj.pitch_width
        },
        penalty_area_size = {
            pitch_obj.penalty_area_length, pitch_obj.penalty_area_width,
        },
        goal_size = {
            pitch_obj.goal_width, pitch_obj.goal_height,
        },
        penalty_spot_distance = pitch_obj.penalty_distance,
        penalty_area_radius = pitch_obj.penalty_area_radius,
    }
    p.properties = nil -- {friction, bounce, etc.}

    return p
end

function api.new_team(team_obj)
    local t = {}

    t.name = team_obj.name

    local index = 0
    for i, team in ipairs(api.game_object.teams) do
        if team == team_obj then index = i end
    end
    t.attacking_direction = api.game_object.directions[index]

    t.players = nil -- @TODO
    t.manager = nil -- @TODO

    return t
end

local time = {}
time.__index = time

function api.new_time(time_obj)
    local t = {}
    setmetatable(t, time)

     -- @TODO

    return t
end

function time:getSecondsElapsed() -- number
end

function time:getHalf() -- number (1 or 2)
end

function time:getSecondsRemaining() -- number
end

function time:isExtraTime() -- boolean
end

function api.new_goal(goal_obj)
    local g = {}
    g.team = nil
    g.scorer = nil
    g.time = nil
    return g
end

function api.new_score(score_obj)
    local s = {}
    s.home_score = nil
    s.away_score = nil
    s.goals = nil
    return s
end

function api.new_game(game_obj)
    local g = {}

    g.score = api.new_score(game_obj.score)
    g.time  = api.new_time(game_obj.timer)

    g.teams = {api.new_team(game_obj.teams[1]), api.new_team(game_obj.teams[2])}
    g.pitch = api.new_pitch(game_obj.pitch)
    g.ball = api.new_ball(game_obj.ball)

    if game_obj.player_with_ball then
        g.player_with_ball = api.new_player(game_obj.player_with_ball)
    end

    return g
end

--------------------------------------------------------------------------------

--[[




    local old_require = require
    require = function(...)
        print(...)
    end
    require 'lib_camera'

    require = old_require

    -- as a way to stop them requiring stuff. Or maybe rather than completely 
    -- disabling it, could just limit it to their own modules?

This looks like a good post on sandboxing:
https://stackoverflow.com/questions/1224708/how-can-i-create-a-secure-lua-sandbox


]]

return api