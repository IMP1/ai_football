local ai = {
    name   = "Test_GK",
    author = "Huw Taylor"
}

function ai.start_position(self, game)
    local dir = -self.team.attacking_direction
    return vec3(0, dir * (0.5 * game.pitch.dimensions.pitch_size[1] - 1), 0)
end

function ai.interrupt(self, command, game)
end

function ai.tick(self, game)
    if self.has_ball then
        local dir = self.team.attacking_direction
        local goal_pos = vec3(0, dir * game.pitch.dimensions.pitch_size[1], 0)
        local direction = goal_pos - self.position
        direction.z = direction:magnitude() / 2
        self:kick(direction, 10, 0)
    else
        
    end
end

return ai
