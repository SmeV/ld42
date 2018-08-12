require "human"

WaitingLine = {}
WaitingLine.__index = WaitingLine

function WaitingLine:create()
    local waitingline = {}
    setmetatable(waitingline, WaitingLine)
    waitingline.first = 0
    waitingline.last = -1
    return waitingline
end

function WaitingLine:push(human)
    local first = self.first - 1
    self.first = first
    self[first] = human
end

function WaitingLine:pop()
    local last = self.last
    if self.first > self.last then return nil end
    local human = self[last]
    self[last] = nil
    self.last = last - 1
    return human
end

function WaitingLine:getSize()
    return self.last - self.first + 1
end

function WaitingLine:draw(x, y)
    for i = self.last, self.first, -1 do
        self[i]:draw(x, y, self.last - i)
    end
end