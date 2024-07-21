class("Cannon").extends()

function Cannon:init(columnOffset, columnStart, rowOffset, rowStart, direction, team)
    self.columnOffset = columnOffset
    self.columnStart = columnStart
    self.rowOffset = rowOffset
    self.rowStart = rowStart
    self.direction = direction
    self.reloadTimer = playdate.timer.new(2000)
    self.reloadTimer.discardOnCompletion = false
    self.reloadTimer.value = 2000
    self.cannonballSpeed = 100
    self.team = team
end

function Cannon:isReadyToShoot()
    return not (self.reloadTimer.timeLeft > 0)
end

function Cannon:shoot(shipX, shipY, shipDX, shipDY, shipDirection)
    -- Calculate the move direction of the cannonball
    local direction = shipDirection + self.direction
    
    local rdx, rdy = convertDegreesToXY(direction)  -- Convert the adjusted direction to x, y components
    -- Adjust dx, dy based on the ship's current speed and the cannonball's speed
    local dx = rdx * self.cannonballSpeed + shipDX
    local dy = rdy * self.cannonballSpeed + shipDY

    -- Convert ship's direction to a unit vector for the offset calculation
    local cannonDirX, cannonDirY = convertDegreesToXY(shipDirection)
    local columnStartX = self.columnStart * cannonDirX
    local columnOffsetX = self.columnOffset * cannonDirX
    local columnStartY = self.columnStart * cannonDirY
    local columnOffsetY = self.columnOffset * cannonDirY
    
    local cannonDirX90, cannonDirY90 = convertDegreesToXY(shipDirection + math.abs(self.direction))
    local rowStartX = self.rowStart * cannonDirX90
    local rowOffsetX = self.rowOffset * cannonDirX90
    local rowStartY = self.rowStart * cannonDirY90
    local rowOffsetY = self.rowOffset * cannonDirY90
    
    local cannonX =  columnStartX + columnOffsetX + rowStartX + rowOffsetX + shipX
    local cannonY = columnStartY + columnOffsetY + rowStartY + rowOffsetY + shipY
    
    cannonball(cannonX, cannonY, dx, dy, self.team)
    self.reloadTimer:reset()
end