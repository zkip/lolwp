---@class LOL_WP_UNIQUE
local tool = {}

---是否有眼石,有则寻找对应装备
---@param player ent
---@param equip_prefab string # 需要找的amulet的prefab
---@return ent|nil
---@nodiscard
function tool:getEquipInEyeStone(player,equip_prefab)
    return player and player.eyestone_containers_stuff and player.eyestone_containers_stuff[equip_prefab]
end

return tool