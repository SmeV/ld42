require "button"
require "waitingline"
require "human"
require "ability"

Platform = {}
Platform.__index = Platform

function Platform:create(num) 
    local platform = {}
    setmetatable(platform, Platform)
    platform.number = num

    platform.stats = {}
    platform.stats["pushedPeople"] = 0
    platform.stats["boardedPeople"] = 0
    platform.stats["wronglyBoarded"] = 0
    platform.stats["peopleKilled"] = 0
    platform.stats["perfectlyBoarded"] = 0
    platform.stats["money"] = 0

    platform.statsDaily = {}
    platform.statsDaily["pushedPeople"] = 0
    platform.statsDaily["boardedPeople"] = 0
    platform.statsDaily["wronglyBoarded"] = 0
    platform.statsDaily["peopleKilled"] = 0
    platform.statsDaily["perfectlyBoarded"] = 0
    platform.statsDaily["money"] = 0

    platform.multiplier = {}
    platform.multiplier["normal"] = 1.0
    platform.multiplier["woman"] = 2.0
    platform.multiplier["lowac"] = 3.0

    platform.abilities = {}
    platform:initAbilities()

    platform.wagon = {}
    platform.wagon["size"] = 100
    platform.wagon["fillStatus"] = 0.0
    platform.wagon["pushedPeople"] = 0
    platform.wagon["boardedPeople"] = 0
    platform.wagon["wronglyBoarded"] = 0
    platform.wagon["graphics"] = g_wagon
    platform.wagon["type"] = "normal"
    platform.wagon["status"] = "entering"
    if num == 1 then
        platform.wagon["graphics"] = g_wagon_woman
        platform.wagon["type"] ="woman"
    elseif num == 4 then
        platform.wagon["graphics"] = g_wagon_ac
        platform.wagon["type"] = "lowac"
    end

    platform.employees = 0
    platform.boardingTimeNeeded = 1.0
    platform.boardingTimer = 0.0
    platform.autoBoardingMax = 0.5
    platform.pushPowerNeeded = 1.0
    platform.currentPower = 0.0
    platform.powerSaver = 0.0
    platform.smartness = 0.0

    -- update timer every 1 sec
    platform.custom_dt = 0

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
    platform.color_factor = 0.0001
    platform.clever_factor = 100.0

    platform:initClickables()

    return platform
end

