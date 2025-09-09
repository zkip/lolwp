-- AddComponentPostInit('combat',
-- ---comment
-- ---@param self component_combat
-- function (self)
--     local old_GetAttacked = self.GetAttacked
--     function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
--         -- 如果武器有组件并且启用了
--         if weapon and weapon.components.lol_wp_critical_hit and weapon.components.lol_wp_critical_hit:IsEnabled() then
--             -- 如果发生暴击
--             if math.random() < weapon.components.lol_wp_critical_hit:GetCriticalChanceWithModifier() then

--                 local on_critical_hit_fn = weapon.components.lol_wp_critical_hit.on_critical_hit_fn
--                 if on_critical_hit_fn then
--                     on_critical_hit_fn(weapon,self.inst,attacker)
--                 end

--                 local dmgmult = weapon.components.lol_wp_critical_hit:GetCriticalDamageWithModifier()
--                 if damage then
--                     if weapon.components.lol_wp_critical_hit.affect_physical_damage then
--                         damage = damage * dmgmult
--                     end
--                 end
--                 if spdamage then
--                     local affect_spdamage_types = weapon.components.lol_wp_critical_hit.affect_spdamage_types
--                     if affect_spdamage_types then
--                         if affect_spdamage_types == 'all' then
--                             for k,_ in pairs(spdamage) do
--                                 spdamage[k] = spdamage[k] * dmgmult
--                             end
--                         elseif type(affect_spdamage_types) == 'table' then
--                             for _,v in ipairs(affect_spdamage_types) do
--                                 if spdamage[v] then
--                                     spdamage[v] = spdamage[v] * dmgmult
--                                 end
--                             end
--                         end
--                     end
--                 end
--             end
--         end
--         return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
--     end
-- end)

-- ---@type SourceModifierList
-- local SourceModifierList = require("util/sourcemodifierlist")


local critical_weapons_map = { -- 允许使用暴击系统的武器
    lol_wp_s13_infinity_edge = true,
    lol_wp_s13_statikk_shiv = true,
    lol_wp_s13_statikk_shiv_charged = true,
    lol_wp_s13_collector = true,

    lol_wp_s18_bloodthirster = true,
    lol_wp_s18_stormrazor_nosaya = true,
    lol_wp_s18_krakenslayer = true,
}

local normal_weapon_cd_mult = 1.5 -- 普通武器暴击伤害倍率


-- 更改为人物组件

AddPlayerPostInit(function (inst)
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent('lol_wp_critical_hit_player')
    inst:AddComponent('lol_wp_player_dmg_adder')
    inst:AddComponent('lol_wp_player_invincible') -- 无敌
end)

---@class component_combat
---@field modifier_lol_wp_dmg_adder SourceModifierList # 加算修饰: 固定伤害加成

