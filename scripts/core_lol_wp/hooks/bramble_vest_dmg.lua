-- 原版的荆棘外壳反伤不吃额外伤害加成

local bramblefxs = {
    'bramblefx_armor','bramblefx_armor_upgrade'
}
for _,v in ipairs(bramblefxs) do
    AddPrefabPostInit(v,function (inst)
        if not TheWorld.ismastersim then
            return inst
        end

        local old_onupdatefns = inst.components.updatelooper and inst.components.updatelooper.onupdatefns
        for i,_ in ipairs(old_onupdatefns or {}) do
            local old_fn = old_onupdatefns[i]
            old_onupdatefns[i] = function(_inst,...)
                if _inst then
                    _inst.lol_wp_bramble_vest_atk = true
                    if _inst.owner then
                        _inst.owner.lol_wp_bramble_vest_atk = true
                    end
                end
                local res = old_fn ~= nil and {old_fn(_inst,...)} or {}
                if _inst then
                    _inst.lol_wp_bramble_vest_atk = nil
                    if _inst.owner then
                        _inst.owner.lol_wp_bramble_vest_atk = nil
                    end
                end
                return unpack(res)
            end
        end

    end)
end


AddComponentPostInit('combat',
---comment
---@param self component_combat
function (self)
    local old_GetAttacked = self.GetAttacked
    function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
        if attacker and attacker.lol_wp_bramble_vest_atk then
            local victim = self.inst
            if LOLWP_S:checkAlive(victim) then
                local total_dmg = (damage and TUNING.ARMORBRAMBLE_DMG or 0) + (spdamage and spdamage.planar and TUNING.ARMORBRAMBLE_DMG_PLANAR_UPGRADE or 0)
                victim.components.health:DoDelta(-total_dmg)
                ---@type event_data_attacked
                local event_data_attacked = { attacker = attacker, damage = total_dmg, damageresolved = total_dmg, original_damage = total_dmg}
                victim:PushEvent('attacked',event_data_attacked)
                -- damage = 0
                -- spdamage = {}
            end
            return
        end
        return old_GetAttacked ~= nil and old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...) or nil
    end
end
)