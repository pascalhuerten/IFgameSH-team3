class("arrow").extends()

function arrow:init(enemyShip, playerShip, kraken)
    self.targetShip = enemyShip
    self.targetKraken = kraken
    self.pivot = playerShip
    local image = loadImage(config.arrowPath)
    self.imageTable = makeRotationImageTable(image, 72)
    self.sprite = createSpriteFromImage(self.imageTable:getImage(1))
    self.sprite:setCenter(0,0)
    self.direction = 360
    self.sprite:moveTo(screenWidth - 50, screenHeight - 50)
end

function arrow:update()
    local target = self.targetShip
    if(not target.active) then
        target = self.targetKraken
    end
    local dirX = target.x - self.pivot.x
    local dirY = target.y - self.pivot.y
    local distance = math.sqrt((dirX) * (dirX) + (dirY) *  (dirY));
    local dx = dirX/distance
    local dy = dirY/distance
    self.direction = xyToDegrees(dx, dy)

    --local drawX = self.target.x - cameraX
    --local drawY = self.target.y - cameraY
    --if((drawX >= 0 and drawX < screenWidth - 50) or (drawY >= 0 and drawY < screenHeight - 50)) then return end
    --if(drawX >= screenWidth - 50) then drawX = screenWidth - 50 elseif (drawX < 0) then drawX = 0 end
    --if(drawY >= screenHeight - 50) then drawY = screenHeight - 50 elseif (drawY < 0) then drawY = 0 end
    
end

function arrow:draw()
    local segments = self.imageTable:getLength() - 1 -- Assuming the last image is for 360 degrees, which is the same as 0 degrees
    local frameIndex = math.floor(((self.direction % 360) / 360) * segments) + 1
    self.sprite:setImage(self.imageTable:getImage(frameIndex))
end