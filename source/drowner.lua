class("drowner").extends("object")

function drowner:init(x, y, direction)
    drowner.super.init(self, x, y, 20, 20, direction, config.drowningPersonImagePath, false, 140)
    print("spawn    drowner")
    self.sprite:setZIndex(-10)
    self.expirationTime = 20
    self.timer = 0
    self.targetX = math.random(-80, 80)
    self.targetY = math.random(-80, 80)
end

function drowner:update()
    self.timer = self.timer + deltaTime
    local dx = lerp(self.x, self.targetX, 0.01)
    local dy = lerp(self.y, self.targetY, 0.01)
    self:move(dx, dy)
end

function drowner:isExpired()
    return self.timer >= self.expirationTime
end