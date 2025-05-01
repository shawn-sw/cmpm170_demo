local menu = require "states.menu"
local Gamestate = require "lib.gamestate"


local dead = {}

function dead:draw()
    love.graphics.printf("YOU DIED - PRESS M TO MENU", 0, 200, love.graphics.getWidth(), "center")
end

function dead:keypressed(key)
    if key == "m" then
        Gamestate.switch(menu)
    end
end

return dead
