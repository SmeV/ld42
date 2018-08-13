require "button"
require "abilityclickable"
require "stationclickable"

Gui = {}
Gui.__index = Gui

function Gui:create()
    local gui = {}
    setmetatable(gui, Gui)

    gui.current_tab = 1
    gui.scrollPosition = 1
    gui.length = 0
 
    gui.push_clickables = {}   
    gui:initClickables()

    gui.ability_clickables = {}
    gui:initAbilityClickables()

    gui.station_clickables = {}
    gui:initStationClickables()

    for i, abiclick in pairs(gui.ability_clickables) do
        abiclick:updatePosition(gui.scrollPosition)
    end

    return gui
end

function Gui:draw(num_people)
    local oldr, oldg, oldb = love.graphics.getColor()
    -- roadmap
    love.graphics.draw(g_stations_map, 1100 + pos, 50)
    love.graphics.setColor(0,0.8,0)
    if current_station == "shimbashi" then
        love.graphics.circle("fill",1310+pos, 245, 15)
        love.graphics.setColor(0,0,0)
        love.graphics.circle("line",1310+pos, 245, 15)
    elseif current_station == "Tokyo" then
        love.graphics.circle("fill",1335+pos, 205, 15)
        love.graphics.setColor(0,0,0)
        love.graphics.circle("line",1335+pos, 205, 15)
    elseif current_station == "Takadanobaba" then
        love.graphics.circle("fill",1125+pos, 125, 15)
        love.graphics.setColor(0,0,0)
        love.graphics.circle("line",1125+pos, 125, 15)
    elseif current_station == "Shinagawa" then
        love.graphics.circle("fill",1180+pos, 285, 15)
        love.graphics.setColor(0,0,0)
        love.graphics.circle("line",1180+pos, 285, 15)
    elseif current_station == "Shinjuku" then
        love.graphics.circle("fill",1115+pos, 165, 15)
        love.graphics.setColor(0,0,0)
        love.graphics.circle("line",1115+pos, 165, 15)
    elseif current_station == "Ikebukuro" then 
        love.graphics.circle("fill",1145+pos, 90, 15)
        love.graphics.setColor(0,0,0)
        love.graphics.circle("line",1145+pos, 90, 15)
    elseif current_station == "Shibuya" then
        love.graphics.circle("fill",1120+pos, 220, 15)
        love.graphics.setColor(0,0,0)
        love.graphics.circle("line",1120+pos, 220, 15)
    end

    -- print current money and time
    love.graphics.setFont(fonts["46"])
    love.graphics.setColor(0,0,0)
    love.graphics.print("Money " .. money, 1400 + pos, 50)
    love.graphics.print(string.format("time %02d:%02d", time_h, time_m), 1400+pos, 150)
    love.graphics.print("People at this platform: " .. num_people, 50 + pos, 0)

    -- menu
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill", 1400+pos, 400, 450, 600)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", 1400+pos, 400, 450, 600)
    love.graphics.setColor(oldr, oldg, oldb)
    
    for i, abiclick in pairs(self.ability_clickables) do 
        abiclick:draw(self.scrollPosition, self.current_tab)
    end
    for i, click in pairs(self.push_clickables) do
        click:draw()
    end

    for i, sclick in pairs(self.station_clickables) do 
        sclick:draw(self.current_tab)
    end
end

function Gui:mousemoved(x, y, dx, dy, istouch)
    for i, clickable in pairs(self.push_clickables) do
        clickable:mousemoved(x, y, dx, dy, istouch)
    end
    for i, abiclick in pairs(self.ability_clickables) do
        abiclick:mousemoved(x, y, dx, dy, istouch, self.scrollPosition, self.current_tab)
    end
    for i, sclick in pairs(self.station_clickables) do
        sclick:mousemoved(x, y, dx, dy, istouch, self.current_tab)
    end
end