function Platform:drawWagon(animate_factor)
    local s = 100.0/1250.0
    local oldr, oldg, oldb = love.graphics.getColor()

    -- label woman only and low ac cars on platfrom
    love.graphics.setColor(0,0,0)
    love.graphics.setFont(fonts["46"])
    if self.number == 1 then
        love.graphics.print("From 6 to 9:30 Woman only",(self.number-1) * g_wagon:getWidth() + 100, 300+ g_wagon:getHeight() + 200)
        --love.graphics.print("XXXXXXXXXXXXXXXxxx",(self.number-1) * g_wagon:getWidth() + 100, 300+ g_wagon:getHeight() + 200)
    elseif self.number == 4 then
        love.graphics.print("Weak Air Conditioning",(self.number-1) * g_wagon:getWidth() + 100, 300+ g_wagon:getHeight() + 200)
    end
    love.graphics.setColor(oldr, oldg, oldb)

    -- train animation
    if self.wagon["status"] == "leaving" then
        love.graphics.draw(self.wagon["graphics"], (self.number-1) * (g_wagon:getWidth()) + 100 - animate_factor, 300)

        --draw windows
        for i=1,5 do
            if self.wagon["fillStatus"] <= 0.25 then
                love.graphics.draw(g_window0, (self.number-1) * g_wagon:getWidth() + 150 + (i-1) * (g_wagon:getWidth()/5)- animate_factor, 300+g_wagon:getHeight()/2)
            elseif self.wagon["fillStatus"] <= 0.5 then
                love.graphics.draw(g_window1, (self.number-1) * g_wagon:getWidth() + 150 + (i-1) * (g_wagon:getWidth()/5)- animate_factor, 300+g_wagon:getHeight()/2)
            elseif self.wagon["fillStatus"] <= 0.75 then
                love.graphics.draw(g_window2, (self.number-1) * g_wagon:getWidth() + 150 + (i-1) * (g_wagon:getWidth()/5)- animate_factor, 300+g_wagon:getHeight()/2)
            elseif self.wagon["fillStatus"] <= 1.0 then
                love.graphics.draw(g_window3, (self.number-1) * g_wagon:getWidth() + 150 + (i-1) * (g_wagon:getWidth()/5)- animate_factor, 300+g_wagon:getHeight()/2)
            else
                love.graphics.draw(g_window4, (self.number-1) * g_wagon:getWidth() + 150 + (i-1) * (g_wagon:getWidth()/5)- animate_factor, 300+g_wagon:getHeight()/2)
            end
        end
    elseif self.wagon["status"] == "entering" then
        love.graphics.draw(self.wagon["graphics"], (self.number-1) * g_wagon:getWidth() + 100 + g_platform:getWidth()*10 - animate_factor, 300)

        --draw windows
        for i=1,5 do
            if self.wagon["fillStatus"] <= 0.25 then
                love.graphics.draw(g_window0, (self.number-1) * g_wagon:getWidth() + 150 + g_platform:getWidth()*10 + (i-1) * (g_wagon:getWidth()/5)- animate_factor, 300+g_wagon:getHeight()/2)
            elseif self.wagon["fillStatus"] <= 0.5 then
                love.graphics.draw(g_window1, (self.number-1) * g_wagon:getWidth() + 150 + g_platform:getWidth()*10 + (i-1) * (g_wagon:getWidth()/5)- animate_factor, 300+g_wagon:getHeight()/2)
            elseif self.wagon["fillStatus"] <= 0.75 then
                love.graphics.draw(g_window2, (self.number-1) * g_wagon:getWidth() + 150 + g_platform:getWidth()*10 + (i-1) * (g_wagon:getWidth()/5)- animate_factor, 300+g_wagon:getHeight()/2)
            elseif self.wagon["fillStatus"] <= 1.0 then
                love.graphics.draw(g_window3, (self.number-1) * g_wagon:getWidth() + 150 + g_platform:getWidth()*10 + (i-1) * (g_wagon:getWidth()/5)- animate_factor, 300+g_wagon:getHeight()/2)
            else
                love.graphics.draw(g_window4, (self.number-1) * g_wagon:getWidth() + 150 + g_platform:getWidth()*10 + (i-1) * (g_wagon:getWidth()/5)- animate_factor, 300+g_wagon:getHeight()/2)
            end
        end

    elseif self.wagon["status"] == "stopping" then
        love.graphics.draw(self.wagon["graphics"], (self.number-1) * g_wagon:getWidth() + 100, 300)

        --draw windows
        for i=1,5 do
            if self.wagon["fillStatus"] <= 0.25 then
                love.graphics.draw(g_window0, (self.number-1) * g_wagon:getWidth() + 150 + (i-1) * (g_wagon:getWidth()/5), 300+g_wagon:getHeight()/2)
            elseif self.wagon["fillStatus"] <= 0.5 then
                love.graphics.draw(g_window1, (self.number-1) * g_wagon:getWidth() + 150 + (i-1) * (g_wagon:getWidth()/5), 300+g_wagon:getHeight()/2)
            elseif self.wagon["fillStatus"] <= 0.75 then
                love.graphics.draw(g_window2, (self.number-1) * g_wagon:getWidth() + 150 + (i-1) * (g_wagon:getWidth()/5), 300+g_wagon:getHeight()/2)
            elseif self.wagon["fillStatus"] <= 1.0 then
                love.graphics.draw(g_window3, (self.number-1) * g_wagon:getWidth() + 150 + (i-1) * (g_wagon:getWidth()/5), 300+g_wagon:getHeight()/2)
            else
                love.graphics.draw(g_window4, (self.number-1) * g_wagon:getWidth() + 150 + (i-1) * (g_wagon:getWidth()/5), 300+g_wagon:getHeight()/2)
            end
        end
    end

    for i, clickable in pairs(self.push_clickables) do
        clickable:draw()
    end

    
    -- Minimap of current station
    --love.graphics.push()
    love.graphics.setColor(oldr, oldg, oldb)
    love.graphics.setScissor(50*scale_factor, 50*scale_factor, 1000*scale_factor, 200*scale_factor)
    love.graphics.draw(g_platform, pos + (self.number-1) * g_platform:getWidth() * s +50, 150, 0, s, s)
    love.graphics.setColor(math.min(1,1*math.max(0,self.color_factor)),math.min(1,1*math.max(0,(1.0/self.color_factor))),0)
    love.graphics.circle("fill",pos + (self.number-1) * 100 + 50 + 50, 225, 15)
    love.graphics.setColor(oldr, oldg, oldb)

    if self.number == wagon_num then
        love.graphics.setColor(255,255,0)
        love.graphics.rectangle("line", pos + (self.number-1) * g_wagon:getWidth() * s + 50, 100, 100, 150)
        love.graphics.setColor(oldr, oldg, oldb)
    end
    if self.wagon["status"] == "leaving" then
        love.graphics.draw(self.wagon["graphics"], pos + (self.number-1) * g_wagon:getWidth() * s + 50 - animate_factor * s --[[/(10*g_platform:getWidth())*1000]], 150+300*s, 0, s, s)
        for i=1,5 do
            love.graphics.draw(g_window0, pos + (self.number-1) * g_wagon:getWidth() *s + 50 + s*60 + (i-1) * (g_wagon:getWidth()*s/5) - animate_factor * s, 150+300*s+g_wagon:getHeight()*s/2, 0, s, s)
        end
    elseif self.wagon["status"] == "entering" then
        love.graphics.draw(self.wagon["graphics"], pos + (self.number-1)* g_wagon:getWidth() * s + 50 + g_platform:getWidth()*10*s - animate_factor*s, 150+300*s, 0, s,s)
        for i=1,5 do
            love.graphics.draw(g_window0, pos + (self.number-1) * g_wagon:getWidth() * s + 50 + s*60 + g_platform:getWidth()*10*s + (i-1) * (g_wagon:getWidth()*s/5) - animate_factor * s, 150+300*s+g_wagon:getHeight()*s/2, 0, s, s)
        end
    elseif self.wagon["status"] == "stopping" then
        love.graphics.setColor(math.min(1,1*math.max(0,self.wagon["fillStatus"])),math.min(1,1*math.max(0,(1.0/self.wagon["fillStatus"]))),0)
        love.graphics.rectangle("fill",pos + (self.number-1) * g_wagon:getWidth() * s + 50, 100, 100, 70)
        love.graphics.setColor(oldr, oldg, oldb)
        love.graphics.draw(self.wagon["graphics"], pos + (self.number-1) * g_wagon:getWidth() * s + 50, 150+300*s, 0, s,s)
        for i=1,5 do
            love.graphics.draw(g_window0, pos + (self.number-1) * g_wagon:getWidth() *s + 50 + s*60 + (i-1) * (g_wagon:getWidth()*s/5), 150+300*s+g_wagon:getHeight()*s/2,0, s, s)
        end
    elseif self.wagon["status"] == "stopping" then
    end
    love.graphics.setScissor()
    --love.graphics.pop()
