import "object"
import "cannonball"

class("ship").extends("object")

function ship:init(x, y, width, height, moveSpeed, direction, imagePath, enableRotation, maxSpeed, team)
    -- self.super = object(x, y, width, height, direction, imagePath, enableRotation)
    ship.super.init(self, x, y, width, height, direction, imagePath, enableRotation)
    self.desiredSpeed = 0;
    self.moveSpeed = 0;
    self.maxSpeed = maxSpeed;
    self.rotationSpeed = 0;
    self.desiredRotationSpeed = 0;
    self.canMove = false;
    local cannonballDirection = 0
    self.team = team;
    self.cannonball = cannonball(x, y, 4, 4, 60, cannonballDirection, config.cannonBallImagePath, false, self.team)
    self.dx = 0;
    self.dy = 0;
    self.activeCollision = true
    self.hp = 100;
    self.dyingCallback = function () end
end

function ship:update()
    self:rotate(self.rotationSpeed)
    local t = 0.25;
    if(math.abs(self.rotationSpeed)  >= math.abs(self.desiredRotationSpeed)) then
        t = 0.01
    end
    self.rotationSpeed = lerp(self.rotationSpeed, self.desiredRotationSpeed, t);
    local dirX,dirY = convertDegreesToXY(self.direction)

    self.moveSpeed = lerp(self.moveSpeed, self.desiredSpeed, 0.01)
    self.dx = self.moveSpeed * dirX * deltaTime;
    self.dy = self.moveSpeed * dirY * deltaTime;
    self:move(self.dx,self.dy)
end
function ship:shoot()
    self.cannonball:shoot(self.x + self.width/2, self.y + self.height/2, self.direction + 90, self.dx, self.dy)
end

function ship:setRotationSpeed(value)
    if(self.canMove) then
        self.desiredRotationSpeed = value
    else
        self.desiredRotationSpeed = lerp(0, value, self.moveSpeed/self.maxSpeed)
    end
end

function ship:switchCanMove()
    self.canMove = not (self.canMove);
    if (self.canMove) then
        self.desiredSpeed = self.maxSpeed;
    else
        self.desiredSpeed = 0;
    end
end

function ship:draw(cameraX, cameraY)
    ship.super.draw(self, cameraX, cameraY)
end

function ship:collide(object)
    if(object == self.cannonball) then return end
    if(self.activeCollision and object.activeCollision and self.team ~= object.team and collides(self, object)) then
        self:damage()
        object:registerCollision()
        --self.activeCollision = false;
    end
end

function ship:registerCollision()
    self:damage()
    --self.activeCollision = false;
end

function ship:damage()
    print("damage")
end