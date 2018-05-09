

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

function Container.new(capacity, ...)
    local self = {}
    setmetatable(self, Container)
    self.types    = {...}
    self.max_size = capacity
    self.items    = {}
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

function Component.new(name)
    local self = {}
    setmetatable(self, Component)
    self.name        = name
    self.containers  = {}
    self.environment = {}
    return self
end

function Component:is_a(Component_type)
    local metatable = getmetatable(self)
    while metatable ~= nil do
        if metatable == component_type then
            return true
        end
        metatable = getmetatable(metatable)
    end
    return false
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

function Expression.new(name)
    local self = Component.new(name .. "-Expression")
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

function Value.new(type)
    local self = Expression.new("Value")
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

function BinaryCondition.new()
    local self = Expression.new("Condition")
    setmetatable(self, BinaryCondition)
    self.containers['left_operand']  = Container.new(1, Expression)
    self.containers['right_operand'] = Container.new(1, Expression)
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

function VariableAccess.new(varname)
    local self = Expression.new("Variable")
    setmetatable(self, VariableAccess)
    self.containers['name'] = Container.new(1, Value)
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

function Statement.new(name)
    local self = Component.new(name .. "-Statement")
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

function Block.new()
    local self = Statement.new("Block")
    setmetatable(self, Block)
    self.containers['children'] = Container.new(nil, Statement)
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

function IfStatement.new()
    local self = Statement.new("If")
    setmetatable(self, IfStatement)

    self.containers['condition'] = Container.new(1, Statement)
    self.containers['then']      = Container.new(1, Block)

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

function IfElseStatement.new()
    local self = Statement.new("If")
    setmetatable(self, IfElseStatement)

    self.containers['condition'] = Container.new(1, Expression)
    self.containers['then']      = Container.new(1, Block)
    self.containers['else']      = Container.new(1, Block)

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

function DeclStatement.new()
    local self = Statement.new("Declaration")
    setmetatable(self, DeclStatement)
    self.containers['name']  = Container.new(1, Value)
    self.containers['value'] = Container.new(1, Expression)
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

function Programme.new()
    local self = Block.new()
    setmetatable(self, Programme)
    self.programme = self.programme
    self.environment = {}
    return self
end

function Programme:execute(env)
    Block.execute(self, env or self.environment)
end

local lang = {}

lang.objects = {
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

lang.if_then      = IfStatement.new
lang.if_then_else = IfElseStatement.new
lang.var_set      = DeclStatement.new
lang.var_get      = VariableAccess.new
lang.block        = Block.new
lang.value        = Value.new
lang.bin_cond     = BinaryCondition.new
lang.programme    = Programme.new

return lang