
local db = TUNING.MOD_LOL_WP.MURAMANA
local item_database = require('item_database')

local wind_slash = Class(function(self, args)
	-- 充能完成所需的次数
	self.charge_desire = args.charge_desire

	self.charge_count = 0
	self.can_be_charge = true
	self.charged = false
end)

function wind_slash:CanBeCharged()
    local owner = self.passive_owner.inst
	return owner.sg.currentstate.name ~= "lolwp_triple_atk"
end

function wind_slash:ReadyForCharged()
	return self.charged
end

function wind_slash:WhenAttack()
    local owner = self.passive_owner.inst
	print(owner.sg.currentstate.name, ">>>>>>>>>>>>>")
	self.charged = false
	if not self:CanBeCharged() then return end

	self.charge_count = (self.charge_count + 1) % (self.charge_desire + 1)
	self.charged = self.charge_count == 0
end

function wind_slash:WhenEquip()
    self.passive_owner:Activate(self)
end

function wind_slash:WhenUnequip()
    self.passive_owner:Deactivate(self)
end

wind_slash.data = { }

wind_slash.actions = {
	{
		stategraph = "wilson",
		action = ACTIONS.ATTACK,
		fn = function (wind_slashes, inst, action)

			if not inst.sg:HasStateTag("attack") or action.target ~= inst.sg.statemem.attacktarget then
				return
			end
			if inst.components.health == nil or inst.components.health:IsDead() then
				return
			end

			for wind_slash, _ in pairs(wind_slashes) do
				print("xxxxxxxxxxxxx", wind_slash and wind_slash:ReadyForCharged(), wind_slash and wind_slash.charge_count)
				if wind_slash:ReadyForCharged() then
					return "lolwp_triple_atk"
				end
			end
		end
	},
	
	{
		stategraph = "wilson_client",
		action = ACTIONS.ATTACK,
		fn = function (wind_slash_replicas, inst, action)
			print("wilson_client:::::::::", wind_slashes)
			if not inst.sg:HasStateTag("attack") or action.target ~= inst.sg.statemem.attacktarget then
				return
			end

			if IsEntityDead(inst) then
				return
			end

			for wind_slash, _ in pairs(wind_slashes) do
				print("xxxxxxxxxxxxx", wind_slash and wind_slash:ReadyForCharged(), wind_slash and wind_slash.charge_count)
				if wind_slash:ReadyForCharged() then
					return "lolwp_triple_atk"
				end
			end
		end
	}
}

return wind_slash