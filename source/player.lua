import "ship"
import "camera"
import "collision"

class("player").extends()
import "config"

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
        end;
        upButtonDown = function()
            self.ship:crewToSail()
        end;
        downButtonDown = function()
            self.ship:crewToCannons()
        end;
    };
    self.ship = ship(200, 200, 74, 74, 0, config.playerShipImagePath, true, 50)
    playdate.inputHandlers.push(self.myInputHandlers)
end

function player:update()
    
end

function player:draw()
    self.ship:draw()
end