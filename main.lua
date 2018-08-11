-- called once at startup, load resources here
function love.load()
    love.window.setMode(1920, 1080)
    shimbashi = love.graphics.newImage("images/shimbashi_subway.png")
    platform = love.graphics.newImage("images/platform.png")
    passenger = love.graphics.newImage("images/passenger.png")
    train = love.graphics.newImage("images/train_wagon.png")
    love.graphics.setNewFont(12)
    love.graphics.setColor(0,0,0)
    love.graphics.setBackgroundColor(255,255,255)
    num = 0
end

-- called continuously, drawing happens here
function love.draw()
    --love.graphics.print("Hello World", 400, 300)
    --love.graphics.scale(1920, 1080)
    love.graphics.setColor(255,255,255)
    love.graphics.draw(shimbashi)
    love.graphics.draw(train, 500, 800)
    love.graphics.draw(platform, 0, 0)
end

-- called continuously, do math here
function love.update(dt)
    if love.keyboard.isDown("up") then
       num = num + 100 * dt -- this would increment num by 100 per second
    end
 end

 function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end