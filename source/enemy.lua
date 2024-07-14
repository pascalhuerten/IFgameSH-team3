class("enemy").extends()

local distanceToStop = 0

function enemy:init(player)
    self.ship = ship(player.x + 100, player.y + 100, 74, 40, 40, config.playerShipImagePath, true, 50, 1)
    self.target = player
end

function enemy:update()
    local distance = (self.target.x - self.ship.x) * (self.target.x - self.ship.x) + (self.target.y - self.ship.y) *  (self.target.y - self.ship.y);
    local directionX = self.ship.x - self.target.x
    local directionY = self.ship.x - self.target.y
    local direction = xyToDegrees(directionX, directionY)
    if(distance >= distanceToStop) then
        
    end
end

function enemy:draw()
end