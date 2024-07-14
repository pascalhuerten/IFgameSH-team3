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
    self.ship = ship(200, 200, 74, 74, 0, config.playerShipImagePath, true, 50, 0, 5)
    playdate.inputHandlers.push(self.myInputHandlers)
end

function player:draw()
    self.ship:draw()
end