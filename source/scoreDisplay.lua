local pd <const> = playdate
local gfx <const> = pd.graphics

class('ScoreDisplay').extends(gfx.sprite)

function ScoreDisplay:init(x, y, width, height, score)
	ScoreDisplay.super.init(self)
	self:moveTo(x, y)
	
	local scoreDisplayImage = gfx.image.new(width, height)
	
	gfx.pushContext(scoreDisplayImage)
        gfx.drawRect(0, 0, width, height)
        gfx.drawText("Game Over!", 150, 100)
        gfx.drawText("Your score: " .. score, 145, 125)
        gfx.drawText("Press A to play again ", 125, 150)
	gfx.popContext()
	
	self:setImage(scoreDisplayImage)
end