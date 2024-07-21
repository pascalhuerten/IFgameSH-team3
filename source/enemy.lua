class("enemy").extends()

local distanceToStop = 150

function enemy:init(playerShip)
    self.ship = ship(math.random(-1000, 1000), math.random(-1000, 1000), 74, 40, 40, config.enemyShipImagePath, true, 50, 1, 5)
    self.target = playerShip
    self.waitForAction = 0.5
    self.time = 0
    self.directionToTarget = 0
    self.deltaRotation = 0
end

function enemy:update()
    if(not self.ship.active) then return end
    self.time += deltaTime
    if(self.time >= self.waitForAction) then
        self.time = 0;
    else
        return
    end
    local dirX = self.target.x - self.ship.x
    local dirY = self.target.y - self.ship.y
    local distance = math.sqrt((dirX) * (dirX) + (dirY) *  (dirY));
    local dx = dirX/distance
    local dy = dirY/distance
    self.directionToTarget = xyToDegrees(dx, dy)
    self.deltaRotation = self.directionToTarget - self.ship.direction
    self.deltaRotation = self.deltaRotation%360
    local rotAbsNormalized = math.abs(self.deltaRotation - 180)
    if(distance > distanceToStop * 2) then
        self.ship:setRotationSpeed(self.deltaRotation)
        while self.ship.crewAtSail < self.ship.totalCrew do
            self.ship:crewToSail()
        end
    else
        if(self.ship.crewAtSail < 1)then
            self.ship:crewToSail()
        elseif(self.ship.crewAtSail > 1) then
            self.ship:crewToCannons()
        end
        if(rotAbsNormalized < 70 or rotAbsNormalized > 110) then
            local d = 1
            if((self.deltaRotation - 180) * -1 < 0) then
                d = -1
            end
            self.ship:setRotationSpeed(45 * d)
        else
            self.ship:setRotationSpeed(0)
        end
    end
    if((250 < self.deltaRotation and self.deltaRotation < 290)
            or (-250 > self.deltaRotation and self.deltaRotation < -290)) then
        self.ship:shootLeft()
    elseif((70 < self.deltaRotation and self.deltaRotation < 110)
            or (-70 > self.deltaRotation and self.deltaRotation < -110)) then
        self.ship:shootRight()
    end
end