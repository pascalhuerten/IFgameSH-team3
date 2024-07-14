import "CoreLibs/graphics"
import "CoreLibs/sprites"

class("sea").extends()

local gfx <const> = playdate.graphics

function sea:init()
    self.waves = {}
    self.waveImageTable = playdate.graphics.imagetable.new(config.waveImagePath) -- Load the GIF once
    local screenWidth, screenHeight = playdate.display.getSize()
    local spacing = 50
    -- Correctly calculate the number of columns and rows based on screen dimensions
    local cols = math.ceil(screenWidth / spacing) -- Number of columns in the grid
    local rows = math.ceil(screenHeight / spacing) -- Number of rows in the grid
    local noiseScale = 0.5 -- Adjust for more or less frequent waves
    local repeatPattern = 0 -- No repeat
    local octaves = 2 -- Number of octaves of noise
    local persistence = 0.7 -- Influence of each successive octave

    for row = 1, rows do
        for col = 1, cols do
            -- Generate Perlin noise value for current position
            local noiseValue = playdate.graphics.perlin(col * noiseScale, row * noiseScale, 0, repeatPattern, octaves, persistence)
            -- Use noise value to decide if a wave should be placed
            if noiseValue > 0.5 then -- Threshold to decide if a wave should be placed
                local waveSprite = playdate.graphics.sprite.new()
                waveSprite:setSize(8, 4)
                -- Correctly calculate position based on row and column with spacing
                -- Offset every second row by 50 pixels to the right
                local xOffset = ((row % 2) == 0) and 25 or 0
                local yOffset = ((col % 2) == 0) and 25 or 0
                local x = (col - 1) * spacing + 20 -- Adjust starting position as needed and add xOffset
                local y = (row - 1) * spacing + 20 + yOffset -- Adjust starting position as needed
                waveSprite.originalX = x
                waveSprite.originalY = y
                waveSprite:moveTo(x, y)
                waveSprite:add()
                waveSprite.frameCount = self.waveImageTable:getLength()
                waveSprite.frame = (1 + row + col) % waveSprite.frameCount + 1-- Start each wave at a different frame
                waveSprite:setImage(self.waveImageTable:getImage(waveSprite.frame))
                waveSprite.timer = 0
                table.insert(self.waves, waveSprite)
            end
        end
    end
end

function sea:update()
    local frameDuration = 140 -- 140ms per frame
    local screenWidth, screenHeight = playdate.display.getSize()
    for _, waveSprite in ipairs(self.waves) do
        local drawX = waveSprite.originalX - cameraX
        local drawY = waveSprite.originalY - cameraY

        -- Loop wave on the y-axis
        if drawY < 0 then
            waveSprite.originalY = waveSprite.originalY + screenHeight
        elseif drawY > screenHeight then
            waveSprite.originalY = waveSprite.originalY - screenHeight
        end

        -- Loop wave on the x-axis
        if drawX < 0 then
            waveSprite.originalX = waveSprite.originalX + screenWidth
        elseif drawX > screenWidth then
            waveSprite.originalX = waveSprite.originalX - screenWidth
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