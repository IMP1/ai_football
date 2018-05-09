local lang = require 'lang'

local Container = {}
setmetatable(Container, lang.objects.Container)
Container.__index = Container

function Container.new(x, y, w, h, capacity, types)
    local self = lang.objects.Container.new(capacity, unpack(types))
    setmetatable(self, Container)
    self.position  = {x, y}
    self.size      = {w, h}
    return self
end

function Container:hasPoint(x, y)
    return x >= self.position[1] and x <= self.position[1] + self.size[1] and
           y >= self.position[2] and y <= self.position[2] + self.size[2]
end


local Component = {}
setmetatable(Component, lang.objects.Component)
Component.__index = Component

function Component.new(x, y, w, h, name)
    local self = lang.objects.Component.new(name)
    setmetatable(self, Component)
    self.position   = {x, y}
    self.size       = {w, h}
    return self
end

-- @Override
function Component:setContainer(x, y, w, h, name, limit, ...)
    self.containers[name] = Container.new(x, y, w, h, limit, ...)
end



local gui = {}

gui.objects = {
    Container,
    Component,

    Expression,
    Value,
    BinaryCondition,
    VariableAccess,
    
    Statement,
    Block,
    IfStatement,
    IfElseStatement.
    DeclStatement,
    Programme,
}

gui.if_then      = IfStatement.new
gui.if_then_else = IfElseStatement.new
gui.var_set      = DeclStatement.new
gui.var_get      = VariableAccess.new
gui.block        = Block.new
gui.value        = Value.new
gui.bin_cond     = BinaryCondition.new
gui.programme    = Programme.new

return gui