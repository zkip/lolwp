---@diagnostic disable: undefined-global

-- 掉落蓝图
-- 蓝图
for k,v in pairs(TUNING.MOD_LOL_WP.OVERLORDBLOOD.BLUEPRINTDROP_CHANCE) do
    AddPrefabPostInit(string.lower(k), function(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        if not inst.components.lootdropper then
            inst:AddComponent('lootdropper')
        end
        local old_lootsetupfn = inst.components.lootdropper.lootsetupfn
        inst.components.lootdropper:SetLootSetupFn(function (...)
            local res = old_lootsetupfn ~= nil and {old_lootsetupfn(...)} or {}
            inst.components.lootdropper:AddChanceLoot('lol_wp_overlordbloodarmor_blueprint',v)
            return unpack(res)
        end)
    end)
end

-- 被动
AddComponentPostInit('combat',
---comment
---@param self component_combat
function (self)
    local old_GetAttacked = self.GetAttacked
    function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
        if attacker and attacker:HasTag("player") and attacker.components.health and attacker.components.inventory:EquipHasTag('lol_wp_overlordbloodarmor') then
            local allow_calc = true
            if weapon and weapon.components.lol_wp_type and weapon.prefab then
                local weapon_type = weapon.components.lol_wp_type:GetType()
                if weapon_type == 'mage' then
                    allow_calc = false
                end
            end
            if allow_calc then
                local maxhealth = attacker.components.health.maxhealth
                if maxhealth then
                    if stimuli and stimuli == 'lol_wp_trinity_terraprisma' then
                        -- local player_dmgmult = attacker.components.combat.damagemultiplier or 1
                        -- local player_extramult = attacker.components.combat.externaldamagemultipliers:Get()

                        local extra_atk = TUNING.MOD_LOL_WP.OVERLORDBLOOD.SKILL_MAXHP_TO_ATK * maxhealth
                        local lost_hp = (1-attacker.components.health:GetPercent()) * maxhealth
                        local extra_atk2 = lost_hp * TUNING.MOD_LOL_WP.OVERLORDBLOOD.SKILL_LOSTHP_TO_ATK

                        damage = (damage or 0) + extra_atk + extra_atk2
                        -- damage = damage * player_dmgmult * player_extramult
                    else
                        -- 被动：【专横】将玩家5%最大生命值转化为额外攻击力。
                        local extra_atk = TUNING.MOD_LOL_WP.OVERLORDBLOOD.SKILL_MAXHP_TO_ATK * maxhealth
                        if damage then
                            damage = damage + extra_atk
                        end
                        -- 被动：【报复】获得损失生命值10%的攻击力提升
                        local lost_hp = (1-attacker.components.health:GetPercent()) * maxhealth
                        local extra_atk2 = lost_hp * TUNING.MOD_LOL_WP.OVERLORDBLOOD.SKILL_LOSTHP_TO_ATK
                        if damage then
                            damage = damage + extra_atk2
                        end
                    end
                end
            end
        end
        return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
    end
end)


AddComponentPostInit('equippable',function (self)
    local old_IsRestricted = self.IsRestricted
    function self:IsRestricted(target,...)
        if self.inst.prefab == 'lol_wp_overlordbloodarmor' then
            if self.inst:HasTag('lol_wp_overlordbloodarmor_nofiniteuses') then
                return true
            end
        end
        return old_IsRestricted(self,target,...)
    end
end)

AddClassPostConstruct("components/equippable_replica", function(self)
    local old_IsRestricted = self.IsRestricted
    function self:IsRestricted(target,...)
        if self.inst.prefab == 'lol_wp_overlordbloodarmor' then
            if self.inst:HasTag('lol_wp_overlordbloodarmor_nofiniteuses') then
                return true
            end
        end
        return old_IsRestricted(self,target,...)
    end
end)