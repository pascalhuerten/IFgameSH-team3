class("ship").extends("object")

function ship:init(params)
    self.super:init(params)
    self.moveSpeed = params.moveSpeed;
    self.direction = {x = 1; y = 1;}
end

function ship:update(deltaTime)
    local dx = self.moveSpeed * deltaTime * self.direction.x;
    local dy = self.moveSpeed * deltaTime * self.direction.y;
    self:moveTo(self.x + dx, self.y + dy);
end

function ship:moveTo(x,y)
    self.super:moveTo(x, y)
end

function ship:draw(cameraX, cameraY)
    self.super:draw(cameraX, cameraY)
end