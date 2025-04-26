local db = TUNING.MOD_LOL_WP.GUINSOO

-- 掉落
-- AddPrefabPostInit('klaus', function(inst)
--     if not TheWorld.ismastersim then
--         return inst
--     end
--     if not inst.components.lootdropper then
--         inst:AddComponent('lootdropper')
--     end
--     local old_lootsetupfn = inst.components.lootdropper.lootsetupfn
--     inst.components.lootdropper:SetLootSetupFn(function (...)
--         local res = old_lootsetupfn ~= nil and {old_lootsetupfn(...)} or {}
--         if inst:IsUnchained() then
--             inst.components.lootdropper:AddChanceLoot('lol_wp_s10_guinsoo_blueprint',1)
--         end
--         return unpack(res)
--     end)
-- end)


AddPrefabPostInit("dragonfly", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    if not inst.components.lootdropper then
        inst:AddComponent('lootdropper')
    end
    local old_lootsetupfn = inst.components.lootdropper.lootsetupfn
    inst.components.lootdropper:SetLootSetupFn(function (...)
        local res = old_lootsetupfn ~= nil and {old_lootsetupfn(...)} or {}
        inst.components.lootdropper:AddChanceLoot('lol_wp_s10_guinsoo_blueprint',db.BLUEPRINTDROP_CHANCE.dragonfly)
        return unpack(res)
    end)
end)

AddPrefabPostInit("mutatedbearger", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    if not inst.components.lootdropper then
        inst:AddComponent('lootdropper')
    end
    local old_lootsetupfn = inst.components.lootdropper.lootsetupfn
    inst.components.lootdropper:SetLootSetupFn(function (...)
        local res = old_lootsetupfn ~= nil and {old_lootsetupfn(...)} or {}
        inst.components.lootdropper:AddChanceLoot('lol_wp_s10_guinsoo',db.DROP_CHANCE.mutatedbearger)
        return unpack(res)
    end)
end)


-- 阿尔法突袭
AddComponentPostInit('combat',function (self)
    local old_GetAttacked = self.GetAttacked
    ---comment
    ---@param attacker ent
    ---@param damage any
    ---@param weapon ent
    ---@param stimuli any
    ---@param spdamage any
    ---@param ... unknown
    ---@return unknown
    function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
        if damage and weapon and weapon.prefab and weapon.prefab == 'lol_wp_s10_guinsoo' then
            if weapon.flag_lol_wp_s10_guinsoo_islunge then
                if spdamage == nil then
                    spdamage = {}
                end
                spdamage['planar'] = (spdamage['planar'] or 0) + db.SKILL_ALPHA.PLANAR_DMG

                weapon.flag_lol_wp_s10_guinsoo_islunge = false
            end
        end
        return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
    end
end)


local old_stroverridefn = ACTIONS.CASTAOE.stroverridefn
ACTIONS.CASTAOE.stroverridefn = function(act, ...)
	if act.invobject ~= nil and act.invobject.prefab == 'lol_wp_s10_guinsoo' then
		return STRINGS.MOD_LOL_WP.ACTIONS.REPLACE_ACTION_GUINSOO
	end
    if old_stroverridefn ~= nil then
        return old_stroverridefn(act, ...)
    end
    return
end