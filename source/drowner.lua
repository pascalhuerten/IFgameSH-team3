class("drowner").extends("object")

function drowner:init(x, y, team)
    self.targetDirection = math.random(0, 360)
    drowner.super.init(self, x, y, 20, 20, targetDirection, 10, 10, config.drowningPersonImagePath, false, 140, team, 0, 30, true, {{0, 0, 10}})
    self.sprite:setZIndex(-10)
    self.drownTimer = playdate.timer.new(20000, self.destroy, self)
    self.activeCollision = false
    self.immuneTimer = playdate.timer.new(500, function() self.activeCollision = true end)
    self.speed = 170
end

function drowner:update()
    if self.immuneTimer.timeLeft > 0 then
        local rad = math.rad(self.targetDirection)
        self.dx = math.cos(rad) * self.speed
        self.dy = math.sin(rad) * self.speed
    else
        if not self.reachedTarget then
            self.reachedTarget = true
            self.dx = 0
            self.dy = 0
        end
    end

    drowner.super.update(self)
end

function drowner:onCollisionEnter(_)
end

function drowner:onCollision(otherObject)
    -- If colliding with another drowner move away
    if otherObject.className == "drowner" then
        local dx = self.x - otherObject.x
        local dy = self.y - otherObject.y
        local distance = math.sqrt(dx * dx + dy * dy)

        if distance > 0 then
            self.dx = (dx / distance) * self.speed
            self.dy = (dy / distance) * self.speed
        end
    end
end