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
    self.cannonball = cannonball(x, y, 4, 4, 40, cannonballDirection, config.cannonBallImagePath, false)
end

function ship:update()
    print(self.moveSpeed)
    self.rotationSpeed = lerp(self.rotationSpeed, self.desiredRotationSpeed, 0.01)
    self:rotate(self.desiredRotationSpeed)
    self.rotationSpeed = lerp(self.rotationSpeed, self.rotationSpeed / 2, 0.01);
    if (not self.canMove) then
        self.moveSpeed = lerp(self.moveSpeed, 0, 0.01)
        self:move(self.moveSpeed)
    else
        self.moveSpeed = lerp(self.moveSpeed, self.desiredSpeed, 0.01)
        self:move(self.moveSpeed)
    end
    self.cannonball:update()
end

function ship:shoot()
    self.cannonball:shoot(self.x, self.y, self.direction + 90)
end

function ship:setRotationSpeed(value)
    self.desiredRotationSpeed = value
end

function ship:switchCanMove()
    self.canMove = not (self.canMove);
    if (self.canMove) then
        self.moveSpeed = self.maxSpeed;
    end
end

function ship:draw(cameraX, cameraY)
    ship.super.draw(self, cameraX, cameraY)
    self.cannonball:draw(cameraX, cameraY)
end
