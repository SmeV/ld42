require "station"
require "gui"


-- called once at startup, load resources here
function love.load()
    love.window.setMode(1920, 1080)

    -- load images
    g_shimbashi = love.graphics.newImage("images/shimbashi_subway.png")
    g_platform = love.graphics.newImage("images/platform.png")
    g_passenger = love.graphics.newImage("images/passenger.png")
    g_wagon = love.graphics.newImage("images/train_wagon.png")
    g_title = love.graphics.newImage("images/titel.png")

    love.graphics.setNewFont(46)
    love.graphics.setColor(0,0,0)
    love.graphics.setBackgroundColor(255,255,255)

    -- initialize vars
    mode = "title"
    level ="shimbashi"
    wagon_num = 1
    stations = {}
    stations["shimbashi"] = Station:create("shimbashi", g_shimbashi)
    current_station = "shimbashi"
    gui = Gui:create()

end

-- called continuously, drawing happens here
function love.draw()
    love.graphics.setColor(255,255,255)
    if mode=="title" then
        love.graphics.draw(g_title)
    end
    --love.graphics.print("Hello World", 400, 300)
    --love.graphics.scale(1920, 1080)
    if mode == "game" then 
        pos = (wagon_num - 1) * g_wagon:getWidth()*2.5
        love.graphics.translate(-pos, 0)
        stations[current_station]:draw()
        gui:draw()
        --[[
        pos = (wagon_num - 1) * 1920
        love.graphics.translate(-pos, 0)
        if level == "shimbashi" then
            for i = 1, 10 do
                love.graphics.draw(shimbashi, (i-1) * 1920, 0)
                love.graphics.draw(train, (i-1) * 1920 + 100, 300, 0, 2.5,2.5)
                love.graphics.draw(platform, (i-1) * 1920, -1080, 0, 1, 2)
            end
        end
        love.graphics.setColor(0,255,255)
        love.graphics.rectangle("fill", 100+pos, 50, 800, 200)
        love.graphics.setColor(0,0,255)
        love.graphics.rectangle("fill", 950+pos, 50, 300, 200)
        love.graphics.setColor(0,0,0)
        love.graphics.print("Money " .. yen, 1400+pos, 50)
        love.graphics.print("time", 1400+pos, 150)
        love.graphics.rectangle("fill", 1400+pos, 300, 500, 750)
        ]]--
    end
end

-- called continuously, do math here
function love.update(dt)

end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if mode == "title" and key == "return" then
        mode = "game"
    end

    if mode == "game" then
        if key == "left" then 
            wagon_num = math.max(wagon_num - 1, 1)
        end

        if key == "right" then
            wagon_num = math.min(wagon_num + 1, 10)
        end
    end
end