require "button"

StatScreen = {}
StatScreen.__index = StatScreen

function StatScreen:create(title, stats)
    local statscreen = {}
    setmetatable(statscreen, StatScreen)
    statscreen.title = title
    statscreen.stats = stats
    statscreen.isActive = false
    statscreen.fixed = true

    statscreen.animation = {}
    statscreen.animation["duration"] = 0.2
    statscreen.animation["status"] = "none"
    statscreen.animation["timer"] = 0.0

    statscreen.graphics = {}
    statscreen.graphics["x"] = 100
    statscreen.graphics["y"] = 100
    local window_width, window_height, window_flags = love.window.getMode()
    statscreen.graphics["width"] = window_width - 2 * statscreen.graphics["x"]
    statscreen.graphics["height"] = window_height - 2 * statscreen.graphics["y"]

    local closeButton = Clickable:create(statscreen.graphics["x"] + statscreen.graphics["width"] - 55, statscreen.graphics["y"] + 5, 50, 50)
    closeButton.fixed = true
    statscreen.all_buttons = {}
    statscreen.all_buttons["close"] = closeButton
    function closeButton:clicked()
        statscreen:close()
    end
    function closeButton:draw()
        love.graphics.push()
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", self.x + pos, self.y, self.width, self.height)
        if statscreen.isActive then
            love.graphics.setColor(255,255,255)
        else
            love.graphics.setColor(255,0,255)
        end
        love.graphics.setFont(fonts["46"])
        love.graphics.printf("x", self.x + pos, self.y, self.width, "center")
        love.graphics.pop()
    end
    return statscreen

end

function StatScreen:changeAnimationStatus(status)
    self.animation["status"] = status
    self.animation["timer"] = 0.0
end

function StatScreen:open()
    self.animation["timer"] = 0.0
    self.animation["status"] = "opening"
    self.isActive = true
end

function StatScreen:close()
    self:changeAnimationStatus("closed")
    for sname, station in pairs(stations) do
        station:newDay()
    end
    self.isActive = false
end

function StatScreen:update(dt)
    if self.animation["status"] == "opening" then
        self.animation["timer"] = self.animation["timer"] + dt
    end
    if self.animation["timer"] > self.animation["duration"] then
        self:changeAnimationStatus("opened")
    end
end

function StatScreen:draw()
    if self.animation["status"] == "opening" then
        local rectanglePercent = self.animation["timer"] / self.animation["duration"]
        local rectX = self.graphics["x"] + self.graphics["width"]/2.0 - rectanglePercent * (self.graphics["width"]/2.0)
        local rectY = self.graphics["y"] + self.graphics["height"]/2.0 - rectanglePercent * (self.graphics["height"]/2.0)
        if self.fixed then
            rectX = rectX + pos
        end
        rectangleAppear({255,255,0}, {255,255,255}, rectX, rectY, self.graphics["width"] * rectanglePercent, self.graphics["height"] * rectanglePercent)
    elseif self.animation["status"] == "opened" then
        local rectX = self.graphics["x"]
        local rectY = self.graphics["y"]
        if self.fixed then
            rectX = rectX + pos
        end
        rectangleAppear({255,255,0}, {255,255,255}, rectX, rectY, self.graphics["width"], self.graphics["height"])

        love.graphics.push()
        love.graphics.setColor(0,0,0)
        love.graphics.setFont(fonts["46"])
        love.graphics.printf(self.title, rectX, rectY + 100, self.graphics["width"], "center")

        local i = 0
        for name, stat in pairs(self.stats) do
            love.graphics.printf(name..": "..stat, rectX + 100, rectY + 200 + 100 * i, self.graphics["width"] - 200)
            i = i+1
        end
        for i, clickable in pairs(self.all_buttons) do
            clickable:draw()
        end
        love.graphics.pop()
    end
end

function StatScreen:mousemoved(x, y, dx, dy, istouch)
    for i, clickable in pairs(self.all_buttons) do
        clickable:mousemoved(x, y, dx, dy, istouch)
    end
end

function StatScreen:mousepressed(x, y, button, istouch, presses)
    for i, clickable in pairs(self.all_buttons) do
        clickable:mousepressed(x, y, button, istouch, presses)
    end
end



function rectangleAppear(bordercolor, fillcolor, x, y, width, height)
   love.graphics.push()
   love.graphics.setColor(fillcolor, 150)
   love.graphics.rectangle("fill", x, y, width, height, 5)
 
   if width > 10 and height > 10 then
     love.graphics.setColor(bordercolor, 200)
     love.graphics.rectangle("line", x+5, y+5, width-10, height-10, 5)
   end
 
   love.graphics.pop()
 end