end

function Platform:drawPlatform(animate_factor)
    -- draw fence
    if self.abilities["fence"].level > 0 then
        love.graphics.draw(g_fence, (self.number-1) * g_wagon:getWidth() + 100, 300)
    end

    -- draw humans
    for i, line in pairs(self.lines) do
        line:draw(((self.number-1)*5 + math.ceil(i/2)) * g_wagon:getWidth()/5 + 50 - 10 + i%2 * 100, g_platform:getHeight() * 0.68, i%2)
    end
end

function Platform:update(dt, modifiers)
    self.custom_dt = self.custom_dt + dt
    self.boardingTimer = self.boardingTimer + dt
    if self.custom_dt > 1 then
        self:peopleAdded(modifiers)
        self:refillLines()
        self:employeesPush()
        self.custom_dt = 0

        self.num_people = self.people[4]+self.people[1]+self.people[2]+self.people[3]
        self.color_factor = self.num_people * self.boardingTimeNeeded / (self.clever_factor)
    end

    if self.boardingTimer >= self.boardingTimeNeeded then
        self:autoBoarding()
        self.boardingTimer = 0.0
    end

    if self.wagon["status"] == "waiting" then
        self.wagon["fillStatus"] = 0.0
    end
    self.pushPowerNeeded = 1.0 / (1.0 / (1.0 + self.wagon["fillStatus"]))
end

function Platform:peopleAdded(modifier)
    for i = 1, 4 do

        if time_s >= 5*3600 and time_s <= 5.5 * 3600 then
            self.people[i] = self.people[i] + math.random(0, 1)
        elseif time_s > 5.5 *3600 and time_s <= 9 * 3600 then
            self.people[i] = self.people[i] + math.floor((time_h - 4) * modifier * math.random(50, 100) / 40 * self.custom_dt)
        elseif time_s > 9 *3600 and time_s <= 14 * 3600 then
            self.people[i] = self.people[i] + math.floor((15 - time_h) * modifier * math.random(10, 50) / 40 * self.custom_dt)
        elseif time_s > 14 *3600 and time_s <= 21 * 3600 then
            self.people[i] = self.people[i] + math.floor((time_h - 13) * modifier * math.random(30, 80) / 40 * self.custom_dt)
        elseif time_s > 21 *3600 and time_s <= 24 * 3600 then
            self.people[i] = self.people[i] + math.floor((25 - time_h) * modifier * math.random(30, 80) / 40 * self.custom_dt)
        end
    end
