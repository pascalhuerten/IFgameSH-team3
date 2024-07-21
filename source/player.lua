import "ship"
import "camera"
import "collision"
import "config"

class("player").extends()

function player:init()
    self.myInputHandlers = {
        cranked = function (_, acceleratedChange)
            self.ship:setRotationSpeed(acceleratedChange);
        end;
        AButtonDown = function()
            self.ship:shootRight()
        end;
        BButtonDown = function ()
            self.ship:shootLeft()
        end;
        upButtonDown = function()
            self.ship:crewToSail()
        end;
        downButtonDown = function()
            self.ship:crewToCannons()
        end;
    };
    self.ship = playerShip(0, 0, 0, 74, 74, config.playerShipImagePath, 0, 20, 1000, 5)
    playdate.inputHandlers.push(self.myInputHandlers)
end