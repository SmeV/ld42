Gui = {}
Gui.__index = Gui

function Gui:create()
    local gui = {}
    setmetatable(gui, Gui)

    return gui
end

function Gui:draw(num_people)
    local oldr, oldg, oldb = love.graphics.getColor()
    love.graphics.setColor(0,255,255)
--    love.graphics.rectangle("fill", 50 + pos, 50, 1000, 200)
    --love.graphics.setColor(255,255,255)
    --love.graphics.rectangle("fill", 1050 + pos, 50, 900, 200)
    love.graphics.setColor(0,0,255)
    love.graphics.rectangle("fill", 1100 + pos, 50, 250, 200)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Money " .. money, 1400 + pos, 50)
    love.graphics.print(string.format("time %02d:%02d", time_h, time_m), 1400+pos, 150)
    love.graphics.print("People at this platform: " .. num_people, 50 + pos, 0)
    love.graphics.rectangle("fill", 1400+pos, 300, 500, 750)
    love.graphics.setColor(oldr, oldg, oldb)
end
