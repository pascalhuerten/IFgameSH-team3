class("ship").extends("object")

function ship:init(params)
    self.super:init(params)
    self.moveSpeed = params.moveSpeed;
    self.direction = {x = 1; y = 1;}
end

function ship:update(params)
    params.dx = self.moveSpeed * params.deltaTime * self.direction.x;
    params.dy = self.moveSpeed * params.deltaTime * self.direction.y;
    self:moveTo(self.x, self.y)
end

function ship:moveTo(x,y)
    x = y + params.dx;
    y = y + params.dy;
    self.super:moveTo(x, y)
end

function ship:draw(cameraX, cameraY)
    self.super:draw(cameraX, cameraY)
end