import "CoreLibs/timer"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "utils"
import "object"
import "ship"
import "camera"
import "sea"
import "player"
import "kraken"
import "sea"
import "wind"
import "hud" -- DEMO
import "cannonball"

local gfx <const> = playdate.graphics


local sea = sea()
local kraken = kraken(400, 200)
local player = player()
local camera = camera(player.ship.x, player.ship.y)
local wind = wind(40, math.pi * 0.8)
local hud = hud()

local objects = {
	one = player.ship;
	two = player.ship.cannonball,
	-- something else
}

local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	-- gfx.setFont(font) -- DEMO
end

loadGame()
local function updateGame()
	print(ipairs(objects))
	for i,v in pairs(objects) do
		v:update()
	end
	player:update()
	camera:update(player.ship.x, player.ship.y)
	cameraX, cameraY = camera.x, camera.y
	detectCollision()
	kraken:update()
	sea:update()
	wind:update()
	local cannonCount = 1
	local sailCount = 5
	hud:update({
		cannonCount = cannonCount,
		sailCount = sailCount
	})
end

function detectCollision()
	for i1,v1 in ipairs(objects) do
		for i2,v2 in ipairs(objects) do
			if(v1 ~= v2) then
				v1:collide(objects.v2)
			end
		end
	end
end

local function drawGame()
	gfx.clear() -- Clears the screen
	for k,v in pairs(objects) do
		v:draw()
	end
	kraken:draw()
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