require "button"

StationClickable = {}
StationClickable.__index = StationClickable

function StationClickable:create(station, listPosition, cost)
    local stationClickable = {}
    setmetatable(stationClickable, StationClickable)

    stationClickable.linkedStation = station
    stationClickable.clickable = Clickable:create(1400, 400 + 50 * listPosition, 500, 50)
    stationClickable.clickable.fixed = true
    stationClickable.listPosition = listPosition
    stationClickable.stationAvailable = true
    stationClickable.cost = cost

    function stationClickable.clickable:clicked()
        stationClickable:buyStation()
    end

    return stationClickable
end

function StationClickable:buyStation()
    if money >= self.cost and self.stationAvailable then
        money = money - self.cost
        stations[self.linkedStation] = Station:create(self.linkedStation, g_shimbashi, 1)
        self.stationAvailable = false
    elseif not self.stationAvailable then
        current_station = self.linkedStation
    end
end

function StationClickable:draw(tab)
    if tab ~= 2  then
        return
    end
    if self.linkedStation == current_station then
        love.graphics.setColor(0,0.8,0)
    else
        love.graphics.setColor(255,255,255)
    end
    love.graphics.rectangle("fill", self.clickable.x +pos, self.clickable.y, self.clickable.width, self.clickable.height)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", self.clickable.x+pos, self.clickable.y, self.clickable.width, self.clickable.height)

    love.graphics.setNewFont(20)
    if self.stationAvailable then
        love.graphics.printf(self.linkedStation .. "     Cost: " .. self.cost, 1400+pos, self.clickable.y, self.clickable.width)
    else
        love.graphics.printf(self.linkedStation .. " bought.", 1400+pos, self.clickable.y, self.clickable.width)
    end
    --love.graphics.printf("Cost: " .. (self.linkedStation.cost), 1400+pos, self.clickable.y+100, self.clickable.width, "right")
    love.graphics.setNewFont(46)

end

function StationClickable:mousemoved(x, y, dx, dy, istouch, tab)
    if tab ~= 2 then
        return
    end
    self.clickable:mousemoved(x,y,dx,dy,istouch)
end

function StationClickable:mousepressed(x, y, button, istouch, presses, tab)
    if tab ~= 2 then
        return
    end
    self.clickable:mousepressed(x,y,button,istouch, presses)
end