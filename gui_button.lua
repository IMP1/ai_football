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
    if not self.enabled then return end
    if self:isMouseOver(mx, my) then
        self:fire()
    end
end

function Button:fire()
    self:action()
end

function Button:drawContents()
    Element.drawContents(self)
    local x, y  = unpack(self.position)
    local w     = self.size[1]
    local align = self.align[1]
    love.graphics.printf(self.text(), x, y + 8, w, align)
end

return Button
