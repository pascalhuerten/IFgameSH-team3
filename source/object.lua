local gfx <const> = playdate.graphics

class("object").extends()

function object:init(params)
    self.x = params.x;
    self.y = params.y;
    self.direction = params.direction;
    local image = gfx.image.new(params.imagePath)
    if image == nil then
        error("no image found")
    end
    sprite = gfx.sprite.new(image)
    if sprite == nil then
        error("no image found")
    end
    sprite:setSize(params.width,params.height)
    sprite:moveTo(self.x, self.y)
    sprite:add()
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
    sprite:moveTo(self.x - cameraX,self.y - cameraY);
    --gfx.drawRotated(self.x - cameraX, self.y - cameraY,image, etc);
end