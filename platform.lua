Platform = {}
Platform.__index = Platform

function Platform:create(num) 
    local platform = {}
    setmetatable(platform, Platform)
    platform.number = num

    platform.people = {}
    table.insert(platform.people, 0)
    table.insert(platform.people, 0)
    table.insert(platform.people, 0)
    table.insert(platform.people, 0)

    platform.wagon_type = "none"
    platform.wagon_type = "normal"

    return platform
end

function Platform:draw(status, animate_factor)
    love.graphics.draw(g_platform, (self.number-1) * g_platform:getWidth(), -g_platform:getHeight(), 0, 1, 2)
    if status == "leaving" then
        if self.wagon_type == "normal" then
            love.graphics.draw(g_wagon, (self.number-1) * (g_wagon:getWidth() * 2.5) + 100 - animate_factor, 300, 0, 2.5, 2.5)
        end
    end
    if status == "entering" then
        if self.wagon_type == "normal" then
            love.graphics.draw(g_wagon, (self.number-1) * (g_wagon:getWidth() * 2.5) + 100 + g_platform:getWidth()*10 - animate_factor, 300, 0, 2.5, 2.5)
        end
    end
    if status == "stopping" then
        if self.wagon_type == "normal" then
            love.graphics.draw(g_wagon, (self.number-1) * (g_wagon:getWidth() * 2.5) + 100, 300, 0, 2.5, 2.5)
        end
    end
end

