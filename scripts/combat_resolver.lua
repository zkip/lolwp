local resolve_priority = require("resolve_priority")

local function resolve_combat_modifiers(owners, combat_args)
	local passive_owner = owners.passive_owner
	local buff_owner = owners.buff_owner

	local resolved_combat_args = combat_args or { }

	local attacker_owners = { passive_owner = owners.attacker_passive_owner, buff_owner = owners.attacker_buff_owner }
	local target_owners = { passive_owner = owners.target_passive_owner, buff_owner = owners.target_buff_owner }
	
	local resolved_attacker_modifiers = resolve_priority(attacker_owners, "attack")
	-- print("=================================")
	-- for i, v in ipairs(resolved_attacker_modifiers) do
	-- 	print("resolve_combat_modifiers::::::::::", (v.passive or v.buff).name)
	-- end
	-- print("=================================")
	-- print(resolved_attacker_modifiers and #resolved_attacker_modifiers, "LLLLLLLLLL")
	for index, modifier_data in ipairs(resolved_attacker_modifiers) do
		local modifier = modifier_data.passive or modifier_data.buff
		if modifier.WhenAttack then
			resolved_combat_args = modifier:WhenAttack(resolved_combat_args) or resolved_combat_args
		end
	end

	local resolved_target_modifiers = resolve_priority(target_owners, "get_attacked")
	for index, modifier_data in ipairs(resolved_target_modifiers) do
		local modifier = modifier_data.passive or modifier_data.buff
		if modifier.WhenGetAttacked then
			resolved_combat_args = modifier:WhenGetAttacked(resolved_combat_args) or resolved_combat_args
		end
	end

	return resolved_combat_args
end

return resolve_combat_modifiers