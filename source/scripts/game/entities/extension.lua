local pd <const> = playdate
local gfx <const> = pd.graphics

class('Extension').extends(gfx.sprite)

function Extension:init(x, y, width, height, image)
	Extension.super.init(self)	
	gfx.pushContext(extension)
    gfx.setColor(0, 0, 0, 1)
    gfx.fillRect(x, y, width, height)
	gfx.popContext()
	
	self:setImage(image)	
end

function Extension:update()
    if pd.buttonIsPressed(pd.kButtonUp) then
        self:setSize(self.width, self.height - 2)
    end
    if pd.buttonIsPressed(pd.kButtonDown) then
        self:setSize(self.width, self.height + 2)
    end
end
