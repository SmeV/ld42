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

function Platform:draw()
    love.graphics.draw(g_platform, (self.number-1) * g_platform:getWidth(), -g_platform:getHeight(), 0, 1, 2)

    if self.wagon_type == "normal" then
        love.graphics.draw(g_wagon, (self.number-1) * (g_wagon:getWidth() * 2.5 + 10) + 100, 300, 0, 2.5, 2.5)
    end
end

