local pd <const> = playdate
local gfx <const> = pd.graphics

import "entities/toy"

class('Player').extends(gfx.sprite)

function Player:init(x, y, image)
	self.moveSpeed = 2
	self:moveTo(x, y)
	self:setImage(image)
	self:setCollideRect(0, 0, self:getSize())
	self.isMoving = false
end

function checkToyCollisions(collisions)
	for index, collision in ipairs(collisions) do
		local collidedObject = collision['other']
		if collidedObject:isa(Toy) then
			isTouchingToy = true
		end
	end
end

function Player:update()
	Player.super.update(self)

	-- For each of these controls, we have the player move
	-- with collisions. We store the collision data,
	-- and then evalutate if it's a toy collision
	-- if there is a collision. If there's not a
	-- toy collision, we reset the boolean isToyTouching.
	if pd.buttonIsPressed(pd.kButtonLeft) then
		local actualX, actualY, collisions, length = self:moveWithCollisions(self.x - self.moveSpeed, self.y)
		self.isMoving = true

		if length > 0 then
			checkToyCollisions(collisions)
		else
			isTouchingToy = false
		end
	end
	if pd.buttonIsPressed(pd.kButtonRight) then
		local actualX, actualY, collisions, length = self:moveWithCollisions(self.x + self.moveSpeed, self.y)
		self.isMoving = true

		if length > 0 then
			checkToyCollisions(collisions)
		else
			isTouchingToy = false
		end
	end
	if pd.buttonIsPressed(pd.kButtonUp) then
		local actualX, actualY, collisions, length = self:moveWithCollisions(self.x, self.y - self.moveSpeed)
		self.isMoving = true

		if length > 0 then
			checkToyCollisions(collisions)
		else
			isTouchingToy = false
		end
	end
	if pd.buttonIsPressed(pd.kButtonDown) then
		local actualX, actualY, collisions, length = self:moveWithCollisions(self.x, self.y + self.moveSpeed)
		self.isMoving = true

		if length > 0 then
			checkToyCollisions(collisions)
		else
			isTouchingToy = false
		end
	end

	function pd.cranked(change, acceleratedChange)
		if change > 0 then
			local actualX, actualY, collisions, length = self:moveWithCollisions(self.x, self.y + acceleratedChange)
			if length > 0 then
				checkToyCollisions(collisions)
			else
				isTouchingToy = false
			end

			print("Change " ..change)
			print("Accel " ..acceleratedChange)
		elseif change < 0 then
			local actualX, actualY, collisions, length = self:moveWithCollisions(self.x, self.y + acceleratedChange)
			if length > 0 then
				checkToyCollisions(collisions)
			else
				isTouchingToy = false
			end

			print("Change " ..change)
			print("Accel " ..acceleratedChange)
		end
	end
end
