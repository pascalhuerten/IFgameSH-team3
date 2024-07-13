class("player").extends()

local dt <const> = playdate.getElapsedTime()

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
        imagePath = "Resource/Schiffchen.png";
        width = 96;
        height = 40;
        moveSpeed = 25;
    }
    self.ship = ship(shipParams)
    playdate.inputHandlers.push(self.myInputHandlers)
    --self.camera = camera()
end

function player:update()
    self.ship:update()
    --self.camera:update(self.ship.x, self.ship.y)
end

function player:draw()
    self.ship:draw(0, 0)
end