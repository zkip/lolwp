--[[
	该组件的功能是实现多个不同 Passive 的数据持久化，
	逻辑上可以理解为 PassiveController 组件拥有多个不同的 Passive
--]]

local makeClassMemberSync = require("utils/class_member_syncer")
local utils_passive = require("utils/passive")
local genNetVarName = utils_passive.genNetVarName

---@class component_passive_controller
local lolwp_passive_controller = Class(function(self, inst)
    self.inst = inst
	-- { passive_name string: Passive }
	self.passives = { }
end)

function lolwp_passive_controller:OnSave()
	-- Passive 的存在性不需要存储，存在性的存储由其依赖的组件提供
	-- 仅提供对 Passive 数据的存储
	local data = { }
	for passive_name, passive in pairs(self.passives) do
		data[passive_name] = {}
		for dataname, data_setting in pairs(passive.data or { }) do
			data[passive_name][dataname] = passive[dataname]
		end
	end
    return data
end

function lolwp_passive_controller:OnLoad(data)
	for passive_name, passive in pairs(self.passives) do
		for dataname, _ in pairs(passive.data or { }) do
			if data[passive_name] then
				passive[dataname] = data[passive_name][dataname]
			end
		end
	end
end

function lolwp_passive_controller:SetupPassives(passives)
	local replica = self.inst.replica.lolwp_passive_controller
	for passive_name, passive_args in pairs(passives) do
		local Passive = require('passives/' .. passive_name)
		local passive = Passive(passive_args)
		rawset(passive, 'name', passive_name)
		rawset(passive, 'passive_controller', self)

		--[[
			data 是 Passive 特殊的成员变量，会被 controller 进行特殊处理，用以指示如何将该数据传递至客户端中，
			在 Passive 中应以 Passive.data_<dataname> 来进行访问，如 self.data_mana
		--]]
		-- 为passive中的syncs字段自动添加同步逻辑，可能有点复杂，但绝对值得
		for dataname, data_setting in pairs(Passive.data or { }) do
			local init_value, type = unpack(data_setting)
			local netvar = replica:Netvar(type, passive_name, dataname)
			makeClassMemberSync(passive, dataname, init_value, netvar)
		end

		self.passives[passive_name] = passive
	end
end

function lolwp_passive_controller:OnRemoveFromEntity()
	for passive_name, passive in pairs(self.passives) do
		if passive.WhenRemoveFromEntity then
			passive:WhenRemoveFromEntity()
		end
	end
end

function lolwp_passive_controller:SetOwner(owner)
	for passive_name, passive in pairs(self.passives) do
		passive.passive_owner = owner
	end
end

function lolwp_passive_controller:GetAllPassives(owner)
	for passive_name, passive in pairs(self.passives) do
		passive.passive_owner = owner
	end
end

function lolwp_passive_controller:GetAllPassives()
	return self.passives
end

function lolwp_passive_controller:GetPassive(passive_name)
	return self.passives[passive_name]
end

return lolwp_passive_controller