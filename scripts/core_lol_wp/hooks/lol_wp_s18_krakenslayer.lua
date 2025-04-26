local db = TUNING.MOD_LOL_WP.KRAKENSLAYER

AddPrefabPostInit('sunkenchest',function (inst)
    if not TheWorld.ismastersim then
        return inst
    end
    inst:ListenForEvent('worked',function ()
        if TheWorld.components.world_data_lol_wp and TheWorld.components.world_data_lol_wp.alterguardian_phase3_defeat then
            local pt = inst:GetPosition()
            local workleft = inst.components.workable and inst.components.workable.workleft
            if workleft and workleft <= 0 then
                local passed_day = TheWorld.state.cycles or 0
                local chance = db.CHANCE_TO_GET_IN_CHEST_AFTER_KILL_BOSS
                if math.random() < chance then
                    LOLWP_S:flingItem(SpawnPrefab('lol_wp_s18_krakenslayer'),pt)
                end
            end
        end
    end)
end)
