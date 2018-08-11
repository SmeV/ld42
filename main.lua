require "station"
require "gui"
require "button"


-- called once at startup, load resources here
function love.load()
    love.window.setMode(1920, 1080)

    -- load images
    g_shimbashi = love.graphics.newImage("images/shimbashi_subway.png")
    g_platform = love.graphics.newImage("images/platform.png")
    g_human = love.graphics.newImage("images/passenger.png")
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
    stations["shimbashi"] = Station:create("shimbashi", g_shimbashi, 1)
    current_station = "shimbashi"
    gui = Gui:create()
    time_h = 5
    time_m = 0
    time_s = 5* 3600
    yen = 0

    all_buttons = {}

    test_button = Button:create(500, 500, 250, 250)
    test_button.clicked = false
    function test_button:draw()
        oldr, oldg, oldb = love.graphics.getColor()
        if self.hovered then
            love.graphics.setColor(255, 0, 0)
        else
            if self.clicked then
                love.graphics.setColor(0, 255, 255)
            else
                love.graphics.setColor(0, 0, 255)
            end
        end
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(oldr, oldg, oldb)
    end
    function test_button:buttonPressed(button, istouch, presses)
        self.clicked = true
    end

    table.insert(all_buttons, test_button)
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
    end

    for i, button in pairs(all_buttons) do
        button:draw()
    end
end

-- called continuously, do math here
function love.update(dt)
    time_s =  time_s + 288 * dt
    if time_s >= 86400 then
        time_s = 5 * 3600
    end
    time_m = math.floor(time_s/60) % 60 
    time_h = math.floor(time_s/3600) % 24
    stations[current_station]:update(dt)
end

function love.mousemoved(x, y, dx, dy, istouch)
    for i, button in pairs(all_buttons) do
        button:mousemoved(x, y, dx, dy, istouch)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    for i, button in pairs(all_buttons) do
        button:mousepressed(x, y, button, istouch, presses)
    end
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