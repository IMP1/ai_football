local Element   = require 'lib_gui_element'
local Palette   = require 'lib_gui_palette'
local Slider    = require 'lib_gui_slider'
local TextInput = require 'lib_gui_text_input'

local palette_shader = [[
]]

local slider_shader = [[
]]

local ColourPalette = {}
setmetatable(ColourPalette, Element)
ColourPalette.__index = ColourPalette

function ColourPalette.new(options)
    local self = Element.new(options)
    setmetatable(self, ColourPalette)

    self.value = options.value or {0, 0, 0}

    local x, y = unpack(self.position)
    local w, h = unpack(self.size)

    self.palette = Palette.new({
        position = {x, y},
        size     = {w * 0.8, w * 0.8},
    })

    self.slider = Slider.new({
        position  = {x + w * 0.8, y},
        size      = {w * 0.2, w * 0.8},
        direction = "vertical",
    })

    self.rgb_text = TextInput.new({
        position = {x, y + w * 0.8},
        size     = {w * 0.5, h - w * 0.8},
    })
    self.hex_text = TextInput.new({
        position = {x + w * 0.5, y + w * 0.8},
        size     = {w * 0.5, h - w * 0.8},
    })

    self.elements = {}
    table.insert(self.elements, self.palette)
    table.insert(self.elements, self.slider)
    table.insert(self.elements, self.rgb_text)
    table.insert(self.elements, self.hex_text)

    return self
end


function ColourPalette:keyPressed(key, is_repeat)
    if self.rgb_text.focus then
        self.rgb_text:keyPressed(key, is_repeat)
    end
    if self.hex_text.focus then
        self.hex_text:keyPressed(key, is_repeat)
    end
    if (key == "v" and love.keyboard.isDown("lctrl", "rctrl")) or 
    (key == "insert" and love.keyboard.isDown("lshift", "rshift")) then
        print("pasted.")
    end
end

function ColourPalette:keyTyped(text)
    if self.rgb_text.focus then
        self.rgb_text:keyTyped(text)
    end
    if self.hex_text.focus then
        self.hex_text:keyTyped(text)
    end
end

function ColourPalette:update(dt, mx, my)
    for _, element in pairs(self.elements) do
        element:update(dt, mx, my)
    end
end

function ColourPalette:mouseReleased(mx, my)
    if self:isMouseOver(mx, my) then
        for _, element in pairs(self.elements) do
            element:mouseReleased(mx, my)
        end    
    end
end

function ColourPalette:draw()
    for _, element in pairs(self.elements) do
        element:draw()
    end
end

return ColourPalette
