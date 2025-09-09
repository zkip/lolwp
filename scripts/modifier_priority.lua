local modifier_priority =  {
    {
        name = "grievous_wounds",
        kind = "health_delta",
        group = "after",
        type = "buff",
    },
}

local group_priority = {
    "before",
    "default",
    "after"
}

local group_modifiers = { }
local modifier_kind_data = { }

for _, modifier in ipairs(modifier_priority) do
    local group = group_modifiers[modifier.group] or { }
    table.insert(group, modifier)

    local kind_flag = modifier.name .. "/" .. (modifier.kind or "")
    modifier_kind_data[kind_flag] = modifier

    group_modifiers[modifier.group] = group
end

return { modifier_priority, group_priority, modifier_kind_data, group_modifiers }