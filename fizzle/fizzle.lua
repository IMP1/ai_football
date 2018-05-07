--[[

-- Names?

-- grapple
-- visionary
-- prograph
-- splash
-- viscous
-- socks
-- physical / programming
-- fizzle?


-- Add statements for mofdifying game state (kick ball, run, tackle, etc.)
-- Add expressions for querying game state (position of X, veloctiy of Y, pitch properties, etc.)

-- TESTING

local prog = Block.new(0, 0, 0, 0)

    local decl = Declaration.new(0, 0, 0, 0)

        local name = Value.new('string', 0, 0, 0, 0)
        name:set("foo")
        local value = Value.new('number', 0, 0, 0, 0)
        value:set(5)

    decl:add('name', name)
    decl:add('value', value)

prog.add('children', decl)

    local ifst = IfStatement.new(0, 0, 0, 0)

        local cond = BinaryCondition.new()

            local op1 = Variable.new('foo', 0, 0, 0, 0)
            local op2 = Value.new('number', 0, 0, 0, 0)
            op2:set(5)

        cond:add('left_operand', op1)
        cond:add('right_operand', op2)
        cond:operation(Operation.LESS_THAN)

    ifst:add('condition', cond)
    
prog.add('children', ifst)

--]]


local Container = {}
Container.__tostring = function(self)
    return "Container"
end
Container.__index = function(tbl, key)
    if type(key) == "number" then
        return tbl.items[key]
    else
        return Container[key]
    end
end

function Container.new(x, y, w, h, types, size)
    local self = {}
    setmetatable(self, Container)
    self.position  = {x, y}
    self.size      = {w, h}
    self.types     = types
    self.max_size  = size
    self.items     = {}
    return self
end

