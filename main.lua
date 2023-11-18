-- Localisation and init [CONTAINERS]
local mouse = {
    x = 0,
    y = 0
}
local slime = {
    x = 10,
    y = 10,
    velocity = 0,
    gravity = 400
}
local bullet = {
    x = -20,
    y = -20,
    xvelocity = 0,
    yvelocity = 0,
    rotation = 0,
    speed = 600
}
local ragdoll = {
    x = 50,
    y = 50
}

-- Localisation and init [VARIABLES]
local wHeight
local wWidth
local slimeImage
local bulletImage
local ragdollImage
local streak
local shot
local collision
local background
local icon
shot = false
streak = 0

-- Setting a fixed framerate by using love.conf
function love.conf(t)
    t.window.vsync = 1 -- Set to 1 for a fixed frame rate
    t.console = true
end

-- Function to check collisions
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return
    x1 - (w1 / 2) < x2 - (w2 / 2) + w2 and
    x2 - (w2 / 2) < x1 - (w1 / 2) + w1 and
    y1 - (h1 / 2) < y2 - (h2 / 2) + h2 and
    y2 - (h2 / 2) < y1 - (h1 / 2) + h1
end

-- Load function
function love.load()
    -- Loading graphics
    slimeImage = love.graphics.newImage('slime.png')
    bulletImage = love.graphics.newImage('bullet.png')
    ragdollImage = love.graphics.newImage('ragdoll.png')
    background = love.graphics.newImage('background.png')
    -- Def windows to fullscreen
    love.window.setFullscreen(true, "desktop")
    love.window.setTitle("GrinShot")
    wHeight = love.graphics.getHeight()
    wWidth = love.graphics.getWidth()
    local iconImageData = love.image.newImageData("icon.png")
    local iconImage = love.graphics.newImage(iconImageData)
    love.window.setIcon(iconImageData)
end

-- Update function
function love.update(dt)
    
    -- Gravitational logic [slime]
    slime.velocity = slime.velocity + slime.gravity * dt
    slime.y = slime.y + slime.velocity * dt

    -- Velocity logic [bullet]
    bullet.x = bullet.x + bullet.xvelocity * dt
    bullet.y = bullet.y + bullet.yvelocity * dt
    --[[    bullet.xvelocity = mouse.x * dt
    bullet.yvelocity = mouse.y * dt
    bullet.x = bullet.xvelocity + bullet.x * dt
    bullet.y = bullet.yvelocity + bullet.y * dt
    ]]--

    -- Boundary logic
    if (slime.y + (slimeImage:getHeight())) > wHeight then
        slime.velocity = 0
        slime.y = wHeight - (slimeImage:getHeight())
    end
    if slime.x + slimeImage:getWidth() > wWidth then
        slime.x = 0
    end
    if slime.x < 0 then
        slime.x = wWidth - slimeImage:getWidth()
    end

    -- Sprite movement logic
    if love.keyboard.isDown("up", "space", "w") and slime.y == (wHeight - (slimeImage:getHeight())) then
        slime.velocity = -300 -- Set a negative velocity for jumping
    end

    if love.keyboard.isDown("right", "d") then
        slime.x = slime.x + 200 * dt -- Adjusted the movement speed
    end

    if love.keyboard.isDown("left", "a") then
        slime.x = slime.x - 200 * dt -- Adjusted the movement speed
    end

    -- Shooting logic
    if bullet.x < 0 or bullet.y > wHeight or bullet.x > wWidth or bullet.y < 0 then
        if love.mouse.isDown(1) then
            -- init for position of bullet
            bullet.x = slime.x
            bullet.y = slime.y
            -- grabbing mouse coords
            mouse.x, mouse.y = love.mouse.getPosition()
            -- calculating rotation angle and x, y vel. of bullet
            bullet.rotation = math.atan2(mouse.y - slime.y, mouse.x - slime.x)
            bullet.xvelocity = bullet.speed * math.cos(bullet.rotation)
            bullet.yvelocity = bullet.speed * math.sin(bullet.rotation)
            shot = true
        end
    end

    -- Collision/Bullet shoot effect logic [1]
    collision = checkCollision(ragdoll.x, ragdoll.y, ragdollImage:getWidth(), ragdollImage:getHeight(), bullet.x, bullet.y, bulletImage:getWidth(), bulletImage:getHeight())
    if collision then
         ragdoll.x = math.random(0, wWidth - ragdollImage:getWidth() * 1.5)
        ragdoll.y = math.random(0, wHeight - ragdollImage:getHeight() * 1.5)
        streak = streak + 1
        print("collision has taken place")
        print(dt)
    end
    --elseif not collision and slime.x ~= bullet.x then
        --streak = 0
    -- elseif collision == false then
        -- streak = 0

    --[[        if (mouse.y > bullet.y) then
            bullet.yvelocity = mouse.y * dt
        elseif (mouse.y < bullet.y) then
            bullet.yvelocity = -(mouse.y) * dt
        elseif (mouse.y == bullet.y) then
            bullet.yvelocity = -(mouse.y) * dt
        end

        if (mouse.x > bullet.x) then
            bullet.xvelocity = -(mouse.x) * dt
        elseif (mouse.x < bullet.x) then
            bullet.xvelocity = mouse.x * dt
        elseif (mouse.x == bullet.x) then
            bullet.xvelocity = -(mouse.x) * dt
        end
        -- bullet.xvelocity = mouse.x * 3 * dt
        -- bullet.yvelocity = mouse.y * 3 * dt
        -- bullet.xvelocity = 100
        -- bullet.yvelocity = 100
    end
]]--
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ragdollImage, ragdoll.x, ragdoll.y, 0, 2.5, 2.5, ragdollImage:getWidth() / 2, ragdollImage:getHeight() / 2)
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.setColor(255, 87, 51)
    love.graphics.print("Kill counter: ".. streak, 20, 20)
    love.graphics.draw(slimeImage, slime.x, slime.y, 0, 2, 2, slimeImage:getWidth() / 2, slimeImage:getHeight() / 2)
    love.graphics.draw(bulletImage, bullet.x, bullet.y, bullet.rotation, 2, 2, bulletImage:getWidth() / 2, bulletImage:getHeight() / 2)
end