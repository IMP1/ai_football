local ai = {
    name   = "Idle",
    author = "Huw Taylor"
}

function ai.start_position(self, game, is_our_kickoff)
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
    if not self.memory['target'] then
        local dir = math.random() * 2 * math.pi
        local dx, dy = math.cos(dir), math.sin(dir)

    end
end

return ai
