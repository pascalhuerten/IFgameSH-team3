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
        local ms = self.moveSpeed
        self:move(ms)
    end
end

function cannonball:shoot(x,y, direction)
    self.active = true
    self.x = x
    self.y = y
    self.direction = direction
end

function cannonball:draw(cameraX, cameraY)
    if(self.active) then
        cannonball.super.draw(self, cameraX, cameraY)
    end
end