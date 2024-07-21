import "CoreLibs/timer"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "utils"
import "object"
import "ship"
import "drowner"
import "camera"
import "sea"
import "player"
import "sea"
import "wind"
import "hud"
import "Cannon"
import "cannonball"
import "kraken"
import "enemy"
import "SoundController"
import "GameObjectManager"
import "CoreLibs/timer"
import "arrow"

-- Global Scope
GameObjectManager = GameObjectManager()

screenWidth, screenHeight = playdate.display.getSize()
soundController = SoundController()

-- Local scope
local gfx <const> = playdate.graphics
local font = gfx.font.new('font/Mini Sans 2X') -- DEMO

local sea = sea()
local kraken = kraken(math.random(-1000, 1000), math.random(-1000, 1000))
local player = player()
local camera = camera(player.ship.x, player.ship.y)
local wind = wind(40, math.pi * 0.8)
local hud = hud()
local enemy = enemy(player.ship);
local arrow = arrow(enemy.ship, player.ship, kraken)

local function loadGame()
	playdate.display.setRefreshRate(50)           -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random

	soundController:playIdleSoundtrack()
end
loadGame()

local function updateGame()
	playdate.timer.updateTimers()
	enemy:update()
	GameObjectManager:update()
	camera:update(player.ship.x, player.ship.y)
	cameraX, cameraY = camera.x, camera.y

	GameObjectManager:detectCollision()

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

local function drawGame()
	gfx.clear() -- Clears the screen

	if player.ship.totalCrew <= 0 then
		gfx.pushContext()
		gfx.setFont(font) -- DEMO
		playdate.graphics.drawTextInRect("Blown Away", 0, 100, 400, 50, nil, nil, kTextAlignment.center, font)
		gfx.popContext()
		return
	end

	-- Draw Sprites
	GameObjectManager:draw()
	gfx.sprite.update()

	-- Draw other graphics
	-- GameObjectManager:drawHealth()
	-- GameObjectManager:drawCollisionBorder()
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
