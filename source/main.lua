import "CoreLibs/timer"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "object"
import "ship"
import "input"

local gfx <const> = playdate.graphics
local dt <const> = playdate.getElapsedTime()
local font = gfx.font.new('font/Mini Sans 2X') -- DEMO
local shifParams = {
	x = 200;
    y = 200;
    rotation = 0;
    imagePath = "Resource/Schiffchen.png";
	width = 96;
	height = 40;
	moveSpeed = 25;
}
local ship = ship(shifParams)

local function loadGame()
	
end

loadGame()

local function updateGame()
	params = {deltaTime = dt;}
	ship:update(params)
end

local function drawGame()
	gfx.clear() -- Clears the screen
	ship:draw(0,0)
	gfx.sprite.update()
end

function playdate.update()
	updateGame()
	drawGame()
	playdate.drawFPS(0,0) -- FPS widget
end

