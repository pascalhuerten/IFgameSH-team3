import "CoreLibs/timer"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "object"
import "ship"
import "input"
import "hud" -- DEMO
local hud = hud() -- DEMO

local gfx <const> = playdate.graphics
local dt <const> = playdate.getElapsedTime()
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
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	-- gfx.setFont(font) -- DEMO
end

loadGame()

local function updateGame()
	params = {deltaTime = dt;}
	ship:update(params)
	local cannonCount = 1
	local sailCount = 5
	hud:update({
		cannonCount = cannonCount,
		sailCount = sailCount
	})
end

local function drawGame()
	gfx.clear() -- Clears the screen
	ship:draw(0,0)
	gfx.sprite.update()
	hud:draw()
end

function playdate.update()
	updateGame()
	drawGame()
	playdate.drawFPS(0,0) -- FPS widget
end

