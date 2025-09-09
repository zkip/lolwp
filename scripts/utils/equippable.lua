--[[
    Copyright (c) 2025 zkip zkiplan@qq.com
    MIT License
--]]

local item_database = require('item_database')

---判断给定实体是否在 inventory 的眼石中
---@param inventory Component
---@param prefab Entity
---@return boolean
local function isInEyestone(inventory, item)
    local equip_slots = inventory and inventory.equipslots or {}

    if not item or not item.components.equippable then return false end

    -- 如果在任何一个装备槽中，那么它不在眼石中
    if inventory and inventory.equipslots[item.components.equippable.equipslot] == item then
        return false
    end
    
    local eyestone = equip_slots[EQUIPSLOTS.LOL_WP]
	if not eyestone then return false end
    local eyestone_slots = eyestone.components.container and eyestone.components.container.slots

    for _, v in ipairs(eyestone_slots or {}) do
        if v == item then return true end
    end
    
    return false
end

---分别获取眼石外盒眼石内的装备
---@param inventory Component
---@return table<string, ent>, table<string, ent> # 返回 { prefab: Entity }, { prefab: Entity }
local function getEquipmentForKinds(inventory)
    local equip_slots = inventory and inventory.equipslots or {}
    local inEyestoneEquips = {}
    local outsideEyestoneEquips = {}
    
    local eyestone_slots = {}
    
    for _, v in pairs(equip_slots) do
        -- TODO: PrefabID 聚合管理
        local isEyeStone = v.prefab == 'lol_wp_s9_eyestone_low' or v.prefab == 'lol_wp_s9_eyestone_high'
        if isEyeStone then
            eyestone_slots = v.components.container and v.components.container.slots
        end
        outsideEyestoneEquips[v.prefab] = v
    end
    
    for _, v in pairs(eyestone_slots or {}) do
        inEyestoneEquips[v.prefab] = v
    end

    return outsideEyestoneEquips, inEyestoneEquips
end

---获取所有装备（包括眼石中的）
---@param inventory Component
---@return ent[] # 返回包含所有装备的数组
local function getAllEquipments(inventory)
    local equip_slots = inventory and inventory.equipslots or {}
	local equips = {}
	local lolwpSlotItem = equip_slots[EQUIPSLOTS.LOL_WP]
	local lolwpData = lolwpSlotItem and item_database:get_by_prefab(lolwpSlotItem.prefab)
    local eyestone_slots = {}

	if lolwpData and lolwpData.group['eyestone'] and lolwpSlotItem.components.container then
		eyestone_slots = lolwpSlotItem.components.container.slots
	end

    for _, equip in pairs(equip_slots) do
		table.insert(equips, equip)
    end
    
    for _, equip in pairs(eyestone_slots or {}) do
		table.insert(equips, equip)
    end

    return equips
end

---根据 Prefab 分别获取眼石外的装备和眼石内的
---@param inventory Component
---@param prefab string
---@return ent # 返回一个眼石外的
---@return ent # 返回一个眼石内的
local function findEquipment(inventory, prefab)
	local outsideEyestoneEquips, insideEyestoneEquips = getEquipmentForKinds(inventory, prefab)
    local equips = merge(outsideEyestoneEquips, insideEyestoneEquips)
    local inEyestone = insideEyestoneEquips[prefab]
    return outsideEyestoneEquips[prefab], insideEyestoneEquips[prefab]
end

---根据 Passive_name 分别获取眼石外的装备和眼石内的
---@param inventory Component
---@param prefab string
---@return ent[] # 返回眼石外所有具备该被动的装备
---@return ent[] # 返回眼石内所有具备该被动的装备
local function findPassiveItem(inventory, passive_name)
	local outsideEyestoneEquips, insideEyestoneEquips = getEquipmentForKinds(inventory)
	local outsidePassiveItems, insidePassiveItems = {}, {}
	for _, equip in pairs(outsideEyestoneEquips) do
		if equip and equip.components.lolwp_passive_controller then
			local passive = equip.components.lolwp_passive_controller:GetPassive(passive_name)
			if passive then table.insert(outsideEyestoneEquips, passive) end
		end
	end
	for _, equip in pairs(insideEyestoneEquips) do
		if equip and equip.components.lolwp_passive_controller then
			local passive = equip.components.lolwp_passive_controller:GetPassive(passive_name)
			if passive then table.insert(insideEyestoneEquips, passive) end
		end
	end
	
	return outsidePassiveItems, insidePassiveItems
end

---判断给定 Prefab 是否处于装备中（包括眼石中的）
---@param inventory Component
---@param prefab Entity
---@return boolean
local function isEquipped(inventory, prefab)
    local equip_slots = inventory and inventory.equipslots or {}

	local inside, outside = findEquipment(inventory, prefab)
	
    return inside[prefab] or outside[prefab]
end

---对比物品的装备槽位是否和给定的一致
---@param inst ent
---@param prefab string
---@return boolean # 返回 { prefab: Entity }
local function isEquipSlot(inst, equipslot)
    if inst and inst.components.equippable then
        return inst.components.equippable.equipslot == equipslot
    end
    return false
end

return {
	isInEyestone = isInEyestone,
	getEquipmentForKinds = getEquipmentForKinds,
	getAllEquipments = getAllEquipments,
	findEquipment = findEquipment,
	isEquipped = isEquipped,
	isEquipSlot = isEquipSlot,
}