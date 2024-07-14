class("cannonball").extends("object")


function cannonball:init(x, y, width, height, moveSpeed, direction, imagePath, enableRotation)
    print(config.cannonBallImagePath)
    self.moveSpeed = moveSpeed
    -- self.super = object(x, y, width, height, direction, config.cannonBallImagePath, enableRotation)
    cannonball.super.init(self, x, y, width, height, direction, config.cannonBallImagePath, enableRotation)
    self.active = false
end

function cannonball:update()
    if(self.active)then
        local _dx = self.moveSpeed * self.dirX * 1/30 + self.dx;
        local _dy = self.moveSpeed * self.dirY * 1/30 + self.dy;
        self:move(_dx, _dy)
    end
end

function cannonball:shoot(x,y,direction, dx,dy)
    self.active = true
    self.x = x
    self.y = y
    self.dirX, self.dirY = convertDegreesToXY(direction)
    self.dx = dx;
    self.dy = dy;
end

function cannonball:draw(cameraX, cameraY)
    if(self.active) then
        cannonball.super.draw(self, cameraX, cameraY)
    end
end