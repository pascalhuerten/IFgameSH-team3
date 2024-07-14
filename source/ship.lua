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
    self.team = 0;
    self.cannonball = cannonball(x, y, 4, 4, 60, cannonballDirection, config.cannonBallImagePath, false, self.team)
    self.dx =0;
    self.dy = 0;
    self.activeCollision = true
    self.hp = 100;
    self.dyingCallback = function ();
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
    self.cannonball:shoot(self.x, self.y, self.direction + 90, self.dx, self.dy)
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

function ship:draw()
    ship.super.draw(self)
    self.cannonball:draw()
end

function ship:collide(object)
    if(object == self.cannonball) then return end
    if(collides(self, object) and self.team ~= object.team and object.activeCollision) then
        self:damage(object.collisionDamage)
        self.activeCollision = false;
    end
end

function ship:damage(dmg)
    self.hp -= dmg;
    if(self.hp <= 0) then
        self.dyingCallback() end
    end
end