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

    return clickable
end


function Clickable:mousepressed(x, y, button, istouch, presses)
    if (x + pos) >= self.x and (x + pos) < self.x + self.width and y >= self.y and y < self.y + self.height then
        self:clicked(button, istouch, presses)
    end
end

function Clickable:mousemoved(x,y, dx, dy, istouch)
    if (x + pos) >= self.x and (x + pos) < self.x + self.width and y >= self.y and y < self.y + self.height then
        self.hovered = true
    else
        self.hovered = false
    end
end

function Clickable:clicked(button, istouch, presses)
end

function Clickable:draw()
end
