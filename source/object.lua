local gfx <const> = playdate.graphics

class("object").extends()

function object:init(params)
    self.x = params.x;
    self.y = params.y;
    self.rotation = params.rotation;
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

function object:moveTo(x,y)
    self.x = x;
    self.y = y;
end

function object:draw(cameraX,cameraY)
    print(self.x, self.y);
    sprite:moveTo(self.x - cameraX,self.y - cameraY);
    --gfx.drawRotated(self.x - cameraX, self.y - cameraY,image, etc);
end