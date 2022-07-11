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

local pd <const> = playdate
local gfx <const> = pd.graphics

local playerSprite = nil
local playerStartX = 200
local playerStartY = 120
local playerSpeed = 2

local playTimer = nil
local playTime = 30 * 1000

local toySprite = nil
local score = 0

local function resetTimer()
    playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

local function moveToy()
    local yField = 180
    local randX = math.random(40, 200)
    toySprite:moveTo(randX, yField)
end

function myGameSetUp()
    -- Set up the toy sprite
    math.randomseed(playdate.getSecondsSinceEpoch()) -- Creates some randomness

    -- Iniitalize player
    local playerImage = gfx.image.new("images/playerImage")
    local playerInstance = Player(200, 115, playerImage)
    playerInstance:add() 
    
    -- Iniitalize the claw mechanism that follows the player
    local mechanismWidth = 5
    local mechanismHeight = 55 -- initially the mechanism won't be that long
    local mechanismImage = gfx.image.new(5, 55)
    
    gfx.pushContext(mechanismImage)
        gfx.drawRect(0, 0, mechanismWidth, mechanismHeight) -- starts at 0,0 and goes to the width and height
        gfx.fillRect(0, 0, mechanismWidth, mechanismHeight)
    gfx.popContext()
    
    mechanismSprite = gfx.sprite.new(mechanismImage)
    mechanismSprite:moveTo(200, 70)
    mechanismSprite:setCollideRect(-13, 0, playerInstance.width, mechanismSprite.height)
    mechanismSprite:add()
    
    -- Initialize walls
    local wallWidth = 30
    local wallHeight = 190
    local wallImage = gfx.image.new(wallWidth, wallHeight)
    
    gfx.pushContext(wallImage)
        gfx.drawRect(0, 0, wallWidth, wallHeight) -- starts at 0,0 and goes to the width and height
        gfx.fillRect(0, 0, wallWidth, wallHeight)
    gfx.popContext()
    
    wallSprite = gfx.sprite.new(wallImage)
    wallSprite:moveTo(0, 120)
    wallSprite:add()
    wallSprite:setCollideRect(0, 0, wallSprite:getSize())
    
    -- Initialize collectibles
    local toyImage = gfx.image.new("images/toy")
    toySprite = gfx.sprite.new(toyImage)
    
    moveToy()
    toySprite:setCollideRect(0, 0, toySprite:getSize())    
    toySprite:add() -- add to draw list

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

end

myGameSetUp()

function playdate.update()
    if playTimer.value == 0 then
        if pd.buttonIsPressed(pd.kButtonA) then
            resetTimer()
            moveToy()
            score = 0
        end
    else
        if pd.buttonIsPressed(pd.kButtonRight) then
            mechanismSprite:moveWithCollisions(mechanismSprite.x + playerSpeed, mechanismSprite.y)
        end
        if pd.buttonIsPressed(pd.kButtonLeft) then
            mechanismSprite:moveWithCollisions(mechanismSprite.x - playerSpeed, mechanismSprite.y)
        end
        
        -- Set up collisions
        local toyCollisions = toySprite:overlappingSprites()
        if #toyCollisions >= 1 then
            moveToy()
            score += 1
        end
    end
    
    gfx.sprite.update()
    -- Update timers at the end
    playdate.timer.updateTimers()
    
    -- Display timer
    gfx.drawText("Time: " .. math.ceil(playTimer.value/1000), 5, 217)
    gfx.drawText("Score: " .. score, 100, 217)
end