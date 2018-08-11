Gui = {}
Gui.__index = Gui

function Gui:create()
    local gui = {}
    setmetatable(gui, Gui)

    return gui
end

function Gui:draw()
    local oldr, oldg, oldb = love.graphics.getColor()
    love.graphics.setColor(0,255,255)
    love.graphics.rectangle("fill", 100+pos, 50, 800, 200)
    love.graphics.setColor(0,0,255)
    love.graphics.rectangle("fill", 950+pos, 50, 300, 200)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Money " .. yen, 1400 + pos, 50)
    love.graphics.print(string.format("time %02d:%02d", time_h, time_m), 1400+pos, 150)
    love.graphics.rectangle("fill", 1400+pos, 300, 500, 750)
    love.graphics.setColor(oldr, oldg, oldb)
end
