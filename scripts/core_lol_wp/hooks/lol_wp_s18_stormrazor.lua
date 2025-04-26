local db = TUNING.MOD_LOL_WP.STORMRAZOR

AddPrefabPostInit("moose", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    if not inst.components.lootdropper then
        inst:AddComponent('lootdropper')
    end
    local old_lootsetupfn = inst.components.lootdropper.lootsetupfn
    inst.components.lootdropper:SetLootSetupFn(function (...)
        local res = old_lootsetupfn ~= nil and {old_lootsetupfn(...)} or {}
        inst.components.lootdropper:AddChanceLoot('lol_wp_s18_stormrazor_blueprint',db.BLUEPRINTDROP_CHANCE.moose)
        return unpack(res)
    end)
end)