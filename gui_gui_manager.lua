local gui_manager = {}

function gui_manager.hook()
    for event_name, func in pairs(love.handlers) do
        love.handlers[event_name] = function(...)
            func(...)
            if gui_manager[event_name] then
                gui_manager[event_name](...)
            end
        end
    end
end

local scenes = {}
local transitions = {}

local function active_scenes()
    local result = {}
    for _, scene in pairs(scenes) do
        if scene.active then
            table.insert(result, scene)
        end
    end
    return result
end

local function visible_scenes()
    local result = {}
    for _, scene in pairs(scenes) do
        if scene.visible then
            table.insert(result, scene)
        end
    end
    return result
end

local function add_transition(gui_id, transition_id, transition)
    transitions[gui_id][transition_id] = transition
end

gui_manager.transitions = {
    swipe = function(id, pos_from, pos_to, duration, post_action)
        local timer = 0
        local original_position = {unpack(scenes[id].offset)}
        scenes[id].offset = pos_from or original_position
        add_transition(id, 'swipe', function(dt)
            timer = timer + dt
            if timer >= duration then
                scenes[id].offset = pos_to or original_position
                transitions[id].swipe = nil
                if post_action then
                    post_action()
                end
                return
            end
            local dx = dt * (pos_to[1] - pos_from[1]) / duration
            local dy = dt * (pos_to[2] - pos_from[2]) / duration
            scenes[id].offset[1] = scenes[id].offset[1] + dx
            scenes[id].offset[2] = scenes[id].offset[2] + dy
        end)
    end,
    fade = function(id, fade_from, fade_to, duration, post_action)
        local timer = 0
        scenes[id].opacity = fade_from
        add_transition(id, 'fade', function(dt)
            timer = timer + dt
            if timer >= duration then
                scenes[id].opacity = fade_to
                transitions[id].fade = nil
                if post_action then
                    post_action()
                end
                return
            end
            local dx = dt * (fade_to - fade_from) / duration
            scenes[id].opacity = scenes[id].opacity + dx
        end)
    end
}

function gui_manager.clear()
    scenes = {}
    transitions = {}
end

function gui_manager.register(id, elements)
    scenes[id] = {
        id       = id,
        offset   = {0, 0},
        opacity  = 1,
        visible  = false,
        active   = false,
        elements = elements,
    }
    transitions[id] = {}
end

function gui_manager.reset(id)
    if scenes[id] then
        transitions[id] = {}
        scenes[id].offset  = {0, 0}
        scenes[id].opacity = 1
    end
end

function gui_manager.remove(id)
    scenes[id] = nil
    transitions[id] = nil
end

function gui_manager.switchTo(id)
    for id, scene in pairs(scenes) do
        gui_manager.disable(id)
    end
    gui_manager.enable(id)
end

function gui_manager.enable(id)
    scenes[id].active = true
end

function gui_manager.disable(id)
    scenes[id].active = false
end

function gui_manager.show(id)
    scenes[id].visible = true
end

function gui_manager.hide(id)
    scenes[id].visible = false
end

function gui_manager.open(id)
    gui_manager.show(id)
    gui_manager.enable(id)
end

function gui_manager.close(id)
    gui_manager.disable(id)
    gui_manager.hide(id)
end

function gui_manager.is_visible(id)
    return scenes[id].visible
end

function gui_manager.is_enabled(id)
    return scenes[id].active
end

function gui_manager.update(dt)
    local mx, my = love.mouse.getPosition()
    for _, scene in pairs(scenes) do
        local updated_transition = false
        for transisition_type, transition in pairs(transitions[scene.id]) do
            transition(dt)
            updated_transition = true
        end
        if scene.active and not updated_transition then
            for _, element in pairs(scene.elements) do
                element:update(dt, mx, my)
            end
        end
    end
end

function gui_manager.draw()
    for _, scene in pairs(visible_scenes()) do
        love.graphics.push()
        love.graphics.translate(unpack(scene.offset))
        love.graphics.setColor(1, 1, 1, scene.opacity)
        for _, element in pairs(scene.elements) do
            local element_opacity = element.opacity
            element.opacity = element.opacity * scene.opacity
            element:draw()
            element.opacity = element_opacity
        end
        love.graphics.pop()
    end
end


function gui_manager.mousepressed(mx, my, key)
    for _, scene in pairs(active_scenes()) do
        local ox, oy = unpack(scene.offset)
        for _, element in pairs(scene.elements) do
            element:mousePressed(mx - ox, my - oy, key)
        end
    end
end

function gui_manager.mousereleased(mx, my, key)
    for _, scene in pairs(active_scenes()) do
        local ox, oy = unpack(scene.offset)
        for _, element in pairs(scene.elements) do
            element:mouseReleased(mx - ox, my - oy, key)
        end
    end
end 

function gui_manager.wheelmoved(mx, my, dx, dy)
    for _, scene in pairs(active_scenes()) do
        local ox, oy = unpack(scene.offset)
        for _, element in pairs(scene.elements) do
            element:mouseScrolled(mx - ox, my - oy, dx, dy)
        end
    end
end 

function gui_manager.keypressed(key, is_repeat)
    for _, scene in pairs(active_scenes()) do
        for _, element in pairs(scene.elements) do
            element:keyPressed(key, is_repeat)
        end
    end
end

function gui_manager.keyreleased(key)
    for _, scene in pairs(active_scenes()) do
        for _, element in pairs(scene.elements) do
            element:keyReleased(key)
        end
    end
end

function gui_manager.textinput(key)
    for _, scene in pairs(active_scenes()) do
        for _, element in pairs(scene.elements) do
            element:keyTyped(key)
        end
    end
end

return gui_manager
