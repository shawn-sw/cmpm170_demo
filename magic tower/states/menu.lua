local Gamestate = require "lib.gamestate"
local level1 = require "states.level1"

local menu = {}

function menu:draw()
    love.graphics.printf("PRESS ENTER TO START", 0, 200, love.graphics.getWidth(), "center")
end

function menu:keypressed(key)
    if key == "return" then
        Gamestate.switch(level1)
    end
end

return menu
