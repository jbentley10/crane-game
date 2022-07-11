local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(gfx.sprite)

function Player:init(x, y, image)
	self.moveSpeed = 2
	self:moveTo(x, y)
	self:setImage(image)	
	self:setCollideRect(0, 0, self:getSize())
end

function Player:update()
	Player.super.update(self)
	if pd.buttonIsPressed(pd.kButtonLeft) then
		self:moveWithCollisions(self.x - self.moveSpeed, self.y)
	end
	if pd.buttonIsPressed(pd.kButtonRight) then
		self:moveWithCollisions(self.x + self.moveSpeed, self.y)
	end
	if pd.buttonIsPressed(pd.kButtonUp) then
		self:moveWithCollisions(self.x, self.y - self.moveSpeed)
	end
	if pd.buttonIsPressed(pd.kButtonDown) then
		self:moveBy(0, self.moveSpeed)
	end
end