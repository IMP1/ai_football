local colour = require 'util_colour'

local Vector = require 'lib_vec3'
local Vec3 = Vector.new

local Object = require 'cls_object'

local Player = {}
setmetatable(Player, Object)
Player.__index = Player

Player.POSITIONS = {
    "GK", 
    "LB",  "LCB",  "CB",  "RCB",  "RB",
    "LDM", "LCDM", "CDM", "RCDM", "RDM",
    "LM",  "LCM",  "CM",  "RCM",  "RM",
    "LAM", "LCAM", "CAM", "RCAM", "RAM",
    "LF",  "LCF",  "CF",  "RCF",  "RF",
}

function Player.new(team, name, number, ai)
    local self = Object.new(0, 0, 0)
    setmetatable(self, Player)

    self.team = team
    self.name = name
    self.number = number
    self.ai = ai
    self.stats = {
        speed = 5, -- m/s
        turn_speed = nil, -- r/s?
    }
    self.memory = {}
    self.game_position_index = 1

    -- In-Game properties
    self.has_the_ball = false

    return self
end

function Player:dump()
    local str = "{\n"

    str = str .. string.format("\tname   = \"%s\",\n", self.name)
    str = str .. string.format("\tnumber = \"%s\",\n", self.number)
    str = str .. string.format("\tai     = \"ai_%s_%s.lua\",\n", self.ai.author, self.ai.name)
    str = str .. "\tstats  = {\n"

    for stat, value in pairs(self.stats) do
        str = str .. string.format("\t\t%s = %s,\n", stat, value)
    end

    str = str .. "\t},\n"

    return str .. "}\n"
end

function Player:moveTowards(position)
    self.linear_velocity = (position - self.position):normalise() * self.stats.speed
end

function Player:interrupt(game, command)
    if self.ai.interrupt then
        self.ai.interrupt(self, game, command)
    end
end

function Player:shout(game, command, recipient)
    if recipient and recipient.team == self.team then
        print("Shouting '" .. command .. "' at " .. recipient.name)
        recipient:interrupt(game, command)
    else
        for _, player in pairs(self.team.players) do
            if player.team == team then
                print("Shouting '" .. team.interrupts[interrupt_index] .. "' at the team")
                player:interrupt(game, command)
            end
        end
    end
end

function Player:update(dt, game)
    Object.update(self, dt)
end

function Player:draw(ox, oy, rotation, scale)
    -- @TODO: take offset (ox and oy) into account

    local x, y, z = unpack(self.position:rotate(0, 0, -rotation).data)
    love.graphics.setColor(self.team.home_colour)
    love.graphics.circle("fill", x * scale, y * scale, 1 * scale)
    love.graphics.setColor(colour.textColour(self.team.home_colour))
    love.graphics.printf(self.number, x * scale - 32, y * scale - 6, 64, "center")
end

return Player