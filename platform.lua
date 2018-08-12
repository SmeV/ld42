require "button"
require "waitingline"
require "human"

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

    platform.lines = {}
    table.insert(platform.lines, WaitingLine:create())
    table.insert(platform.lines, WaitingLine:create())
    table.insert(platform.lines, WaitingLine:create())
    table.insert(platform.lines, WaitingLine:create())

    platform.num_people = 0
    platform.wagon_type = "none"
    platform.wagon_type = "normal"
    platform.custom_dt = 0
    platform.boarding_multiplier = 1
    platform.boarded_people = 0

    platform.wagonSize = 100
    platform.wagonFillStatus = 0.0
    platform.autoBoardingMax = 0.6
    platform.pushPowerNeeded = 1.0

    platform:initClickables()

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

--    love.graphics.print(self.people[4]+self.people[1]+self.people[2]+self.people[3], 1000*(self.number-1),1000)
    for i, clickable in pairs(self.push_clickables) do
        clickable:draw()
    end
    for i, line in pairs(self.lines) do
        line:draw(((self.number-1)*4 + i) * g_wagon:getWidth()*2.5/4 - 50, g_platform:getHeight() * 0.6)
    end
end

function Platform:update(dt, modifier, status)
    self.custom_dt = self.custom_dt + dt
    if self.custom_dt > 1 then
        self:autoBoarding(status)
        for i = 1, 4 do

            if time_s >= 5*3600 and time_s <= 5.5 * 3600 then
                self.people[i] = self.people[i] + math.random(0, 1)
                while self.lines[i]:getSize() < 10 and self.lines[i]:getSize() < self.people[i] do
                    self.lines[i]:push(Human:create())
                end
            end

            if time_s > 5.5 *3600 and time_s <= 9 * 3600 then
                self.people[i] = self.people[i] + math.floor((time_h - 4) * modifier * math.random(50, 100) / 40 * self.custom_dt)
                while self.lines[i]:getSize() < 10 and self.lines[i]:getSize() < self.people[i] do
                    self.lines[i]:push(Human:create())
                end
            end

            if time_s > 9 *3600 and time_s <= 14 * 3600 then
                self.people[i] = self.people[i] + math.floor((15 - time_h) * modifier * math.random(10, 50) / 40 * self.custom_dt)
                while self.lines[i]:getSize() < 10 and self.lines[i]:getSize() < self.people[i] do
                    self.lines[i]:push(Human:create())
                end
            end

            if time_s > 14 *3600 and time_s <= 21 * 3600 then
                self.people[i] = self.people[i] + math.floor((time_h - 13) * modifier * math.random(30, 80) / 40 * self.custom_dt)
                while self.lines[i]:getSize() < 10 and self.people[i] > 0 do
                    self.lines[i]:push(Human:create())
                    self.people[i] = self.people[i] - 1
                end
            end

            if time_s > 21 *3600 and time_s <= 24 * 3600 then
                self.people[i] = self.people[i] + math.floor((25 - time_h) * modifier * math.random(30, 80) / 40 * self.custom_dt)
                while self.lines[i]:getSize() < 10 and self.people[i] > 0 do
                    self.lines[i]:push(Human:create())
                    self.people[i] = self.people[i] - 1
                end
            end
        end
        self.custom_dt = 0

        self.num_people = self.people[4]+self.people[1]+self.people[2]+self.people[3]
    end
end

function Platform:autoBoarding(status)
    if status == "stopping"  then
        for i = 1, 4 do
            if self.wagonFillStatus < self.autoBoardingMax and self.people[i] > 0 then
                self:personPushed(i)
            end
        end
    end
end

function Platform:personPushed(i)
    local pushed = self.lines[i]:pop()
    if pushed == nil then
    else
        self.boarded_people = self.boarded_people + 1
        self.people[i] = self.people[i] - 1
        if self.people[i] > self.lines[i]:getSize() then
            self.lines[i]:push(Human:create())
        end
        self.wagonFillStatus = self.wagonFillStatus + 1.0 / self.wagonSize
    end
end

function Platform:mousemoved(x, y, dx, dy, istouch)
    for i, clickable in pairs(self.push_clickables) do
        clickable:mousemoved(x, y, dx, dy, istouch)
    end
end

function Platform:mousepressed(x, y, button, istouch, presses)
    for i, clickable in pairs(self.push_clickables) do
        clickable:mousepressed(x, y, button, istouch, presses)
    end
end

function Platform:initClickables()
    local platform = self
    platform.push_clickables = {}
    platform.push1 = Clickable:create((platform.number-1) * (g_wagon:getWidth() * 2.5) + 100 + 0 * 400, 300, (g_wagon:getWidth() / 4), 600)
    platform.push2 = Clickable:create((platform.number-1) * (g_wagon:getWidth() * 2.5) + 100 + 1 * 400, 300, (g_wagon:getWidth() / 4), 600)
    platform.push3 = Clickable:create((platform.number-1) * (g_wagon:getWidth() * 2.5) + 100 + 2 * 400, 300, (g_wagon:getWidth() / 4), 600)
    platform.push4 = Clickable:create((platform.number-1) * (g_wagon:getWidth() * 2.5) + 100 + 3 * 400, 300, (g_wagon:getWidth() / 4), 600)
    platform.push1.numclicked = 0
    function platform.push1:clicked(button)
        if button == 1 then
            platform:personPushed(1)
        end
    end
    function platform.push2:clicked(button)
        if button == 1 then
            platform:personPushed(2)
        end
    end
    function platform.push3:clicked(button)
        if button == 1 then
            platform:personPushed(3)
        end
    end
    function platform.push4:clicked(button)
        if button == 1 then
            platform:personPushed(4)
        end
    end
    function platform.push1:draw()
        oldr, oldg, oldb = love.graphics.getColor()
        if self.hovered then
            love.graphics.setColor(255, 0, 0)
        else
            love.graphics.setColor(0, 0, 255)
        end
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        love.graphics.print(self.numclicked, self.x + self.width / 2, self.y + self.height/2)
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
    table.insert(platform.push_clickables, platform.push1)
    table.insert(platform.push_clickables, platform.push2)
    table.insert(platform.push_clickables, platform.push3)
    table.insert(platform.push_clickables, platform.push4)
end