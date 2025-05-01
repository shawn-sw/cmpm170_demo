local menu = require "states.menu"
local Gamestate = require "lib.gamestate"

local ending = {}

function ending:draw()
    love.graphics.printf("THE END - PRESS M TO MENU", 0, 200, love.graphics.getWidth(), "center")
end

function ending:keypressed(key)
    if key == "m" then
        Gamestate.switch(menu)
    end
end

return ending
