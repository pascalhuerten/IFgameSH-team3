class("player").extends()

local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

function player:init()
    local shipParams = {
        x = 200;
        y = 200;
        rotation = 0;
        imagePath = "Resource/Schiffchen.png";
        width = 96;
        height = 40;
        moveSpeed = 40;
    }
    self.ship = ship(shipParams)
    self.camera = camera(self.ship.x, self.ship.y)
end

function player:update(params)
    self.ship:update(params)
    self.camera:update(self.ship.x, self.ship.y)
end

function player:draw()
    -- Draw the waves relative to the camera position
    self.ship:draw(self.camera.x, self.camera.y)
end