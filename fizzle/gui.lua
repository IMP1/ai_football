--[[

TODO:
  - Make a single visual component? That refers to a single language component.
  - Then subclass the visual component to deal with how it looks and behaves.


  Statements    square
  Expressions   rounded rectangles
  Containers    depends on types it can take
  Dropdowns     square

--]]

local lang = require 'lang'

local Object = {}
Object.__index = Object

function Object.new(x, y, w, h, component)
    local self = {}
    setmetatable(self, Object)
    self.position  = {x, y}
    self.size      = {w, h}
    self.component = nil
    return self
end

function Object:containsPoint(x, y)
    return x >= self.position[1] and x <= self.position[1] + self.size[1] and
           y >= self.position[2] and y <= self.position[2] + self.size[2]
end



local Container = {}
setmetatable(Container, Object)
Container.__index = Container

function Container.new(x, y, w, h, capacity, type)
    local self = Object.new(x, y, w, h)
    setmetatable(self, Container)
    self.component = lang.objects.Container.new(capacity, type)
    return self
end

function Container:draw()
    -- @TODO: decide how things are drawn
    local x, y = unpack(self.position)
    local w, h = unpack(self.size)
    local r = 0
    if self.component.type == lang.objects.Expression then
        r = 8
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", x, y, w, h)
    -- Shadow
    love.graphics.setColor(0, 0, 0, 0.3)
    love.graphics.rectangle("fill", x, y, 2, h)
    love.graphics.rectangle("fill", x, y, w, 2)
    -- @TODO: draw contents.
end

local Component = {}
setmetatable(Component, Object)
Component.__index = Component

function Component.new(x, y, w, h, name)
    local self = Object.new(x, y, w, h)
    setmetatable(self, Component)
    self.component  = lang.objects.Component.new(name)
    self.containers = {}
    return self
end

function Component:add(name, child)
    self.containers[name]:add(child)
    self.containers[name].component:add(child.component)
end

function Component:draw()
    -- @STUB
end

local Expression = {}
setmetatable(Expression, Object)
Expression.__index = Expression

function Expression.new(x, y, w, h, name)
    local self = Object.new(x, y, w, h)
    setmetatable(self, Expression)
    self.component = lang.objects.Expression.new(name)
    return self
end

local Statement = {}
setmetatable(Statement, Object)
Statement.__index = Statement

function Statement.new(x, y, w, h, name)
    local self = Object.new(x, y, w, h)
    setmetatable(self, Statement)
    self.component = lang.objects.Statement.new(name)
    return self
end







local gui = {}

gui.objects = {
    Object,

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