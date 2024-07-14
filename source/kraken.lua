local gfx <const> = playdate.graphics

class("kraken").extends("object")

function kraken:init(x, y)
    kraken.super.init(self, x, y, 40, 40, 0, config.krakenImagePath, false, 140)
    self.tentacles = {}
    self.warnings = {}
    self.spawnDelay = 1.3 -- Delay in seconds between spawns
    self.lastSpawnTime = 0 -- Time since last spawn
end

function kraken:update()
    self.lastSpawnTime = self.lastSpawnTime + deltaTime

    -- Update warnings and spawn tentacles
    for i = #self.warnings, 1, -1 do
        local warning = self.warnings[i]
        warning:update(deltaTime)
        if warning:isExpired() then
            -- Replace warning with tentacle
            table.insert(self.tentacles, tentacle(warning.x, warning.y, warning.direction))
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
        table.insert(self.warnings, warning(x, y, direction))
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

function kraken:draw()
    kraken.super.draw(self)
    -- Draw warnings
    for i, warning in ipairs(self.warnings) do
        warning:draw()
    end
    -- Draw tentacles
    for i, tentacle in ipairs(self.tentacles) do
        tentacle:draw()
    end
end


class("tentacle").extends("object")

function tentacle:init(x, y, direction)
    tentacle.super.init(self, x, y, 40, 40, direction, config.tentacleImagePath, false, 140)
    self.sprite:setZIndex(-10)
    self.timer = 0
end

function tentacle:update()
    self.timer = self.timer + deltaTime
end

function tentacle:isExpired()
    return self.currentFrame >= self.frameCount
end

class("warning").extends("object")

function warning:init(x, y, direction)
    warning.super.init(self, x, y, 20, 20, direction, config.tentacleWarningImagePath, false, 140)
    self.sprite:setZIndex(-10)
    self.expirationTime = 3
    self.timer = 0
end

function warning:update()
    self.timer = self.timer + deltaTime
end

function warning:isExpired()
    return self.timer >= self.expirationTime
end