import "CoreLibs/graphics"
import "CoreLibs/object"
import "hudElement"

local gfx <const> = playdate.graphics

class("hud").extends()

function hud:init()
	self.hudElements = {}
	table.insert(self.hudElements, hudElement(5, 200, "sailCount", "Resource/sailIcon.png"))
	table.insert(self.hudElements, hudElement(5, 220, "cannonCount", "Resource/cannonIcon.png"))
	table.insert(self.hudElements, hudElement(35, 200, nil, "Resource/dPadVerticalIcon.png"))
end

function hud:update(values)
	for _, hudElement in ipairs(self.hudElements) do
		hudElement:update(values)
	end
end

function hud:draw()
	for _, hudElement in ipairs(self.hudElements) do
		hudElement:draw()
	end
end