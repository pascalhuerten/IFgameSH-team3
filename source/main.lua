import "CoreLibs/timer"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "utils"
import "object"
import "ship"
import "camera"
import "sea"
import "player"
import "sea"
import "wind"
import "hud" -- DEMO
import "cannonball"

local hud = hud() -- DEMO

local gfx <const> = playdate.graphics

local sea = sea()
local wind = wind(40, math.pi * 0.8)
local player = player()

local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	-- gfx.setFont(font) -- DEMO
end

loadGame()

local function updateGame()
	player:update()
	sea:update(player.camera.x, player.camera.y)
	wind:update(player.camera.x, player.camera.y)
	local cannonCount = 1
	local sailCount = 5
	hud:update({
		cannonCount = cannonCount,
		sailCount = sailCount
	})
end

local function drawGame()
	gfx.clear() -- Clears the screen
	player:draw()
	gfx.sprite.update()
	hud:draw()
end

function playdate.update()
	deltaTime = playdate.getElapsedTime()
	playdate.resetElapsedTime()
	updateGame()
	drawGame()
	playdate.drawFPS(0,0) -- FPS widget
end