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
        print(game.ball.position, goal_pos)
        print((game.ball.position - goal_pos):magnitude())
        if (game.ball.position - goal_pos):magnitude() < 100 then
            -- @TODO: if ball is near then get in between it and goal
            print("intercepting...")
            local dir = (game.ball.position - goal_pos):normalise()
            print("dir = ", dir)
            local intercept = goal_pos + dir * 4
            print("intercept = ", intercept)
            self:moveTowards(intercept)
        end
    end
end

return ai
