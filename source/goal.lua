local pd <const> = playdate
local gfx <const> = pd.graphics

class('Goal').extends(gfx.sprite)

function Goal:init(x, y, width, height)
	Goal.super.init(self)
	self:moveTo(x, y)
	
	local GoalImage = gfx.image.new(width, height)
	
	gfx.pushContext(GoalImage)
		gfx.drawRect(0, 0, width, height)
	gfx.popContext()
	
	self:setImage(GoalImage)	
	self:setCollideRect(0, 0, self:getSize())
end

function checkGoalCollisions(collisions)
	for index, collision in ipairs(collisions) do
		local collidedObject = collision['other']
		if collidedObject:isa(Toy) then
			-- local objectSize = collidedObject.getSize()
			-- if objectSize > 16 then
			-- 	score += 2
			-- end
			score += 1
            smallToyInstance:remove()
            smallToyInstance:add()
            moveToy()
		end
	end
end

function Goal:update()
	local actualX, actualY, collisions, length = self:checkCollisions(self.x, self.y)

    if length > 0 then
        checkGoalCollisions(collisions)
    end
end