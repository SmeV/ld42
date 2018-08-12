Clickable = {}
Clickable.__index = Clickable

function Clickable:create(x, y, width, height) 
    local clickable = {}
    setmetatable(clickable, Clickable)
    clickable.x = x
    clickable.y = y
    clickable.width = width
    clickable.height = height
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
    end
end

function Clickable:mousemoved(x,y, dx, dy, istouch)
    if not self.fixed then
        x = x + pos
    end
    if x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height then
        self.hovered = true
    else
        self.hovered = false
    end
end

function Clickable:clicked(button, istouch, presses)
end

function Clickable:draw()
end
