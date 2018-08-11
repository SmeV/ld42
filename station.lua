require "platform"

Station = {}
Station.__index = Station

function Station:create(name, graphic)
    local station = {}
    setmetatable(station, Station)
    station.name = name
    station.graphic = graphic
    station.platforms = {}
    for i = 1, 10 do
        table.insert(station.platforms, Platform:create(i))
    end

    return station
end

function Station:draw()
    for i = 1, 10 do
        love.graphics.draw(self.graphic, (i-1) * self.graphic:getWidth(), 0)
    end
    for i, plat in pairs(self.platforms) do
        plat:draw()
    end
end