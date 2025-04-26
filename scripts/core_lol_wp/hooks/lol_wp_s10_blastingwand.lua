local db = TUNING.MOD_LOL_WP.BLASTINGWAND
AddComponentPostInit('combat',function (self)
    local old_GetAttacked = self.GetAttacked
    ---comment
    ---@param attacker any
    ---@param damage any
    ---@param weapon ent
    ---@param stimuli any
    ---@param spdamage any
    ---@param ... unknown
    ---@return unknown
    function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
        ---@type ent
        local victim = self.inst
        if victim and weapon and weapon.prefab and weapon.prefab == 'lol_wp_s10_blastingwand' then
            if victim:HasTag('lunar_aligned') then
                if damage then
                    damage = damage * db.DMGMULT_TO_PLANAR
                end
                for k,_ in pairs(spdamage or {}) do
                    spdamage[k] = spdamage[k] * db.DMGMULT_TO_PLANAR
                end
            end
        end
        return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
    end
end)