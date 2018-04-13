local Element = require 'gui_element'

local ScrollList = {}
setmetatable(ScrollList, Element)
ScrollList.__index = ScrollList

function ScrollList.new(options)
    local self = Element.new(options)
    setmetatable(self, ScrollList)

    self.items        = options.items          or {}
    self.scoll_offset = options.initial_scroll or {0, 0}

    return self
end

function ScrollList:draw()
    local x, y = unpack(self.position)
    local w, h = unpack(self.size)

    local background_colour = {unpack(self.style.background_colour)}
    background_colour[4] = self.background_opacity or self.opacity
    love.graphics.setColor(background_colour)
    love.graphics.rectangle("fill", x, y, w, h, 4, 4)

    local border_colour = {unpack(self.style.border_colour)}
    border_colour[4] = self.opacity
    love.graphics.setColor(border_colour)
    love.graphics.rectangle("line", x, y, w, h, 4, 4)

    -- @TODO: draw contents, offset by scroll_offset, using a scissor.
end

return ScrollList
