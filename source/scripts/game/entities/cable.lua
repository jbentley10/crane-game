local pd <const> = playdate
local gfx <const> = pd.graphics

import "extension"

class('Cable').extends(gfx.sprite)

function Cable:init(x, y, image, player)
    self.moveSpeed = 2
    self:moveTo(x, y)
    self:setImage(image)	
    self:setCollideRect(0, 0, self:getSize())
    self.player = player -- Add a reference to the Player object
end

function Cable:update()
	Cable.super.update(self)
	self:moveTo(self.player.x + 50, self.y) -- Move to the same X position as the Player
end