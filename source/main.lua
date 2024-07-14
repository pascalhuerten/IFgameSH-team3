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
import "enemy"
import "SoundController"

local gfx <const> = playdate.graphics


local sea = sea()
local kraken = kraken(400, 200)
local player = player()
local camera = camera(player.ship.x, player.ship.y)
local wind = wind(40, math.pi * 0.8)
local hud = hud()
local enemy = enemy(player.ship);
soundController = SoundController()

local objects = {
}

function registerObject(object)
	key = tostring(#object)
	objects[key] = object
end

function destroyObject(key)
	table.remove(objects,key)
end

local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	-- gfx.setFont(font) -- DEMO

	-- SoundController:playBattleSoundtrack()
	-- SoundController:playCannonShot()
	-- SoundController:playCannonHit()
	
	soundController:playIdleSoundtrack()
end

loadGame()
local function updateGame()
	player:update()
	enemy:update()
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
		crewAtCannons = player.ship.crewAtCannons,
		crewAtSail = player.ship.crewAtSail
	})

	if kraken.sprite:isVisible() then
        soundController:playBattleSoundtrack()
    else
		soundController:playIdleSoundtrack()
    end
end

function detectCollision()
	for i1,v1 in pairs(objects) do
		for i2,v2 in pairs(objects) do
			if(v1 ~= v2) then
				v1:collide(v2)
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