local bricks = require 'lib_bricks'
local colour = require 'util_colour'

local cx, cy = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 -- centre points

return function(team)
    
    local w = FONTS.game_title:getWidth(team.name)
    local title = bricks.text({cx - w / 2 - 32, 16, w + 64, FONTS.game_title:getHeight() + 32, "center"}, {
        text = team.name,
        tags = {"title"},
        style = {
            font = FONTS.game_title,
            backgroundColor = team.home_colour,
            borderRadius = {12, 12},
            padding = {16, 16, 16, 16}
        },
    })

    local bg_colour = {[0] = DEFAULT_THEME.stripe1, [1] = DEFAULT_THEME.stripe2}
    local player_list = bricks.group({32, 96, 320, 416}, {
        style = {
            backgroundColor = DEFAULT_THEME.background,
            borderRadius = {4, 4},
            borderColor = team.home_colour,
        },
    }, {
        bricks.text({0, 0, 32, "100"}, {
            text = "#",
            style = {
                textColor = {colour.textColour(DEFAULT_THEME.background)},
            },
        }),
        bricks.text({24, 0, 64, "100"}, {
            text = "Pos",
            style = {
                textColor = {colour.textColour(DEFAULT_THEME.background)},
            },
        }),
        bricks.text({64, 0, 128, "100"}, {
            text = "Name",
            style = {
                textColor = {colour.textColour(DEFAULT_THEME.background)},
            },
        }),
    })
    for i, player in ipairs(team.available_players) do
        local player_elem = bricks.button({0, 24 + (i-1) * 24, "100", 24}, {
                style = {
                    backgroundColor = bg_colour[i % 2],
                    borderRadius = {0, 0},
                    margin = {1, 0, 1, 0},
                    padding = {0, 0, 0, 0},
                },
            }, {
            bricks.text({0, 0, 32, "100"}, {
                text = tostring(player.number),
                style = {
                    textColor = {colour.textColour(bg_colour[i % 2])},
                },
            }),
            bricks.text({24, 0, 64, "100"}, {
                text = player.POSITIONS[player.game_position_index],
                style = {
                    textColor = {colour.textColour(bg_colour[i % 2])},
                },
            }),
            bricks.text({64, 0, 128, "100"}, {
                text = player.name,
                style = {
                    textColor = {colour.textColour(bg_colour[i % 2])},
                },
            }),
        })
        -- @TODO: handle on-click
        player_list:addElement(player_elem)
    end

    return bricks.layout({
        title,
        player_list,
    })

end