---@diagnostic disable: undefined-global
AddComponentPostInit("combat", function(self)
    local old_GetAttacked = self.GetAttacked
    ---comment
    ---@param attacker ent
    ---@param damage any
    ---@param weapon any
    ---@param stimuli any
    ---@param spdamage any
    ---@param ... unknown
    ---@return unknown
    function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
        if attacker and attacker:HasTag('player') then
            local isequip_lol_wp_trinity = false
            -- 先找眼石
            local trinity = LOLWP_U:getEquipInEyeStone(attacker,'lol_wp_trinity')
            if trinity then
                isequip_lol_wp_trinity = true
            end
            -- 如果眼石中没找到三项才接着找装备栏 省一点性能
            if not isequip_lol_wp_trinity then
                local amulet, found = LOLWP_S:findEquipments(attacker,'lol_wp_trinity')
                if found then
                    for _,v in ipairs(amulet) do
                        if v.lol_wp_trinity_type and v.lol_wp_trinity_type == 'amulet' then
                            isequip_lol_wp_trinity = true
                            -- 找到一件即可
                            break
                        end
                    end
                end
            end
            if isequip_lol_wp_trinity then
                if damage then
                    damage = damage * TUNING.MOD_LOL_WP.TRINITY.DMGMULT
                end
            end
        end
        return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
    end
end)


AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return inst end

    if inst.components.combat then
        local old_CanHitTarget = inst.components.combat.CanHitTarget
        function inst.components.combat:CanHitTarget(...)
            if self.inst.lol_wp_trinity_terraprisma_canhittarget then
                return true
            end
            return old_CanHitTarget(self,...)
        end
    end

end)

-- cant equip when nofiniteuse
AddComponentPostInit('equippable',function (self)
    local old_IsRestricted = self.IsRestricted
    function self:IsRestricted(target,...)
        if self.inst.prefab == 'lol_wp_trinity' then
            if self.inst:HasTag('lol_wp_trinity_nofiniteuses') then
                return true
            end
        end
        return old_IsRestricted(self,target,...)
    end
end)

AddClassPostConstruct("components/equippable_replica", function(self)
    local old_IsRestricted = self.IsRestricted
    function self:IsRestricted(target,...)
        if self.inst.prefab == 'lol_wp_trinity' then
            if self.inst:HasTag('lol_wp_trinity_nofiniteuses') then
                return true
            end
        end
        return old_IsRestricted(self,target,...)
    end
end)