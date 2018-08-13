require "station"
require "gui"
require "button"
require "statscreen"


-- called once at startup, load resources here
function love.load()
    love.window.setMode(1920, 1080, {vsync=true})

    -- load images
    g_shimbashi = love.graphics.newImage("images/shimbashi_subway.png")
    g_platform = love.graphics.newImage("images/platform.png")
    g_wagon = love.graphics.newImage("images/train_wagon.png")
    g_wagon_woman = love.graphics.newImage("images/train_wagon_woman.png")
    g_wagon_ac = love.graphics.newImage("images/train_wagon_ac.png")
    g_title = love.graphics.newImage("images/titel.png")
    g_human = love.graphics.newImage("images/passenger.png")
    g_busiw = love.graphics.newImage("images/p_business_girl.png")
    g_busim = love.graphics.newImage("images/p_business_guy.png")
    g_schow = love.graphics.newImage("images/p_school_girl.png")
    g_schom = love.graphics.newImage("images/p_school_guy.png")
    g_vacaw = love.graphics.newImage("images/p_vacation_girl.png")
    g_vacam = love.graphics.newImage("images/p_vacation_guy.png")
    g_stations_map = love.graphics.newImage("images/all_stations_map.png")
    g_window0 = love.graphics.newImage("images/w_0.png")
    g_window1= love.graphics.newImage("images/w_1.png")
    g_window2= love.graphics.newImage("images/w_2.png")
    g_window3= love.graphics.newImage("images/w_3.png")
    g_window4= love.graphics.newImage("images/w_4.png")

    love.graphics.setNewFont(46)
    love.graphics.setColor(0,0,0)
    love.graphics.setBackgroundColor(255,255,255)


    -- initialize vars
    globalAbilities = {}
    initGlobalAbilities()
    mode = "title"
    level ="shimbashi"
    wagon_num = 1
    stations = {}
    stations["shimbashi"] = Station:create("shimbashi", g_shimbashi, 1)
    current_station = "shimbashi"
    gui = Gui:create()
    time_h = 5
    time_m = 0
    time_s = 5* 3600
    money = 1000
    pos = 0
    pushPower = 1.0


    statistics = StatScreen:create(current_station, stations[current_station].statsDaily)
    --statistics:changeAnimationStatus("bla")
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
        pos = (wagon_num - 1) * g_wagon:getWidth()
        love.graphics.translate(-pos, 0)
        stations[current_station]:draw()


        gui:draw(stations[current_station].platforms[wagon_num].num_people)
    end
    if statistics.isActive then
        statistics:draw()
    end
end

-- called continuously, do math here
function love.update(dt)
    if statistics.isActive then
        statistics:update(dt)
        return
    end
    time_s =  time_s + 288 * dt
    if time_s >= 24*3600 then
        for sname, station in pairs(stations) do
            station:dayEnd()
            station:newDay()
        end
        statistics:open()

        time_s = 5 * 3600
    end
    time_m = math.floor(time_s/60) % 60 
    time_h = math.floor(time_s/3600) % 24
    stations[current_station]:update(dt)

end

function love.mousemoved(x, y, dx, dy, istouch)
    if statistics.isActive then
        statistics:mousemoved(x,y,dx,dy,istouch)
        return
    end

    stations[current_station]:mousemoved(x, y, dx, dy, istouch)
    gui:mousemoved(x, y, dx, dy, istouch)

end

function love.mousepressed(x, y, button, istouch, presses)
    if statistics.isActive then
        statistics:mousepressed(x,y,button,istouch, presses)
        return
    end

    stations[current_station]:mousepressed(x, y, button, istouch, presses)
    gui:mousepressed(x, y, button, istouch, presses)
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
            switchPlatform(math.max(wagon_num - 1, 1))
        end

        if key == "right" then
            switchPlatform(math.min(wagon_num + 1, 10))
        end

        if key == "1" then
            switchPlatform(1)
        end

        if key == "2" then
            switchPlatform(2)
        end

        if key == "3" then
            wagon_num = 3
            switchPlatform(3)
        end

        if key == "4" then
            wagon_num = 4
            switchPlatform(4)
        end

        if key == "5" then
            wagon_num = 5
            switchPlatform(5)
        end

        if key == "6" then
            wagon_num = 6
            switchPlatform(6)
        end

        if key == "7" then
            wagon_num = 7
            switchPlatform(7)
        end

        if key == "8" then
            wagon_num = 8
            switchPlatform(8)
        end

        if key == "9" then
            wagon_num = 9
            switchPlatform(9)
        end

        if key == "0" then
            switchPlatform(10)
        end
    end
end

function switchPlatform(num)
    wagon_num = num
    gui:switchPlatform(num)
end

function initGlobalAbilities()
    local push = Ability:create("Push", "")

    function push:upgraded()
        pushPower = math.pow(1.50, self.level)
    end
    globalAbilities["Push"] = push

end