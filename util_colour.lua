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

function colour_util.toRGB(h, s, l, a)
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
        255 * h2rgb(m1, m2, h + 1/3),
        255 * h2rgb(m1, m2, h),
        255 * h2rgb(m1, m2, h - 1/3)
end

function colour_util.toHSL(r, g, b, a)
    r, g, b = r / 255, g / 255, b / 255

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

function colour_util.textColour(backgroundColour)
    local r, g, b = unpack(backgroundColour)
    local h, s, l = colour_util.toHSL(r, g, b)
    if l > 0.5 then
        return 0, 0, 0
    else
        return 255, 255, 255
    end
end

return colour_util