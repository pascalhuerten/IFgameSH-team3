import "CoreLibs/graphics"
import "CoreLibs/object"

local gfx <const> = playdate.graphics

class("hudElement").extends()

function hudElement:init(x, y, key, iconPath)
    self.x = x
    self.y = y
    self.text = ""
    self.key = key
    self.icon = gfx.image.new(iconPath)
end

function hudElement:update(values)
    -- Check if values has key and update text
    if self.key == nil then
        return
    end

    if values[self.key] then
        self.text = values[self.key]
    end
end

function hudElement:draw()
	self.icon:draw(self.x, self.y)
    if self.text ~= "" then
        local text = "*" .. self.text .. "*"
        gfx.drawText(text, self.x + 25, self.y + 2)
    end
end