function Container:canTake(component)
    if self.max_size and (#self.items >= self.max_size) then
        return false
    end
    for _, t in ipairs(self.types) do
        if component:is_a(t) then
            return true
        end
    end
    return false
end

function Container:add(component)
    if not self:canTake(component) then
        return false
    end
    table.insert(self.items, component)
    return true
end



local Component = {}
Component.__index = Component
Component.__tostring = function(self)
    return "Component"
end

function Component.new(name, x, y, w, h)
    local self = {}
    setmetatable(self, Component)
    self.name        = name
    self.position    = {x, y}
    self.size        = {w, h}
    self.containers  = {}
    self.environment = {}
    return self
end

function Component:is_a(component_type)
    local metatable = getmetatable(self)
    while metatable ~= nil do
        if metatable == component_type then
            return true
        end
        metatable = getmetatable(metatable)
    end
    return false
end

function Component:canAdd(child, x, y)
    for _, container in pairs(self.containers) do
        if x == nil or y == nil then
            if container:canTake(child) then
                return container
            end
        end
        if container:containsPoint(x, y) and container:canTake(child) then
            return container
        end
    end
    return nil
end

function Component:add(container, child)
    if self.programme then
        child.programme = self.programme
    end
    self.containers[container]:add(child)
end



local Expression = {}
setmetatable(Expression, Component)
Expression.__index = Expression
Expression.__tostring = function(self)
    return "Expression"
end

function Expression.new(name, x, y, w, h)
    local self = Component.new(name .. "-Expression", x, y, w, h)
    setmetatable(self, Expression)
    return self
end

function Expression:evaluate(env)
    error("not implemented")
end


local Value = {}
setmetatable(Value, Expression)
Value.__index = Value
Value.__tostring = function(self)
    return "Value"
end

function Value.new(type, x, y, w, h)
    local self = Expression.new("Value", x, y, w, h)
    setmetatable(self, Value)
    self.type  = type
    self.value = nil
    return self
end

function Value:set(value)
    self.value = value
end

function Value:evaluate(env)
    return self.value
end


local BinaryCondition = {}
setmetatable(BinaryCondition, Expression)
BinaryCondition.__index = BinaryCondition
BinaryCondition.__tostring = function(self)
    return "BinaryCondition"
end

BinaryCondition.Operation = {
    LESS_THAN     = "<",
    GREATER_THAN  = ">",
    EQUAL_TO      = "=",
    NOT_EQUAL_TO  = "=/=",
    LESS_EQUAL    = "<=",
    GREATER_EQUAL = ">=",
}

function BinaryCondition.new(x, y, w, h)
    local self = Expression.new("Condition", x, y, w, h)
    setmetatable(self, BinaryCondition)
    self.containers['left_operand']  = Container.new(0, 0, 0, 0, {Expression}, 1)
    self.containers['right_operand'] = Container.new(0, 0, 0, 0, {Expression}, 1)
    self.operation = BinaryCondition.Operation.EQUAL_TO
    return self
end

function BinaryCondition:setOperation(op)
    self.operation = op
end

function BinaryCondition:evaluate(env)
    local left  = self.containers['left_operand'][1]:evaluate(env)
    local right = self.containers['right_operand'][1]:evaluate(env)
    if self.operation == BinaryCondition.Operation.LESS_THAN then
        return left < right
    elseif self.operation == BinaryCondition.Operation.GREATER_THAN then
        return left > right
    elseif self.operation == BinaryCondition.Operation.EQUAL_TO then
        return left == right
    elseif self.operation == BinaryCondition.Operation.NOT_EQUAL_TO then
        return left ~= right
    elseif self.operation == BinaryCondition.Operation.LESS_EQUAL then
        return left <= right
    elseif self.operation == BinaryCondition.Operation.GREATER_EQUAL then
        return left >= right
    else
        error("invalid operation '" .. self.operation .. "'.")
    end
end


local VariableAccess = {}
setmetatable(VariableAccess, Expression)
VariableAccess.__index = VariableAccess
VariableAccess.__tostring = function(self)
    return "VariableAccess"
end

function VariableAccess.new(varname, x, y, w, z)
    local self = Expression.new("Variable", x, y, w, h)
    setmetatable(self, VariableAccess)
    self.containers['name'] = Container.new(0, 0, 0, 0, {Value}, 1)
    local name = Value.new("string", 0, 0, 0, 0)
    name:set(varname)
    self.containers['name']:add(name)
    return self
end

function VariableAccess:evaluate(env)
    local varname = self.containers['name'][1]:evaluate(env)
    return env[varname]
end




local Statement = {}
setmetatable(Statement, Component)
Statement.__index = Statement
Statement.__tostring = function(self)
    return "Statement"
end

function Statement.new(name, x, y, w, h)
    local self = Component.new(name .. "-Statement", x, y, w, h)
    setmetatable(self, Statement)
    return self
end

function Statement:execute(env)
    error("not implemented")
end


local Block = {}
setmetatable(Block, Statement)
Block.__index = Block
Block.__tostring = function(self)
    return "Block"
end

function Block.new(x, y, w, h)
    local self = Statement.new("Block", x, y, w, h)
    setmetatable(self, Block)
    self.containers['children'] = Container.new(0, 0, 0, 0, {Statement})
    return self
end

function Block:execute(env)
    for _, statement in ipairs(self.containers['children'].items) do
        statement:execute(env)
    end
end



local IfStatement = {}
setmetatable(IfStatement, Statement)
IfStatement.__index = IfStatement
IfStatement.__tostring = function(self)
    return "IfStatement"
end

function IfStatement.new(x, y, w, h)
    local self = Statement.new("If", x, y, w, h)
    setmetatable(self, IfStatement)

    self.containers['condition'] = Container.new(0, 0, 0, 0, {Expression}, 1)
    self.containers['then']      = Container.new(0, 0, 0, 0, {Block}, 1)

    return self
end

function IfStatement:execute(env)
    local cond = self.containers['condition'][1]:evaluate(env)
    if cond then
        self.containers['then'][1]:execute(env)
    end
end

local IfElseStatement = {}
setmetatable(IfElseStatement, Statement)
IfElseStatement.__index = IfElseStatement
IfElseStatement.__tostring = function(self)
    return "IfElseStatement"
end

function IfElseStatement.new(x, y, w, h)
    local self = Statement.new("If", x, y, w, h)
    setmetatable(self, IfElseStatement)

    self.containers['condition'] = Container.new(0, 0, 0, 0, {Expression}, 1)
    self.containers['then']      = Container.new(0, 0, 0, 0, {Block}, 1)
    self.containers['else']      = Container.new(0, 0, 0, 0, {Block}, 1)

    return self
end

function IfElseStatement:execute(env)
    local cond = self.containers['condition']:evaluate(env)
    if cond then
        self.containers['then'][1]:execute(env)
    else
        self.containers['else'][1]:execute(env)
    end
end



local DeclStatement = {}
setmetatable(DeclStatement, Statement)
DeclStatement.__index = DeclStatement
DeclStatement.__tostring = function(self)
    return "DeclStatement"
end

function DeclStatement.new(x, y, w, h)
    local self = Statement.new("Declaration", x, y, w, h)
    setmetatable(self, DeclStatement)
    self.containers['name']  = Container.new(0, 0, 0, 0, {Value}, 1)
    self.containers['value'] = Container.new(0, 0, 0, 0, {Expression}, 1)
    return self
end

function DeclStatement:execute(env)
    local varname = self.containers['name'][1]:evaluate(env)
    local value = self.containers['value'][1]:evaluate(env)
    env[varname] = value
end


local Programme = {}
setmetatable(Programme, Block)
Programme.__index = Programme

function Programme.new(x, y, w, h)
    local self = Block.new(x, y, w, h)
    setmetatable(self, Programme)
    self.programme = self.programme
    self.environment = {}
    return self
end

function Programme:execute(env)
    Block.execute(self, env or self.environment)
end


local fizzle = {}

fizzle.if_then      = IfStatement.new
fizzle.if_then_else = IfElseStatement.new
fizzle.var_set      = DeclStatement.new
fizzle.var_get      = VariableAccess.new
fizzle.block        = Block.new
fizzle.value        = Value.new
fizzle.bin_cond     = BinaryCondition.new
fizzle.programme    = Programme.new

return fizzle