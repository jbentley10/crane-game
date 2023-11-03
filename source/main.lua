import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

-- Project imports
import "button"
import "crank"
import "lifecycle"
import "simulator"
import "player"
import "wall"
import "toy"
import "goal"
import "mechanism"
import "extension"
import "cable"
import "scoreDisplay"

local pd <const> = playdate
local gfx <const> = pd.graphics

local playTimer = nil
local playTime = 45 * 1000
score = 0
isTouchingToy = false

-- Animations
-- toyCubicAnimator = gfx.animator.new(2000, playerInstance.y, 300, pd.easingFunctions.inOutCubic)

-- Images
local playerImage = gfx.image.new("images/player")
local playerHoldingImage = gfx.image.new("images/player--holding")

-- Functions
local function resetTimer()
    playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

function moveToy()
    local yField = 180
    local randX = math.random(120, 380)
    smallToyInstance:moveTo(randX, yField)
    --mediumToyInstance:moveTo(randX, yField)
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
    mechanismInstance:remove()
    playerInstance:remove()
    cableInstance:remove()
    smallToyInstance:remove()
end

function myGameSetUp()
    -- Set up the toy sprite
    math.randomseed(playdate.getSecondsSinceEpoch()) -- Creates some randomness

    setCharacters()

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
    local smallToyImage = gfx.image.new("images/toy--small")
    local mediumToyImage = gfx.image.new("images/toy--medium")
    smallToyInstance = Toy(smallToyImage)
    --mediumToyInstance = Toy(mediumToyImage)

    smallToyInstance:add()
    --mediumToyInstance:add()

    local backgroundImage = gfx.image.new("images/background")
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

function showScoreDisplay() 
    scoreDisplayInstance = ScoreDisplay(200, 125, 200, 100, score)
    scoreDisplayInstance:add()
end

function removeScoreDisplay()
    scoreDisplayInstance:remove()
end

function playdate.update()
    if playTimer.value == 0 then
        removeCharacters()

        -- Init score display
        -- showScoreDisplay()

        if pd.buttonIsPressed(pd.kButtonA) then
            resetTimer()
            moveToy()
            score = 0
            -- removeScoreDisplay()
            setCharacters()
        end
    end

    gfx.sprite.update()
    -- Update timers at the end
    playdate.timer.updateTimers()

    -- Display timer
    gfx.drawText("Time: " .. math.ceil(playTimer.value / 1000), 5, 217)
    gfx.drawText("Score: " .. score, 100, 217)
end
