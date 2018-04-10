local Pitch = {}
Pitch.__index = Pitch

local PI = math.pi

function Pitch.new()
    local self = {}
    setmetatable(self, Pitch)

    self.name = name or ""

    self.gravity        = 9.81
    self.bounce         = 0.5
    self.friction       = 0.5
    self.air_resistance = 0.1

    self.background_colour = {0.25, 0.75, 0.25}
    self.line_colour       = {0.75, 1, 0.75}

    -- All following lengths are in metres, and are according to the BBC website
    -- http://news.bbc.co.uk/sport1/hi/football/rules_and_equipment/4200666.stm
    self.pitch_length         = 100 --  (ranging from 90 - 120)
    self.pitch_width          = 60 --  (ranging from 45 - 90)
    self.middle_circle_radius = 9.14
    self.corner_radius        = 0.91
    self.goal_height          = 2.44
    self.goal_width           = 7.32
    self.six_yard_box_width   = self.goal_width + 5.49 * 2
    self.six_yard_box_length  = 5.49
    self.penalty_area_width   = self.goal_width + 16.46 * 2
    self.penalty_area_length  = 16.46
    self.penalty_distance     = 11 
    self.penalty_area_radius  = 9.14

    self.spot_radius = 0.3


    return self
end

function Pitch:isInPitch(position)
    return math.abs(position.x) <= self.pitch_width / 2 and
           math.abs(position.y) <= self.pitch_length / 2
end

function Pitch:isInPenaltyArea(position)
    if not self:isInPitch(position) then
        return false
    end
    local x, y = position.x, position.y
    if math.abs(y) <= self.pitch_length - self.penalty_area_length then
        return false
    end
    if math.abs(x) > self.penalty_area_width / 2 then 
        return false
    end
    return true
    -- @TODO, return as second argument which penalty area it is?
end

function Pitch:isInGoal(position)
    if self:isInPitch(position) then 
        return false 
    end
    local x, y, z = unpack(position.data)
    if math.abs(x) >= self.goal_width then
        return false
    end
    if z >= self.goal_height then
        return false 
    end
    return true
    -- @TODO, return as second argument which goal it is?
end

function Pitch:draw(x, y, rotation, scale)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(rotation or 0)

    local ox = -self.pitch_width / 2
    local oy = -self.pitch_length / 2
    
    -- Pitch boundaries
    love.graphics.setColor(self.background_colour)
    love.graphics.rectangle("fill", 
        ox * scale, oy * scale, 
        self.pitch_width * scale, self.pitch_length * scale)
    love.graphics.setColor(self.line_colour)
    love.graphics.rectangle("line", 
        ox * scale, oy * scale, 
        self.pitch_width * scale, self.pitch_length * scale)

    -- Centre circle
    love.graphics.circle("line", 0, 0, self.middle_circle_radius * scale)
    love.graphics.circle("fill", 0, 0, self.spot_radius * scale)
    love.graphics.line(ox * scale, 0, 
        (ox + self.pitch_width) * scale, 0)

    -- Corner arcs
    love.graphics.arc("line", 
        ox * scale, oy * scale, 
        self.corner_radius * scale, 0, PI / 2)
    love.graphics.arc("line", 
        (ox + self.pitch_width) * scale, oy * scale,
        self.corner_radius * scale, PI / 2, PI)
    love.graphics.arc("line", 
        (ox + self.pitch_width) * scale, (oy + self.pitch_length) * scale, 
        self.corner_radius * scale, PI, 3 * PI / 2)
    love.graphics.arc("line", 
        ox * scale, (oy + self.pitch_length) * scale, 
        self.corner_radius * scale, 3 * PI / 2, 2 * PI)

    -- Penalty areas
    local r = math.acos((self.penalty_area_length - self.penalty_distance) / self.penalty_area_radius)
    love.graphics.rectangle("line", 
        (-self.penalty_area_width / 2) * scale, oy * scale, 
        self.penalty_area_width * scale, self.penalty_area_length * scale)
    love.graphics.arc("line", "open",
        0, (oy + self.penalty_distance) * scale, 
        self.penalty_area_radius * scale, math.pi / 2 - r, math.pi / 2 + r)
    love.graphics.circle("fill", 
        0, (oy + self.penalty_distance) * scale, 
        self.spot_radius * scale)
    
    love.graphics.rectangle("line", 
        (-self.penalty_area_width / 2) * scale, (oy + self.pitch_length - self.penalty_area_length) * scale, 
        self.penalty_area_width * scale, self.penalty_area_length * scale)
    love.graphics.arc("line", "open",
        0, (oy + self.pitch_length - self.penalty_distance) * scale, 
        self.penalty_area_radius * scale, -math.pi / 2 - r, -math.pi / 2 + r)
    love.graphics.circle("fill", 
        0, (oy + self.pitch_length - self.penalty_distance) * scale, 
        self.spot_radius * scale)

    -- Six-yard boxes
    love.graphics.rectangle("line", 
        (-self.six_yard_box_width / 2) * scale, oy * scale, 
        self.six_yard_box_width * scale, self.six_yard_box_length * scale)
    love.graphics.rectangle("line", 
        (-self.six_yard_box_width / 2) * scale, (oy + self.pitch_length - self.six_yard_box_length) * scale, 
        self.six_yard_box_width * scale, self.six_yard_box_length * scale)
    love.graphics.pop()
end

return Pitch