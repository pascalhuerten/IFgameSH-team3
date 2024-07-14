local gfx <const> = playdate.graphics

class("object").extends()

function object:init(x, y, width, height, direction, imagePath, enableRotation)
    self.x = x
    self.y = y
    self.direction = direction
    
    local image = gfx.image.new(imagePath)
    if image == nil then
        error("no image found")
    end
    
    -- Check if rotation is enabled and generate imagetable
    if enableRotation then
        self.imageTable = makeRotationImageTable(image, 72)
        image = self.imageTable:getImage(1)
        self.sprite = gfx.sprite.new(image)
    else
        self.sprite = gfx.sprite.new(image)
    end
    
    if self.sprite == nil then
        error("no image found")
    end
    self.sprite:setSize(image:getSize())
    self.sprite:add()
end

function object:move(moveSpeed)
    local dirX,dirY = convertDegreesToXY(self.direction)
    local dx = moveSpeed * dirX * 1/30;
    local dy = moveSpeed * dirY * 1/30;
    self.x += dx;
    self.y += dy;
end

function object:rotate(rotationSpeed)
    self.direction += rotationSpeed * 1/30;
    if(self.direction >= 360) then
        self.direction = math.fmod(self.direction, 360)
    end
end

function object:draw(cameraX, cameraY)
    -- Calculate the correct frame based on direction
    if self.imageTable then
        local segments = self.imageTable:getLength() - 1 -- Assuming the last image is for 360 degrees, which is the same as 0 degrees
        local frameIndex = math.floor(((self.direction % 360) / 360) * segments) + 1
        self.sprite:setImage(self.imageTable:getImage(frameIndex))
    end
    
    self.sprite:moveTo(self.x - cameraX, self.y - cameraY)
end