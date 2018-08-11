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

    platform.num_people = 0
    platform.wagon_type = "none"
    platform.wagon_type = "normal"
    platform.custom_dt = 0
    platform.boarding_multiplier = 1
    platform.boarded_people = 0

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

    --humans
    for i, human in pairs(self.people) do
        for j = 1, math.min(10,human) do
            love.graphics.draw(g_human, ((self.number-1)*4 +i) * g_wagon:getWidth()*2.5/4 - 50, g_platform:getHeight() * 0.6 + (j * 2.5 * math.min(10,human)), 0, 2.5, 2.5)
        end
    end

--    love.graphics.print(self.people[4]+self.people[1]+self.people[2]+self.people[3], 1000*(self.number-1),1000)
end

function Platform:update(dt, modifier, status)
    self.custom_dt = self.custom_dt + dt
    if self.custom_dt > 1 then
        for i = 1, 4 do
            if status == "stopping" then
                self.boarded_people = self.boarded_people + math.max(self.people[i]-1*self.boarding_multiplier,0)
                self.people[i] = math.max(self.people[i]-1*self.boarding_multiplier,0)
            end

            if time_s >= 5*3600 and time_s <= 5.5 * 3600 then
                self.people[i] = self.people[i] + math.random(0, 1)
            end

            if time_s > 5.5 *3600 and time_s <= 9 * 3600 then
                self.people[i] = self.people[i] + math.floor((time_h - 4) * modifier * math.random(50, 100) / 40 * self.custom_dt)
            end

            if time_s > 9 *3600 and time_s <= 14 * 3600 then
                self.people[i] = self.people[i] + math.floor((15 - time_h) * modifier * math.random(10, 50) / 40 * self.custom_dt)
            end

            if time_s > 14 *3600 and time_s <= 21 * 3600 then
                self.people[i] = self.people[i] + math.floor((time_h - 13) * modifier * math.random(30, 80) / 40 * self.custom_dt)
            end

            if time_s > 21 *3600 and time_s <= 24 * 3600 then
                self.people[i] = self.people[i] + math.floor((25 - time_h) * modifier * math.random(30, 80) / 40 * self.custom_dt)
            end
        end
        self.custom_dt = 0

        self.num_people = self.people[4]+self.people[1]+self.people[2]+self.people[3]
    end
end
