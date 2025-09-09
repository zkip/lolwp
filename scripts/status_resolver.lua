
local resolve_priority = require("resolve_priority")

--[[
	请注意 resolve 的时机依赖于 Passive 和 Buff 生效时机，不能总是假设处于装备中才会使 Passive 生效
--]]
local function sanity_rate(owners, sanity_rate)
	local resolved_sanity_rate = sanity_rate
	
	local passive_owner = owners.passive_owner
	local buff_owner = owners.buff_owner

	local resolved_modifiers = resolve_priority(owners, "sanity_rate")
	for index, modifier_data in ipairs(resolved_modifiers) do
        -- print("sanity_rate", "::::::::::::", sanity_rate, index)
		local modifier = modifier_data.passive or modifier_data.buff
		if modifier.WhenSanityRate then
			resolved_sanity_rate = modifier:WhenSanityRate(resolved_sanity_rate)
		end
	end

	return resolved_sanity_rate
end

-- 解决同步性问题
local function health_delta(owners, amount)
	local resolved_delta_amount = amount
	
	local passive_owner = owners.passive_owner
	local buff_owner = owners.buff_owner

	local resolved_modifiers = resolve_priority(owners, "health_delta")
	for index, modifier_data in ipairs(resolved_modifiers) do
		local modifier = modifier_data.passive or modifier_data.buff
		if modifier.WhenHealthDelta then
			resolved_delta_amount = modifier:WhenHealthDelta(resolved_delta_amount)
		end
	end

	return resolved_delta_amount
end

return {
	sanity_rate = sanity_rate,
	health_delta = health_delta,
}