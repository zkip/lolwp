local modid = 'lol_wp'

---comment
---@param inst ent
local function amuletFn(inst)
    if inst.components.finiteuses then
        inst.components.finiteuses:Use(1)
    end
end

AddComponentPostInit('combat',function (self)
    LOLWP_S:hookFnHasReturn(self,'GetAttacked',
    ---comment
    ---@param self any
    ---@param attacker ent
    ---@param damage any
    ---@param weapon any
    ---@param stimuli any
    ---@param spdamage any
    ---@param ... unknown
    function (self, attacker,damage,weapon,stimuli,spdamage,...)

        -- 这里条件不触发峡谷, 
        if (stimuli and stimuli == 'lol_wp_trinity_terraprisma') or (attacker and attacker.damage_from_lol_wp_trinity_terraprisma_amulet) or (self.inst._riftmaker_dont_drain) then

        else
            ---@type ent
            local victim = self.inst

            if damage and weapon and weapon.prefab and weapon.prefab == 'riftmaker_weapon' then
                if victim:HasTag('lunar_aligned') then
                    damage = damage * 1.1
                    if spdamage == nil then
                        spdamage = {}
                    end
                    spdamage['planar'] = spdamage['planar'] * 1.1
                end
            end

            if attacker and attacker:HasTag('player') and damage then
                local has_riftmaker_amulet = false
                local equips, found = LOLWP_S:findEquipments(attacker,'riftmaker_amulet')
                if found then
                    has_riftmaker_amulet = true
                    for _,equip in pairs(equips) do
                        amuletFn(equip)
                    end
                end

                local amuletineyestone = LOLWP_U:getEquipInEyeStone(attacker,'riftmaker_amulet')
                if amuletineyestone then
                    has_riftmaker_amulet = true
                    amuletFn(amuletineyestone)
                end

                if has_riftmaker_amulet then
                    -- 消耗2点san值
                    if attacker.components.sanity then
                        attacker.components.sanity:DoDelta(-2)
                    end
                    -- 每次攻击附带7点吸血，
                    if attacker.components.health and victim and not victim:HasTag('wall') and not victim:HasTag('structure') then
                        attacker.components.health:DoDelta(3)
                    end
                    -- 护符形态下额外增加20点额外位面伤害
                    if spdamage == nil then
                        spdamage = {}
                    end
                    spdamage['planar'] = (spdamage['planar'] or 0) + (amuletineyestone ~= nil and 20*TUNING.MOD_LOL_WP.ITEM_EFFECT_RATE_IN_EYESTONE or 20)
                    -- 对月亮阵营伤害增加10%
                    if victim:HasTag('lunar_aligned') then
                        damage = damage * 1.1
                        spdamage['planar'] = spdamage['planar'] * 1.1
                    end
                    -- -- 每次攻击会附带当前攻击力25%的额外真实伤害
                    -- LOLWP_S:dealTrueDmg(damage*.25,self.inst)
                end
            end



        end
        return attacker,damage,weapon,stimuli,spdamage,...
    end)

end)