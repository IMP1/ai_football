local Element = {}
Element.__index = Element

Element.DEFAULT_STYLE = {
    background_colour = {1, 1, 1},
    text_colour       = {0, 0, 0},
    border_colour     = {0, 0, 0},
    border_radius     = {4, 4},
    padding           = {4, 4, 4, 4},
    font              = love.graphics.getFont(),

    disabled_background_colour = {0.5, 0.5, 0.5},
    disabled_border_colour     = {0.2, 0.2, 0.2},
    disabled_text_colour       = {0.2, 0.2, 0.2},

    invalid_background_colour  = {1, 0.8, 0.8},
    invalid_border_colour      = {0.5, 0, 0},
    invalid_text_colour        = {0.5, 0, 0},

    focus_background_colour    = {1, 1, 1},
    focus_border_colour        = {0, 0, 1},
    focus_text_colour          = {0, 0, 0},

}

function Element.new(options)
    local self = {}
    setmetatable(self, Element)

    self.position = options.position or {0, 0}
    self.size     = options.size     or {256, 256}
    self.align    = options.align    or {"center", "top"}
    self.style    = options.style    or {}
    self.opacity  = options.opacity  or 1
    self.data     = options.data     or {}
    
    self.enabled  = true
    if options.enabled == false then
        self.enabled = false
    end
    self.focus    = false
    self.invalid  = false

    self:setDefaultStyle()
    
    return self
end

function Element:setDefaultStyle()
    for k, v in pairs(Element.DEFAULT_STYLE) do
        if not self.style[k] then
            self.style[k] = v
        end
    end
end

function Element:textColour()
    local colour = self.style.text_colour
    if not self.enabled then
        colour = self.style.disabled_text_colour
    elseif self.invalid then
        colour = self.style.invalid_text_colour
    elseif self.focus then
        colour = self.style.focus_text_colour
    end 
    return {
        colour[1],
        colour[2],
        colour[3],
        (colour[4] or 1) * (self.text_opacity or 1) * (self.opacity or 1)
    }
end

function Element:borderColour()
    local colour = self.style.border_colour
    if not self.enabled then
        colour = self.style.disabled_border_colour
    elseif self.invalid then
        colour = self.style.invalid_border_colour
    elseif self.focus then
        colour = self.style.focus_border_colour
    end 
    return {
        colour[1],
        colour[2],
        colour[3],
        (colour[4] or 1) * (self.border_opacity or 1) * (self.opacity or 1)
    }
end

function Element:backgroundColour()
    local colour = self.style.background_colour
    if not self.enabled then
        colour = self.style.disabled_background_colour
    elseif self.invalid then
        colour = self.style.invalid_background_colour
    elseif self.focus then
        colour = self.style.focus_background_colour
    end 
    return {
        colour[1],
        colour[2],
        colour[3],
        (colour[4] or 1) * (self.background_opacity or 1) * (self.opacity or 1)
    }
end

function Element:isMouseOver(mx, my)
    if mx == nil or my == nil then
        mx, my = love.mouse.getPosition()
    end
    return (mx >= self.position[1] and mx <= self.position[1] + self.size[1] and
            my >= self.position[2] and my <= self.position[2] + self.size[2])
end

function Element:update(dt)
end

function Element:mousePressed(mx, my, key)
end

function Element:mouseReleased(mx, my, key)
end 

function Element:mouseScrolled(mx, my, dx, dy)
end 

function Element:keyPressed(key)
end

function Element:keyReleased(key)
end

function Element:keyTyped(key)
end

function Element:draw()
    self:drawBackground()
    self:drawBorder()
    self:drawContents()
end

function Element:drawBackground()
    local x, y = unpack(self.position)
    local w, h = unpack(self.size)
    local rx, ry = unpack(self.style.border_radius)

    love.graphics.setColor(self:backgroundColour())
    love.graphics.rectangle("fill", x, y, w, h, rx, ry)
end

function Element:drawBorder()
    local x, y = unpack(self.position)
    local w, h = unpack(self.size)
    local rx, ry = unpack(self.style.border_radius)

    love.graphics.setColor(self:borderColour())
    love.graphics.rectangle("line", x, y, w, h, rx, ry)
end

function Element:drawContents()
    local x, y = unpack(self.position)
    local w, h = unpack(self.size)

    love.graphics.setColor(self:textColour())
    love.graphics.setFont(self.style.font)
end

return Element