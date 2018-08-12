require "button"

AbilityClickable = {}
AbilityClickable.__index = AbilityClickable

function AbilityClickable:create(ability, listPosition)
    local abilityClickable = {}
    setmetatable(abilityClickable, AbilityClickable)

    abilityClickable.linkedAbility = ability
    abilityClickable.clickable = Clickable:create(1400, -500, 500, 200) -- init on unclickable region?
    abilityClickable.clickable.fixed = true
    function abilityClickable.clickable:clicked()
        abilityClickable:upgradeAbility()
    end
    abilityClickable.listPosition = listPosition

    return abilityClickable
end

function AbilityClickable:upgradeAbility()
    if money >= self.linkedAbility.cost then
        money = money - self.linkedAbility.cost
        self.linkedAbility:upgrade()
    end
end

function AbilityClickable:draw(scrollPosition, tab)
    if tab ~= 1 or self.listPosition < scrollPosition or (self.listPosition - scrollPosition) >= 3 then
        return
    end
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill", 1400+pos, self.clickable.y, self.clickable.width, self.clickable.height)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", 1400+pos, self.clickable.y, self.clickable.width, self.clickable.height)

    love.graphics.printf(self.linkedAbility.name .. " Lvl. " .. (self.linkedAbility.level + 1), 1400+pos, self.clickable.y, self.clickable.width)
    love.graphics.printf("Cost: " .. (self.linkedAbility.cost), 1400+pos, self.clickable.y+100, self.clickable.width, "right")

end

function AbilityClickable:updatePosition(scrollPosition)
    if self.listPosition >= scrollPosition and (self.listPosition - scrollPosition) < 3 then
        self.clickable.y = 400 + (self.listPosition - scrollPosition) * 200 
    else
        self.clickable.y = -500
    end
end

function AbilityClickable:mousemoved(x, y, dx, dy, istouch, scrollPosition, tab)
    if tab ~= 1 or self.listPosition < scrollPosition or (self.listPosition - scrollPosition) >= 3 then
        return
    end
    self.clickable:mousemoved(x,y,dx,dy,istouch)
end

function AbilityClickable:mousepressed(x, y, button, istouch, presses, scrollPosition, tab)
    if tab ~= 1 or self.listPosition < scrollPosition or (self.listPosition - scrollPosition) >= 3 then
        return
    end
    self.clickable:mousepressed(x,y,button,istouch, presses)
end