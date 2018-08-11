require "platform"

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
    -- money made by this station for the last train
    self.money = 0
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
        love.graphics.draw(self.graphic, (i-1) * self.graphic:getWidth(), 0)
    end
    for i, plat in pairs(self.platforms) do
        plat:draw(self.status, animation_factor)
    end
   -- love.graphics.print(self.timer, 1000,1000)
   -- love.graphics.print(self.status, 1000, 800)
end

function Station:update(dt)
    self.timer = self.timer + dt 
    if  self.status == "empty" and self.timer >= self.wait_time then
        self.timer = 0
        self.status = "entering"
    end

    if self.status == "entering" and self.timer >= self.animation_time then
        self.timer = 0
        self.status = "stopping"
    end
    
    if self.status == "stopping" and self.timer >= self.halt_time then
        self.timer = 0
        self.status = "leaving"
        for i, plat in pairs(self.platforms) do
            plat.boarded_people = 0
        end
        self.money = self.boarded_people
        self.boarded_people = 0
    end

    if self.status == "leaving" and self.timer >= self.animation_time then
        self.timer = 0
        self.status = "empty"
    end

    passengers = 0
    boarded = 0
    for i, plat in pairs(self.platforms) do
        plat:update(dt, self.modifier, self.status)
        passengers = passengers + plat.num_people
        boarded = boarded + plat.boarded_people
    end

    self.boarded_people = boarded
    self.num_people = passengers
end

function Station:mousemoved(x, y, dx, dy, istouch)
    for i, platform in pairs(self.platforms) do
        platform:mousemoved(x, y, dx, dy, istouch)
    end
end

function Station:mousepressed(x, y, button, istouch, presses)
    for i, platform in pairs(self.platforms) do
        platform:mousepressed(x, y, button, istouch, presses)
    end
end