local gfx <const> = playdate.graphics

function lerp(a, b, t)
    return a + (b - a) * t
end

function convertDegreesToXY(angleInDegrees)
    local radians = degreesToRadians(angleInDegrees)
    local x = math.cos(radians)
    local y = math.sin(radians)
    return x, y
end

function degreesToRadians(degrees)
    return degrees * (math.pi / 180)
end

function makeRotationImageTable(image, segments)
    local w, h = image:getSize()
    local max_wh = math.floor(math.sqrt(w * w + h * h)) + 1
    local image_table = gfx.imagetable.new(segments + 1, max_wh, max_wh)
    local image_index = 0
    for angle = 0 , 360, 360/segments do
        image_index += 1
        local rotated_image = gfx.image.new(max_wh, max_wh)
        gfx.lockFocus(rotated_image)
        image:drawRotated(max_wh/2, max_wh/2, angle)
        gfx.unlockFocus()
        image_table:setImage(image_index, rotated_image)
    end
    return image_table
end

function loadImage(imagePath)
    local image = gfx.image.new(imagePath)
    if not image then
        error("no image found")
    end
    return image
end

function isGif(imagePath)
    return imagePath:lower():match("%.gif$")
end

function createSpriteFromImage(image)
    local sprite = gfx.sprite.new(image)
    sprite:setSize(image:getSize())
    sprite:add()
    return sprite
end