AddComponentPostInit('combat',
---comment
---@param self component_combat
function (self)

    local old_DoAttack = self.DoAttack
    function self:DoAttack(targ,weapon,projectile,stimuli,instancemult,instrangeoverride,instpos,...)


        -- 卢登的回声 后续弹跳伤害减少
        if projectile and projectile.prefab and projectile.prefab == 'lol_wp_s17_luden_projectile_fx_divine' then
            if weapon then
                weapon.lol_wp_s17_luden_projectile_fx_divine = true
            end
        end
        local res = old_DoAttack ~= nil and {old_DoAttack(self,targ,weapon,projectile,stimuli,instancemult,instrangeoverride,instpos,...)} or {}
        if weapon then
            weapon.lol_wp_s17_luden_projectile_fx_divine = nil
        end
        return unpack(res)
    end

    local old_GetAttacked = self.GetAttacked
    function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
        local victim = self.inst
        -- 如果无敌 则不继续执行
        if victim and victim.components.lol_wp_player_invincible then
            if victim.components.lol_wp_player_invincible:IsInvincible() then
                victim:PushEvent("blocked", { attacker = attacker })
                return false
            end
        end

        -- 筛选一些情况,不用继续计算加成等
        local allow_to_continue = true
        -- / 护符三项不吃伤害加成
        if allow_to_continue and stimuli and stimuli == 'lol_wp_trinity_terraprisma' and attacker and attacker.damage_from_lol_wp_trinity_terraprisma_amulet then
            -- / 但是狂妄又能给护符三项加成,单独计算
            if attacker and attacker.components.lol_wp_player_dmg_adder then
                local val_1 = attacker.components.lol_wp_player_dmg_adder.physical:CalculateModifierFromKey('lol_wp_s14_hubris')
                local val_2 = attacker.components.lol_wp_player_dmg_adder.physical:CalculateModifierFromKey('lol_wp_s14_hubrisskill_reputation')
                damage = (damage or 0) + (val_1 or 0) + (val_2 or 0)
            end
            -- / 护符三项不吃伤害加成
            allow_to_continue = false
        end
        -- / 约束静电
        if allow_to_continue and self.inst.prefab and self.inst.prefab == 'moonstorm_static' then
            damage = 0
            spdamage = nil
            allow_to_continue = false
        end

        -- / S15 破碎王后之冕  被动：【护卫 佩戴时生成一个铥矿皇冠同样的护盾 免疫所有伤害
        if allow_to_continue and self.inst and self.inst.lol_wp_s15_crown_of_the_shattered_queen_invincible then
            damage = 0
            spdamage = {}
            stimuli = nil
            allow_to_continue = false
        end

        -- / S15 中娅沙漏  主动：【凝滞 在3秒内免疫所有伤害 阻止推送挨打事件
        if allow_to_continue and self.inst.lol_wp_s15_zhonya_invincible then
            damage = 0
            spdamage = {}
            stimuli = nil
            allow_to_continue = false
        end

        -- 计算
        if allow_to_continue then
            -------------------------------------
            local weapon_prefab = weapon and weapon.prefab or nil
            if spdamage == nil then
                spdamage = {}
            end

            -- 键prefab id,值是装备
            local allequips = {}
            if attacker then
                allequips = LOLWP_S:getAllEquipments(attacker)
            end
            -------------------------------------
            -- 卢登的回声 后续弹跳伤害减少
            if weapon and weapon.prefab == 'lol_wp_s17_luden' and weapon.lol_wp_s17_luden_projectile_fx_divine then
                if spdamage == nil then
                    spdamage = {}
                end
                spdamage.planar = TUNING.MOD_LOL_WP.LUDEN.SKILL_ECHO.PLANAR_DMG
            end

            -- s18 饮血剑 和虚空风帽，虚空长袍同时装备时，获得额外5点吸血和10点位面伤害。
            if weapon and weapon.prefab == 'lol_wp_s18_bloodthirster' and weapon.components.finiteuses and attacker and attacker:HasTag('player') and victim and not victim:HasTag('wall') and not victim:HasTag('structure') then
                local drain = TUNING.MOD_LOL_WP.BLOODTHIRSTER.DRAIN

                local equip1,found1 = LOLWP_S:findEquipments(attacker,"voidclothhat")
                if found1 then
                    local equip2,found2 = LOLWP_S:findEquipments(attacker,"armor_voidcloth")
                    if found2 then
                        drain = drain + TUNING.MOD_LOL_WP.BLOODTHIRSTER.SUITE_EFFECT.DRAIN

                        if spdamage == nil then
                            spdamage = {}
                        end
                        spdamage.planar = (spdamage.planar or 0) + TUNING.MOD_LOL_WP.BLOODTHIRSTER.SUITE_EFFECT.PLANAR_DMG
                    end
                else
                    equip1,found1 = LOLWP_S:findEquipments(attacker,"lol_wp_overlordbloodarmor")
                    if found1 then
                        local equip2,found2 = LOLWP_S:findEquipmentsWithKeywords(attacker,{"lol_wp_demonicembracehat"})
                        if found2 then
                            drain = drain + TUNING.MOD_LOL_WP.BLOODTHIRSTER.SUITE_EFFECT_2.DRAIN

                            if spdamage == nil then
                                spdamage = {}
                            end
                            spdamage.planar = (spdamage.planar or 0) + TUNING.MOD_LOL_WP.BLOODTHIRSTER.SUITE_EFFECT_2.PLANAR_DMG
                        end
                    end
                end

                if attacker and LOLWP_S:checkAlive(attacker) then
                    attacker.components.health:DoDelta(drain)

                    local maxhp = attacker.components.health.maxhealth
                    local curhp = attacker.components.health.currenthealth
                    local should_repair = curhp + drain - maxhp
                    if should_repair > 0 then
                        if weapon.components.finiteuses then
                            weapon.components.finiteuses:Repair(should_repair)
                        end
                    end
                end
            end

            -- lol_wp_player_dmg_adder 额外攻击力加成
            if attacker and attacker.components.lol_wp_player_dmg_adder then
                -- 是否允许物理伤害加算加成
                local allow_physical_add = true
                if weapon and weapon.prefab then
                    if weapon.components.lol_wp_type then
                        local weapon_type = weapon.components.lol_wp_type:GetType()
                        if weapon_type == 'mage' then -- 法师武器不能加成物理伤害
                            allow_physical_add = false
                        end
                    end
                end
                -- 允许物理伤害加算加成
                if allow_physical_add then
                    local physical_add = attacker.components.lol_wp_player_dmg_adder.physical:Get()
                    damage = (damage or 0) + physical_add
                end
                -- 位面伤害加成
                if spdamage == nil then
                    spdamage = {}
                end
                for k,v in pairs(attacker.components.lol_wp_player_dmg_adder.spdamage) do
                    local spd_add = v:Get()
                    spdamage[k] = (spdamage[k] or 0) + spd_add
                end

                -- 物理伤害乘算加成
                local physical_mult = attacker.components.lol_wp_player_dmg_adder.mult_physical:Get()
                damage = (damage or 0) * physical_mult

                -- 位面伤害乘算加成
                for k,v in pairs(attacker.components.lol_wp_player_dmg_adder.mult_spdamage) do
                    local spd_mult = v:Get()
                    spdamage[k] = (spdamage[k] or 0) * spd_mult
                end

                -- 执行击中函数
                attacker.components.lol_wp_player_dmg_adder:RunOnHitAlways(self.inst)
            end

            --------------------
            -- 单独处理

            -- 星蚀 亮茄头盔 亮茄盔甲 同时装备 +20位面伤害
            if allequips['lol_wp_s12_eclipse'] and allequips["lunarplanthat"] and allequips["armor_lunarplant"] then
                spdamage.planar = (spdamage.planar or 0) + TUNING.MOD_LOL_WP.ECLIPSE.SUIT_PLANAR_DMG
            end

            -- s19 大天使之杖 被动：【敬畏】获得2%最大理智值的额外位面伤害
            local sanity_max = attacker and attacker.components.sanity and attacker.components.sanity.max
            if weapon_prefab and sanity_max then
                local extra_lol_wp_s19_archangelstaff_san_percent = (weapon_prefab == 'lol_wp_s19_archangelstaff' and TUNING.MOD_LOL_WP.ARCHANGELSTAFF.SKILL_FEAR.PLANAR_DMG_MAXSANPERCENT) or (weapon_prefab == 'lol_wp_s19_archangelstaff_upgrade' and TUNING.MOD_LOL_WP.ARCHANGELSTAFF.UPGRADE.SKILL_FEAR.PLANAR_DMG_MAXSANPERCENT) or 0
                if extra_lol_wp_s19_archangelstaff_san_percent > 0 then
                    local extra_lol_wp_s19_archangelstaff_san_dmg = sanity_max * extra_lol_wp_s19_archangelstaff_san_percent
                    if spdamage then
                        spdamage.planar = (spdamage.planar or 0) + extra_lol_wp_s19_archangelstaff_san_dmg
                    end
                end
            end

            -- s19 魔宗  被动：【敬畏】获得2%最大理智值的额外物理伤害。
            -- if weapon_prefab and sanity_max then
            --     local physics_extra_lol_wp_s19_archangelstaff_san_percent = (weapon_prefab == 'lol_wp_s19_muramana' and TUNING.MOD_LOL_WP.MURAMANA.SKILL_FEAR.SAN_PERCENT) or (weapon_prefab == 'lol_wp_s19_muramana_upgrade' and TUNING.MOD_LOL_WP.MURAMANA.UPGRADE.SKILL_FEAR.SAN_PERCENT) or 0
            --     local planar_extra_lol_wp_s19_archangelstaff_san_percent = (weapon_prefab == 'lol_wp_s19_muramana_upgrade' and TUNING.MOD_LOL_WP.MURAMANA.UPGRADE.SKILL_SLASH.SAN_PERCENT) or 0
            --     if physics_extra_lol_wp_s19_archangelstaff_san_percent > 0 then
            --         local extra_physics_dmg = sanity_max * physics_extra_lol_wp_s19_archangelstaff_san_percent
            --         damage = (damage or 0) + extra_physics_dmg
            --     end
            --     if planar_extra_lol_wp_s19_archangelstaff_san_percent > 0 then
            --         local extra_planar_dmg = sanity_max * planar_extra_lol_wp_s19_archangelstaff_san_percent
            --         if spdamage then
            --             spdamage.planar = (spdamage.planar or 0) + extra_planar_dmg
            --         end
            --     end
            -- end

            -- s19 凛冬  被动：【冰川增幅】与兰德里的折磨同时装备时获得套装效果，每次攻击造成额外20%减速，并使该目标伤害降低20%，持续1.5秒，无冷却。
            if attacker and victim then
                local equip1,found1 = LOLWP_S:findEquipments(attacker,"lol_wp_s19_fimbulwinter_armor_upgrade")
                if found1 then
                    local equip2,found2 = LOLWP_S:findEquipmentsWithKeywords(attacker,{"lol_wp_s17_liandry"})
                    if found2 then
                        if victim.taskintime_lol_wp_s19_fimbulwinter_armor_upgrade_debuff ~= nil then
                            victim.taskintime_lol_wp_s19_fimbulwinter_armor_upgrade_debuff:Cancel()
                            victim.taskintime_lol_wp_s19_fimbulwinter_armor_upgrade_debuff = nil
                        end

                        if victim.components.locomotor then
                            victim.components.locomotor:SetExternalSpeedMultiplier(attacker,'lol_wp_s19_fimbulwinter_armor_upgrade',TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.SKILL_ICERAISE.SPEEDDOWN)
                        end
                        if victim.components.combat then
                            victim.components.combat.externaldamagemultipliers:SetModifier(attacker,TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.SKILL_ICERAISE.DOWN_TARGET_ATK,'lol_wp_s19_fimbulwinter_armor_upgrade')
                        end

                        victim.taskintime_lol_wp_s19_fimbulwinter_armor_upgrade_debuff = victim:DoTaskInTime(TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.SKILL_ICERAISE.DURATION,function()
                            if victim then
                                if victim.components.locomotor then
                                    victim.components.locomotor:RemoveExternalSpeedMultiplier(attacker,'lol_wp_s19_fimbulwinter_armor_upgrade')
                                end
                                if victim.components.combat then
                                    victim.components.combat.externaldamagemultipliers:RemoveModifier(attacker,'lol_wp_s19_fimbulwinter_armor_upgrade')
                                end
                            end
                        end)
                    end
                end
            end

            -- 大面具改动 使用月亮阵营武器会额外增伤10%
            if attacker and attacker:HasTag('player') and weapon and weapon:HasTag('lunar_aligned') then
                local equips,found = LOLWP_S:findEquipments(attacker,'lol_wp_s17_liandry')
                if found then
                    damage = (damage or 0) * TUNING.MOD_LOL_WP.LIANDRY.DMGMULT_TO_SHADOW
                    if spdamage then
                        spdamage.planar = (spdamage.planar or 0) * TUNING.MOD_LOL_WP.LIANDRY.DMGMULT_TO_SHADOW
                    end
                end
            end
            -- S15 破碎王后之冕 被动：【哀悼】 与破败王者之刃同时装备时，其伤害提升20%。
            if weapon and weapon.prefab and weapon.prefab == 'gallop_brokenking' and attacker and attacker.when_equip_brokenking_and_crown_of_the_shattered_queen then
                local dmgmult = TUNING.MOD_LOL_WP.CROWN_OF_THE_SHATTERED_QUEEN.SKILL_MOURN.DMGMULT
                damage = (damage or 0) * dmgmult
                if spdamage then
                    for k,_ in pairs(spdamage) do
                        spdamage[k] = (spdamage[k] or 0) * dmgmult
                    end
                end
            end

            -- s18 海妖杀手 被动：【捕鲸手】 对水上生物造成双倍伤害
            local victim_x,_,victim_z = victim:GetPosition():Get()
            local tile = TheWorld.Map:GetTileAtPoint(victim_x,0,victim_z)
            -- local platform = TheWorld.Map:GetPlatformAtPoint(victim_x,0,victim_z)
            if tile >= 201 and tile <= 208 then
            -- print(TileGroupManager:IsOceanTile(tile))
            -- print()
            -- if TileGroupManager:IsOceanTile(tile) then
            -- if platform == nil then
                damage = (damage or 0) * TUNING.MOD_LOL_WP.KRAKENSLAYER.SKILL_KUJIRA.DMGMULT_TO_MOB_ON_WATER
                if spdamage then
                    for k,_ in pairs(spdamage) do
                        spdamage[k] = (spdamage[k] or 0) * TUNING.MOD_LOL_WP.KRAKENSLAYER.SKILL_KUJIRA.DMGMULT_TO_MOB_ON_WATER
                    end
                end
            end

            -- 暴击 最后处理
            -- if weapon_prefab and critical_weapons_map[weapon_prefab] then -- 只有这张表里的武器才能暴击
            if weapon_prefab then -- 临时让所有的武器可以暴击
                if attacker and attacker.components.lol_wp_critical_hit_player then
                    attacker.components.lol_wp_critical_hit_player:RunOnHit(self.inst)
                    if math.random() < attacker.components.lol_wp_critical_hit_player:GetCriticalChanceWithModifier() then
                        -- local dmgmult = attacker.components.lol_wp_critical_hit_player:GetCriticalDamageWithModifier()
                        -- 普通武器暴击伤害倍率 
                        local dmgmult = normal_weapon_cd_mult
                        if critical_weapons_map[weapon_prefab] then
                            dmgmult = attacker.components.lol_wp_critical_hit_player:GetCriticalDamageWithModifier()
                        end
                        -- 是否允许暴击
                        local allow_cc = true
                        if weapon and weapon.prefab then
                            if weapon.components.lol_wp_type then
                                local weapon_type = weapon.components.lol_wp_type:GetType()
                                if weapon_type == 'mage' then -- 法师武器不能暴击造成物理伤害
                                    allow_cc = false
                                end
                            end
                        end
                        if allow_cc then
                            if damage then
                                damage = damage * dmgmult
                            end
                        end

                        -- if spdamage then
                        --     for k,_ in pairs(spdamage) do
                        --         spdamage[k] = spdamage[k] * dmgmult
                        --     end
                        -- end
                        attacker.components.lol_wp_critical_hit_player:RunOnCriticalHit(self.inst)
                    end
                end
            end

            if attacker and attacker.components.lol_wp_critical_hit_player then
                attacker.components.lol_wp_critical_hit_player:RunOnHitAlways(self.inst)
            end
        end
        return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
    end
end)



