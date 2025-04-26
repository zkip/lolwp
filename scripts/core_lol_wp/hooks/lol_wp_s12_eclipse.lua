local db = TUNING.MOD_LOL_WP.ECLIPSE

AddComponentPostInit('combat',
---comment
---@param self component_combat
function (self)
    local old_GetAttacked = self.GetAttacked
    function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
        ---@type ent
        local victim = self.inst
        -- 主动：【新月打击】 是否在使用技能
        if attacker and attacker.is_lol_wp_s12_eclipse_skill_newmoon_strike and victim then
            damage = 0
            if spdamage == nil then
                spdamage = {}
            end
            spdamage['planar'] = db.SKILL_NEWMOON_STRIKE.LASER_PLANAR_DMG
        end
        if weapon and weapon.prefab and weapon.prefab == 'lol_wp_s12_eclipse' then
            -- 对暗影阵营伤害增加20%
            if victim and victim:HasTag('shadow_aligned') then
                if damage then
                    damage = damage * db.DMGMULT_TO_SHADOW
                end
                if spdamage then
                    for name,_ in pairs(spdamage) do
                        spdamage[name] = spdamage[name] * db.DMGMULT_TO_SHADOW
                    end
                end
            end
            -- -- 和亮茄头盔，亮茄盔甲同时装备时，武器获得带电效果。
            -- -- "lunarplanthat" "armor_lunarplant"
            -- if attacker then
            --     local allequips = LOLWP_S:getAllEquipments(attacker)
            --     if allequips['lunarplanthat'] and allequips['armor_lunarplant'] then
            --         stimuli = 'electric'
            --         LOLWP_S:declare('double equip')
            --     end
            -- end
        end
        return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
    end

    -- local old_DoAttack = self.DoAttack
    -- function self:DoAttack(targ,weapon,projectile,stimuli,instancemult,instrangeoverride,instpos,...)
    --     local attacker = self.inst
    --     if weapon == nil then
    --         weapon = self:GetWeapon()
    --     end
    --     if weapon and weapon.prefab and weapon.prefab == 'lol_wp_s12_eclipse' then
    --         if attacker then
    --             local allequips = LOLWP_S:getAllEquipments(attacker)
    --             if allequips['lunarplanthat'] and allequips['armor_lunarplant'] then
    --                 stimuli = 'electric'
    --             end
    --         end
    --     end
    --     return old_DoAttack(self,targ,weapon,projectile,stimuli,instancemult,instrangeoverride,instpos,...)
    -- end
end)




-- 被动：【永升之月】

--  每第2次攻击会造成敌方最大生命值6%的额外位面伤害，

--  并为你提供持续2秒的无敌护盾，

--  冷却时间6秒。

--  （触发时附带特效：crab_king_shine）

---@class ent
---@field lol_wp_s12_eclipse_skill_evermoon_stack integer # 【星蚀】 被动：【永升之月】 当前攻击次数

AddComponentPostInit('combat',
---comment
---@param self component_combat
function (self)
    local old_GetAttacked = self.GetAttacked
    function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
        local victim = self.inst
        -- 永生之月 不要触发 【新月打击】
        if attacker and not attacker.is_lol_wp_s12_eclipse_skill_newmoon_strike then
            if attacker and LOLWP_S:checkAlive(attacker) and weapon and weapon.prefab and weapon.prefab == 'lol_wp_s12_eclipse' and victim and victim.components.health and weapon.components.lol_wp_cd_itemtile and not weapon.components.lol_wp_cd_itemtile:IsCD() then
                weapon.lol_wp_s12_eclipse_skill_evermoon_stack = (weapon.lol_wp_s12_eclipse_skill_evermoon_stack or 0) + 1
                if weapon.lol_wp_s12_eclipse_skill_evermoon_stack >= db.SKILL_EVERMOON.ATK_COUNT_DO_EXTRA then
                    weapon.lol_wp_s12_eclipse_skill_evermoon_stack = weapon.lol_wp_s12_eclipse_skill_evermoon_stack % db.SKILL_EVERMOON.ATK_COUNT_DO_EXTRA
                    -- 造成敌方最大生命值6%的额外位面伤害，
                    if spdamage == nil then
                        spdamage = {}
                    end
                    local victim_maxhp = victim.components.health:GetMaxWithPenalty()
                    local bonus = victim_maxhp * db.SKILL_EVERMOON.ENEMY_MAXHP_RATE_PLANAR_DMG
                    spdamage['planar'] = (spdamage['planar'] or 0) + bonus

                    -- CD
                    weapon.components.lol_wp_cd_itemtile:ForceStartCD()

                    -- 提供持续2秒的无敌护盾，
                    local skin = weapon:GetSkinName()
                    local shield_color = {5/255,253/255,227/255,1}
                    if skin then
                        if skin == 'lol_wp_s12_eclipse_skin_excalibur' then
                            shield_color = {1,231/255,25/255,1}
                        end
                    end

                    local shield = SpawnPrefab('forcefieldfx')
                    shield.AnimState:SetAddColour(unpack(shield_color))
                    shield.entity:SetParent(attacker.entity)

                    attacker.components.health:SetInvincible(true)
                    attacker:DoTaskInTime(db.SKILL_EVERMOON.SHIELD_DURATION,function()
                        if shield and shield:IsValid() then
                            shield:Remove()
                        end
                        if attacker and attacker.components.health then
                            attacker.components.health:SetInvincible(false)
                        end
                    end)

                    -- 触发时附带特效
                    SpawnPrefab('crab_king_shine').Transform:SetPosition(victim:GetPosition():Get())

                end
            end
        end
        return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
    end
end)

-- 击败天体英雄100%掉落蓝图
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
        inst.components.lootdropper:AddChanceLoot('lol_wp_s12_eclipse_blueprint',db.BLUEPRINTDROP_CHANCE.alterguardian_phase3)
        return unpack(res)
    end)
    -- inst:ListenForEvent('death',function (inst, data)
    --     LOLWP_S:declare('death')
    --     LOLWP_S:flingItem(SpawnPrefab('lol_wp_s12_eclipse_blueprint'),inst:GetPosition())
    -- end)
end)

--[[ 
-- 星蚀的激光，末端貌似会拆建筑
AddComponentPostInit('workable',
---comment
---@param self component_workable
function (self)
    local old_Destroy = self.Destroy
    function self:Destroy(destroyer,...)
        local inst = self.inst
        if destroyer and destroyer.is_lol_wp_s12_eclipse_skill_newmoon_strike then
            if inst:HasTag('structure') then
                return
            end
        end
        return old_Destroy(self,destroyer,...)
    end
end)

 ]]