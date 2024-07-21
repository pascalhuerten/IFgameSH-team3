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
import "CoreLibs/timer"
import "arrow"

screenWidth, screenHeight = playdate.display.getSize()

local objects = {}

objects = {
}
function registerObject(object)
	table.insert(objects,object)
end

function destroyObject(object)
	for i,v in pairs(objects) do
		if(v == object) then table.remove(objects, i); return end
	end
end

local gfx <const> = playdate.graphics
local font = gfx.font.new('font/Mini Sans 2X') -- DEMO


local sea = sea()
local kraken = kraken(math.random(-1000, 1000), math.random(-1000, 1000))
local player = player()
local camera = camera(player.ship.x, player.ship.y)
local wind = wind(40, math.pi * 0.8)
local hud = hud()
local enemy = enemy(player.ship);
soundController = SoundController()
local arrow = arrow(enemy.ship, player.ship, kraken)

local function loadGame()
	playdate.display.setRefreshRate(50)           -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	-- gfx.setFont(font) -- DEMO

	-- SoundController:playBattleSoundtrack()
	-- SoundController:playCannonShot()
	-- SoundController:playCannonHit()

	soundController:playIdleSoundtrack()
end

loadGame()

local function updateGame()
	playdate.timer.updateTimers()
	enemy:update()
	for i, v in pairs(objects) do
		if(v.active and v.update) then
			v:update()
		end
	end
	camera:update(player.ship.x + player.ship.width / 2, player.ship.y + player.ship.height / 2)
	cameraX, cameraY = camera.x, camera.y
	detectCollision()
	sea:update()
	wind:update()
	hud:update({
		crewAtCannons = player.ship.crewAtCannons,
		crewAtSail = player.ship.crewAtSail
	})
	arrow:update()
	if kraken.sprite:isVisible() then
		soundController:playBattleSoundtrack()
	else
		soundController:playIdleSoundtrack()
	end
end

function detectCollision()
	for i1, v1 in pairs(objects) do
		if(not v1.active or not v1.collide) then goto continue1 end
		for i2, v2 in pairs(objects) do
			if(not v2.active or not v2.collide) then goto continue2 end
			if (v1 ~= v2) then
				v1:collide(v2)
			end
			::continue2::
		end
		::continue1::
	end
end

local function drawGame()
	gfx.clear() -- Clears the screen

	if player.ship.totalCrew <= 0 then
		gfx.pushContext()
		gfx.setFont(font) -- DEMO
		playdate.graphics.drawTextInRect("Blown Away", 0, 100, 400, 50, nil, nil, kTextAlignment.center, font)
		gfx.popContext()
		return
	end
	for k, v in pairs(objects) do
		if(v.active)then
			v:draw()
		end
	end
	kraken:draw()
	gfx.sprite.update()
	hud:draw()
	arrow:draw()
end

function playdate.update()
	deltaTime = playdate.getElapsedTime()
	playdate.resetElapsedTime()
	updateGame()
	drawGame()
	playdate.drawFPS(0, 0) -- FPS widget
end

-- This function relies on the use of timers, so the timer core library
-- must be imported, and updateTimers() must be called in the update loop
function screenShake(shakeTime, shakeMagnitude)
	-- Creating a value timer that goes from shakeMagnitude to 0, over
	-- the course of 'shakeTime' milliseconds
	local shakeTimer = playdate.timer.new(shakeTime, shakeMagnitude, 0)
	-- Every frame when the timer is active, we shake the screen
	shakeTimer.updateCallback = function(timer)
		-- Using the timer value, so the shaking magnitude
		-- gradually decreases over time
		local magnitude = math.floor(timer.value)
		local shakeX = math.random(-magnitude, magnitude)
		local shakeY = math.random(-magnitude, magnitude)
		playdate.display.setOffset(shakeX, shakeY)
	end
	-- Resetting the display offset at the end of the screen shake
	shakeTimer.timerEndedCallback = function()
		playdate.display.setOffset(0, 0)
	end
end
