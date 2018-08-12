require "button"

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

    platform.push_buttons = {}
    platform.push1 = Button:create((platform.number-1) * (g_wagon:getWidth() * 2.5) + 100 + 0 * 400, 300, (g_wagon:getWidth() / 4), 600)
    platform.push2 = Button:create((platform.number-1) * (g_wagon:getWidth() * 2.5) + 100 + 1 * 400, 300, (g_wagon:getWidth() / 4), 600)
    platform.push3 = Button:create((platform.number-1) * (g_wagon:getWidth() * 2.5) + 100 + 2 * 400, 300, (g_wagon:getWidth() / 4), 600)
    platform.push4 = Button:create((platform.number-1) * (g_wagon:getWidth() * 2.5) + 100 + 3 * 400, 300, (g_wagon:getWidth() / 4), 600)
    platform.push1.clicked = 0
    function platform.push1:buttonPressed()
        platform.boarded_people = platform.boarded_people + math.min(1, platform.people[1])
        platform.people[1] = math.max(0, platform.people[1] - 1)
    end
    function platform.push2:buttonPressed()
        platform.boarded_people = platform.boarded_people + math.min(1, platform.people[2])
        platform.people[2] = math.max(0, platform.people[2] - 1)
    end
    function platform.push3:buttonPressed()
        platform.boarded_people = platform.boarded_people + math.min(1, platform.people[3])
        platform.people[3] = math.max(0, platform.people[3] - 1)
    end
    function platform.push4:buttonPressed()
        platform.boarded_people = platform.boarded_people + math.min(1, platform.people[4])
        platform.people[4] = math.max(0, platform.people[4] - 1)
    end
    function platform.push1:draw()
        oldr, oldg, oldb = love.graphics.getColor()
        if self.hovered then
            love.graphics.setColor(255, 0, 0)
        else
            love.graphics.setColor(0, 0, 255)
        end
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        love.graphics.print(self.clicked, self.x + self.width / 2, self.y + self.height/2)
        love.graphics.print(platform.people[1], self.x + self.width / 2, self.y + self.height/2 + 50)
        love.graphics.setColor(oldr, oldg, oldb)
    end
    function platform.push2:draw()
        oldr, oldg, oldb = love.graphics.getColor()
        if self.hovered then
            love.graphics.setColor(255, 0, 0)
        else
            love.graphics.setColor(0, 255, 255)
        end
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        love.graphics.setColor(oldr, oldg, oldb)
    end
    table.insert(platform.push_buttons, platform.push1)
    table.insert(platform.push_buttons, platform.push2)
    table.insert(platform.push_buttons, platform.push3)
    table.insert(platform.push_buttons, platform.push4)

    return platform
end

function Platform:draw(status, animate_factor)
    local s = 100.0/1250.0
    local oldr, oldg, oldb = love.graphics.getColor()
    love.graphics.draw(g_platform, (self.number-1) * g_platform:getWidth(), 0)

    -- train animation
    if status == "leaving" then
        if self.wagon_type == "normal" then
            love.graphics.draw(g_wagon, (self.number-1) * (g_wagon:getWidth()) + 100 - animate_factor, 300)
        end
    end
    if status == "entering" then
        if self.wagon_type == "normal" then
            love.graphics.draw(g_wagon, (self.number-1) * g_wagon:getWidth() + 100 + g_platform:getWidth()*10 - animate_factor, 300)
        end
    end
    if status == "stopping" then
        if self.wagon_type == "normal" then
            love.graphics.draw(g_wagon, (self.number-1) * g_wagon:getWidth() + 100, 300)
        end
    end

    --humans
    for i, human in pairs(self.people) do
        for j = 1, math.min(10,human) do
            love.graphics.draw(g_human, ((self.number-1)*4 +i) * g_wagon:getWidth()/4 - 50, g_platform:getHeight() * 0.6 + (j *  math.min(10,human)))
        end
    end

    for i, button in pairs(self.push_buttons) do
        button:draw()
    end





    
    -- Minimap of current station
    love.graphics.setScissor(50, 50, 1000, 200)
    love.graphics.draw(g_platform, pos + (self.number-1) * g_platform:getWidth() * s +50, 150, 0, s, s)
    love.graphics.setColor(255,0,0)
    love.graphics.circle("fill",pos + (self.number-1) * 100 + 50 + 50, 225, 15)
    love.graphics.setColor(oldr, oldg, oldb)

    -- train animation
    if status == "leaving" then
        if self.wagon_type == "normal" then
            -- gui
            love.graphics.draw(g_wagon, pos + (self.number-1) * g_wagon:getWidth() * s + 50 - animate_factor * s --[[/(10*g_platform:getWidth())*1000]], 150+300*s, 0, s, s)
        end
    end
    if status == "entering" then
        if self.wagon_type == "normal" then
            love.graphics.draw(g_wagon, pos + (self.number-1)* g_wagon:getWidth() * s + 50 + g_platform:getWidth()*10*s - animate_factor*s, 150+300*s, 0, s,s)
        end
    end
    if status == "stopping" then
        if self.wagon_type == "normal" then
            love.graphics.setColor(255,0,0)
            love.graphics.rectangle("fill",pos + (self.number-1) * g_wagon:getWidth() * s + 50, 100, 100, 100)
            love.graphics.setColor(oldr, oldg, oldb)
            love.graphics.draw(g_wagon, pos + (self.number-1) * g_wagon:getWidth() * s + 50, 150+300*s, 0, s,s)
        end
    end

    if self.number == wagon_num then
        love.graphics.setColor(255,255,0)
        love.graphics.rectangle("line", pos + (self.number-1) * g_wagon:getWidth() * s + 50, 100, 100, 150)
        love.graphics.setColor(oldr, oldg, oldb)
    end

    love.graphics.setScissor()
end

function Platform:update(dt, modifier, status)
    self.custom_dt = self.custom_dt + dt
    if self.custom_dt > 1 then
        for i = 1, 4 do
            if status == "stopping" then
                self.boarded_people = self.boarded_people + math.min(1, self.people[i]) * self.boarding_multiplier
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

function Platform:mousemoved(x, y, dx, dy, istouch)
    for i, button in pairs(self.push_buttons) do
        button:mousemoved(x, y, dx, dy, istouch)
    end
end

function Platform:mousepressed(x, y, button, istouch, presses)
    for i, button in pairs(self.push_buttons) do
        button:mousepressed(x, y, button, istouch, presses)
    end
end
