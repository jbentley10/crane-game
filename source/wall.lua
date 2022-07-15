local pd <const> = playdate
local gfx <const> = pd.graphics

class('Wall').extends(gfx.sprite)

function Wall:init(x, y, width, height)
	Wall.super.init(self)
	self:moveTo(x, y)
	
	local wallImage = gfx.image.new(width, height)
	
	gfx.pushContext(wallImage)
		gfx.drawRect(0, 0, width, height)
	gfx.popContext()
	
	self:setImage(wallImage)	
	self:setCollideRect(0, 0, self:getSize())
end