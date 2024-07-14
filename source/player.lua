import "ship"
import "camera"
import "collision"

class("player").extends()
import "config"

local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

function player:init()
    self.myInputHandlers = {
        cranked = function (change, acceleratedChange)
            local min = math.min(acceleratedChange, 60)
            self.ship:setRotationSpeed(min * 3);
        end;
        AButtonDown = function()
            self.ship:switchCanMove();
        end;
        BButtonDown = function ()
            self.ship:shoot()
        end
    };
    
    self.ship = ship(200, 200, 74, 40, 40, 0, config.playerShipImagePath, true, 50, 0)
    playdate.inputHandlers.push(self.myInputHandlers)
    self.camera = camera(self.ship.x, self.ship.y)
end

function player:update()
    self.camera:update(self.ship.x, self.ship.y)
end

function player:draw()
    -- Draw the waves relative to the camera position
    self.ship:draw(self.camera.x, self.camera.y)
end