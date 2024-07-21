import "object"

class("kraken").extends("object")

function kraken:init(x, y)
    kraken.super.init(self, x, y, 0, 0, nil, 80, 80, config.krakenImagePath, false, 140, 1, 10, 1000, true, {{0, 0, 55}})
    self.tentacles = {}
    self.warnings = {}
    self.spawnDelay = 1.3 -- Delay in seconds between spawns
    self.lastSpawnTime = 0 -- Time since last spawn
end

function kraken:update()
    if(self.health <= 0) then
        for _, v in ipairs(self.tentacles) do
            v:destroy()
        end
        for _, v in ipairs(self.warnings) do
            v:destroy()
        end
        print("Kraken killed!")
        self:destroy()
        return
    end

    self.lastSpawnTime = self.lastSpawnTime + deltaTime

    -- Update warnings and spawn tentacles
    for i = #self.warnings, 1, -1 do
        local warning = self.warnings[i]
        if warning:isExpired() then
            -- Replace warning with tentacle
            table.insert(self.tentacles, tentacle(warning.x, warning.y, warning.direction, self.team))
            self.warnings[i]:destroy()
            table.remove(self.warnings, i)
        end
    end


    -- Spawn warnings if kraken is visible on screen

    if self.sprite:isVisible() and #self.tentacles + #self.warnings < 4 and self.lastSpawnTime >= self.spawnDelay then
        local minDistance = 80
        local maxDistance = 200
        local x, y
        repeat
            x = self.x + math.random(-maxDistance, maxDistance)
            y = self.y + math.random(-maxDistance, maxDistance)
            local distance = math.sqrt((x - self.x)^2 + (y - self.y)^2)
        until distance >= minDistance

        local direction = 0
        if x < 0 then
            direction = 180
        end

        -- Insert warning object
        table.insert(self.warnings, warning(x, y, direction, self.team))
        self.lastSpawnTime = 0
    end

    -- Update and remove tentacles
    for i = #self.tentacles, 1, -1 do
        local tentacle = self.tentacles[i]
        if tentacle:isExpired() then
            tentacle:destroy()
            table.remove(self.tentacles, i)
        end
    end
end

function kraken:onCollision(otherObject)
    print("Kraken hit")
    if otherObject.team == self.team then
        print("Kraken hit by same team, no damage")
        return
    end

    self:receiveDamage(otherObject.damageOutput)
end


class("tentacle").extends("object")

function tentacle:init(x, y, direction, team)
    tentacle.super.init(self, x, y, 0, 0, direction, 40, 40, config.tentacleImagePath, false, 140, team, 10, 10, true, {{0, 0, 20}})
    self.sprite:setZIndex(-10)
end

function tentacle:isExpired()
    return self.currentFrame >= self.frameCount
end

class("warning").extends("object")

function warning:init(x, y, direction)
    warning.super.init(self, x, y, 0, 0, direction, 20, 20, config.tentacleWarningImagePath, false, 140, team, 0, 1000, true)
    self.sprite:setZIndex(-10)
    self.timer = playdate.timer.new(3000, function() self:expire() end)
end

function warning:expire()
    self.expired = true
end

function warning:isExpired()
    return self.expired
end