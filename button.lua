Button = {}
Button.__index = Button

function Button:create(x, y, width, height) 
    local button = {}
    setmetatable(button, Button)
    button.x = x
    button.y = y
    button.width = width
    button.height = height
    button.hovered = false

    return button
end


function Button:mousepressed(x, y, button, istouch, presses)
    if x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height then
        self:buttonPressed(button, istouch, presses)
    end
end

function Button:mousemoved(x,y, dx, dy, istouch)
    if x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height then
        self.hovered = true
    else
        self.hovered = false
    end
end

function Button:buttonPressed(button, istouch, presses)
end

function Button:draw()
end
