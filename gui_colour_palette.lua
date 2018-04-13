local colour = require 'util_colour'

local Element   = require 'gui_element'
local Palette   = require 'gui_palette'
local Slider    = require 'gui_slider'
local TextInput = require 'gui_text_input'
local Text      = require 'gui_text'

local PALETTE_SHADER_CODE = [[
    extern number hue;

    vec3 hsv2rgb(vec3 c)
    {
        vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
        vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
        return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
    }

    vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        vec4 texture_colour = Texel(texture, texture_coords);
        if (texture_colour.a == 0) {
            return vec4(0, 0, 0, 0);
        } else if (texture_colour.r == 0) {
            return vec4(0, 0, 0, 1);
        } else if (texture_colour.r == 1) {
            vec3 c = hsv2rgb(vec3(hue, 1-texture_coords.y, texture_coords.x));
            return vec4(c, 1);
        }
    }
]]

local SLIDER_SHADER_CODE = [[
    vec3 hsv2rgb(vec3 c)
    {
        vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
        vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
        return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
    }

    vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        vec4 texture_colour = Texel(texture, texture_coords);
        if (texture_colour.a == 0) {
            return vec4(0, 0, 0, 0);
        }else if (texture_colour.r == 0) {
            return vec4(0, 0, 0, 1);
        } else if (texture_colour.r == 1) {
            vec3 c = hsv2rgb(vec3(texture_coords.y, 1, 1));
            return vec4(c, 1);
        }
    }
]]

local function valid_hex(text)
    return text:match("#[%dA-Fa-f][%dA-Fa-f][%dA-Fa-f][%dA-Fa-f][%dA-Fa-f][%dA-Fa-f]")
end

local function valid_rgb(text)
    return text:match("%d+,? %d+,? %d+")
end

local ColourPalette = {}
setmetatable(ColourPalette, Element)
ColourPalette.__index = ColourPalette

function ColourPalette.new(options)
    local self = Element.new(options)
    setmetatable(self, ColourPalette)

    self.value       = options.value        or {0, 0, 0}
    self.swatch_size = options.preview_size or 32 * 2 - 8
    self.open        = options.open         or false
    self.onopen      = options.onopen       or nil
    self.onclose     = options.onclose      or nil
    self.onchange    = options.onchange     or nil

    local x, y = unpack(self.position)
    local w, h = unpack(self.size)

    self.palette = Palette.new({
        position = {x, y + self.swatch_size + 8},
        size     = {w * 0.8, w * 0.8},
        onchange = function()
            local h = self.slider.value
            local s = 1 - self.palette.value[2]
            local v = self.palette.value[1]
            self:refresh(h, s, v)
        end,
    })

    self.slider = Slider.new({
        position  = {x + w * 0.85, y + self.swatch_size + 8},
        size      = {w * 0.15, w * 0.8},
        direction = "vertical",
        onchange = function() 
            local h = self.slider.value
            local s = 1 - self.palette.value[2]
            local v = self.palette.value[1]
            self:refresh(h, s, v)
        end,
    })

    self.rgb_text = TextInput.new({
        position = {x + w * 0.5, y},
        size     = {w * 0.5, 24},
    })
    self.hex_text = TextInput.new({
        position = {x + w * 0.5, y + 32},
        size     = {w * 0.5, 24},
    })

    self.elements = {}
    table.insert(self.elements, self.palette)
    table.insert(self.elements, self.slider)
    table.insert(self.elements, self.rgb_text)
    table.insert(self.elements, self.hex_text)
    table.insert(self.elements, Text.new({
        position = {x + w * 0.25, y},
        size     = {64, 24},
        text     = "RGB",
    }))
    table.insert(self.elements, Text.new({
        position = {x + w * 0.25, y + 32},
        size     = {64, 24},
        text     = "Hex",
    }))

    self.palette_canvas = love.graphics.newCanvas(unpack(self.palette.size))
    self.palette_shader = love.graphics.newShader(PALETTE_SHADER_CODE)
    self.palette_shader:send("hue", tonumber(self.slider.value))

    self.slider_shader = love.graphics.newShader(SLIDER_SHADER_CODE)
    self.slider_canvas = love.graphics.newCanvas(unpack(self.slider.size))

    self:refresh(colour.rgb_to_hsv(unpack(self.value)))

    return self
