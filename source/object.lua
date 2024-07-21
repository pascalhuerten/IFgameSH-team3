local gfx <const> = playdate.graphics

class("object").extends()

function object:init(x, y, width, height, direction, imagePath, enableRotation, animationSpeed)
    self.x = x
    self.y = y
    self.direction = direction
    self.animationSpeed = animationSpeed or 0
    self.animationTimer = 0
    self.currentFrame = 1
    self.frameCount = 1
    self.enableRotation = enableRotation
    self.width = width
    self.height = height
    registerObject(self)
    self.active = true
    self.onDestroyCallback = function ()
        
    end
    if isGif(imagePath) then
        self.imageTable = gfx.imagetable.new(imagePath)
        self.sprite = createSpriteFromImage(self.imageTable:getImage(self.currentFrame))
        self.frameCount = self.imageTable:getLength()
        return
    end

    local image = loadImage(imagePath)

    if self.enableRotation then
        self.imageTable = makeRotationImageTable(image, 72)
        self.sprite = createSpriteFromImage(self.imageTable:getImage(1))
    else
        self.sprite = createSpriteFromImage(image)
    end
    self.sprite:setCenter(0,0)
end

function object:move(dx,dy)
    self.x += dx;
    self.y += dy;
end

function object:rotate(rotationSpeed)
    self.direction += rotationSpeed * deltaTime;
    if(self.direction >= 360) then
        self.direction = math.fmod(self.direction, 360)
    end
end

function object:draw()
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
    destroyObject(self)
    self.active = false
end