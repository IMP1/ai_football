local Element = require 'gui_element'

local Slider = {}
setmetatable(Slider, Element)
Slider.__index = Slider

local function invalid_direction_message(dir)
    return "invalid direction '" .. tostring(dir) .. "'. Must be 'horizontal' or 'vertical'."
end

function Slider.new(options)
    local self = Element.new(options)
    setmetatable(self, Slider)

    self.value          = options.value          or 0
    self.direction      = options.direction      or "horizontal"
    self.snapping       = options.snapping       or nil
    self.selection_size = options.selection_size or 1
    self.onchange       = options.onchange       or nil

    return self
end

function Slider:update(dt, mx, my)
    if love.mouse.isDown(1) and self:isMouseOver(mx, my) then
        self:mouseReleased(mx, my)
    end
end

function Slider:mouseReleased(mx, my)
    if self:isMouseOver(mx, my) then
        mx = mx - self.position[1]
        my = my - self.position[2]
        if self.direction == "horizontal" then
            if self.snapping then
                local snap = self.snapping
                mx = math.floor((mx + snap / 2) / snap) * snap
            end
            self.value = mx / self.size[1]
        elseif self.direction == "vertical" then
            if self.snapping then
                local snap = self.snapping
                my = math.floor((my + snap / 2) / snap) * snap
            end
            self.value = my / self.size[2]
        else
            error(invalid_direction_message(self.direction))
        end
        if self.onchange then self.onchange() end
    end
end

function Slider:draw()
    local x, y = unpack(self.position)
    local w, h = unpack(self.size)
    local rx, ry = unpack(self.style.border_radius)

    local background_colour = {unpack(self.style.background_colour)}
    background_colour[4] = self.background_opacity or self.opacity
    love.graphics.setColor(background_colour)
    love.graphics.rectangle("fill", x, y, w, h, rx, ry)

    local border_colour = {unpack(self.style.border_colour)}
    border_colour[4] = self.border_opacity or self.opacity
    love.graphics.setColor(border_colour)
    love.graphics.rectangle("line", x, y, w, h, rx, ry)

    local selection_colour = {unpack(self.style.text_colour)}
    local value = self.value
    selection_colour[4] = self.text_opacity or self.opacity
    love.graphics.setColor(selection_colour)
    if self.direction == "horizontal" then
        love.graphics.rectangle("fill", x + value * w, y, self.selection_size, h)
    elseif self.direction == "vertical" then
        love.graphics.rectangle("fill", x, y + value * h, w, self.selection_size)
    else
        error(invalid_direction_message(self.direction))
    end
end

return Slider