end


function ColourPalette:keyPressed(key, is_repeat)
    if not self.enabled then return end
    if not self.open then return end

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
    if not self.enabled then return end
    if not self.open then return end

    if self.rgb_text.focus then
        self.rgb_text:keyTyped(text)
        print(self.rgb_text.value)
        if valid_rgb(self.rgb_text.value) then
            local c = loadstring("return {" .. self.rgb_text.value .. "}")()
            local r = c[1] / 255
            local g = c[2] / 255
            local b = c[3] / 255
            local h, s, v = colour.rgb_to_hsv(r, g, b)
            self:refresh(h, s, v)
        end
    end
    if self.hex_text.focus then
        self.hex_text:keyTyped(text)
        if valid_hex(self.hex_text.value) then
            local r, g, b = colour.fromHexString(self.hex_text.value:sub(2))
            local h, s, v = colour.rgb_to_hsv(r, g, b)
            self:refresh(h, s, v)
        end
    end
end

function ColourPalette:mouseReleased(mx, my)
    if not self.enabled then return end

    if self.open then
        if self:isMouseOver(mx, my) then
            for _, element in pairs(self.elements) do
                element:mouseReleased(mx, my)
            end    
        end
    end

    if self:isMouseOver(mx, my) then
        local x, y = unpack(self.position)
        local w = self.swatch_size
        if mx >= x and mx <= x + w and my >= y and my <= y + w then
            self.open = not self.open
            if self.open and self.onopen then
                self.onopen()
            end
            if not self.open and self.onclose then
                self.onclose()
            end
        end
    end
end

function ColourPalette:refresh(h, s, v)
    local r, g, b = colour.hsv_to_rgb(h, s, v)
    self.value = {r, g, b}
    self.slider.value = h
    self.palette.value = {v, 1-s}
    self.palette_shader:send("hue", h)
    self.hex_text.value = "#" .. colour.toHexString(r, g, b)
    self.rgb_text.value = colour.toRgbString(r, g, b)

    if self.onchange then self.onchange() end
end

function ColourPalette:update(dt, mx, my)
    if not self.open then return end

    for _, element in pairs(self.elements) do
        element:update(dt, mx, my)
    end
end

function ColourPalette:draw()
    if self.open then 
        for _, element in pairs(self.elements) do
            if element ~= self.palette and element ~= self.slider then
                element:draw()
            end
        end
        self:drawPalette()
        self:drawSlider()
    end

    local c = {unpack(self.value)}
    c[4] = (c[4] or 1) * self.opacity
    love.graphics.setColor(c)
    local x, y = unpack(self.position)
    local w = self.size[1]
    love.graphics.rectangle("fill", x, y, self.swatch_size, self.swatch_size)

    c = {unpack(self.style.border_colour)}
    c[4] = (c[4] or 1) * (self.border_opacity or self.opacity)
    love.graphics.setColor(c)
    love.graphics.rectangle("line", x, y, self.swatch_size, self.swatch_size)
end

function ColourPalette:drawPalette()
    local x, y = unpack(self.palette.position)
    love.graphics.push()
    love.graphics.translate(-x, -y)
    love.graphics.setCanvas(self.palette_canvas)
    self.palette:draw()
    love.graphics.setCanvas()
    love.graphics.pop()
    love.graphics.setShader(self.palette_shader)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.palette_canvas, x, y)
    love.graphics.setShader()
end

function ColourPalette:drawSlider()
    local x, y = unpack(self.slider.position)
    love.graphics.push()
    love.graphics.translate(-x, -y)
    love.graphics.setCanvas(self.slider_canvas)
    self.slider:draw()
    love.graphics.setCanvas()
    love.graphics.pop()
    love.graphics.setShader(self.slider_shader)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.slider_canvas, x, y)
    love.graphics.setShader()
end

return ColourPalette
