local db = TUNING.MOD_LOL_WP.SUNFIREAEGIS

-- 掉落
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
        inst.components.lootdropper:AddChanceLoot('lol_wp_s10_sunfireaegis_blueprint',db.BLUEPRINTDROP_CHANCE.dragonfly)
        -- LOLWP_S:flingItem(SpawnPrefab('lol_wp_s10_sunfireaegis_blueprint'),inst:GetPosition())
        return unpack(res)
    end)
end)

-- 技能描述
local old_stroverridefn = ACTIONS.CASTAOE.stroverridefn
ACTIONS.CASTAOE.stroverridefn = function(act, ...)
	if act.invobject ~= nil and act.invobject.prefab == 'lol_wp_s10_sunfireaegis' then
		return STRINGS.MOD_LOL_WP.ACTIONS.REPLACE_ACTION_SHIELD_BLOCK_TO_SUNFIREAEGIS
	end
    if old_stroverridefn ~= nil then
        return old_stroverridefn(act, ...)
    end
    return
end

-- fx圈始终朝上 并且提前转

-- local isRotated = false
-- TheInput:AddControlHandler(CONTROL_ROTATE_LEFT,function ()
--     if not isRotated then
--         isRotated = true
--         TheWorld:PushEvent('lol_wp_rt')
--     end
--     TheWorld:DoTaskInTime(0.2,function ()
--         isRotated = false
--     end)
-- end)

-- TheInput:AddControlHandler(CONTROL_ROTATE_RIGHT,function ()
--     TheWorld:PushEvent('lol_wp_rt')
-- end)