import "object"
import "cannonball"

class("ship").extends("object")

function ship:init(x, y, width, height, direction, imagePath, enableRotation, maxSpeed, team, totalCrew)
    ship.super.init(self, x, y, width, height, direction, imagePath, enableRotation)
    self.moveSpeed = 0;
    self.desiredSpeed = 0;
    self.maxSpeed = maxSpeed;
    self.rotationSpeed = 0;
    self.desiredRotationSpeed = 0;
    self.team = team;
    self.cannonballright = cannonball(x, y, 4, 4, 60, 0, config.cannonBallImagePath, false, self.team)
    self.cannonballleft = cannonball(x, y, 4, 4, 60, 0, config.cannonBallImagePath, false, self.team)
    self.dx = 0;
    self.dy = 0;
    self.activeCollision = true
    self.totalCrew = totalCrew
    self.crewAtCannons = self.totalCrew;
    self.crewAtSail = 0;
    self.collideTimer = 0;
    self.collideTime = 2;
    self.shootTimerR = 0;
    self.shootTimerL = 0;
    self.canShootRight = true;
    self.canShootLeft = true;
    self.maxReloadTime = 3.0
end

function ship:getTimeToShoot()
    return 1 + self.maxReloadTime * (1 - self:getCrewAtCannonsFactor())
end

function ship:update()
    if(not self.activeCollision) then
        self.collideTimer += deltaTime;
        if(self.collideTimer >= self.collideTime) then
            self.collideTimer = 0;
            self.activeCollision = true
        end
    end
    if(not self.canShootRight) then
        self.shootTimerR += deltaTime;
        if(self.shootTimerR >= self:getTimeToShoot()) then
            self.shootTimerR = 0;
            self.canShootRight = true
        end
    end
    if(not self.canShootLeft) then
        self.shootTimerL += deltaTime;
        if(self.shootTimerL >= self:getTimeToShoot()) then
            self.shootTimerL = 0;
            self.canShootLeft = true
        end
    end
    self:rotate(self.rotationSpeed)
    local t = 0.25;
    --if(math.abs(self.rotationSpeed)  >= math.abs(self.desiredRotationSpeed)) then
    --    t = 0.01
    --end
    self.rotationSpeed = lerp(self.rotationSpeed, self.desiredRotationSpeed, t);
    local dirX,dirY = convertDegreesToXY(self.direction)

    self.moveSpeed = lerp(self.moveSpeed, self.desiredSpeed, 0.01)
    self.dx = self.moveSpeed * dirX * deltaTime;
    self.dy = self.moveSpeed * dirY * deltaTime;
    self:move(self.dx,self.dy)
end

function ship:shootRight()
    if(self.canShootRight)then
        if(self:getCrewAtCannonsFactor() == 0) then
            return
        end
        self.canShootRight = false
        self.cannonballright:shoot(self.x + self.width/2, self.y + self.height/2, self.direction + 90, self.dx, self.dy)
    end
end
function ship:shootLeft()
    if(self.canShootLeft)then
        if(self:getCrewAtCannonsFactor() == 0) then
            return
        end
        self.canShootLeft = false
        self.cannonballleft:shoot(self.x + self.width/2, self.y + self.height/2, self.direction - 90, self.dx, self.dy)
    end
end

function ship:setRotationSpeed(value)
    if(self:getCrewAtSailFactor() ~= 0) then
        self.desiredRotationSpeed = value
    else
        self.desiredRotationSpeed = lerp(0, value, self.moveSpeed/self.maxSpeed)
    end
end

function ship:draw()
    ship.super.draw(self)
    self.cannonballright:draw(cameraX,cameraY)
    self.cannonballright:draw(cameraX,cameraY)
end

function ship:collide(object)
    if(self.team == object.team) then return end
    if(self.activeCollision and collides(self, object)) then
        self:registerCollision()
        object:registerCollision()
    end
end

function ship:registerCollision()
    self:damage()
    self.activeCollision = false;
end
function ship:damage()
    screenShake(500, 5)
    self:dropCrew()
    if(self.totalCrew <= 0) then
        self:destroy()
        self.cannonballleft:destroy()
        self.cannonballright:destroy()
    end
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
        self.desiredSpeed = self.maxSpeed * self:getCrewAtSailFactor()
    end
end

function ship:crewToCannons()
    if self.crewAtSail > 0 then
        self.crewAtCannons = self.crewAtCannons + 1
        self.crewAtSail = self.crewAtSail - 1
        self.desiredSpeed = self.maxSpeed * self:getCrewAtSailFactor()
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
        -- Check if there is crew to remove
    if self.crewAtSail == 0 and self.crewAtCannons == 0 then
        return
    elseif self.crewAtSail == 0 then
        self.crewAtCannons = self.crewAtCannons - 1
    elseif self.crewAtCannons == 0 then
        self.crewAtSail = self.crewAtSail - 1
    else
-- Remove crew from random place
        if math.random(0, 1) == 0 then
            self.crewAtSail = self.crewAtSail - 1
        else
            self.crewAtCannons = self.crewAtCannons - 1
        end
    end
    if self.totalCrew > 0 then
        self.totalCrew = self.totalCrew - 1
    end
end