local prefab_id = 'lol_wp_s8_deathcap'
AddComponentPostInit('combat', function(self)
    local old_GetAttacked = self.GetAttacked
    function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
        if stimuli and stimuli == 'lol_wp_trinity_terraprisma' and attacker and attacker.damage_from_lol_wp_trinity_terraprisma_amulet then
        else
            if attacker and attacker.components.inventory and attacker.components.inventory:EquipHasTag(prefab_id) then
                if spdamage == nil then
                    spdamage = {}
                end
                -- 使每次攻击附带额外40点位面伤害
                spdamage['planar'] = (spdamage['planar'] or 0) + TUNING.MOD_LOL_WP.DEATHCAP.SKILL_MAGIC.WEAR_INCREASE_PLANAR_DMG
                -- 佩戴时会使当前造成的位面伤害提升35%，
                spdamage['planar'] = spdamage['planar'] * TUNING.MOD_LOL_WP.DEATHCAP.SKILL_MAGIC.WEAR_INCREASE_PLANAR_DMG_MULT
                -- 使用暗影物品会额外增伤20%
                if weapon and weapon:HasTag("shadow_item") then
                    if damage then
                        damage = damage * TUNING.MOD_LOL_WP.DEATHCAP.WEAR_INCREASE_SHADOW_WEAPON_DMGMULT
                    end
                    if spdamage['planar'] then
                        spdamage['planar'] = spdamage['planar'] * TUNING.MOD_LOL_WP.DEATHCAP.WEAR_INCREASE_SHADOW_WEAPON_DMGMULT
                    end
                end
            end
        end
        return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
    end
end)