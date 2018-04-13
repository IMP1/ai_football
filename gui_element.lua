local Element = {}
Element.__index = Element

Element.DEFAULT_STYLE = {
    background_colour = {1, 1, 1},
    text_colour       = {0, 0, 0},
    border_colour     = {0, 0, 0},
    border_radius     = {4, 4},
    padding           = {4, 4, 4, 4},
    font              = love.graphics.getFont(),
}

function Element.new(options)
    local self = {}
    setmetatable(self, Element)

    self.position = options.position or {0, 0}
    self.size     = options.size     or {256, 256}
    self.align    = options.align    or {"center", "top"}
    self.style    = options.style    or {}
    self.opacity  = options.opacity  or 1
    
    self.enabled  = true
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
end

return Element