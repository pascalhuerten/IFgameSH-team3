import "CoreLibs/graphics"
import "CoreLibs/sprites"

class("sea").extends()

local gfx <const> = playdate.graphics

function sea:init()
    self.waves = {}
    self.waveImageTable = playdate.graphics.imagetable.new("Resource/wave.gif") -- Load the GIF once
    local screenWidth, screenHeight = playdate.display.getSize()
    local spacing = 70
    local rows = screenWidth / spacing -- Number of rows in the grid
    local cols = screenHeight / spacing -- Number of columns in the grid

    for row = 1, rows do
        for col = 1, cols do
            local waveSprite = playdate.graphics.sprite.new()
            waveSprite:setSize(8, 4)
            -- Calculate position based on row and column with spacing
            -- Offset every second row by 50 pixels to the right
            local xOffset = ((row % 2) == 0) and 25 or 0
            local x = (col - 1) * spacing + 20 + xOffset -- Adjust starting position as needed and add xOffset
            local y = (row - 1) * spacing + 20 -- Adjust starting position as needed
            waveSprite.originalX = x
            waveSprite.originalY = y
            waveSprite:moveTo(x, y)
            waveSprite:add()
            waveSprite:setImage(self.waveImageTable:getImage(1))
            waveSprite.frameCount = self.waveImageTable:getLength()
            waveSprite.frame = (1 + row + col + col) % waveSprite.frameCount -- Start each wave at a different frame
            waveSprite.timer = 0
            table.insert(self.waves, waveSprite)
        end
    end
end

function sea:update(cameraX, cameraY)
    local frameDuration = 140 -- 140ms per frame
    local screenWidth, screenHeight = playdate.display.getSize()
    for _, waveSprite in ipairs(self.waves) do
        local drawX = waveSprite.originalX - cameraX
        local drawY = waveSprite.originalY - cameraY

        -- Check if the wave is off-screen in the y direction
        if drawY < 0 then
            -- Move the wave to the bottom of the screen
            waveSprite.originalY = waveSprite.originalY + screenHeight
            drawY = waveSprite.originalY - cameraY
        elseif drawY > screenHeight then
            -- Move the wave to the top of the screen
            waveSprite.originalY = waveSprite.originalY - screenHeight
            drawY = waveSprite.originalY - cameraY
        end
        if drawX < 0 then
            -- Move the wave to the right of the screen
            waveSprite.originalX = waveSprite.originalX + screenWidth
            drawX = waveSprite.originalX - cameraX
        elseif drawX > screenWidth then
            -- Move the wave to the left of the screen
            waveSprite.originalX = waveSprite.originalX - screenWidth
            drawX = waveSprite.originalX - cameraX
        end

        waveSprite:moveTo(drawX, drawY)
        
        -- Update the timer with the elapsed time
        waveSprite.timer = waveSprite.timer + (deltaTime * 1000) -- Ensure deltaTime is correctly accumulated

        -- Check if 140ms have passed
        if waveSprite.timer >= frameDuration then
            -- Update animation frame
            waveSprite.frame = (waveSprite.frame % waveSprite.frameCount) + 1
            waveSprite:setImage(self.waveImageTable:getImage(waveSprite.frame))

            -- Reset the timer, accounting for overflow
            waveSprite.timer = waveSprite.timer - frameDuration -- Carry over any extra time beyond 140ms
        end
        
        waveSprite:markDirty()
    end
end