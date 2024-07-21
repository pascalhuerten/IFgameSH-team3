local gfx <const> = playdate.graphics

class("kraken").extends("object")

function kraken:init(x, y)
    kraken.super.init(self, x, y, 40, 40, 0, config.krakenImagePath, false, 140)
    self.tentacles = {}
    self.warnings = {}
    self.spawnDelay = 1.3 -- Delay in seconds between spawns
    self.lastSpawnTime = 0 -- Time since last spawn
    self.team = 2
    self.HP = 100;
end

function kraken:update()
    self.lastSpawnTime = self.lastSpawnTime + deltaTime

    -- Update warnings and spawn tentacles
    for i = #self.warnings, 1, -1 do
        local warning = self.warnings[i]
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

function kraken:collide(object)
    if(self.team == object.team) then return end
    if((object.activeCollision == nil or object.activeCollision) and object.active and collides(self, object)) then 
        object:registerCollision()
        self:registerCollision()
    end
end

function kraken:registerCollision()
    self.HP -= 10;
    if(self.HP <= 0) then
        self:destroy()
        for index, value in ipairs(self.tentacles) do
            value:destroy()
        end
        for index, value in ipairs(self.warnings) do
            value:destroy()
        end
    end
end


class("tentacle").extends("object")

function tentacle:init(x, y, direction)
    tentacle.super.init(self, x, y, 40, 40, direction, config.tentacleImagePath, false, 140)
    self.sprite:setZIndex(-10)
    self.timer = 0
    self.team = 2
end

function tentacle:collide(object)
    if(self.team == object.team) then return end
    if(object.enableCollision and object.active and collides(self, object)) then 
        object:registerCollision()
        self:registerCollision()
    end
end

function tentacle:registerCollision()
    print("tentacle collides!")
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