local item_database = require("item_database")
local LOLWP_S = require('core_lol_wp/utils/sugar')
local utils_table = require('utils/table')
local utils_equippable = require('utils/equippable')

-- 所有标签具有lolwp前缀
-- 具有固定标签lolwp_item

local function common_lolwp_item(lolwp_data, buildfn, unbuildfn, equipfn, unequipfn)
    local inst = CreateEntity()
	inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:SetPristine()

	inst:AddTag("lolwp_item")

    if TheWorld.ismastersim then
		if lolwp_data.equipslot then
			inst:AddComponent("equippable")
			inst.components.equippable.equipslot = lolwp_data.equipslot
			inst.components.equippable:SetOnEquip(function (inst, owner)
				-- TODO: 考虑是否替换成 shouldBuild
				if not utils_equippable.isInEyestone(owner.components.inventory, inst) then
					buildfn(inst, owner)
				end
				if equipfn then equipfn(inst, owner) end
			end)
			inst.components.equippable:SetOnUnequip(function (inst, owner)
				local prev_place = inst.__lolwp_prev_place
				if prev_place ~= "eyestone" then
					unbuildfn(inst, owner)
				end
				if unequipfn then unequipfn(inst, owner) end
			end)
		end

		inst:AddComponent("lolwp_passive_controller")
		inst.components.lolwp_passive_controller:SetupPassives(lolwp_data.passives)
	end
	
	return inst
end

return common_lolwp_item