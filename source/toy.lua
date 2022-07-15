local pd <const> = playdate
local gfx <const> = pd.graphics

class('Toy').extends(gfx.sprite)

function Toy:init(image)
	self:setImage(image)	
	self:setCollideRect(0, 0, self:getSize())
end

function Toy:update()
	
end