end

function Platform:refillLines()
    for i = 1,4 do
        local combinedSize = self.lines[i*2 + 0]:getSize() + self.lines[i*2 - 1]:getSize()
        while combinedSize < 10 and combinedSize < self.people[i] do
            if self.lines[i*2 + 0]:getSize() <= self.lines[i*2 - 1]:getSize() then
                self.lines[i*2 + 0]:push(self:getHuman())
            else
                self.lines[i*2 - 1]:push(self:getHuman())
            end
            combinedSize = combinedSize + 1
        end
    end
end

function Platform:employeesPush()
    if self.wagon["status"] == "stopping" then
        for i = 1,self.employees do
            local rngPos = math.random(4)
            self:personPushed(rngPos, 1.0)
        end
    end
end

function Platform:autoBoarding()
    if self.wagon["status"] == "stopping"  then
        for i = 1, 4 do
            if self.wagon["fillStatus"] < self.autoBoardingMax and self.people[i] > 0 then
                self:personPushed(i, 1.0)
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
            --self.currentPower = self.currentPower * self.powerSaver
            --self.currentPower = 0
            break
        else
            if self:evalStats(pushed) then
                local combinedSize = self.lines[i*2 + 0]:getSize() + self.lines[i*2 - 1]:getSize()
                self.people[i] = self.people[i] - 1
                if self.people[i] > combinedSize then
                    self.lines[i * 2 - self.doormodulos[i] % 2]:push(self:getHuman())
                end
                self.wagon["fillStatus"] = self.wagon["fillStatus"] + 1.0 / self.wagon["size"]
                self.currentPower = self.currentPower - self.pushPowerNeeded
                self.doormodulos[i] = self.doormodulos[i] % 2 + 1
                pushed = nil
            else
                self.lines[i * 2 - self.doormodulos[i] % 2]:pushFront(pushed)
                break
            end
        end
    end
end

function Platform:evalStats(person)
    if self.wagon["status"] ~= "stopping" and self.abilities["fence"].level == 0 then
        self.statsDaily["peopleKilled"] = self.statsDaily["peopleKilled"] + 1
    elseif self.wagon["status"] ~= "stopping" and self.abilities["fence"].level >= 0 then
        self.currentPower = self.currentPower * self.powerSaver
        return false
    elseif self.wagon["type"] == "woman" and person.gender == "male" then
        self.wagon["wronglyBoarded"] = self.wagon["wronglyBoarded"] + 1
        self.wagon["boardedPeople"] = self.wagon["boardedPeople"] + 1
    elseif self.wagon["type"] == "lowac" and person.type ~= "tourist" then
        self.wagon["wronglyBoarded"] = self.wagon["wronglyBoarded"] + 1
        self.wagon["boardedPeople"] = self.wagon["boardedPeople"] + 1
    else
        self.wagon["boardedPeople"] = self.wagon["boardedPeople"] + 1
    end
    return true
end

function Platform:evalWagon()
    self.statsDaily["pushedPeople"] = self.statsDaily["pushedPeople"] + self.wagon["pushedPeople"]
    self.statsDaily["boardedPeople"] = self.statsDaily["boardedPeople"] + self.wagon["boardedPeople"]
    self.statsDaily["wronglyBoarded"] = self.statsDaily["wronglyBoarded"] + self.wagon["wronglyBoarded"]

    local earnedMoney = self.wagon["boardedPeople"] - 2 * self.wagon["wronglyBoarded"]
    if self.wagon["wronlgyBoarded"] == 0 then
        earnedMoney = math.floor(earnedMoney * self.wagon["multiplier"])
    end

    self.statsDaily["money"] = self.statsDaily["money"] + earnedMoney
    return earnedMoney
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

