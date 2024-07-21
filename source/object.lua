local gfx <const> = playdate.graphics

class("object").extends()

function object:init(x, y, dx, dy, direction, width, height, imagePath, enableRotation, animationSpeed, team, damageOutput, health, active, collisionCircles)
    self.x = x or 0
    self.y = y or 0
    self.dx = dx or 0
    self.dy = dy or 0
    self.direction = direction or 0
    self.animationSpeed = animationSpeed or 0
    self.animationTimer = 0
    self.currentFrame = 1
    self.frameCount = 1
    self.enableRotation = enableRotation or false
    self.width = width or 10
    self.height = height or 10
    self.damageOutput = damageOutput or 0
    self.health = health or 1000
    self.team = team or 0
    self.active = active or true
    if collisionCircles ~= nil and #collisionCircles > 0 then
        self.activeCollision = true
        self.collisionCircles = collisionCircles
    else
        self.activeCollision = false
    end
    self.active = true
    self.onDestroyCallback = function () end
    GameObjectManager:registerObject(self)

    if isGif(imagePath) then
        self.imageTable = gfx.imagetable.new(imagePath)
        self.sprite = createSpriteFromImage(self.imageTable:getImage(self.currentFrame))
        self.frameCount = self.imageTable:getLength()
    else
        local image = loadImage(imagePath)

        if self.enableRotation then
            self.imageTable = makeRotationImageTable(image, 72)
            self.sprite = createSpriteFromImage(self.imageTable:getImage(1))
        else
            self.sprite = createSpriteFromImage(image)
        end
    end
end

function object:move()
    self.x += self.dx * deltaTime;
    self.y += self.dy * deltaTime;
end

function object:rotate(rotation)
    self.direction += rotation * deltaTime;
    self.direction = self.direction % 360
end

function object:update()
    self:move()
end

function object:draw()
    if(not self.active) then
        self.sprite:setVisible(false)
        return
    end

    -- Calculate the correct frame based on direction
    if self.enableRotation then
        local segments = self.imageTable:getLength() - 1 -- Assuming the last image is for 360 degrees, which is the same as 0 degrees
        local frameIndex = math.floor(((self.direction % 360) / 360) * segments) + 1
        self.sprite:setImage(self.imageTable:getImage(frameIndex))
    end

    if self.animationSpeed > 0 then
        self:animate()
    end
    
    local drawX = self.x - cameraX
    local drawY = self.y - cameraY

    self.sprite:moveTo(drawX, drawY)

    if isOnScreen(drawX, drawY, 200) then
        self.sprite:setVisible(true)
    else
        self.sprite:setVisible(false)
    end
end

function object:getOriginTopLeft()
    local x = self.x - (self.width / 2)
    local y = self.y - (self.height / 2)
    return x, y
end

function object:drawCollisionBorder()
    local drawX = self.x - cameraX
    local drawY = self.y - cameraY
    if not self.activeCollision then
        return
    end
    
    local rad = math.rad(self.direction) -- Convert direction to radians
    for i = 1, #self.collisionCircles do
        local circleParams = self.collisionCircles[i]
        -- Relative position vector
        local relX, relY = circleParams[1], circleParams[2]
        -- Rotate the relative position around (0,0)
        local rotatedX = relX * math.cos(rad) - relY * math.sin(rad)
        local rotatedY = relX * math.sin(rad) + relY * math.cos(rad)
        -- Add the object's position to get the absolute position
        local absX = drawX + rotatedX
        local absY = drawY + rotatedY
        -- Draw the circle at the absolute position
        local radius = circleParams[3]
        gfx.pushContext()
        gfx.setLineWidth(3) -- Original line width
        gfx.setColor(gfx.kColorWhite)
        gfx.drawCircleAtPoint(absX, absY, radius)
        gfx.setColor(gfx.kColorBlack)
        gfx.setLineWidth(1) -- Original line width
        gfx.drawCircleAtPoint(absX, absY, radius)
        gfx.popContext()
    end
end

function object:drawHealth()
    local drawX = self.x - cameraX - 15
    local drawY = self.y - cameraY - 40 -- Adjust Y to draw above the object
    gfx.pushContext()
    gfx.setColor(gfx.kColorBlack)
    gfx.drawText(tostring(self.health), drawX, drawY)
    gfx.popContext()
end

function object:animate()
    -- cycle through the imagetable at animationSpeed
    -- Update the animationTimer with the elapsed time
    self.animationTimer = self.animationTimer + (deltaTime * 1000) -- Ensure deltaTime is correctly accumulated

    -- Check if 140ms have passed
    if self.animationTimer >= self.animationSpeed then
        -- Update animation frame
        self.currentFrame = (self.currentFrame % self.frameCount) + 1
        self.sprite:setImage(self.imageTable:getImage(self.currentFrame))

        -- Reset the animationTimer, accounting for overflow
        self.animationTimer = self.animationTimer - self.animationSpeed -- Carry over any extra time beyond 140ms
    end
    
    self.sprite:markDirty()
end

function object:destroy()
    self.sprite:remove()
    self.active = false
    self.activeCollision = false
    GameObjectManager:destroyObject(self)
end

function object:onCollision(otherObject)
    -- Override this function in child classes
    if otherObject.team == self.team then
        print("Friendly fire")
        return
    end

    self:receiveDamage(otherObject.damageOutput)
end

function object:receiveDamage(damage)
    self.health -= damage or 0
end