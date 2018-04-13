local colour_util = {}

local function h2rgb(m1, m2, h)
    if h < 0 then h = h+1 end
    if h > 1 then h = h-1 end
    if h * 6 < 1 then
        return m1 + (m2 - m1) * h * 6
    elseif h * 2 < 1 then
        return m2
    elseif h * 3 < 2 then
        return m1 + (m2 - m1) * (2 / 3 -h) * 6
    else
        return m1
    end
end

function colour_util.fromHexString(hex_string)
    local r, g, b
    if #hex_string == 6 then
        r = hex_string:sub(1, 2)
        g = hex_string:sub(3, 4)
        b = hex_string:sub(5, 6)
    elseif #hex_string == 3 then
        r = hex_string:sub(1, 1)
        g = hex_string:sub(2, 2)
        b = hex_string:sub(3, 3)
    else
        error("Invalid Hexadecimal colour: " .. tostring(hex_string))
    end
    return tonumber("0x" .. r) / 255, 
           tonumber("0x" .. g) / 255, 
           tonumber("0x" .. b) / 255
end

function colour_util.toHexString(r, g, b, a)
    -- @TODO: do some rounding
    local hex = ""
    hex = hex .. string.format("%02x", r * 255)
    hex = hex .. string.format("%02x", g * 255)
    hex = hex .. string.format("%02x", b * 255)
    if a then hex = hex .. string.format("%02x", a * 255) end
    return hex
end

function colour_util.toRgbString(r, g, b, a)
    local rgb = ""
    rgb = rgb .. string.format("%d, ", r * 255)
    rgb = rgb .. string.format("%d, ", g * 255)
    rgb = rgb .. string.format("%d",   b * 255)
    if a then rgb = rgb .. string.format(", %d", a * 255) end
    return rgb
end

function colour_util.hsl_to_rgb(h, s, l)
    h = h % 360
    s = math.max(0, math.min(s, 1))
    l = math.max(0, math.min(l, 1))
    h = h / 360
    local m1, m2
    if l <= 0.5 then
        m2 = l * (s + 1)
    else
        m2 = l + s - l * s
    end
    m1 = l * 2 - m2
    return
        h2rgb(m1, m2, h + 1/3),
        h2rgb(m1, m2, h),
        h2rgb(m1, m2, h - 1/3)
end

function colour_util.rgb_to_hsl(r, g, b)

    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, l

    l = (max + min) / 2

    if max == min then
        h, s = 0, 0 -- achromatic
    else
        local d = max - min
        if l > 0.5 then 
            s = d / (2 - max - min) 
        else 
            s = d / (max + min) 
        end
        if max == r then
            h = (g - b) / d
            if g < b then h = h + 6 end
        elseif max == g then 
            h = (b - r) / d + 2
        elseif max == b then 
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    return h, s, l, a or 1
end

function colour_util.rgb_to_hsv(r, g, b)
    local k = 0
    if g < b then
        g, b = b, g
        k = -1
    end
    if r < g then
        r, g = g, r
        k = -1 / 6 - k
    end
    local chroma = r - math.min(g, b)

    local h = math.abs(k + (g - b) / (6 * chroma + 1E-20))
    local s = chroma / (r + 1E-20)
    local v = r;

    return h, s, v
end

function colour_util.hsv_to_rgb(h, s, v)
    local r, g, b

    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then
        r, g, b = v, t, p
    elseif i == 1 then
        r, g, b = q, v, p
    elseif i == 2 then
        r, g, b = p, v, t
    elseif i == 3 then
        r, g, b = p, q, v
    elseif i == 4 then
        r, g, b = t, p, v
    elseif i == 5 then
        r, g, b = v, p, q
    end

    return r, g, b, a
end

function colour_util.textColour(backgroundColour)
    local r, g, b = unpack(backgroundColour)
    local h, s, l = colour_util.rgb_to_hsl(r, g, b)
    if l > 0.5 then
        return 0, 0, 0
    else
        return 1, 1, 1
    end
end

return colour_util

