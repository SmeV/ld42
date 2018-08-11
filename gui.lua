Gui = {}
Gui.__index = Gui

function Gui:create()
    local gui = {}
    setmetatable(gui, Gui)
    gui.yen = 0
    gui.time_h = 0
    gui.time_m = 0

    return gui
end

function Gui:draw()
    local oldr, oldg, oldb = love.graphics.getColor()
    love.graphics.setColor(0,255,255)
    love.graphics.rectangle("fill", 100+pos, 50, 800, 200)
    love.graphics.setColor(0,0,255)
    love.graphics.rectangle("fill", 950+pos, 50, 300, 200)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Money " .. self.yen, 1400 + pos, 50)
    love.graphics.print("time " .. self.time_h .. ":" .. self.time_m, 1400+pos, 150)
    love.graphics.rectangle("fill", 1400+pos, 300, 500, 750)
    love.graphics.setColor(oldr, oldg, oldb)
end
