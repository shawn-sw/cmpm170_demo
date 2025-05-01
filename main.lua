local sti = require "lib.sti"
local Gamestate = require "lib.gamestate"

local menu = require "states.menu"
local level1 = require "states.level1"
--local level2 = require "states.level2"
local dead = require "states.dead"
local ending = require "states.end"

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end