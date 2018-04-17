local ai = {
    name   = "Test",
    author = "Huw Taylor"
}

function ai.start_position(self, game)
    local dir = -self.team.attacking_direction
    if self.number == 1 then
        return vec3(4, dir * 10, 0), {1, 0, 0, 1}
    elseif self.number == 2 then
        return vec3(-4, dir * 16, 0), {1, 0, 0, 1}
    elseif self.number == 3 then
        return vec3(0, dir * 40, 0), {1, 0, 0, 1}
    elseif self.number == 4 then
        return vec3(16, dir * 20, 0), {1, 0, 0, 1}
    else
        print("No specfic start position for player #" .. i .. ". giving default.")
        return vec3(0, dir * 20, 0), {1, 0, 0, 1}
    end
end

function ai.interrupt(self, game, command)
end

function ai.tick(self, game)
    if self.has_ball then
        local dir = self.team.attacking_direction
        local goal_pos = vec3(0, dir * game.pitch.dimensions.pitch_size[1], 0)
        local direction = goal_pos - self.position
        direction.z = direction:magnitude() / 2
        self:kick(direction, 10, 0)
    else
        local ball_pos = game.ball.position
        if (ball_pos - self.position):magnitudeSquared() < 1 then
            self:challengeForBall()
        else
            self:moveTowards(ball_pos)
        end
    end
end

return ai
