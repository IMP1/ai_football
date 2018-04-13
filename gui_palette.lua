local Element = require 'gui_element'

local Palette = {}
setmetatable(Palette, Element)
Palette.__index = Palette

function Palette.new(options)
    local self = Element.new(options)
    setmetatable(self, Palette)

    self.value          = options.value          or {0, 0}
    self.snapping       = options.snapping       or nil
    self.selection_size = options.selection_size or 4
    self.onchange       = options.onchange       or nil

    return self
end

function Palette:update(dt, mx, my)
    if love.mouse.isDown(1) and self:isMouseOver(mx, my) then
        self:mouseReleased(mx, my)
    end
end

function Palette:mouseReleased(mx, my)
    if self:isMouseOver(mx, my) then
        mx = mx - self.position[1]
        my = my - self.position[2]
        if self.snapping then
            local sx, sy = unpack(self.snapping)
            mx = math.floor((mx + sx / 2) / sx) * sx
            my = math.floor((my + sy / 2) / sy) * sy
        end
        local x = mx / self.size[1]
        local y = my / self.size[2]
        self.value = {x, y}
        if self.onchange then self.onchange() end
    end
end

function Palette:draw()
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
    local vx, vy = unpack(self.value)
    selection_colour[4] = self.text_opacity or self.opacity
    love.graphics.setColor(selection_colour)
    love.graphics.circle("fill", vx * w + x, vy * h + y, self.selection_size)
end

return Palette
