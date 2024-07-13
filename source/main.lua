import "CoreLibs/timer"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "object"
import "ship"
import "utils"
import "camera"
import "player"
import "sea"
import "input"
import "hud" -- DEMO
local hud = hud() -- DEMO

local gfx <const> = playdate.graphics

local player = player()
local sea = sea()

local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	-- gfx.setFont(font) -- DEMO
end

loadGame()

local function updateGame()
	params = {
		deltaTime = dt
	}
	player:update()
	sea:update(player.camera.x, player.camera.y)
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