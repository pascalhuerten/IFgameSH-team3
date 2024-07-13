class("player").extends()
import "config"

local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

function player:init()
    self.myInputHandlers = {
        cranked = function (change, acceleratedChange)
            self.ship:setRotationSpeed(acceleratedChange * 2);
        end;
        AButtonDown = function()
            self.ship:switchCanMove();
        end
    };
    local shipParams = {
        x = 200;
        y = 200;
        direction = 0;
        imagePath = config.playerShipImagePath;
        width = 96;
        height = 40;
        moveSpeed = 40;
    }
    self.ship = ship(shipParams)
    playdate.inputHandlers.push(self.myInputHandlers)
    self.camera = camera(self.ship.x, self.ship.y)
end

function player:update()
    self.ship:update()
    self.camera:update(self.ship.x, self.ship.y)
end

function player:draw()
    -- Draw the waves relative to the camera position
    self.ship:draw(self.camera.x, self.camera.y)
end