class("kraken").extends("object")

function kraken:init(x, y)
    kraken.super.init(self, x, y, 40, 40, 0, config.krakenImagePath, false, 140)
end

function kraken:update()
    -- Update tentacles.
end


function kraken:draw(cameraX, cameraY)
    kraken.super.draw(self, cameraX, cameraY)
    -- Draw tentacles.
    -- self.cannonball:draw(cameraX, cameraY)
end
