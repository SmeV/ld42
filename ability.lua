Ability = {}
Ability.__index = Ability

function Ability:create(name, explanation)
    local ability = {}
    setmetatable(ability, Ability)

    ability.name = name
    ability.explanation = explanation
    ability.level = 0
    ability.initCost = 5 --00
    ability.costIncrease = 1.2
    ability.cost = 5

    return ability
end

function Ability:upgrade()
    self.level = self.level + 1
    self.cost = math.ceil(self.initCost * math.pow(self.costIncrease, self.level))
    self:upgraded()
end

-- Overwrittable to react to upgrades
function Ability:upgraded()
end