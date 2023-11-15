-- CoreLibs
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

-- Libraries
import "scripts/libraries/utilities"
import "scripts/libraries/lifecycle"
import "scripts/libraries/simulator"
import "scripts/libraries/button"
import "scripts/libraries/crank"

-- Game
import "scripts/game/player"
-- Entities
import "scripts/game/entities/wall"
import "scripts/game/entities/toy"
import "scripts/game/entities/goal"
import "scripts/game/entities/mechanism"
import "scripts/game/entities/extension"
import "scripts/game/entities/cable"
-- NPCS
import "scripts/game/npcs/scoreDisplay"

local pd <const> = playdate
local gfx <const> = pd.graphics
local util <const> = utilities

-- Instantiate game variables
local playTimer = nil
local playTime = 3 * 1000
score = 0
gameOver = false
gameOverShown = false
isTouchingToy = false
local gameOver = false -- Flag to indicate if the game is over

-- Animations
-- toyCubicAnimator = gfx.animator.new(2000, playerInstance.y, 300, pd.easingFunctions.inOutCubic)

-- Images
local playerImage = gfx.image.new("images/player")
local playerHoldingImage = gfx.image.new("images/player--holding")
local gameEndTextImage = gfx.image.new("images/ui/game-over")
local smallToyImage = gfx.image.new("images/toy--small")
local backgroundImage = gfx.image.new("images/background")

-- Functions
local function resetTimer()
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

-- GAME
function resetGame() 
	gameEndTextSprite:remove()
	print('button A pressed')
	resetTimer()
	moveToy()
	score = 0
	gameOver = false
	gameOverShown = false
	setCharacters()
end

function moveToy()
	local yField = 180
	local randX = math.random(120, 380)
	smallToyInstance:moveTo(randX, yField)
end

-- Input handlers
local myInputHandlers = {
	-- If the player holds down the A button, swap out the sprite image
	AButtonHeld = function()
		if isTouchingToy == true then
			playerInstance:setImage(playerHoldingImage)
			smallToyInstance:remove()
		end
	end,

	-- If the player releases the A button, swap out the sprite image
	-- and make the toy fall
	AButtonUp = function()
		-- local toyCubicY = toyCubicAnimator:currentValue()

		playerInstance:setImage(playerImage)
		smallToyInstance:add()
		smallToyInstance:moveTo(playerInstance.x, 200)
	end
}

pd.inputHandlers.push(myInputHandlers)

-- CHARACTERS
function setCharacters()
	-- Initialize player
	playerInstance = Player(200, 125, playerImage)
	playerInstance:add()

	-- Initialize mechanism and extension
	local mechanismImage = gfx.image.new("images/mechanism")
	mechanismInstance = Mechanism(200, 85, mechanismImage, playerInstance)
	mechanismInstance:add()

	local extensionImage = gfx.image.new(5, 200)
	extensionInstance = Extension(200, 105, 10, 10, extensionImage)
	extensionInstance:add()

	local cableImage = gfx.image.new("images/cable")
	cableInstance = Cable(250, 92, cableImage, playerInstance)
	cableInstance:add()
end

function removeCharacters()
	print("removing characters...")
	mechanismInstance:remove()
	playerInstance:remove()
	cableInstance:remove()
	smallToyInstance:remove()
end

-- UI
function showGameOver() 
	print('If not gameOverShown then')
	gameOver = true
	removeCharacters()
	gameEndTextSprite = gfx.sprite.new(gameEndTextImage)
	gameEndTextSprite:add()
	gameEndTextSprite:setZIndex(100)
	gameEndTextSprite:moveTo(200, 50)
	gameOverShown = true
end

function showScoreDisplay()
	scoreDisplayInstance = ScoreDisplay(200, 125, 200, 100, score)
	scoreDisplayInstance:add()
end

function removeScoreDisplay()
	scoreDisplayInstance:remove()
end


-- START GAME / GAME LOOP
function myGameSetUp()
	print("Starting game.")	
	-- Set up the toy sprite
	math.randomseed(playdate.getSecondsSinceEpoch()) -- Creates some randomness

	setCharacters()

	local gameEndTextSprite = nil

	-- Initialize walls
	local wallLeft = Wall(15, 130, 20, 150)
	local wallRight = Wall(390, 130, 20, 150)
	local wallTop = Wall(0, 0, 800, 120)
	local wallBottom = Wall(0, 270, 800, 120)

	wallLeft:add()
	wallRight:add()
	wallTop:add()
	wallBottom:add()

	-- Initialize goal
	local goalInstance = Goal(60, 180, 60, 45)
	goalInstance:add()

	-- Initialize collectibles
	smallToyInstance = Toy(smallToyImage)
	smallToyInstance:add()

	assert(backgroundImage)

	gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			backgroundImage:draw(0, 0)
			gfx.clearClipRect()
		end
	)

	resetTimer()
	moveToy()
end

myGameSetUp()

function playdate.update()
	if not gameOver then
		gfx.sprite.update()
		-- Update timers at the end
		playdate.timer.updateTimers()

		-- Display timer
		gfx.drawText("Time: " .. math.ceil(playTimer.value / 1000), 5, 217)
		gfx.drawText("Score: " .. score, 100, 217)

		if playTimer.value == 0 then
			showGameOver()
		end
	end
	if gameOver then
		if pd.buttonIsPressed(pd.kButtonA) then
			resetGame()
		end
	end
end
