AddComponentPostInit('combat',function (self)
    LOLWP_S:hookFn(self,'GetAttacked',function (self,attacker,damage,weapon,stimuli,spdamage, ...)
        local victim = self.inst
        if victim and attacker and attacker:HasTag("player") then
            local equips,found = LOLWP_S:findEquipments(attacker,'lol_wp_s9_guider')
            if found then

                if victim and victim.components.locomotor then
                    victim.components.locomotor:SetExternalSpeedMultiplier(victim,'lol_wp_s9_guider_debuff',TUNING.MOD_LOL_WP.GUIDER.SKILL_GUIDE.ATK_SPEEDDOWN)
                end
                if victim.taskintime_lol_wp_s9_guider_debuff then
                    victim.taskintime_lol_wp_s9_guider_debuff:Cancel()
                    victim.taskintime_lol_wp_s9_guider_debuff = nil
                end
                victim.taskintime_lol_wp_s9_guider_debuff = victim:DoTaskInTime(TUNING.MOD_LOL_WP.GUIDER.SKILL_GUIDE.LAST,function()
                    if victim and victim.components.locomotor then
                        victim.components.locomotor:RemoveExternalSpeedMultiplier(victim,'lol_wp_s9_guider_debuff')
                    end
                end)

                for _,v in pairs(equips) do
                    if v.components.rechargeable and v.components.rechargeable:IsCharged() then
                        v.components.rechargeable:Discharge(TUNING.MOD_LOL_WP.GUIDER.SKILL_GUIDE.CD)
                    end
                end
            end
        end
    end)
end)

--[[ 
-- 暖石加热
local MAX_TEMP = 61
local inerval = 1
local per_add = 2 -- >=2

AddPrefabPostInit('heatrock',function (inst)
    if not TheWorld.ismastersim then
        return inst
    end
    inst:ListenForEvent('onputininventory',function ()
        local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
        if owner and owner.prefab and owner.prefab == 'lol_wp_s9_guider' then
            if inst.taskperiod_heatrock_in_lol_wp_s9_guider == nil then
                inst.taskperiod_heatrock_in_lol_wp_s9_guider = inst:DoPeriodicTask(inerval,function()
                    if inst and inst.components.temperature then
                        local cur = inst.components.temperature:GetCurrent()
                        local new = cur + per_add
                        inst.components.temperature:SetTemperature(math.min(MAX_TEMP,new))
                    end
                end)
            end
        end
    end)
    inst:ListenForEvent('ondropped',function ()
        if inst.taskperiod_heatrock_in_lol_wp_s9_guider then
            inst.taskperiod_heatrock_in_lol_wp_s9_guider:Cancel()
            inst.taskperiod_heatrock_in_lol_wp_s9_guider = nil
        end
    end)
end)

 ]]