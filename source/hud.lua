import "CoreLibs/graphics"
import "CoreLibs/object"
import "hudElement"

local gfx <const> = playdate.graphics

class("hud").extends()

function hud:init()
	self.hudElements = {}
	table.insert(self.hudElements, hudElement(5, 200, "sailCount", config.sailIconPath))
	table.insert(self.hudElements, hudElement(5, 220, "cannonCount", config.cannonIconPath))
	table.insert(self.hudElements, hudElement(35, 200, nil, config.dPadVerticalIconPath))
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