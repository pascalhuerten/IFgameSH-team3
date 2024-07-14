class("cannonball").extends("object")

function cannonball:init(params)
    params.imagePath = "Resource/cannonball.png";
    cannonball.super.init(self,params)
    self.speed = params.speed
    self.direction = direction
    self.active = false
end

function cannonball:update()
    if(self.active)then
        local ms = self.moveSpeed
        self:move(ms)
    end
end

function cannonball:shoot(x,y)
    self.active = true
    self.x = x
    self.y = y
end

function cannonball:draw()
    if(self.active) then
        self.super:draw()
    end
end