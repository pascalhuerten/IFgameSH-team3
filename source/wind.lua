import "CoreLibs/graphics"
import "CoreLibs/sprites"

class("wind").extends()

local gfx <const> = playdate.graphics

function wind:init(speed, direction)
    self.speed = speed
    self.direction = direction
    self.sprites = {}
    self.windImageTable = gfx.imagetable.new(config.windImagePath) -- Load the GIF once
    local screenWidth, screenHeight = playdate.display.getSize()
    
    -- create wind sprites
    for i = 1, 5 do
        local windSprite = gfx.sprite.new()
        windSprite:setSize(8, 4)
        windSprite.originalX = math.random(0, screenWidth)
        windSprite.originalY = math.random(0, screenHeight)
        windSprite:moveTo(windSprite.x, windSprite.y)
        windSprite:add()
        windSprite.frameCount = self.windImageTable:getLength()
        windSprite.frame = math.random(1, windSprite.frameCount)
        windSprite:setImage(self.windImageTable:getImage(windSprite.frame))
        windSprite.timer = 0
        table.insert(self.sprites, windSprite)
    end
end

function wind:update()
    local frameDuration = 200 -- 140ms per frame
    local screenWidth, screenHeight = playdate.display.getSize()
    for _, windSprite in ipairs(self.sprites) do
        -- Check if the animation cycle is complete
        if windSprite.frame >= windSprite.frameCount then
            -- Generate a new random position within the screen bounds
            local newPosX = math.random(0, screenWidth) + cameraX
            local newPosY = math.random(0, screenHeight) + cameraY

            -- Move the windSprite to the new position
            windSprite.originalX = newPosX
            windSprite.originalY = newPosY

            -- Optionally, reset the frame to 1 to restart the animation
            windSprite.frame = 1
        end

        -- Move the windSprite based on the wind speed and direction
        local dx = math.cos(self.direction) * self.speed * deltaTime
        local dy = math.sin(self.direction) * self.speed * deltaTime
        windSprite.originalX = windSprite.originalX + dx
        windSprite.originalY = windSprite.originalY + dy

        -- Move the windSprite relative to the camera
        local drawX = windSprite.originalX - cameraX
        local drawY = windSprite.originalY - cameraY
        windSprite:moveTo(drawX, drawY)
        
        -- Update the timer and frame animation
        windSprite.timer = windSprite.timer + (deltaTime * 1000) -- deltaTime in seconds to milliseconds
        if windSprite.timer >= frameDuration then
            windSprite.frame = windSprite.frame + 1
            windSprite:setImage(self.windImageTable:getImage(windSprite.frame))
            windSprite.timer = windSprite.timer - frameDuration
        end
        
        windSprite:markDirty()
    end
end