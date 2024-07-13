class("player").extends()

function player:init()
    local shipParams = {
        x = 200;
        y = 200;
        rotation = 0;
        imagePath = "Resource/Schiffchen.png";
        width = 96;
        height = 40;
        moveSpeed = 25;
    }
    self.ship = ship(shipParams)
    self.camera = camera()
end

function player:update(params)
    self.ship:update(params)
    self.camera:update(self.ship.x, self.ship.y)
end

function player:draw()
    self.ship:draw(self.camera.x, self.camera.y)
end