function Gui:mousepressed(x, y, button, istouch, presses)
    for i, clickable in pairs(self.push_clickables) do
        clickable:mousepressed(x, y, button, istouch, presses)
    end
    for i, abiclick in pairs(self.ability_clickables) do
        abiclick:mousepressed(x, y, button, istouch, presses, self.scrollPosition, self.current_tab)
    end
    for i, sclick in pairs(self.station_clickables) do
        sclick:mousepressed(x, y, button, istouch, presses, self.current_tab)
    end
end

function Gui:initAbilityClickables()
    local g1 = AbilityClickable:create(globalAbilities["Push"], self.length + 1) self.length = self.length + 1
    local p1 = AbilityClickable:create(stations[current_station].abilities["frequency"], 2)
    local p2 = AbilityClickable:create(stations[current_station].abilities["campaign"], 3)
    local l1 = AbilityClickable:create(stations[current_station].platforms[wagon_num].abilities["boardingSpeed"], 4)
    local l2 = AbilityClickable:create(stations[current_station].platforms[wagon_num].abilities["maxBoarding"], 5)
    local l3 = AbilityClickable:create(stations[current_station].platforms[wagon_num].abilities["employees"], 6)
    local l4 = AbilityClickable:create(stations[current_station].platforms[wagon_num].abilities["fence"], 7)
    table.insert(self.ability_clickables, g1)
    table.insert(self.ability_clickables, p1)
    table.insert(self.ability_clickables, p2)
    table.insert(self.ability_clickables, l1)
    table.insert(self.ability_clickables, l2)
    table.insert(self.ability_clickables, l3)
    table.insert(self.ability_clickables, l4)

    self.length = 7
end

function Gui:switchStation(num)
    self.ability_clickables[2].linkedAbility = stations[num].abilities["frequency"]
    self.ability_clickables[3].linkedAbility = stations[num].abilities["campaign"]
    self:switchPlatform(wagon_num)
end

function Gui:switchPlatform(num)
    self.ability_clickables[4].linkedAbility = stations[current_station].platforms[num].abilities["boardingSpeed"]
    self.ability_clickables[5].linkedAbility = stations[current_station].platforms[num].abilities["maxBoarding"]
    self.ability_clickables[6].linkedAbility = stations[current_station].platforms[num].abilities["employees"]
    self.ability_clickables[7].linkedAbility = stations[current_station].platforms[num].abilities["fence"]
end

function Gui:initStationClickables()
    local s0 = StationClickable:create("shimbashi", 0, 0)
    s0.stationAvailable = false
    local s1 = StationClickable:create("Takadanobaba", 1, 10000)
    local s2 = StationClickable:create("Shinagawa", 2, 30000)
    local s3 = StationClickable:create("Tokyo", 3, 50000)
    local s4 = StationClickable:create("Shibuya", 4, 90000)
    local s5 = StationClickable:create("Ikebukuro", 5, 18000)
    local s6 = StationClickable:create("Shinjuku", 6, 800000)
    --local a4 = AbilityClickable:create(stations[current_station].platforms[wagon_num].abilities["fence"], 4)
    table.insert(self.station_clickables, s0)
    table.insert(self.station_clickables, s1)
    table.insert(self.station_clickables, s2)
    table.insert(self.station_clickables, s3)
    table.insert(self.station_clickables, s4)
    table.insert(self.station_clickables, s5)
    table.insert(self.station_clickables, s6)
end

