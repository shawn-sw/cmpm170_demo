local sti = require "lib.sti"
local Gamestate = require "lib.gamestate"
local player = require("states.player")

local level1 = {}

local function getTileByGID(map, gid)
    for _, tileset in ipairs(map.tilesets) do
        if gid >= tileset.firstgid and gid < tileset.firstgid + (tileset.tilecount or 0) then
            local tileid = gid - tileset.firstgid
            return map.tiles[tileid]
        end
    end
    return nil
end

local function isCollidable(tile)
    if not tile or not tile.properties then return false end
    local collides = tile.properties.collides
    return collides == true or (type(collides) == "table" and collides.value == true)
end

local function initTileLayerCollisions(map, world, layerName)
    local tileLayer = map.layers[layerName]
    if not tileLayer then
        print("图层不存在: " .. layerName)
        return
    end

    local tilewidth = map.tilewidth
    local tileheight = map.tileheight

    for y = 1, tileLayer.height do
        for x = 1, tileLayer.width do
            local tileIndex = (y - 1) * tileLayer.width + x
            local tileData = tileLayer.data[tileIndex]
            local gid = (type(tileData) == "table" and tileData.gid) or (type(tileData) == "number" and tileData or nil)

            if type(gid) == "number" and gid > 0 then
                local tile = getTileByGID(map, gid)
                if isCollidable(tile) then
                    local px = (x - 1) * tilewidth + tilewidth / 2
                    local py = (y - 1) * tileheight + tileheight / 2

                    local body = love.physics.newBody(world, px, py, "static")
                    local shape = love.physics.newRectangleShape(tilewidth, tileheight)
                    local fixture = love.physics.newFixture(body, shape)
                    fixture:setUserData("wall")

                    print(string.format("✅ 创建 wall 碰撞体 at (%d, %d) for gid %d", x, y, gid))

                end
            end
        end
    end
end





function level1:enter()
    love.physics.setMeter(32)
    self.world = love.physics.newWorld(0, 0, true)

    self.map = sti("maps/level1.lua", { "box2d" })
    self.map:box2d_init(self.world)  -- 可保留用于 Object Layer

    initTileLayerCollisions(self.map, self.world, "wallLayer")

    player:load(self.world)
end

function level1:update(dt)
    self.world:update(dt)
    player:update(dt)
end

function level1:draw()
    if self.map then self.map:draw() end
    player:draw()

    -- Debug: draw collision shapes
    love.graphics.setColor(1, 0, 0, 0.3)
    for _, body in pairs(self.world:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()
            if shape:typeOf("PolygonShape") then
                love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
            end
        end
    end
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.printf("PRESS E TO END GAME", 0, 10, love.graphics.getWidth(), "center")
end

function level1:keypressed(key)
    if key == "e" then
        local ending = require("states.end")
        Gamestate.switch(ending)
    elseif key == "d" then
        local dead = require("states.dead")
        Gamestate.switch(dead)
    end
end

return level1
