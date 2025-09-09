local modifier_data, group_priority, modifier_kind_data, group_modifiers = unpack(require("modifier_priority"))

local DEFAULT_GROUP_NAME = "default"

--[[
	受到优先级约束的项目包括了 Passive 和 Buff，统称为 Modifier

	优先级约束的规则有以下几条(靠前优先)
		组：总是先应用完组内的所有成员后再应用下一个组；未指定组时处于“default”组中
	组内成员的优先级规则:
		指定在某个前或后：指定的目标和自己不在同一组时无效
		初始化位置靠前优先
		未指定的所有目标视为相同优先级，相同优先级不保证顺序应用
--]]

-- 根据优先级配置对 Modifier 进行排序
local function resolve_priority(owners, kind)
	local passive_owner = owners.passive_owner
	local buff_owner = owners.buff_owner
    
    local groups = { }

	for passive_name, data in pairs(passive_owner and passive_owner.passive_database or { }) do
        local kind_flag = passive_name .. "/" .. (kind or "")
        local group_name = modifier_data[kind_flag] or DEFAULT_GROUP_NAME
        local group = groups[group_name] or { }

        for passive, passive_data in pairs(data) do
            table.insert(group, passive_data)
        end

        -- print("passive count: ", #group)

        groups[group_name] = group
	end

	for buff_name, data in pairs(buff_owner and buff_owner.buff_database or { }) do
        local kind_flag = buff_name .. "/" .. (kind or "")
        local group_name = modifier_data[kind_flag] or DEFAULT_GROUP_NAME
        local group = groups[group_name] or { }

        for buff, buff_data in pairs(data) do
            table.insert(group, buff_data)
        end

        -- print("buff count: ", #group)

        groups[group_name] = group
	end

    local modifiers = { }

    for _, group_name in ipairs(group_priority) do
       local group = groups[group_name] or { }
       for _, modifier in ipairs(group) do
            table.insert(modifiers, modifier)
       end 
    end

    return modifiers
end

return resolve_priority