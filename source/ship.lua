import "utils"

local dt<const> = 1/30;

class("ship").extends("object")

function ship:init(params)
    self.super:init(params)
    self.maxSpeed = params.moveSpeed;
    self.moveSpeed = 0;
    self.rotationSpeed = 0;
    self.canMove = false;
end

function ship:update()
    self:rotate(self.rotationSpeed)
    self.rotationSpeed = lerp(self.rotationSpeed,self.rotationSpeed/2,0.01);
    if(not self.canMove)then
        self.moveSpeed = lerp(self.moveSpeed, self.moveSpeed/2, 0.01)
        self:move(self.moveSpeed)
        return 
    else
        self:move(self.moveSpeed)
    end
end

function ship:move(ms)
    self.super:move(ms);
end

function ship:setRotationSpeed(value)
    if(self.canMove) then
        self.rotationSpeed = value
    end
end

function ship:switchCanMove()
    self.canMove = not (self.canMove);
    if(self.canMove) then 
        self.moveSpeed = self.maxSpeed;
    end
end

function ship:rotate(rs)
    self.super:rotate(rs);
end

function ship:draw(cameraX, cameraY)
    self.super:draw(cameraX, cameraY)
end