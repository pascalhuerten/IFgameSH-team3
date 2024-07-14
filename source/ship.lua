import "object"
import "cannonball"

class("ship").extends("object")

function ship:init(x, y, width, height, direction, imagePath, enableRotation, maxSpeed)
    ship.super.init(self, x, y, width, height, direction, imagePath, enableRotation)
    self.moveSpeed = 0;
    self.desiredSpeed = 0;
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
    self.totalCrew = 5
    self.crewAtCannons = self.totalCrew // 2
    self.crewAtSail = self.totalCrew - self.crewAtCannons
    self.dyingCallback = function () end
end

function ship:update()
    if (self.canMove) then
        self.desiredSpeed = self.maxSpeed * self:getCrewAtSailFactor();
    else
        self.desiredSpeed = 0;
    end
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

function ship:damage()
    self.dropCrew()
end

function ship:getCrewAtSailFactor()
    return self.crewAtSail / self.totalCrew
end

function ship:getCrewAtCannonsFactor()
    return self.crewAtCannons / self.totalCrew
end

function ship:crewToSail()
    if self.crewAtCannons > 0 then
        self.crewAtSail = self.crewAtSail + 1
        self.crewAtCannons = self.crewAtCannons - 1
    end
end

function ship:crewToCannons()
    if self.crewAtSail > 0 then
        self.crewAtCannons = self.crewAtCannons + 1
        self.crewAtSail = self.crewAtSail - 1
    end
end

function ship:pickupCrew()
    self.totalCrew = self.totalCrew + 1
    -- Add crew to place where there is less crew
    if self.crewAtSail < self.crewAtCannons then
        self.crewAtSail = self.crewAtSail + 1
    else
        self.crewAtCannons = self.crewAtCannons + 1
    end
end

function ship:dropCrew()
    self.totalCrew = self.totalCrew - 1
    
    if(self.totalCrew <= 0) then
        self.dyingCallback()
    else
    -- Remove crew from random place
        if math.random(0, 1) == 0 then
            self.crewAtSail = self.crewAtSail - 1
        else
            self.crewAtCannons = self.crewAtCannons - 1
        end
    end
end
