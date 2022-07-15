local pd <const> = playdate
local gfx <const> = pd.graphics

import "extension"

class('Mechanism').extends(gfx.sprite)

function Mechanism:init(x, y, image)
	self.moveSpeed = 2
	self:moveTo(x, y)
	self:setImage(image)	
	self:setCollideRect(0, 0, self:getSize())
end

function Mechanism:update()
	Mechanism.super.update(self)
	if pd.buttonIsPressed(pd.kButtonLeft) then
		self:moveWithCollisions(self.x - self.moveSpeed, self.y)
	end
	if pd.buttonIsPressed(pd.kButtonRight) then
		self:moveWithCollisions(self.x + self.moveSpeed, self.y)
	end
end