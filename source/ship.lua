import "object"
import "cannonball"

class("ship").extends("object")

function ship:init(params)
    print(params)
    ship.super.init(self,params)
    self.desiredSpeed = params.moveSpeed;
    self.moveSpeed = 0;
    self.rotationSpeed = 0;
    self.desiredRotationSpeed = 0;
    self.canMove = false;
    self.cannonball = cannonball(params)
end

function ship:update()
    self.rotationSpeed = lerp(self.rotationSpeed,self.desiredRotationSpeed, 0.01)
    self:rotate(self.desiredRotationSpeed)
    self.rotationSpeed = lerp(self.rotationSpeed,self.rotationSpeed/2,0.01);
    if(not self.canMove)then
        self.moveSpeed = lerp(self.moveSpeed, 0, 0.01)
        self:move(self.moveSpeed)
    else
        self.moveSpeed = lerp(self.moveSpeed, self.desiredSpeed, 0.01)
        self:move(self.moveSpeed)
    end
    self.cannonball:update() -- remove to main.lua
end

function ship:move(ms)
    self.super:move(ms);
end

function ship:shoot(x,y)
    self.cannonball:shoot(x,y)
end

function ship:setRotationSpeed(value)
    self.desiredRotationSpeed = value
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