AddComponentPostInit('health',
---comment
---@param self component_health
function (self)
    local old_DoDelta = self.DoDelta
    function self:DoDelta(amount,overtime,cause,ignore_invincible,afflicter,ignore_absorb,...)
        -- 中娅沙漏  主动：【凝滞 在3秒内免疫所有伤害 防止有人拦在我后面
        if self.inst.lol_wp_s15_zhonya_invincible then
            if amount < 0 then
                amount = 0
            end
        end
        --  无敌组件
        if self.inst.components.lol_wp_player_invincible then
            if self.inst.components.lol_wp_player_invincible:IsInvincible() then
                if amount < 0 then
                    amount = 0
                end
            end
        end
        return old_DoDelta(self,amount,overtime,cause,ignore_invincible,afflicter,ignore_absorb,...)
    end


    local old_SetVal = self.SetVal
    function self:SetVal(val,cause,afflicter,...)
        -- 中娅沙漏  主动：【凝滞 在3秒内免疫所有伤害 防止有人拦在我后面
        if self.inst.lol_wp_s15_zhonya_invincible then
            if val < 0 then
                return
            end
        end
        --  无敌组件
        if self.inst.components.lol_wp_player_invincible then
            if self.inst.components.lol_wp_player_invincible:IsInvincible() then
                if val < 0 then
                    return
                end
            end
        end
        if self.inst.prefab and self.inst.prefab == 'moonstorm_static' then
            if val < 0 then
                return
            end
        end
        return old_SetVal(self,val,cause,afflicter,...)
    end
end)