function Gui:initClickables()
    gui = self
    gui.tab1_clickable = Clickable:create(1400,300, 250, 100)
    gui.tab2_clickable = Clickable:create(1400+250,300, 250, 100)
    gui.tab1_clickable.fixed = true
    gui.tab2_clickable.fixed = true

    local scrollUpClickable = Clickable:create(1850, 400, 50, 50)
    scrollUpClickable.fixed = true
    function scrollUpClickable:clicked()
        if gui.scrollPosition > 1 then
            gui.scrollPosition = gui.scrollPosition - 1
            for i, abiclick in pairs(gui.ability_clickables) do
                abiclick:updatePosition(gui.scrollPosition)
            end
        end
    end
    function scrollUpClickable:draw()
        if gui.scrollPosition <= 1 then
            --return
        end
        love.graphics.push()
        love.graphics.setFont(fonts["46"])
        love.graphics.setColor(0.3,0.3,0.3)
        love.graphics.rectangle("fill", self.x + pos, self.y, self.width, self.height)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("line", self.x + pos, self.y, self.width, self.height)
        love.graphics.setColor(1.0,1.0,1.0)
        love.graphics.printf("^", self.x + pos, self.y, self.width, "center")
        love.graphics.pop()
    end
    function scrollUpClickable:hoveredCallback()
        love.mouse.setCursor(hand_cursor_point)
    end

    local scrollDownClickable = Clickable:create(1850, 950, 50, 50)
    scrollDownClickable.fixed = true
    function scrollDownClickable:clicked()
        if gui.scrollPosition < gui.length - 2 then
            gui.scrollPosition = gui.scrollPosition + 1
            for i, abiclick in pairs(gui.ability_clickables) do
                abiclick:updatePosition(gui.scrollPosition)
            end
        end
    end
    function scrollDownClickable:draw()
        if gui.scrollPosition >= gui.length - 2 then
            --return
        end
        love.graphics.push()
        love.graphics.setFont(fonts["46"])
        love.graphics.setColor(0.3,0.3,0.3)
        love.graphics.rectangle("fill", self.x + pos, self.y, self.width, self.height)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("line", self.x + pos, self.y, self.width, self.height)
        love.graphics.setColor(1.0,1.0,1.0)
        love.graphics.printf("v", self.x + pos, self.y, self.width, "center")
        love.graphics.pop()
    end
    function scrollDownClickable:hoveredCallback()
        love.mouse.setCursor(hand_cursor_point)
    end

    function gui.tab1_clickable:draw()
        if gui.current_tab == 1 then
            love.graphics.setColor(1,1,1)
            love.graphics.rectangle("fill", 1400+pos, 300, 250, 100)
        else 
            love.graphics.setColor(0.8,0.8,0.8)
            love.graphics.rectangle("fill", 1400+pos, 300, 250, 100)
        end
        love.graphics.setColor(0,0,0)
        love.graphics.setFont(fonts["46"])
        love.graphics.print("Abilities", 1400+pos+20, 320)
        love.graphics.rectangle("line", 1400+pos, 300, 250, 100)
    end

    function gui.tab1_clickable:clicked()
        gui.current_tab = 1
    end
    function gui.tab1_clickable:hoveredCallback()
        love.mouse.setCursor(hand_cursor_point)
    end

    function gui.tab2_clickable:draw()
        if gui.current_tab == 2 then
            love.graphics.setColor(1,1,1)
            love.graphics.rectangle("fill", 1400+pos + 250, 300, 250, 100)
        else 
            love.graphics.setColor(0.8,0.8,0.8)
            love.graphics.rectangle("fill", 1400+pos + 250, 300, 250, 100)
        end
        love.graphics.setColor(0,0,0)
        love.graphics.setFont(fonts["46"])
        love.graphics.print("Stations", 1400+pos + 280, 320)
        love.graphics.rectangle("line", 1400+pos + 250, 300, 250, 100)
    end

    function gui.tab2_clickable:clicked()
        gui.current_tab = 2
    end
    function gui.tab2_clickable:hoveredCallback()
        love.mouse.setCursor(hand_cursor_point)
    end

    table.insert(gui.push_clickables, gui.tab1_clickable)
    table.insert(gui.push_clickables, gui.tab2_clickable)
    table.insert(gui.push_clickables, scrollDownClickable)
    table.insert(gui.push_clickables, scrollUpClickable)
end