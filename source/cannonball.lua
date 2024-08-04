class("cannonball").extends("object")

function cannonball:init(x, y, dx, dy, team)
    cannonball.super.init(self, x, y, dx, dy, nil, 2, 2, config.cannonBallImagePath, nil, nil, team, 10, 1, true, {{0, 0, 4}})
    self.maxFlyTime = playdate.timer.new(2000, self.destroy, self)
    soundController:playCannonShot()
end

function cannonball:update()
    self.dx = self.dx
    self.dy = self.dy
    if not self.active then
        self:destroy()
        return
    end

    cannonball.super.update(self)
end

function cannonball:onCollisionEnter(otherObject)
    if otherObject.team == self.team then
        return
    end

    self:receiveDamage(otherObject.damageOutput)
end

function cannonball:receiveDamage(_)
    self:destroy()
    soundController:playCannonHit()
end