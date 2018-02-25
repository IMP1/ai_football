local ai = {
    name   = "Test",
    author = "Huw Taylor"
}

local i = 0
function ai.start_position(self, game)
    local dir = -self.team.attacking_direction
    i = i + 1
    if i == 1 then
        return vec3(4, dir * 10, 0), {1, 0, 0, 1}
    elseif i == 2 then
        return vec3(-4, dir * 16, 0), {1, 0, 0, 1}
    elseif i == 3 then
        return vec3(0, dir * 40, 0), {1, 0, 0, 1}
    elseif i == 4 then
        return vec3(16, dir * 20, 0), {1, 0, 0, 1}
    elseif i == 5 then
        return vec3(-16, dir * 20, 0), {1, 0, 0, 1}
    else
        print("No specfic start position for player #" .. i .. ". giving default.")
        return vec3(0, dir * 20, 0), {1, 0, 0, 1}
    end
end

function ai.interrupt(self, command, game)
end

function ai.tick(self, game)
    if self.has_ball then
        local dir = self.team.attacking_direction
        local goal_pos = vec3(0, dir * game.pitch.dimensions.pitch_size[1], 0)
        local direction = goal_pos - self.position
        direction.z = direction:magnitude() / 2
        self:kick(direction, 1, 0)
    else
        local ball_pos = game.ball.position
        self:moveTowards(ball_pos)
    end
end

return ai