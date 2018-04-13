local Element = require 'gui_element'

local Button = {}
setmetatable(Button, Element)
Button.__index = Button

function Button.new(options)
    local self = Element.new(options)
    setmetatable(self, Button)

    self.action   = options.onclick  or function() end
    self.text     = options.text     or function() return "" end

    if type(self.text) == "string" then
        local text = self.text
        self.text = function() return text end
    end

    return self
end

function Button:mouseReleased(mx, my)
    if self:isMouseOver(mx, my) then
        self:fire()
    end
end

function Button:fire()
    self:action()
end

function Button:draw()
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

    local text_colour = {unpack(self.style.text_colour)}
    local align = self.align[1]
    text_colour[4] = self.text_opacity or self.opacity
    love.graphics.setColor(text_colour)
    love.graphics.setFont(self.style.font)
    love.graphics.printf(self.text(), x, y + 8, w, align)
end

return Button
