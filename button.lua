Clickable = {}
Clickable.__index = Clickable

function Clickable:create(x, y, width, height) 
    local clickable = {}
    setmetatable(clickable, Clickable)
    clickable.x = x
    clickable.y = y
    clickable.width = width
    clickable.height = height
    clickable.widthScaled = width * scale_factor
    clickable.heightScaled = height * scale_factor
    clickable.hovered = false
    clickable.fixed = false

    return clickable
end


function Clickable:mousepressed(x, y, button, istouch, presses)
    if not self.fixed then
        x = x + pos
    end
    if x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height then
        self:clicked(button, istouch, presses)
        print('clicked')
    end
end

function Clickable:mousemoved(x,y, dx, dy, istouch)
    if not self.fixed then
        x = x + pos
    end
    if x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height then
        if not self.hovered then self:hover(x,y) end
        self.hovered = true
        self:hoveredCallback(x,y)
    else
        if self.hovered then self:unhover(x,y) end
        self.hovered = false
    end
end

function Clickable:hoveredCallback(x,y)
end

function Clickable:hover(x, y)
end

function Clickable:unhover(x,y)
end

function Clickable:clicked(button, istouch, presses, x, y)
end

function Clickable:draw()
end
