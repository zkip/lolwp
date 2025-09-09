--[[
	该组件从原版 equippable 中转发 equip 和 unequip 事件，并使用新的 lolwp_equip 和 lolwp_unequip 来替代
	除了转发事件外，还会将 eyestone.components.container 中的 itemget 和 itemlose 进行转发
	如果想增加新的场景，请重写本组件
--]]

local item_database = require("item_database")

local function on_eyestone_item_get(eyestone, data)
	local owner = eyestone.lolwp_owner
	local item = data.item

	if item.components.equippable then item.components.equippable:Equip(owner) end
	if owner then owner:PushEvent("lolwp_equip",  { item = item, slot = data.slot, in_eyestone = true }) end
end

local function on_eyestone_item_lose(eyestone, data)
	local owner = eyestone.lolwp_owner
	local item = data.prev_item

	if item then item.__lolwp_prev_place = "eyestone" end
	if item.components.equippable then item.components.equippable:Unequip(owner) end
	if owner then owner:PushEvent("lolwp_unequip", { item = item, slot = data.slot, in_eyestone = true }) end
	if item then item.__lolwp_prev_place = nil end
end

local function onequip(owner, data)
	print("======== onequip", data.item)
	local lolwp_equip_provider = owner.components.lolwp_equip_provider
	
	owner:PushEvent("lolwp_equip", { item = data.item, eslot = data.eslot, in_eyestone = false })

	local item_data = data and data.item and item_database:get_by_prefab(data.item.prefab)
	if item_data and table.contains(item_data.group, "eyestone") and lolwp_equip_provider then
		local eyestone = data.item
		eyestone.lolwp_owner = owner
		lolwp_equip_provider.eyestone = eyestone

		for slot, item in ipairs(eyestone.components.container.slots) do
			if item then
				on_eyestone_item_get(eyestone, { item = item, slot = slot, in_eyestone = true })
			end
		end

		eyestone:ListenForEvent("itemget", on_eyestone_item_get)
		eyestone:ListenForEvent("itemlose", on_eyestone_item_lose)
		-- eyestone:ListenForEvent("gotnewitem", on_eyestone_item_get)
		-- eyestone:ListenForEvent("dropitem", on_eyestone_item_lose)
	end
end

local function onunequip(owner, data)
	print("======== unequip", data.item)
	local lolwp_equip_provider = owner.components.lolwp_equip_provider

	owner:PushEvent("lolwp_unequip", { item = data.item, eslot = data.eslot, in_eyestone = false })

	local item_data = data and data.item and item_database:get_by_prefab(data.item.prefab)
	if item_data and table.contains(item_data.group, "eyestone") and lolwp_equip_provider then
		local eyestone = data.item

		for slot, item in ipairs(data.item.components.container.slots) do
			if item then
				on_eyestone_item_lose(eyestone, { prev_item = item, slot = slot, in_eyestone = true })
			end
		end
		
		eyestone.lolwp_owner = nil
		lolwp_equip_provider.eyestone = nil

		eyestone:RemoveEventCallback("itemget", on_eyestone_item_get)
		eyestone:RemoveEventCallback("itemlose", on_eyestone_item_lose)
		-- eyestone:RemoveEventCallback("gotnewitem", on_eyestone_item_get)
		-- eyestone:RemoveEventCallback("dropitem", on_eyestone_item_lose)
	end
end

local function onitemget(inst, data)
	print("======== itemget", data.item)
	inst:PushEvent("lolwp_itemget", data)
end
local function onitemlose(inst, data)
	print("======== itemlose", data.prev_item)
	inst:PushEvent("lolwp_itemlose", { item = data.prev_item, slot = data.slot })
end

---@class component_passive_owner
local lolwp_equip_provider = Class(function(self, inst)
    self.inst = inst
	self.eyestone = nil

	self.inst:ListenForEvent("itemget", onitemget)
	self.inst:ListenForEvent("itemlose", onitemlose)
	
	self.inst:ListenForEvent("equip", onequip)
	self.inst:ListenForEvent("unequip", onunequip)
end)

function lolwp_equip_provider:OnRemoveFromEntity()
	self.inst:RemoveEventCallback("itemget", onitemget)
	self.inst:RemoveEventCallback("itemlose", onitemlose)

	self.inst:RemoveEventCallback("equip", onequip)
	self.inst:RemoveEventCallback("unequip", onunequip)
end

return lolwp_equip_provider