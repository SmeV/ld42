require "button"
Gui = {}
Gui.__index = Gui

function Gui:create()
    local gui = {}
    setmetatable(gui, Gui)

    gui.current_tab = 2
 
    gui.push_clickables = {}   
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
    love.graphics.rectangle("fill", 1400+pos, 300, 500, 750)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", 1400+pos, 300, 500, 750)
    love.graphics.setColor(oldr, oldg, oldb)
    
    self.tab1_clickable:draw()
    self.tab2_clickable:draw()
end

function Gui:mousemoved(x, y, dx, dy, istouch)
    for i, clickable in pairs(self.push_clickables) do
        clickable:mousemoved(x, y, dx, dy, istouch)
    end
end

function Gui:mousepressed(x, y, button, istouch, presses)
    for i, clickable in pairs(self.push_clickables) do
        clickable:mousepressed(x, y, button, istouch, presses)
    end
end