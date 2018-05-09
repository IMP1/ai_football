local lang = require 'lang'

local Container = {}
setmetatable(Container, lang.objects.Container)
Container.__index = Container

function Container.new(x, y, w, h, capacity, types)
    local self = {}
    setmetatable(self, Container)
    self.position  = {x, y}
    self.size      = {w, h}
    self.container = lang.objects.Container.new(capacity, unpack(types))
    return self
end

function Container:hasPoint(x, y)
    return x >= self.position[1] and x <= self.position[1] + self.size[1] and
           y >= self.position[2] and y <= self.position[2] + self.size[2]
end


local Component = {}
Component.__index = Component

function Component.new(x, y, w, h, name)
    local self = {}
    setmetatable(self, Component)
    self.position   = {x, y}
    self.size       = {w, h}
    self.component  = lang.objects.Component.new(name)
    return self
end



local gui = {}

gui.elements = {
    Container,
    Component,

    Statement,
    IfStatement,
    IfElseStatement.
    DeclStatement,
    Block,
    Programme,
    
    Expression,
    Value,
    VariableAccess,
    BinaryCondition,
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