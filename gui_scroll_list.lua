local Element = require 'gui_element'

local ScrollList = {}
setmetatable(ScrollList, Element)
ScrollList.__index = ScrollList

function ScrollList.new(options)
    local self = Element.new(options)
    setmetatable(self, ScrollList)

    self.items         = options.items          or {}
    self.scoll_offset  = options.initial_scroll or {0, 0}
    self.onselect      = options.onselect       or nil
    self.selected_item = nil

    return self
end

function ScrollList:mouseReleased(mx, my, key)
    if self:isMouseOver(mx, my) then
        print("mouse clicked")
        local item = self:getItemAt(mx, my)
        if item then
            self:select(item)
            self.selected_item = item
        end
    end
end

function ScrollList:select(item)
    self.selected_item = item
    if self.onselect then
        self.onselect(item)
    end
end

function ScrollList:getItemAt(mx, my)
    local oy = self.scoll_offset[2]
    local y = 0
    for index, item in ipairs (self.items) do
        local item_y = item.position[2]
        local item_h = item.size[2]
        -- @TODO: this might have to be -oy instead of +oy
        if y + oy >= item_y and y + oy <= item_y + item_h then
            return item, index
        end
    end
    return nil
end

function ScrollList:drawContents()
    local x, y = unpack(self.position)
    local w, h = unpack(self.size)

    love.graphics.setColor(1, 1, 1)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.setScissor(x, y, w, h)
    
    for i, item in ipairs(self.items) do
        item:draw()
    end

    love.graphics.setScissor()
    love.graphics.pop()
    -- @TODO: draw contents, offset by scroll_offset, using a scissor.
end

return ScrollList
