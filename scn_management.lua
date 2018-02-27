local colour = require 'util_colour'
local bricks = require 'lib_bricks'

-- local group           = bricks.group
-- local text            = bricks.text
-- local checkbox        = bricks.checkbox
-- local spinner         = bricks.spinner
-- local button          = bricks.button
-- local text_input      = bricks.text_input
-- local radio_group     = bricks.radio_group
-- local radio_option    = bricks.radio_option
-- local dropdown_group  = bricks.dropdown_group
-- local dropdown_option = bricks.dropdown_option

local Scene = require 'scn_base'

local Pitch = require 'cls_pitch'

local Management = {}
setmetatable(Management, Scene)
Management.__index = Management

function Management.new(team)
    local self = Scene.new("management")
    setmetatable(self, Management)

    self.team = team
    self.pitch = Pitch.new()

    return self
end

function Management:load()
    local cx, cy = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2

    local w = FONTS.game_title:getWidth(self.team.name)
    local title = bricks.text({cx - w / 2 - 32, 16, w + 64, FONTS.game_title:getHeight() + 32, "center"}, {
        text = self.team.name,
        tags = {"title"},
        style = {
            font = FONTS.game_title,
            backgroundColor = self.team.home_colour,
            borderRadius = {12, 12},
            padding = {16, 16, 16, 16}
        },
    })

    local player_list = bricks.group({32, 128, 128, 544}, {})
    for i, player in ipairs(self.team.available_players) do
        local player_elem = bricks.group({4, i * 32, "100", 32}, {
            bricks.text(tostring(player.number)),
            bricks.text(player.name),
        })
        print(player.number, player.name)
        player_list:addElement(player_elem)
    end

    self.layout = bricks.layout({
        title,
    })
end    

function Management:keypressed(key)
    -- @TODO: save the team with a keypress
    -- @TODO: make a UI so this can be done with on-screen buttons.
end

function Management:draw()
    -- local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    -- love.graphics.setColor(DEFAULT_THEME.background)
    -- love.graphics.rectangle("fill", 16, 16, w - 32, h - 32, 8, 8)
    -- love.graphics.setColor(DEFAULT_THEME.border)
    -- love.graphics.rectangle("line", 16, 16, w - 32, h - 32, 8, 8)

    self.layout:draw()

    -- self:drawTitle()
    self:drawPitch()
    -- self:drawPlayerList()
end

function Management:drawTitle()
    local font = FONTS.game_title
    local padding = 16
    local text_width = font:getWidth(self.team.name:upper()) + padding * 2
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.setColor(self.team.home_colour)
    love.graphics.rectangle("fill", (w - text_width) / 2, 8, text_width, font:getHeight() + padding * 2, 8, 8)
    love.graphics.setColor(DEFAULT_THEME.border)
    love.graphics.rectangle("line", (w - text_width) / 2, 8, text_width, font:getHeight() + padding * 2, 8, 8)
    love.graphics.setColor(colour.textColour(self.team.home_colour))
    love.graphics.setFont(font)
    love.graphics.printf(self.team.name:upper(), (w - text_width) / 2, 8 + padding, text_width, "center")
    
end

function Management:drawPitch()
    local scale = 4
    local w = self.pitch.pitch_width * scale
    local h = self.pitch.pitch_length * scale
    local x = love.graphics.getWidth() - (64 + w / 2)
    local y = love.graphics.getHeight() / 2
    love.graphics.setColor(DEFAULT_THEME.void)
    love.graphics.rectangle("fill", x - w / 2 - 2, y - h / 2 - 2, w + 4, h + 4)
    love.graphics.setColor(DEFAULT_THEME.border)
    love.graphics.rectangle("line", x - w / 2 - 2, y - h / 2 - 2, w + 4, h + 4)
    self.pitch:draw(x, y, 0, scale)
end

function Management:drawPlayerList()
    local font = FONTS.game_text
    local x, y = 32, 128
    local num_width = font:getWidth("99")
    local n = math.max(font:getHeight(), num_width)
    love.graphics.setFont(font)
    for i, player in pairs(self.team.available_players) do
        love.graphics.setColor(DEFAULT_THEME.border)
        love.graphics.rectangle("line", x, y + (i-1) * 24, 128, 24)
        love.graphics.setColor(self.team.home_colour)
        love.graphics.circle("fill", x + 4, y + (i-1) * 24 + 1 + n / 2, n / 2)
        love.graphics.setColor(colour.textColour(self.team.home_colour))
        love.graphics.print(player.number, x, y + (i-1) * 24)
        love.graphics.setColor(colour.textColour(DEFAULT_THEME.background))
        love.graphics.print(player.name, x + 24, y + (i-1) * 24)
    end
end

return Management