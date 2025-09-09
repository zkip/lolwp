local regeneration = Class(function(self, args)
	self.args = {
		health = args.health or 0,
		sanity = args.sanity or 0,
		duration = args.duration or 0,
		interval = args.interval or 1,
	}
end)

function regeneration:WhenSetup()
	local interval = self.args.interval or 1
	if self.task then self.task:Cancel() end

	if self.args.health == 0 and self.args.sanity == 0 then return end

	self:DoPeriodicTask(interval, self.OnTick)
end

function regeneration:WhenEnd()
	
end

function regeneration:OnTick()
	local owner = self.buff_owner.inst

	if owner.components.health then
		owner.components.health:DoDelta(self.args.health)
	end
	if owner.components.sanity then
		owner.components.sanity:DoDelta(self.args.sanity)
	end
end

return regeneration