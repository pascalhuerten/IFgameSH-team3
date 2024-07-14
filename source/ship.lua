import "object"
import "cannonball"

class("ship").extends("object")

function ship:init(x, y, width, height, moveSpeed, direction, imagePath, enableRotation, maxSpeed)
    -- self.super = object(x, y, width, height, direction, imagePath, enableRotation)
    ship.super.init(self, x, y, width, height, direction, imagePath, enableRotation)
    self.desiredSpeed = moveSpeed;
    self.moveSpeed = 0;
    self.maxSpeed = maxSpeed;
    self.rotationSpeed = 0;
    self.desiredRotationSpeed = 0;
    self.canMove = false;
    local cannonballDirection = 0
    self.cannonball = cannonball(x, y, 4, 4, 60, cannonballDirection, config.cannonBallImagePath, false)
    self.dx =0;
    self.dy = 0;
end

function ship:update()
    self:rotate(self.rotationSpeed)
    self.rotationSpeed = lerp(self.rotationSpeed, self.desiredRotationSpeed, 0.01);
    local dirX,dirY = convertDegreesToXY(self.direction)
    self.dx = self.moveSpeed * dirX * 1/30;
    self.dy = self.moveSpeed * dirY * 1/30;
    if (not self.canMove) then
        self.moveSpeed = lerp(self.moveSpeed, self.desiredSpeed, 0.01)
        self:move(self.dx,self.dy)
    end
    self.cannonball:update()
end
function ship:shoot()
    self.cannonball:shoot(self.x, self.y, self.direction + 90, self.dx, self.dy)
end

function ship:setRotationSpeed(value)
    if(self.moveSpeed > 0) then
        self.desiredRotationSpeed = lerp(self.rotationSpeed, value, self.moveSpeed/self.maxSpeed)
    else
        self.desiredRotationSpeed = value
    end
end

function ship:switchCanMove()
    self.canMove = not (self.canMove);
    if (self.canMove) then
        self.desiredSpeed = self.maxSpeed;
    end
end

function ship:draw(cameraX, cameraY)
    ship.super.draw(self, cameraX, cameraY)
    self.cannonball:draw(cameraX, cameraY)
end

function ship:collide()

end