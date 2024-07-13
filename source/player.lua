import "ship"
import "camera"

class("player").extends()

function player:init()
    self.myInputHandlers = {
        cranked = function (change, acceleratedChange)
            local min = math.min(acceleratedChange, MAX_TURN_SPEED)
            self.ship:setRotationSpeed(min * 2);
        end;
        AButtonDown = function()
            self.ship:switchCanMove();
        end
    };
    local shipParams = {
        x = 200;
        y = 200;
        direction = 0;
        imagePath = "Resource/ship.png";
        width = 96;
        height = 40;
        moveSpeed = 40;
    }
    print(shipParams.imagePath)
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