--[[
	!!!该组件要求实体必须具备 向实体发出以下事件 的组件!!!
	itemget itemlose
	gotnewitem dropitem
	equip unequip
	通常来说这个组件是 Inventory, 任意组件只要满足以上要求的都可以，但在本组件中均称为 <inventory>
	
	该组件的功能是管理 inventory 组件中物品中的 Passive 组件
	当想拓展 inventory 中物品的 Passive 生效时机时，请重写该组件

	PassiveOwner 组件适用于管理 PassiveController 组件的实体，理解为 PassiveOwner 拥有多个 PassiveController 组件，请注意区分
--]]

-- passive_database 的结构设计成方便实现幂等操作，该函数允许多次调用并且保证数据不变
-- 这在一些情况下可能会有用，比如从 inventory 放入装备槽中时，该函数进入 inventory 中时已经执行过一次，现需要在 onequipped 再次进行 putin，无需进行清理
-- flag 表示 equipment 处于什么位置，比如是 inventory 中或是装备槽中
local function putin_database(equipment, owner, isEquip)
	print("putin database: ", equipment and equipment.prefab)
	local owner = owner
	local passive_owner = owner and owner.components.lolwp_passive_owner
	local controller = passive_owner and equipment.components.lolwp_passive_controller
	if controller then
		for passive_name, passive in pairs(controller:GetAllPassives() or {}) do
			local data = passive_owner.passive_database[passive_name] or {}
			passive_owner.passive_database[passive_name] = data
			data[passive] = { equipment = equipment, passive = passive }

			passive.passive_owner = passive_owner
			if isEquip then
				passive:WhenEquip()
			else
				passive:WhenInvGet()
			end
		end
	end
end
local function takeout_database(equipment, owner, isEquip)
	print("takeout database: ", equipment and equipment.prefab)
	if not equipment then return end
	local owner = owner
	local passive_owner = owner and owner.components.lolwp_passive_owner
	local passives = passive_owner and equipment.components.lolwp_passive_controller
	if passives then
		for passive_name, passive in pairs(passives:GetAllPassives() or {}) do
			local data = passive_owner.passive_database[passive_name] or {}
			data[passive] = nil

			if isEquip then
				passive:WhenUnequip()
			else
				passive:WhenInLose()
			end
		end
	end
end

local function trigger_passive_fn(owner, controller, transferOwner, fn_name, ...)
	for passive_name, passive in pairs(controller:GetAllPassives() or {}) do
		local data = owner.passive_database[passive_name] or { }
		local fn = passive[fn_name]

		if transferOwner then passive.passive_owner = owner end
		if fn then fn(passive, ...) end
		if not transferOwner then passive.passive_owner = nil end
	end
end

local function onitemget(inst, data)
	local item = data.item
	local owner = inst.components.lolwp_passive_owner
	local controller = item and item.components.lolwp_passive_controller
	if controller then
		controller:SetOwner(owner)
		trigger_passive_fn(owner, controller, true, "WhenInvGet")
	end
end
local function onitemlose(inst, data)
	local item = data.item
	local owner = inst.components.lolwp_passive_owner
	local controller = item and item.components.lolwp_passive_controller
	print(controller, "++++++++++++++", item and item.prefab, item and item.components.lolwp_passive_controller)
	if controller then
		trigger_passive_fn(owner, controller, false, "WhenInvLose")
		controller:SetOwner(nil)
	end
end
local function onequip(inst, data)
	local item = data.item
	local owner = inst.components.lolwp_passive_owner
	local controller = item and item.components.lolwp_passive_controller
	if controller then
		controller:SetOwner(owner)
		trigger_passive_fn(owner, controller, true, "WhenEquip")
	end
end
local function onunequip(inst, data)
	local item = data.item
	local owner = inst.components.lolwp_passive_owner
	local controller = item and item.components.lolwp_passive_controller
	if controller then
		trigger_passive_fn(owner, controller, false, "WhenUnequip")
		controller:SetOwner(nil)
	end
end

---@class component_passive_owner
local lolwp_passive_owner = Class(function(self, inst)
    self.inst = inst
	-- Passive 允许叠加
	-- { passive_name string: { Passive: { equipment: Entity, flag: string, passive: Passive } } }
	self.passive_database = { }
	-- { Passive: activate boolean }
	self.activation = { }

	self.inst:ListenForEvent("lolwp_itemget", onitemget)
	self.inst:ListenForEvent("lolwp_itemlose", onitemlose)
	
	self.inst:ListenForEvent("lolwp_equip", onequip)
	self.inst:ListenForEvent("lolwp_unequip", onunequip)
end)

function lolwp_passive_owner:OnRemoveFromEntity()
	self.inst:RemoveEventCallback("lolwp_itemget", onitemget)
	self.inst:RemoveEventCallback("lolwp_itemlose", onitemlose)

	self.inst:RemoveEventCallback("lolwp_equip", onequip)
	self.inst:RemoveEventCallback("lolwp_unequip", onunequip)
end

function lolwp_passive_owner:Activate(passive)
	local item = passive.passive_controller.inst

	local data = self.passive_database[passive.name] or { }
	self.passive_database[passive.name] = data
	data[passive] = { equipment = item, passive = passive }
	self.activation[passive] = passive
end

function lolwp_passive_owner:Deactivate(passive)
	local item = passive.passive_controller.inst

	local data = self.passive_database[passive.name] or { }
	self.passive_database[passive.name] = data
	data[passive] = nil
	self.activation[passive] = nil
end

function lolwp_passive_owner:Trigger(timing, ...)
	for passive_name, data in pairs(self.passive_database) do
        for passive, passive_data in pairs(data) do
            if passive[timing] then
				passive[timing](passive, ...)
			end
        end
	end
end

--[[
	提供一些方便查询的方法
--]]

--- @return { passive_name string: { passives: { Passive: equipment Entity } } }
function lolwp_passive_owner:GetPassiveDatabase()
	return self.passive_database
end

--- @param passive_name string
--- @return boolean
function lolwp_passive_owner:HasPassive(passive_name)
	if self.passive_database[passive_name] then
		return true
	end
	return false
end

--- @param passive_name string
--- @return { Passive: { equipment: Entity, flag: string } }
function lolwp_passive_owner:GetPassives(passive_name)
	return self.passive_database[passive_name]
end

function lolwp_passive_owner:IsActivate(passive)
	return self.activation[passive]
end

function lolwp_passive_owner:GetFlag(passive)
	local data = self.passive_database[passive.name]
	local passive_data = data and data[passive]
	
	if passive_data then
		return passive_data.flag
	end
end

return lolwp_passive_owner