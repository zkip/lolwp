local prefab_id = 'lol_wp_s8_lichbane'
AddComponentPostInit('combat', function(self)
    local old_GetAttacked = self.GetAttacked
    function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
        if weapon and weapon.prefab and weapon.prefab == prefab_id then
            if not weapon.lol_wp_s8_lichbane_nofuel then
                -- 对月亮阵营生物伤害增加10%，
                if self.inst and self.inst:HasTag("lunar_aligned") then
                    if damage then
                        damage = damage * TUNING.MOD_LOL_WP.LICHBANE.DMGMULT_TO_PLANAR
                    end
                    if spdamage and spdamage['planar'] then
                        spdamage['planar'] = spdamage['planar'] * TUNING.MOD_LOL_WP.LICHBANE.DMGMULT_TO_PLANAR
                    end
                end
                -- 被动：【咒刃】
                if weapon.components.rechargeable and weapon.components.rechargeable:IsCharged() then
                    if damage then
                        damage = damage * TUNING.MOD_LOL_WP.LICHBANE.SKILL_CURSEBLADE.DMGMULT
                    end
                    if spdamage and spdamage['planar'] then
                        spdamage['planar'] = spdamage['planar'] * TUNING.MOD_LOL_WP.LICHBANE.SKILL_CURSEBLADE.DMGMULT
                    end
                    local pos = self.inst:GetPosition()
                    SpawnPrefab('crab_king_shine').Transform:SetPosition(pos:Get())
                    weapon.components.rechargeable:Discharge(TUNING.MOD_LOL_WP.LICHBANE.SKILL_CURSEBLADE.CD)
                end
                -- 被动：【祸源】 FLAG
                local victim = self.inst
                if victim.taskintime_lol_wp_s8_lichbane_skill_curserace then
                    victim.taskintime_lol_wp_s8_lichbane_skill_curserace:Cancel()
                    victim.taskintime_lol_wp_s8_lichbane_skill_curserace = nil
                end
                victim.lol_wp_s8_lichbane_skill_curserace = true
                victim.taskintime_lol_wp_s8_lichbane_skill_curserace = victim:DoTaskInTime(TUNING.MOD_LOL_WP.LICHBANE.SKILL_CURSERACE.LAST,function()
                    if victim and victim:IsValid() then
                        victim.lol_wp_s8_lichbane_skill_curserace = false
                    end
                    if victim.taskintime_lol_wp_s8_lichbane_skill_curserace then
                        victim.taskintime_lol_wp_s8_lichbane_skill_curserace:Cancel()
                        victim.taskintime_lol_wp_s8_lichbane_skill_curserace = nil
                    end
                end)
            end
        end
        return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
    end
end)

-- 被动：【祸源】
AddComponentPostInit('combat', function(self)
    local old_GetAttacked = self.GetAttacked
    function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
        local victim = self.inst
        if victim and victim.lol_wp_s8_lichbane_skill_curserace then
            if damage then
                damage = damage*TUNING.MOD_LOL_WP.LICHBANE.SKILL_CURSERACE.DMGMULT
            end
            if spdamage and spdamage['planar'] then
                spdamage['planar'] = spdamage['planar'] * TUNING.MOD_LOL_WP.LICHBANE.SKILL_CURSERACE.DMGMULT
            end
        end
        return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
    end
end)

-- 击败附身座狼75%掉落一个巫妖之祸
AddPrefabPostInit("mutatedwarg", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    if not inst.components.lootdropper then
        inst:AddComponent('lootdropper')
    end
    local old_lootsetupfn = inst.components.lootdropper.lootsetupfn
    inst.components.lootdropper:SetLootSetupFn(function (...)
        local res = old_lootsetupfn ~= nil and {old_lootsetupfn(...)} or {}
        inst.components.lootdropper:AddChanceLoot(prefab_id,TUNING.MOD_LOL_WP.LICHBANE.DROP_CHANCE.mutatedwarg)
        return unpack(res)
    end)
end)