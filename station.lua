require "platform"
require "statscreen"

Station = {}
Station.__index = Station

function Station:create(name, graphic, modifier)
    local station = {}
    setmetatable(station, Station)
    station.name = name
    station.graphic = graphic
    station.platforms = {}
    station.timer = 0  
    station.halt_time = 10 
    station.wait_time = 10
    station.animation_time = 10
    -- indicates people visiting this station eg shimbashi = 1, xx = 1.25, ...
    station.modifier = modifier
    station.num_people = 0

    station.stats = {}
    station.stats["pushedPeople"] = 0
    station.stats["boardedPeople"] = 0
    station.stats["wronglyBoarded"] = 0
    station.stats["peopleKilled"] = 0
    station.stats["perfectlyBoardedWagon"] = 0
    station.stats["perfectlyBoardedTrains"] = 0
    station.stats["money"] = 0

    station.statsDaily = {}
    station.statsDaily["pushedPeople"] = 0
    station.statsDaily["boardedPeople"] = 0
    station.statsDaily["wronglyBoarded"] = 0
    station.statsDaily["peopleKilled"] = 0
    station.statsDaily["perfectlyBoardedWagon"] = 0
    station.statsDaily["perfectlyBoardedTrains"] = 0
    station.statsDaily["money"] = 0

    station.abilities = {}
    station.abilities["frequency"] = Ability:create("Frequency")
    station.abilities["campaign"] = Ability:create("Campaign")

    -- "empty" "entering" "stopping" "leaving"
    station.status = "entering"
    for i = 1, 10 do
        table.insert(station.platforms, Platform:create(i))
    end

    return station
end

function Station:draw()
    animation_factor = self.timer/self.animation_time * 10 * self.graphic:getWidth()
    for i = 1, 10 do
        --draw station
        love.graphics.draw(self.graphic, (i-1) * self.graphic:getWidth(), 0)
        -- write Station Name
        love.graphics.setColor(0,0,0)
        love.graphics.print(self.name .. " Station", (i-1) * self.graphic:getWidth() + self.graphic:getWidth() / 3.0, self.graphic:getHeight()/2.0)
        love.graphics.setColor(1,1,1)
        --draw platform
        love.graphics.draw(g_platform, (i-1) * self.graphic:getWidth(), 0)
    end
    if self.status == "stopping" then
        -- next train timer
        love.graphics.push()
        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("fill",pos + 50, 100, 1000 * (1.0 - self.timer / self.halt_time), 100)
        love.graphics.setColor(255,255,255)
        love.graphics.pop()
    end

    for i, plat in pairs(self.platforms) do
        plat:draw(animation_factor)
    end
   -- love.graphics.print(self.timer, 1000,1000)
   -- love.graphics.print(self.status, 1000, 800)
end

function Station:update(dt)
    self.timer = self.timer + dt 
    if self.status == "empty" and self.timer >= self.wait_time then
        self:changeStatus("entering")
    elseif self.status == "entering" and self.timer >= self.animation_time then
        self:changeStatus("stopping")
    elseif self.status == "stopping" and self.timer >= self.halt_time then
        self:changeStatus("leaving")
    elseif self.status == "leaving" and self.timer >= self.animation_time then
        self:changeStatus("empty")
    end

    for i, plat in pairs(self.platforms) do
        plat:update(dt, self.modifier, self.status)
    end
end

function Station:mousemoved(x, y, dx, dy, istouch)
    self.platforms[wagon_num]:mousemoved(x, y, dx, dy, istouch)
end

function Station:mousepressed(x, y, button, istouch, presses)
    self.platforms[wagon_num]:mousepressed(x, y, button, istouch, presses)
end

function Station:dayEnd()
    for i, platform in pairs(self.platforms) do
        platform:dayEnd()
        self.statsDaily["peopleKilled"] = self.statsDaily["peopleKilled"] + platform.statsDaily["peopleKilled"]
    end

    self.stats["pushedPeople"] = self.stats["pushedPeople"] + self.statsDaily["pushedPeople"]
    self.stats["boardedPeople"] = self.stats["boardedPeople"] + self.statsDaily["boardedPeople"]
    self.stats["wronglyBoarded"] = self.stats["wronglyBoarded"] + self.statsDaily["wronglyBoarded"]
    self.stats["peopleKilled"] = self.stats["peopleKilled"] + self.statsDaily["peopleKilled"]
    self.stats["perfectlyBoardedWagon"] = self.stats["perfectlyBoardedWagon"] + self.statsDaily["perfectlyBoardedWagon"]
    self.stats["perfectlyBoardedTrains"] = self.stats["perfectlyBoardedTrains"] + self.statsDaily["perfectlyBoardedTrains"]
    self.stats["money"] = self.stats["money"] + self.statsDaily["money"]

    -- reduce money for killed people today!
    money = money - self.statsDaily["peopleKilled"] * 1000
    self.stats["money"] = self.stats["money"] - self.statsDaily["peopleKilled"] * 1000

    -- bonus money for perfectly boarded trains!
    money = money + self.statsDaily["perfectlyBoardedTrains"] * 10000
    self.stats["money"] = self.stats["money"] + self.statsDaily["perfectlyBoardedTrains"] * 10000

    --statsscreen:open()
end

function Station:newDay()
    for i, platform in pairs(self.platforms) do
        platform:newDay()
    end

    self.statsDaily["pushedPeople"] = 0
    self.statsDaily["boardedPeople"] = 0
    self.statsDaily["wronglyBoarded"] = 0
    self.statsDaily["peopleKilled"] = 0
    self.statsDaily["perfectlyBoardedWagon"] = 0
    self.statsDaily["perfectlyBoardedTrains"] = 0
    self.statsDaily["money"] = 0
end

function Station:evalTrain()
    local newMoney = 0
    local wronglyBoarded = 0
    for i, platform in pairs(self.platforms) do
        self.statsDaily["pushedPeople"] = self.statsDaily["pushedPeople"] + platform.wagon["pushedPeople"]
        self.statsDaily["boardedPeople"] = self.statsDaily["boardedPeople"] + platform.wagon["boardedPeople"]
        self.statsDaily["wronglyBoarded"] = self.statsDaily["wronglyBoarded"] + platform.wagon["wronglyBoarded"]
        if platform.wagon["wronglyBoarded"] == 0 then
            self.statsDaily["perfectlyBoardedWagon"] = self.statsDaily["perfectlyBoardedWagon"] + 1
        end

        wronglyBoarded = wronglyBoarded + platform.wagon["wronglyBoarded"]
        newMoney = newMoney + platform:evalWagon()
    end 
    self.statsDaily["money"] = self.statsDaily["money"] + newMoney
    if wronglyBoarded == 0 then
        self.statsDaily["perfectlyBoardedTrains"] = self.statsDaily["perfectlyBoardedTrains"] + 1
    end

    -- update global money
    money = money + newMoney
end

function Station:newTrain()
    for i, platform in pairs(self.platforms) do
        platform:newWagon()
    end
end

function Station:changeStatus(status)
    self.timer = 0
    self.status = status
    if status == "leaving" then
        self:evalTrain()
    elseif status == "entering" then
        self:newTrain()
    end 

    for i, plaform in pairs(self.platforms) do
        plaform:changeStatus(status)
    end
end