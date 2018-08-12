require "button"

StatScreen = {}
StatScreen.__init = StatScreen

function StatScreen:create(title, stats)
    statscreen = {}
    setmetatable(statscreen, StatScreen)
    statscreen.title = title
    statscreen.stats = stats

    statscreen.animation = {}
    statscreen.animation["duration"] = 3.0
    statscreen.animation["status"] = "none"
    statscreen.animation["timer"] = 0.0

    statscreen.graphics = {}
    statscreen.graphics["x"] = 200
    statscreen.graphics["y"] = 200
    statscreen.graphics["width"] = love.window.getWidth() - 2 * statscreen.graphics["x"]
    statscreen.graphics["height"] = love.window.getWidth() - 2 * statscreen.graphics["y"]

    statscreen.all_buttons = {}
    statscreen.all_buttons["close"] = Button:create()
    function statscreen.all_buttons["close"]:clicked()
        statscreen.close()
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
end

function StatScreen:close()
    self:changeAnimationStatus("closed")
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
        rectangleAppear({255,255,0}, {0,255,255}, rectX, rectY, self.graphics["width"] * rectanglePercent, self.graphics["height"] * rectanglePercent)
    elseif self.animation["status"] == "opened" then
        rectangleAppear({255,255,0}, {0,255,255}, self.graphics["x"], self.graphics["y"], self.graphics["width"], self.graphics["height"])
    end
end

function rectangleAppear(bordercolor, fillcolor, x, y, width, height)
   love.graphics.push()
   love.graphics.setColor(0, 0, 0, 150)
   love.graphics.rectangle("fill", x, y, width, height, 5)
 
   --if width > 10 and height > 10 then
   --  love.graphics.setColor(bordercolor[1], bordercolor[2], bordercolor[3], 200)
   --  love.graphics.rectangle("line", x+5, y+5, width-10, height-10, 5)
   --end
 
   love.graphics.pop()
 end



