local pd <const> = playdate
local gfx <const> = playdate.graphics

local util <const> = utilities

class('GameOverScene').extends(gfx.sprite)

function GameOverScene:init()
    print('If not gameOverShown then')
    removeCharacters()
    gameEndTextSprite = gfx.sprite.new(gameEndTextImage)
    gameEndTextSprite:add()
    gameEndTextSprite:setZIndex(100)
    gameEndTextSprite:moveTo(200, 50)
    gameOverShown = true
end

function GameOverScene:update()
    if pd.buttonJustPressed(pd.kButtonA) and self.animationsFinished then
        SCENE_MANAGER:switchScene(TitleScene)
    end
end