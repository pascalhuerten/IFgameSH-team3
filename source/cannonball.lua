class("cannonball").extends("object")


function cannonball:init(x, y, width, height, moveSpeed, direction, imagePath, enableRotation, team)
    self.moveSpeed = moveSpeed
    cannonball.super.init(self, x, y, width, height, direction, config.cannonBallImagePath, enableRotation)
    self.active = false
    self.activeCollision = true
    self.collisionDamage = 10;
    self.team = team;
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

function cannonball:draw()
    if(self.active) then
        cannonball.super.draw(self)
    end
end

function cannonball:collide(object)
    -- animation?
end