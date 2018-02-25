local Pitch = {}
Pitch.__index = Pitch

local PI = math.pi

function Pitch.new()
    local self = {}
    setmetatable(self, Pitch)

    self.name = name or ""

    self.gravity  = 9.81
    self.bounce   = 0.5
    self.friction = 0.5

    self.background_colour = {64, 192, 64}
    self.line_colour       = {192, 255, 192}

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

    self.spot_radius = 1


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
    
end

function Pitch:draw(rotation)
    love.graphics.rotate(rotation or 0)

    local ox = -self.pitch_width / 2
    local oy = -self.pitch_length / 2
    
    -- Pitch boundaries
    love.graphics.setColor(self.background_colour)
    love.graphics.rectangle("fill", ox, oy, self.pitch_width, self.pitch_length)
    love.graphics.setColor(self.line_colour)
    love.graphics.rectangle("line", ox, oy, self.pitch_width, self.pitch_length)

    -- Centre circle
    love.graphics.circle("line", 0, 0, self.middle_circle_radius)
    love.graphics.circle("fill", 0, 0, self.spot_radius)
    love.graphics.line(ox, 0, ox + self.pitch_width, 0)

    -- Corner arcs
    love.graphics.arc("line", 
        ox, oy, 
        self.corner_radius, 0, PI / 2)
    love.graphics.arc("line", 
        ox + self.pitch_width, oy, 
        self.corner_radius, PI / 2, PI)
    love.graphics.arc("line", 
        ox + self.pitch_width, oy + self.pitch_length, 
        self.corner_radius, PI, 3 * PI / 2)
    love.graphics.arc("line", 
        ox, oy + self.pitch_length, 
        self.corner_radius, 3 * PI / 2, 2 * PI)

    -- Penalty areas
    local r = math.acos((self.penalty_area_length - self.penalty_distance) / self.penalty_area_radius)
    love.graphics.rectangle("line", 
        -self.penalty_area_width / 2, oy, 
        self.penalty_area_width, self.penalty_area_length)
    love.graphics.arc("line", "open",
        0, oy + self.penalty_distance, 
        self.penalty_area_radius, math.pi / 2 - r, math.pi / 2 + r)
    love.graphics.circle("fill", 
        0, oy + self.penalty_distance, 
        self.spot_radius)
    
    love.graphics.rectangle("line", 
        -self.penalty_area_width / 2, oy + self.pitch_length - self.penalty_area_length, 
        self.penalty_area_width, self.penalty_area_length)
    love.graphics.arc("line", "open",
        0, oy + self.pitch_length - self.penalty_distance, 
        self.penalty_area_radius, -math.pi / 2 - r, -math.pi / 2 + r)
    love.graphics.circle("fill", 
        0, oy + self.pitch_length - self.penalty_distance, 
        self.spot_radius)

    -- Six-yard boxes
    love.graphics.rectangle("line", 
        -self.six_yard_box_width / 2, oy, 
        self.six_yard_box_width, self.six_yard_box_length)
    love.graphics.rectangle("line", 
        -self.six_yard_box_width / 2, oy + self.pitch_length - self.six_yard_box_length, 
        self.six_yard_box_width, self.six_yard_box_length)
end

return Pitch