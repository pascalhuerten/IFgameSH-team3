class("enemy").extends()

local distanceToStop = 160

function enemy:init(playerShip)
    self.ship = ship(200, 200, 74, 40, 40, config.enemyShipImagePath, true, 50, 1, 5)
    self.target = playerShip
    self.waitForAction = 0.5
    self.time = 0
end

function enemy:update()
    if(not self.ship.active) then return end
    self.time += deltaTime
    if(self.time >= self.waitForAction) then
        self.time = 0;
    else
        return
    end
    local distance = (self.target.x - self.ship.x) * (self.target.x - self.ship.x) + (self.target.y - self.ship.y) *  (self.target.y - self.ship.y);
    local directionX = self.ship.x - self.target.x
    local directionY = self.ship.x - self.target.y
    local direction = xyToDegrees(directionX, directionY)
    print(direction, distance)
    print()
    if(direction < 0) then
        if(-105 < direction) then
            self.ship:setRotationSpeed(45)
        elseif (direction > -75) then
            self.ship:setRotationSpeed(-45)
        else
            self.ship:crewToCannons()
            self.ship:shootLeft()
        end
    else
        if(75 < direction) then
            self.ship:setRotationSpeed(45)
        elseif (direction > 105) then
            self.ship:setRotationSpeed(-45)
        else 
            self.ship:crewToCannons()
            self.ship:shootRight()
        end
    end
    if(distance >= distanceToStop) then
        self.ship:crewToSail()
        return;
    elseif(distance <= distanceToStop/2) then
        self.ship:crewToCannons()
    end
end