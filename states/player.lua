local player = {}

function player:load(world)
    self.sprite = love.graphics.newImage("assets/player.png")
    self.speed = 100

    self.frameWidth = 32
    self.frameHeight = 32
    self.currentFrame = 1
    self.direction = "down"
    self.animTimer = 0
    self.animSpeed = 0.1

    -- 设置初始位置
    local startX, startY = 320, 420

    -- 设置物理刚体
    self.body = love.physics.newBody(world, startX, startY, "dynamic")
    self.shape = love.physics.newRectangleShape(self.frameWidth, self.frameHeight)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData("player")

    -- 动画帧
    self.quads = {}
    for row = 0, 3 do
        self.quads[row] = {}
        for col = 0, 2 do
            self.quads[row][col + 1] = love.graphics.newQuad(
                col * self.frameWidth, row * self.frameHeight,
                self.frameWidth, self.frameHeight,
                self.sprite:getDimensions()
            )
        end
    end
end

function player:update(dt)
    local vx, vy = 0, 0

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        vy = -self.speed
        self.direction = "up"
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        vy = self.speed
        self.direction = "down"
    end

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        vx = -self.speed
        self.direction = "left"
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        vx = self.speed
        self.direction = "right"
    end

    self.body:setLinearVelocity(vx, vy)

    -- 动画更新
    if vx ~= 0 or vy ~= 0 then
        self.animTimer = self.animTimer + dt
        if self.animTimer > self.animSpeed then
            self.animTimer = 0
            self.currentFrame = self.currentFrame % 3 + 1
        end
    else
        self.currentFrame = 2
    end
end

function player:draw()
    local dirIndex = ({ down = 0, left = 1, right = 2, up = 3 })[self.direction]
    local px, py = self.body:getPosition()
    love.graphics.draw(self.sprite, self.quads[dirIndex][self.currentFrame], px, py, 0, 1, 1, self.frameWidth / 2, self.frameHeight / 2)
end

return player
