AddPrefabPostInit('world',function (inst)
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent('world_data_lol_wp')
end)

-- 天体死亡
AddPrefabPostInit("alterguardian_phase3", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    if not inst.components.lootdropper then
        inst:AddComponent('lootdropper')
    end
    local old_lootsetupfn = inst.components.lootdropper.lootsetupfn
    inst.components.lootdropper:SetLootSetupFn(function (...)
        local res = old_lootsetupfn ~= nil and {old_lootsetupfn(...)} or {}

        if TheWorld.components.world_data_lol_wp then
            TheWorld.components.world_data_lol_wp.alterguardian_phase3_defeat = true
        end

        return unpack(res)
    end)
end)