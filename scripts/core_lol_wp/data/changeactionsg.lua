---@type data_changeactionsg[]
local data = {
    -- {
    --     action = 'BUILD',
    --     sg = 'doshortaction',
    --     testfn = function (doer)
    --         return doer and doer:HasTag("player")
    --     end,
    --     testfn_client = function (doer)
    --         return doer and doer:HasTag("player")
    --     end
    -- }
    {
        action = "ATTACK",
        sg = 'lol_wp_handcanon',
        testfn = function (inst, action, ...)
            -- if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.components.health:IsDead()) and (inst.components.rider and not inst.components.rider:IsRiding()) then
            --     local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
            --     if weapon and weapon:HasTag("lol_wp_s13_collector") then
            --         return true
            --     end
            -- end
            -- return false
            ---@type ent|nil
            local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
            if weapon and weapon.prefab == 'lol_wp_s13_collector' then
                if weapon:HasTag('lol_wp_s13_collector_container_isempty') then
                    if inst.components.talker then
                        inst.components.talker:Say(STRINGS.MOD_LOL_WP.COLLECTOR_NO_AMMO)
                    end
                    return 'override'
                end
                if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.components.health:IsDead()) then
                    if inst.components.rider and not inst.components.rider:IsRiding() then
                        return true
                    else
                        if inst:HasTag('lol_wp_s13_collector_riding_atk_cooldown') then
                            return 'override'
                        end
                        inst:AddTag('lol_wp_s13_collector_riding_atk_cooldown')
                        inst:DoTaskInTime(0.8,function ()
                            if inst then
                                inst:RemoveTag('lol_wp_s13_collector_riding_atk_cooldown')
                            end
                        end)
                    end
                end
            end
            return false
        end,
        testfn_client = function (inst, action, ...)
            -- if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or IsEntityDead(inst)) and (inst.replica.rider and not inst.replica.rider:IsRiding()) then
            --     local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            --     if equip and equip:HasTag("lol_wp_s13_collector") then
            --         return true
            --     end
            -- end
            -- return false
            ---@type ent|nil
            local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equip and equip.prefab == 'lol_wp_s13_collector' then
                if equip:HasTag('lol_wp_s13_collector_container_isempty') then
                    if inst.components.talker then
                        inst.components.talker:Say(STRINGS.MOD_LOL_WP.COLLECTOR_NO_AMMO)
                    end
                    return 'override'
                end
                if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or IsEntityDead(inst)) then
                    if inst.replica.rider and not inst.replica.rider:IsRiding() then
                        return true
                    else
                        if inst:HasTag('lol_wp_s13_collector_riding_atk_cooldown') then
                            return 'override'
                        end
                    end
                end
            end
            return false
        end,
    },
    -- 卢登的回声 被动：【回声
    -- {
    --     action = 'ATTACK',
    --     sg = '?',
    --     testfn = function (inst, action, ...)
    --         local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
    --         if weapon and weapon.prefab == 'lol_wp_s17_luden' then
    --             if weapon:HasTag('lol_wp_s17_luden_iscd') then
    --                 return 'override'
    --             end
    --             return false
    --         end
    --         return false
    --     end,
    --     testfn_client = function (inst, action, ...)
    --         local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    --         if equip and equip.prefab == 'lol_wp_s17_luden' then
    --             if equip:HasTag('lol_wp_s17_luden_iscd') then
    --                 return 'override'
    --             end
    --             return false
    --         end
    --         return false
    --     end
    -- }
    {
        action = 'ATTACK',
        sg = 'lol_wp_shotgun',
        testfn = function (inst, action, ...)
            if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.components.health:IsDead()) then
                local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
                if weapon and weapon:HasTag("lol_wp_shotgun") then
                    return true
                end
            end
            return false
        end,
        testfn_client = function (inst, action, ...)
            if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or IsEntityDead(inst)) then
                local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if equip and equip:HasTag("lol_wp_shotgun") then
                    return true
                end
            end
            return false
        end
    },
    {
        action = 'ATTACK',
        sg = 'gallop_triple_atk',
        testfn = function (inst, action, ...)
            if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.components.health:IsDead()) then
                local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
                if weapon and weapon:HasTag("lol_wp_s12_malignance_tri_atk") then
                    if action.target ~= nil and not action.target:HasTag('cant_be_lol_wp_s12_malignance_tri_atk') then
                        return true
                    end
                    -- return 'override'
                end
            end
            return false
        end,
        testfn_client = function (inst, action, ...)
            if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or IsEntityDead(inst)) then
                local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if equip and equip:HasTag("lol_wp_s12_malignance_tri_atk") then
                    if action.target ~= nil and not action.target:HasTag('cant_be_lol_wp_s12_malignance_tri_atk') then
                        return true
                    end
                    -- return 'override'
                end
            end
            return false
        end
    },
}
return data