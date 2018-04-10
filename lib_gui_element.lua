local Element = {}
Element.__index = Element

local DEFAULT_STYLE = {
    background_colour = {255, 255, 255},
    text_colour       = {0, 0, 0},
    border_colour     = {0, 0, 0},
    border_radius     = {4, 4},
    padding           = {4, 4, 4, 4},
    font              = FONTS.game_text,
}

function Element.new(options)
    local self = {}
    setmetatable(self, Element)

    self.position = options.position or {0, 0}
    self.size     = options.size     or {256, 256}
    self.style    = options.style    or {}
    self.opacity  = options.opacity  or 255

    for k, v in pairs(DEFAULT_STYLE) do
        if not self.style[k] then
            self.style[k] = v
        end
    end

    return self
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