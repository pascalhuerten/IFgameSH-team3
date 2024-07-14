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
local kraken = kraken(100, -200)
local player = player()
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
	player:update()
	for i,v in pairs(objects) do
		v:update()
	end
	detectCollision()
	kraken:update()
	sea:update(player.camera.x, player.camera.y)
	wind:update(player.camera.x, player.camera.y)
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
		v:draw(player.camera.x, player.camera.y)
	end
	kraken:draw(player.camera.x, player.camera.y)
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