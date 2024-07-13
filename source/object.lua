local gfx <const> = playdate.graphics

class("object").extends()

function object:init(params)
    self.x = params.x;
    self.y = params.y;
    self.direction = params.direction;
    image = gfx.image.new(params.imagePath)
    print(params.imagePath)
    if image == nil then
        error("no image found")
    end
    self.sprite = gfx.sprite.new(image)
    if self.sprite == nil then
        error("no image found")
    end
    self.sprite:setSize(params.width,params.height)
    self.sprite:moveTo(self.x, self.y)
    self.sprite:add()
    self.sprite:setRotation(self.direction)
end

function object:move(moveSpeed)
    local dirX,dirY = convertDegreesToXY(self.direction)
    local dx = moveSpeed * dirX * 1/30;
    local dy = moveSpeed * dirY * 1/30;
    self.x += dx;
    self.y += dy;
    print(self.x, self.y)
end
function object:rotate(rotationSpeed)
    self.direction += rotationSpeed * 1/30;
    if(self.direction >= 360) then
        self.direction = math.fmod(self.direction, 360)
    end
end

function object:draw(cameraX,cameraY)
    print(self.x, self.y)
    self.sprite:moveTo(self.x - cameraX,self.y - cameraY);
    self.sprite:setRotation(self.direction)
    --gfx.drawRotated(self.x - cameraX, self.y - cameraY,image, etc);
end