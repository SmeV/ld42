Human = {}
Human.__index = Human

function Human:create(gender, type)
    local human = {}
    setmetatable(human, Human)
    local all_genders = {"male", "female"}
    local all_types = {"business", "tourist", "pupil"}
    human.gender = gender or all_genders[math.random(2)]
    human.type = type or all_types[math.random(3)]

    human.graphics = g_human
    if human.gender == "male" and human.type == "business" then
        human.graphics = g_human
    elseif human.gender == "male" and human.type == "tourist" then
        human.graphics = g_human
    elseif human.gender == "male" and human.type == "pupil" then
        human.graphics = g_human
    elseif human.gender == "female" and human.type == "business" then
        human.graphics = g_human
    elseif human.gender == "female" and human.type == "tourist" then
        human.graphics = g_human
    elseif human.gender == "female" and human.type == "pupil" then
        human.graphics = g_human
    end

    return human
end

function Human:draw(x, y, linepos)
    love.graphics.draw(self.graphics, x, y + linepos * 25, 0, 2.5, 2.5)
end