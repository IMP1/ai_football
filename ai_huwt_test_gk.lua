local ai = {
    name   = "Test_GK",
    author = "Huw Taylor"
}

function ai.start_position(self, game)
    local dir = -self.team.attacking_direction
    return vec3(0, dir * (0.5 * game.pitch.dimensions.pitch_size[1] - 1), 0)
end

function ai.interrupt(self, game, command)
end

function ai.tick(self, game)
    local dir = self.team.attacking_direction
    local goal_pos = vec3(0, dir * game.pitch.dimensions.pitch_size[1], 0)
    if self.has_ball then
        local direction = goal_pos - self.position
        direction.z = direction:magnitude() / 2
        self:kick(direction, 10, 0)
    -- @TODO: if "touching" ball then catch it / take possession.
    elseif game.ball.is_in_play then
        local angle = game.ball.velocity:angleBetween(game.ball.position - goal_pos)
        if angle < math.pi / 2 or angle > 3 * math.pi / 2 then
            print("ball is coming towards goal")
        end
        if (game.ball.position - goal_pos):magnitude() < 100 then
            -- @TODO: if ball is near then get in between it and goal
            local dir = (game.ball.position - goal_pos):normalise()
            local intercept = goal_pos + dir * 4
            self:moveTowards(intercept)
        end
    end
end

return ai

--[[
local function get_nearest_object(position, object_list, ignore, start_dist)
    local pitch_length = start_dist or 99999
    local nearest_object = nil
    local object_distance_squared = pitch_length * pitch_length

    for _, object in pairs(object_list) do
        if object ~= ignore then
            local dist_squared = (object.position - position):magnitudeSquared()
            if dist_squared < object_distance_squared then
                nearest_object = object
                object_distance_squared = dist_squared
            end
        end
    end
    return nearest_object
end

local function get_nearest_teammate(self, game)
    local pitch_length = game.pitch.dimensions.pitch_size[1]
    return get_nearest_object(self.position, self.team.players, self, pitch_length)
end

local function get_opposing_team(self, game)
    -- @TODO: make sure the equality function holds here.
    --        maybe redefine the metamethod for all the api classes.
    for _, team in pairs(game.teams) do
        if team ~= self.team then
            return team
        end
    end
end

local function get_nearest_opponent(self, game)
    local other_team = get_opposing_team(self, game)
    local pitch_length = game.pitch.dimensions.pitch_size[1]
    return get_nearest_object(self.position, other_team.players, self, pitch_length)
end

function ai.tick(self, game)
    if self.has_ball then
        local nearest_player = get_nearest_teammate(self, game)
        local nearest_opponent = get_nearest_opponent(nearest_player, game)
        if (nearest_opponent.position - nearest_player.position):magnitudeSquared() < 10 then -- @TODO: test this number
            local dir = self.team.attacking_direction
            local goal_pos = vec3(0, dir * game.pitch.dimensions.pitch_size[1], 0)
            local direction = goal_pos - self.position
            direction.z = direction:magnitude() / 2
            self:kick(direction, 10, 0)
        else
            local direction = nearest_player.position - self.position
            self:kick(direction, 10, 0)
        end
    else

    end
end

--]]
--[[

if got the ball
    if nearest player is marked
        boot it downfield
    else
        kick/throw it to nearest player
elseif the ball is coming closer
    intercept ball
elseif the player with the ball is coming closer
    if one-on-one
        move towards player
    else
        move a bit towards the player
else
    idle

]]