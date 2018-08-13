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

    -- print current money and time
    love.graphics.setColor(0,0,0)
    love.graphics.print("Money " .. money, 1400 + pos, 50)
    love.graphics.print(string.format("time %02d:%02d", time_h, time_m), 1400+pos, 150)
    love.graphics.print("People at this platform: " .. num_people, 50 + pos, 0)

    -- menu
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill", 1400+pos, 400, 500, 600)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", 1400+pos, 400, 500, 600)
    love.graphics.setColor(oldr, oldg, oldb)
    
    self.tab1_clickable:draw()
    self.tab2_clickable:draw()

    for i, abiclick in pairs(self.ability_clickables) do 
        abiclick:draw(self.scrollPosition, self.current_tab)
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
    local a1 = AbilityClickable:create(stations[current_station].platforms[wagon_num].abilities["boardingSpeed"], 1)
    local a2 = AbilityClickable:create(stations[current_station].platforms[wagon_num].abilities["maxBoarding"], 2)
    local a3 = AbilityClickable:create(stations[current_station].platforms[wagon_num].abilities["employees"], 3)
    --local a4 = AbilityClickable:create(stations[current_station].platforms[wagon_num].abilities["fence"], 4)
    table.insert(self.ability_clickables, a1)
    table.insert(self.ability_clickables, a2)
    table.insert(self.ability_clickables, a3)
    --table.insert(self.ability_clickables, a4)
end

function Gui:initStationClickables()
    local s0 = StationClickable:create("shimbashi", 0, 0)
    s0.stationAvailable = false
    local s1 = StationClickable:create("Takadanobaba", 1, 10000)
    local s2 = StationClickable:create("Shinagawa", 2, 30000)
    local s3 = StationClickable:create("Tokyo", 3, 50000)
    local s4 = StationClickable:create("Shibuya", 4, 90000)
    local s5 = StationClickable:create("Ikebukoro", 5, 18000)
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

    function gui.tab1_clickable:draw()
        if gui.current_tab == 1 then
            love.graphics.setColor(255,0,255)
        love.graphics.rectangle("fill", 1400+pos, 300, 250, 100)
        else 
            love.graphics.setColor(255,0,255)
        love.graphics.rectangle("line", 1400+pos, 300, 250, 100)
        end
    end

    function gui.tab1_clickable:clicked()
        gui.current_tab = 1
    end

    function gui.tab2_clickable:draw()
        if gui.current_tab == 2 then
            love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", 1400+pos + 250, 300, 250, 100)
        else 
            love.graphics.setColor(0,0,0)
        love.graphics.rectangle("line", 1400+pos + 250, 300, 250, 100)
        end
    end

    function gui.tab2_clickable:clicked()
        gui.current_tab = 2
    end

    table.insert(gui.push_clickables, gui.tab1_clickable)
    table.insert(gui.push_clickables, gui.tab2_clickable)
end