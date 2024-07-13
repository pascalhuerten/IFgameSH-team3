class("camera").extends()

function camera:init()
    self.x = 0
    self.y = 0
end

-- Modified camera update function to use lerp
function camera:update(x, y)
    local targetX = x - playdate.display.getWidth() / 2
    local targetY = y - playdate.display.getHeight() / 2

    -- Apply lerp to smoothly transition the camera position
    -- 't' is the interpolation factor. Adjust it between 0 and 1 to control the smoothing
    -- A smaller 't' value will make the camera lag more, a value closer to 1 will make it more responsive
    self.x = lerp(self.x, targetX, 0.1) -- Adjust 't' as needed
    self.y = lerp(self.y, targetY, 0.1) -- Adjust 't' as needed
end