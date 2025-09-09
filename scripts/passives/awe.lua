local utils_equippable = require('utils/equippable')
local utils_table = require('utils/table')
local item_database = require('item_database')

--[[
【敬畏】提供基于san值上限的属性
--]]
local awe = Class(function(self, args)
    self.damage_percent = args.damage_percent or 0
    self.planar_damage_percent = args.planar_damage_percent or 0
end)

function awe:WhenEquip()
	self.passive_owner:Activate(self)
end
function awe:WhenUnequip()
	self.passive_owner:Deactivate(self)
end

function awe:WhenAttack(combat_args)
	print("awe:WhenAttack=========>>>>>", combat_args)
    local passive_owner = self.passive_owner.inst
	local sanity_component = passive_owner.components.sanity

	if not sanity_component then return end
	
	local combat_args_accessor = utils_table.access(combat_args)

	local extra_damage = sanity_component.max * self.damage_percent
	local extra_planar_damage = sanity_component.max * self.planar_damage_percent

	print("awe:WhenAttack=========", extra_damage, extra_planar_damage, sanity_component.max, self.damage_percent)

	if extra_planar_damage > 0 then
		combat_args_accessor.delta("spdamage.planar", extra_planar_damage, 0)
	end
	
	if extra_damage > 0 then
		combat_args_accessor.delta("damage", extra_damage, 0)
	end

	return combat_args
end

return awe