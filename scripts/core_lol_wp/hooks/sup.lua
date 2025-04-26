---@class ent
---@field last_atk_weapon ent|nil # 上次攻击使用的武器

AddComponentPostInit("combat", function(self)
    local old_GetAttacked = self.GetAttacked
    function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
        if attacker and attacker.prefab then
            attacker.last_atk_weapon = weapon
        end
        return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
    end
end)