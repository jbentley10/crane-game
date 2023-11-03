local pd <const> = playdate
local gfx <const> = pd.graphics

import "extension"

class('Mechanism').extends(gfx.sprite)

function Mechanism:init(x, y, image, player)
    self.moveSpeed = 2
    self:moveTo(x, y)
    self:setImage(image)	
    self:setCollideRect(0, 0, self:getSize())
    self.player = player -- Add a reference to the Player object
end

function Mechanism:update()
	Mechanism.super.update(self)
	self:moveTo(self.player.x, self.y) -- Move to the same X position as the Player
end