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
    platform.lineSize = 5
    table.insert(platform.lines, WaitingLine:create())
    table.insert(platform.lines, WaitingLine:create())
    table.insert(platform.lines, WaitingLine:create())
    table.insert(platform.lines, WaitingLine:create())
    table.insert(platform.lines, WaitingLine:create())
    table.insert(platform.lines, WaitingLine:create())
    table.insert(platform.lines, WaitingLine:create())
    table.insert(platform.lines, WaitingLine:create())
    platform.doormodulos = {}
    table.insert(platform.doormodulos, 0)
    table.insert(platform.doormodulos, 0)
    table.insert(platform.doormodulos, 0)
    table.insert(platform.doormodulos, 0)

    platform.num_people = 0
    if num == 1 then
        platform.wagon_type ="woman"
        platform.graphics = g_wagon_woman
    elseif num == 4 then
        platform.wagon_type = "lowac"
        platform.graphics = g_wagon_ac
    else
        platform.wagon_type = "normal"
        platform.graphics = g_wagon
    end
    platform.custom_dt = 0
    platform.boarding_multiplier = 1
    platform.boarded_people = 0

    platform.wagonSize = 100
    platform.wagonFillStatus = 0.0
    platform.autoBoardingMax = 0.1
    platform.pushPowerNeeded = 1.0
    platform.currentPower = 0.0
    platform.powerSaver = 0.0

    platform:initClickables()

    return platform
end

function Platform:draw(status, animate_factor)
    local s = 100.0/1250.0
    local oldr, oldg, oldb = love.graphics.getColor()

    -- label woman only and low ac cars on platfrom
    love.graphics.setColor(0,0,0)
    if self.wagon_type == "woman" then
        love.graphics.print("From 6 to 9:30 Woman only",(self.number-1) * g_wagon:getWidth() + 100, 300+ g_wagon:getHeight() + 200)
    elseif self.wagon_type == "lowac" then
        love.graphics.print("Weak Air Conditioning",(self.number-1) * g_wagon:getWidth() + 100, 300+ g_wagon:getHeight() + 200)
    end
    love.graphics.setColor(oldr, oldg, oldb)

    -- train animation
    if status == "leaving" then
        love.graphics.draw(self.graphics, (self.number-1) * (g_wagon:getWidth()) + 100 - animate_factor, 300)
    end
    if status == "entering" then
        love.graphics.draw(self.graphics, (self.number-1) * g_wagon:getWidth() + 100 + g_platform:getWidth()*10 - animate_factor, 300)
    end
    if status == "stopping" then
        love.graphics.draw(self.graphics, (self.number-1) * g_wagon:getWidth() + 100, 300)
    end


    -- draw clickables
    for i, clickable in pairs(self.push_clickables) do
        clickable:draw()
    end

    -- draw humans
    for i, line in pairs(self.lines) do
        line:draw(((self.number-1)*4 + math.ceil(i/2)) * g_wagon:getWidth()/4 - 75 + i%2 * 100, g_platform:getHeight() * 0.68)
    end
    
    -- Minimap of current station
    love.graphics.setScissor(50, 50, 1000, 200)
    love.graphics.draw(g_platform, pos + (self.number-1) * g_platform:getWidth() * s +50, 150, 0, s, s)
    love.graphics.setColor(255,0,0)
    love.graphics.circle("fill",pos + (self.number-1) * 100 + 50 + 50, 225, 15)
    love.graphics.setColor(oldr, oldg, oldb)

    -- train animation
    if status == "leaving" then
        love.graphics.draw(self.graphics, pos + (self.number-1) * g_wagon:getWidth() * s + 50 - animate_factor * s --[[/(10*g_platform:getWidth())*1000]], 150+300*s, 0, s, s)
    end
    if status == "entering" then
        love.graphics.draw(self.graphics, pos + (self.number-1)* g_wagon:getWidth() * s + 50 + g_platform:getWidth()*10*s - animate_factor*s, 150+300*s, 0, s,s)
    end
    if status == "stopping" then
        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("fill",pos + (self.number-1) * g_wagon:getWidth() * s + 50, 100, 100, 100)
        love.graphics.setColor(oldr, oldg, oldb)
        love.graphics.draw(self.graphics, pos + (self.number-1) * g_wagon:getWidth() * s + 50, 150+300*s, 0, s,s)
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
        self:autoBoarding(status)
        self:peopleAdded(modifier)
        self:refillLines()
        self.custom_dt = 0

        self.num_people = self.people[4]+self.people[1]+self.people[2]+self.people[3]
    end
    if self.wagonFillStatus > 0.1 then
        self.pushPowerNeeded = 3.0
    end
end

function Platform:peopleAdded(modifier)
    for i = 1, 4 do

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
end

function Platform:refillLines()
    for i = 1,4 do
        local combinedSize = self.lines[i*2 + 0]:getSize() + self.lines[i*2 - 1]:getSize()
        while combinedSize < 10 and combinedSize < self.people[i] do
            if self.lines[i*2 + 0]:getSize() <= self.lines[i*2 - 1]:getSize() then
                self.lines[i*2 + 0]:push(Human:create())
            else
                self.lines[i*2 - 1]:push(Human:create())
            end
            combinedSize = combinedSize + 1
        end
    end
end


function Platform:autoBoarding(status)
    if status == "stopping"  then
        for i = 1, 4 do
            if self.wagonFillStatus < self.autoBoardingMax and self.people[i] > 0 then
                self:personPushed(i, 1)
            end
        end
    end
end

function Platform:personPushed(i, power)
    self.currentPower = self.currentPower + power
    while self.currentPower >= self.pushPowerNeeded do
        local pushed = self.lines[i * 2 - self.doormodulos[i] % 2]:pop()
        if pushed == nil then
            self.doormodulos[i] = self.doormodulos[i] % 2 + 1
            self.currentPower = self.currentPower * self.powerSaver
            break
        else
            local combinedSize = self.lines[i*2 + 0]:getSize() + self.lines[i*2 - 1]:getSize()
            self.boarded_people = self.boarded_people + 1
            self.people[i] = self.people[i] - 1
            if self.people[i] > combinedSize then
                self.lines[i * 2 - self.doormodulos[i] % 2]:push(Human:create())
            end
            self.wagonFillStatus = self.wagonFillStatus + 1.0 / self.wagonSize
            self.currentPower = self.currentPower - self.pushPowerNeeded
            self.doormodulos[i] = self.doormodulos[i] % 2 + 1
        end
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
            platform:personPushed(1,100)
        end
    end
    function platform.push2:clicked(button)
        if button == 1 then
            platform:personPushed(2,100)
        end
    end
    function platform.push3:clicked(button)
        if button == 1 then
            platform:personPushed(3,100)
        end
    end
    function platform.push4:clicked(button)
        if button == 1 then
            platform:personPushed(4,100)
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