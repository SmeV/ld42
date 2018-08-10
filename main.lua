-- called once at startup, load resources here
function love.load()
    --image = love.graphics.newImage("cake.jpg")
    love.graphics.setNewFont(12)
    love.graphics.setColor(0,0,0)
    love.graphics.setBackgroundColor(255,255,255)
    num = 0
end

-- called continuously, drawing happens here
function love.draw()
    --love.graphics.print("Hello World", 400, 300)
    love.graphics.print(num, 400, 300)
end

-- called continuously, do math here
function love.update(dt)
    if love.keyboard.isDown("up") then
       num = num + 100 * dt -- this would increment num by 100 per second
    end
 end