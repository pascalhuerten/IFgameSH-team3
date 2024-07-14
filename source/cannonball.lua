class("cannonball").extends("object")


function cannonball:init(x, y, width, height, moveSpeed, direction, imagePath, enableRotation, team)
    self.moveSpeed = moveSpeed
    cannonball.super.init(self, x, y, width, height, direction, config.cannonBallImagePath, enableRotation)
    self.active = false
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
    self.sprite:add()
    self.x = x
    self.y = y
    self.dirX, self.dirY = convertDegreesToXY(direction)
    self.dx = dx;
    self.dy = dy;
    soundController:playCannonShot()
end

function cannonball:draw()
    if(self.active) then
        cannonball.super.draw(self)
    end
end

function cannonball:collide(object)
    if(object.activeCollision and self.team ~= object.team and collides(self, object)) then
        self:registerCollision()
        object:registerCollision()
    end
    -- animation?
end

function cannonball:registerCollision()
    self.active = false
    self.sprite:remove()
    soundController:playCannonHit()
end