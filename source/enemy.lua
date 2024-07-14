class("enemy").extends()

function enemy:init(player)
    self.ship = ship(0, 0, 74, 40, 40, 0, config.playerShipImagePath, true, 50, 1)
    self.target = player
end

function enemy:update()
    local distance = (self.ship.x - self.target.x) + (self.ship.y + self.target.y);
    local directionX = self.ship.x - self.target.x
    local directionY = self.ship.x - self.target.y
    local direction = xyToDegrees(directionX, directionY)
end

function enemy:draw()
end