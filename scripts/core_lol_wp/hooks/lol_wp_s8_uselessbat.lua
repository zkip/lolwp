local prefab_id = 'lol_wp_s8_uselessbat'
AddComponentPostInit('combat', function(self)
    local old_GetAttacked = self.GetAttacked
    function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
        if weapon and weapon.prefab and weapon.prefab == prefab_id then
            if self.inst and self.inst:HasTag("lunar_aligned") then
                if damage then
                    damage = damage * TUNING.MOD_LOL_WP.USELESSBAT.DMGMULT_TO_PLANAR
                end
            end
        end
        return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
    end
end)