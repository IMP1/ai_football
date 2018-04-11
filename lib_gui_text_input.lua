local Element = require 'lib_gui_element'

local TextInput = {}
setmetatable(TextInput, Element)
TextInput.__index = TextInput

function TextInput.new(options)
    local self = Element.new(options)
    setmetatable(self, TextInput)

    self.align       = options.align or {"left", "top"}

    self.placeholder = options.placeholder or nil
    self.flash_speed = options.flash_speed or 0.5

    self.value = ""
    self.text  = {}
    self.index = 0

    if options.value then
        self:keyTyped(options.value)
    end

    self.flash_timer    = 0
    self.cursor_visible = true

    return self
end

function TextInput:mouseReleased(mx, my)
    self.focus = self:isMouseOver(mx, my)
end

function TextInput:keyPressed(key, is_repeat)
    -- @SEE: https://love2d.org/wiki/love.textinput
    if key == "backspace" then
        if self.index > 0 and #self.text > 0 then
            table.remove(self.text, self.index)
            self.index = self.index - 1
        end
        self:refresh()
    end
    if key == "delete" then
        if #self.text > 0 and self.text[self.index + 1] then
            table.remove(self.text, self.index + 1)
        end
        self:refresh()
    end
    if key == "left" and self.index > 0 then
        self.index = self.index - 1
    end
    if key == "right" and self.index < #self.text then
        self.index = self.index + 1
    end
    if (key == "v" and love.keyboard.isDown("lctrl", "rctrl")) or
    (key == "insert" and love.keyboard.isDown("lshift", "rshift")) then
        self:keyTyped(love.system.getClipboardText())
    end
end

function TextInput:keyTyped(text)
    for c in text:gmatch(".") do
        table.insert(self.text, self.index + 1, c)
        self.index = self.index + 1
    end
    self:refresh()
end

function TextInput:refresh()
    local text = ""
    for i, char in ipairs(self.text) do
        text = text .. char
    end
    self.value = text
end

function TextInput:update(dt, mx, my)
    if self.focus then
        self.flash_timer = self.flash_timer + dt
        if self.flash_timer > self.flash_speed then
            self.cursor_visible = not self.cursor_visible
            self.flash_timer = self.flash_timer - self.flash_speed
        end
    end
end

function TextInput:draw()
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
    local font = self.style.font
    local ch = font:getHeight()
    local px, py, pright, pbottom = unpack(self.style.padding)

    if self.align[2] == "middle" then
        py = (h - ch) / 2
    elseif self.align[2] == "bottom" then
        py = h - ch - pbottom
    end -- @TODO: copy this over to all other elements

    text_colour[4] = self.text_opacity or self.opacity
    love.graphics.setColor(text_colour)
    love.graphics.setFont(font)
    love.graphics.printf(self.value, x + px, y + py, w, align)

    if self.cursor_visible and self.focus then
        local ox = 0
        for i = 1, self.index do
            ox = ox + font:getWidth(self.text[i])
        end
        love.graphics.line(x + px + ox, y + py, x + px + ox, y + py + ch)
    end
end

return TextInput
