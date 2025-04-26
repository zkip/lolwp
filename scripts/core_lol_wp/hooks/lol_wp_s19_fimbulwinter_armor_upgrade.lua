
-- 星蚀 兰德里的折磨 末日寒冬 同时装备 武器带电
AddPlayerPostInit(function (inst)
    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent('equip',
    ---comment
    ---@param inst ent
    ---@param data event_data_equip
    function (inst, data)
        local allequips = LOLWP_S:getAllEquipments(inst)
        if (allequips['lol_wp_s17_liandry'] or allequips['lol_wp_s17_liandry_nomask']) and allequips['lol_wp_s12_eclipse'] and allequips['lol_wp_s19_fimbulwinter_armor_upgrade'] then
            if inst.components.electricattacks == nil then
                inst:AddComponent("electricattacks")
            end
            inst.components.electricattacks:AddSource(inst)
            if inst._lol_wp_s19_fimbulwinter_armor_upgrade_onattackother == nil then
                inst._lol_wp_s19_fimbulwinter_armor_upgrade_onattackother = function(attacker, data)
                    if data.weapon ~= nil then
                        if data.projectile == nil then
                            --in combat, this is when we're just launching a projectile, so don't do FX yet
                            if data.weapon.components.projectile ~= nil then
                                return
                            elseif data.weapon.components.complexprojectile ~= nil then
                                return
                            elseif data.weapon.components.weapon:CanRangedAttack() then
                                return
                            end
                        end
                        if data.weapon.components.weapon ~= nil and data.weapon.components.weapon.stimuli == "electric" then
                            --weapon already has electric stimuli, so probably does its own FX
                            return
                        end
                    end
                    if data.target ~= nil and data.target:IsValid() and attacker:IsValid() then
                        SpawnPrefab("electrichitsparks"):AlignToTarget(data.target, data.projectile ~= nil and data.projectile:IsValid() and data.projectile or attacker, true)
                    end
                end
                inst:ListenForEvent("onattackother", inst._lol_wp_s19_fimbulwinter_armor_upgrade_onattackother)
            end
            SpawnPrefab("electricchargedfx"):SetTarget(inst)
        end
    end)

    inst:ListenForEvent('unequip',
    ---comment
    ---@param inst ent
    ---@param data event_data_unequip
    function (inst, data)
        local allequips = LOLWP_S:getAllEquipments(inst)
        if (allequips['lol_wp_s17_liandry'] or allequips['lol_wp_s17_liandry_nomask']) and allequips['lol_wp_s12_eclipse'] and allequips['lol_wp_s19_fimbulwinter_armor_upgrade'] then
        else
            if inst.components.electricattacks ~= nil then
                inst.components.electricattacks:RemoveSource(inst)
            end
            if inst._lol_wp_s19_fimbulwinter_armor_upgrade_onattackother ~= nil then
                inst:RemoveEventCallback("onattackother", inst._lol_wp_s19_fimbulwinter_armor_upgrade_onattackother)
                inst._lol_wp_s19_fimbulwinter_armor_upgrade_onattackother = nil
            end
        end
    end)

end)