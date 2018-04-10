local Element = require 'lib_gui_element'

local Text = {}
setmetatable(Text, Element)
Text.__index = Text

local DEFAULT_STYLE = {
    background_colour = {1, 1, 1},
    text_colour       = {0, 0, 0},
    border_colour     = {0, 0, 0},
    border_radius     = {4, 4},
    padding           = {4, 4, 4, 4},
    font              = FONTS.game_text,
}

function Text.new(options)
    local self = Element.new(options)
    setmetatable(self, Text)

    self.text     = options.text     or function() return "" end
    self.background_opacity = 0
    self.border_opacity = 0

    if type(self.text) == "string" then
        local text = self.text
        self.text = function() return text end
    end

    return self
end

function Text:setDefaultStyle()
    for k, v in pairs(DEFAULT_STYLE) do
        if not self.style[k] then
            self.style[k] = v
        end
    end
end

function Text:draw()
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
    text_colour[4] = self.text_opacity or self.opacity
    love.graphics.setColor(text_colour)
    love.graphics.setFont(self.style.font)
    love.graphics.printf(self.text(), x, y + 8, w, "center")
end

return Text
