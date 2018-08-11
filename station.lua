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
    station.modifier = modifier
    station.num_people = 0
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
    end

    if self.status == "leaving" and self.timer >= self.animation_time then
        self.timer = 0
        self.status = "empty"
    end

    passengers = 0
    for i, plat in pairs(self.platforms) do
        plat:update(dt, self.modifier)
        passengers = passengers + plat.num_people
    end

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