function Platform:initAbilities()
    local platform = self
    platform.speedboardingAbility = Ability:create("Speedboarding", "People will board the trains faster.")
    platform.maxboardingAbility = Ability:create("Autoboarding", "People will board fuller trains.")
    platform.employeesAbility = Ability:create("Employees", "Employees will push people into trains.")
    platform.fencesAbility = Ability:create("Fences", "Fences prevent people from falling on the tracks. If you push people against the fence they will board the train once it arrives.")
    platform.abilities["boardingSpeed"] = platform.speedboardingAbility
    platform.abilities["maxBoarding"] = platform.maxboardingAbility
    platform.abilities["employees"] = platform.employeesAbility
    platform.abilities["fence"] = platform.fencesAbility

    function platform.speedboardingAbility:upgraded()
        platform.boardingTimeNeeded = math.pow(0.95, self.level)
    end
    function platform.maxboardingAbility:upgraded()
        platform.autoBoardingMax = 0.5 + 0.5 * math.pow(0.9, self.level)
    end
    function platform.employeesAbility:upgraded()
        platform.employees = self.level
    end
    function platform.fencesAbility:upgraded()
        platform.powerSaver = 1.0 - math.pow(0.95, self.level)
    end

end

function Platform:initClickables()
    local platform = self
    platform.push_clickables = {}
    platform.push1 = Clickable:create((platform.number-1) * g_wagon:getWidth() + 225 + 0 * 250, 300, (g_wagon:getWidth() / 5), 600)
    platform.push2 = Clickable:create((platform.number-1) * g_wagon:getWidth() + 225 + 1 * 250, 300, (g_wagon:getWidth() / 5), 600)
    platform.push3 = Clickable:create((platform.number-1) * g_wagon:getWidth() + 225 + 2 * 250, 300, (g_wagon:getWidth() / 5), 600)
    platform.push4 = Clickable:create((platform.number-1) * g_wagon:getWidth() + 225 + 3 * 250, 300, (g_wagon:getWidth() / 5), 600)
    platform.push1.numclicked = 0
    function platform.push1:clicked(button)
        if button == 1 then
            platform:personPushed(1,pushPower)
        end
    end
    function platform.push1:hoveredCallback(x,y)
        love.mouse.setCursor(hand_cursor)
    end
    function platform.push2:clicked(button)
        if button == 1 then
            platform:personPushed(2,pushPower)
        end
    end
    function platform.push2:hoveredCallback(x,y)
        love.mouse.setCursor(hand_cursor)
    end
    function platform.push3:clicked(button)
        if button == 1 then
            platform:personPushed(3,pushPower)
        end
    end
    function platform.push3:hoveredCallback(x,y)
        love.mouse.setCursor(hand_cursor)
    end
    function platform.push4:clicked(button)
        if button == 1 then
            platform:personPushed(4,pushPower)
        end
    end
    function platform.push4:hoveredCallback(x,y)
        love.mouse.setCursor(hand_cursor)
    end
    table.insert(platform.push_clickables, platform.push1)
    table.insert(platform.push_clickables, platform.push2)
    table.insert(platform.push_clickables, platform.push3)
    table.insert(platform.push_clickables, platform.push4)
end

function Platform:dayEnd()
    -- update continuous stats
    self.stats["pushedPeople"] = self.stats["pushedPeople"] + self.statsDaily["pushedPeople"]
    self.stats["boardedPeople"] = self.stats["boardedPeople"] + self.statsDaily["boardedPeople"]
    self.stats["wronglyBoarded"] = self.stats["wronglyBoarded"] + self.statsDaily["wronglyBoarded"]
    self.stats["peopleKilled"] = self.stats["peopleKilled"] + self.statsDaily["peopleKilled"]
    self.stats["perfectlyBoarded"] = self.stats["perfectlyBoarded"] + self.statsDaily["perfectlyBoarded"]
    self.stats["money"] = self.stats["money"] + self.statsDaily["money"]
end

function Platform:newDay()
    -- reset daily stats
    self.statsDaily["pushedPeople"] = 0
    self.statsDaily["boardedPeople"] = 0
    self.statsDaily["wronglyBoarded"] = 0
    self.statsDaily["peopleKilled"] = 0
    self.statsDaily["perfectlyBoarded"] = 0
    self.statsDaily["money"] = 0
end


function Platform:newWagon(filled)
    self.wagon["size"] = 100
    self.wagon["fillStatus"] = filled or 0.0
    self.wagon["boardedPeople"] = 0
    self.wagon["wronglyBoarded"] = 0
    self.wagon["status"] = "entering"
end

function Platform:changeStatus(status)
    self.wagon["status"] = status
end

function Platform:getHuman()
    local rng = math.random()
    local stupid = true
    if rng < self.smartness then stupid = false end
    if stupid then return Human:create() 
    else 
        if self.wagon["type"] == "woman" then
            return Human:create("female")
        elseif self.wagon["type"] == "lowac" then
            return Human:create(nil,"tourist")
        else
            return Human:create()
        end
    end 
end