local ai = {
    name   = "Idle",
    author = "Huw Taylor"
}

local i = 0
function ai.start_position(self, game)
    local dir = -self.team.attacking_direction
    i = i + 1
    if self.number == 1 then
        return vec3(4, dir * 10, 0), {1, 0, 0, 1}
    elseif self.number == 2 then
        return vec3(-4, dir * 16, 0), {1, 0, 0, 1}
    elseif self.number == 3 then
        return vec3(0, dir * 40, 0), {1, 0, 0, 1}
    elseif self.number == 4 then
        return vec3(16, dir * 20, 0), {1, 0, 0, 1}
    elseif i == 5 then
        return vec3(-16, dir * 20, 0), {1, 0, 0, 1}
    else
        print("No specfic start position for player #" .. i .. ". giving default.")
        return vec3(0, dir * 20, 0), {1, 0, 0, 1}
    end
end

function ai.interrupt(self, game, command)
end

function ai.tick(self, game)
    
end

return ai
