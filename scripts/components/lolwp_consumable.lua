--[[
	该组件的功能是实现多个不同 Passive 的数据持久化，
	逻辑上可以理解为 PassiveController 组件拥有多个不同的 Passive
--]]

local makeClassMemberSync = require("utils/class_member_syncer")
local utils_passive = require("utils/passive")
local genNetVarName = utils_passive.genNetVarName

---@class component_consumable
local lolwp_consumable = Class(function(self, inst)
    self.inst = inst
	-- { passive_name string: Passive }
	self.passives = { }
end)

function lolwp_consumable:OnSave()
	-- Passive 的存在性不需要存储，存在性的存储由其依赖的组件提供
	-- 仅提供对 Passive 数据的存储
	local data = { }
	for passive_name, passive in pairs(lolwp_consumable.passives) do
		data[passive_name] = {}
		for dataname, data_setting in pairs(passive.data or { }) do
			data[passive_name][dataname] = passive[dataname]
		end
	end
    return data
end

function lolwp_consumable:OnLoad(data)
	for passive_name, passive in pairs(lolwp_consumable.passives) do
		for dataname, _ in pairs(passive.data or { }) do
			if data[passive_name] then
				passive[dataname] = data[passive_name][dataname]
			end
		end
	end
end

function lolwp_consumable.f()

end

lolwp_consumable.actions = {
    {
        id = 'ACTION_LOL_WP_S16_DRINK_POTION',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_S16_DRINK_POTION,
        type = 'INVENTORY',
        state = 'quickeat',

        actiondata = {
            mount_valid = false,
            priority = 7,
        },

        fn = function (act)
            local consumer = act.doer
            local item = act.invobject
			local consumable = consumer.components.lolwp_consumable
            if consumer and item and consumer:IsValid() and item:IsValid() and consumable then
                return consumable:Drink(item)
            end
            return false
        end,
        testfn = function (inst, doer, actions, right)
			local consumable_replica = doer.replica.lolwp_consumable
            return consumable_replica ~= nil and consumable_replica:CanDrink(inst)
        end
    },
}

return lolwp_consumable