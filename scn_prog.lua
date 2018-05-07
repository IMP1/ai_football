local fizzle = require 'fizzle.fizzle'

local Scene = require 'scn_base'
local VisProg = {}
setmetatable(VisProg, Scene)
VisProg.__index = VisProg

function VisProg.new()
    local self = Scene.new("programming")
    setmetatable(self, VisProg)

    return self
end

function VisProg:load()
    local prog = fizzle.programme(0, 0, 0, 0)
        local decl = fizzle.var_set(0, 0, 0, 0)
            local name = fizzle.value('string', 0, 0, 0, 0)
            name:set("foo")
            local value = fizzle.value('number', 0, 0, 0, 0)
            value:set(5)
        decl:add('name', name)
        decl:add('value', value)
    prog:add('children', decl)

        local ifst = fizzle.if_then(0, 0, 0, 0)
            local cond = fizzle.bin_cond(0, 0, 0, 0)
                local op1 = fizzle.var_get('foo', 0, 0, 0, 0)
                local op2 = fizzle.value('number', 0, 0, 0, 0)
                op2:set(5)
            cond:add('left_operand', op1)
            cond:add('right_operand', op2)
            cond:setOperation(cond.Operation.LESS_THAN)
        ifst:add('condition', cond)
    prog:add('children', ifst)

    print("Programme set up.")
    prog:execute()
end

function VisProg:update(dt)
end

function VisProg:draw()
end

return VisProg