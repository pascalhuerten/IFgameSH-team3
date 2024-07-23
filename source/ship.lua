import "object"
import "cannonball"

class("ship").extends("object")

function ship:init(x, y, direction, width, height, imagePath, team, damageOutput, health, totalCrew, maxSpeed, maxRotationSpeed)
    ship.super.init(self, x, y, nil, nil, direction, width, height, imagePath, true, nil, team, damageOutput, health, true, {{-22, 0, 16}, {-4, 0, 16}, {14, 0, 10}})
    self.maxSpeed = maxSpeed or 70
    self.rotationSpeed = 0
    self.maxRotationSpeed = maxRotationSpeed or 100
    self.cannonballSpeed = 120
    self.totalCrew = totalCrew
    self.crewAtCannons = self.totalCrew;
    self.crewAtSail = 0;
    self.cannonsLeft, self.cannonsRight = self:buildCannons()
    self.drowners = {}
    self.immunityTimer = playdate.timer.new(2000)
    self.immunityTimer.discardOnCompletion = false
    self.immunityTimer.value = 2000
end

function ship:buildCannons()
    -- For self.totalCrew create cannons for each side at -90 and 90 degrees
    local cannonsRight = {}
    local cannonsLeft = {}

    for i = 1, self.totalCrew do
        local columnLength = self.width * 0.6
        local columnOffset = (columnLength / self.totalCrew) * (i - 1)
        local columnStart = (columnLength / 2) * -1
        local rowLength = 20
        local rowStart = (rowLength / 2) * -1

        table.insert(cannonsRight, Cannon(columnOffset, columnStart, rowLength, rowStart, 90, self.team))
        table.insert(cannonsLeft, Cannon(columnOffset, columnStart, 0, rowStart, -90, self.team))
    end

    return cannonsLeft, cannonsRight

end

function ship:update()
    if(self.totalCrew <= 0) then
        self:destroy()
    end

    self:rotate(self.rotationSpeed)
    local dirX, dirY = convertDegreesToXY(self.direction)
    local speed = self.maxSpeed * self:getCrewAtSailFactor()
    -- TODO: Get previous direction by normalizing the dx, ty vector
    -- TODO: Calculate in previous movement vector, to get accelerated change
    local waterResistance = 0.7
    local oldVec = playdate.geometry.vector2D.new(self.dx, self.dy)
    self.dy = speed * dirY
    self.dx = speed * dirX
    local vec = playdate.geometry.vector2D.new(self.dx, self.dy)
    if (vec:magnitude() > self.maxSpeed) then
        vec:normalize()
        vec:scale(self.maxSpeed)
    end

    vec = oldVec:scaledBy(1 - waterResistance) + vec:scaledBy(waterResistance)

    self.dx, self.dy = vec:unpack()

    ship.super.update(self)

    self.rotationSpeed  = self.rotationSpeed * 0.99
    if self.rotationSpeed < 0.001 and self.rotationSpeed > -0.001 then
        self.rotationSpeed = 0
    end
end

function ship:setRotationSpeed(rotationForce)
    self.rotationSpeed += rotationForce / 2
    self.rotationSpeed = clamp(self.rotationSpeed, -self.maxRotationSpeed, self.maxRotationSpeed)
end

function ship:shootRight()
    self:shoot(true)
end

function ship:shootLeft()
    self:shoot(false)
end

function ship:shoot(toRight)
    if(self:getCrewAtCannonsFactor() == 0) then
        return
    end

    local cannons = toRight and self.cannonsRight or self.cannonsLeft

    -- Iterate through the cannons and check wich one is ready to shoot. Only look at the firs few cannons equal to the amount of self.crewAtCannons
    for i = 1, self.crewAtCannons do
        local cannon = cannons[i]
        if cannon:isReadyToShoot() then
            cannon:shoot(self.x, self.y, self.dx, self.dy, self.direction)
            return
        end
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
        -- table.insert(self.drowners, drowner(self.x, self.y, self.direction))
    end
end

function ship:receiveDamage(_)
    -- As long as the immunity timer runs, no damage will be received.
    if self.immunityTimer.timeLeft > 0 then
        print("Ship immune")
        return
    end

    self:dropCrew()

    screenShake(500, 5)

    -- Restart immunity timer.
    self.immunityTimer:reset()
end