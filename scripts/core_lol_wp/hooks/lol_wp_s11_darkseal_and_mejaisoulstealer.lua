---@diagnostic disable: redundant-parameter

local modid = 'lol_wp'

local db_darkseal = TUNING.MOD_LOL_WP.DARKSEAL
local db_mejai = TUNING.MOD_LOL_WP.MEJAISOULSTEALER

local function log(...)
    LOLWP_S:declare(...)
end

---@class ent
---@field participate_kill_tbl table<GUID, boolean> # 联合击杀贡献表

---挂联合击杀表
---@param self component_combat
AddComponentPostInit('combat',function (self)
    local old_GetAttacked = self.GetAttacked
    function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
        local victim = self.inst
        if attacker and attacker.GUID and victim and attacker:HasTag('player') then
            -- 筛选boss生物
            if victim:HasTag('epic') then
                -- 如果victim没有表 则创建表
                
                if victim.participate_kill_tbl == nil then
                    victim.participate_kill_tbl = {}
                end
                -- 将player的GUID挂到表上
                local guid = attacker.GUID
                victim.participate_kill_tbl[guid] = true
            end
        end
        return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
    end
end)

-- 击杀 参与击杀 获取层数
AddComponentPostInit("health",
---comment
---@param self component_health
function(self)
    local old_SetVal = self.SetVal
    function self:SetVal(val,cause,afflicter,...)
        local res = {old_SetVal(self,val,cause,afflicter,...)}

        local victim = self.inst
        -- 当死亡
        if self:IsDead() then
            -- 只有被戴着可以触发participate_kill_tbl的物品的玩家攻击过的victim才会有这张表
            if victim and victim.participate_kill_tbl then
                local tbl = victim.participate_kill_tbl
                for _,p in pairs(AllPlayers) do
                    local guid = p.GUID
                    -- 如果是参与击杀者
                    if guid and tbl[guid] then
                        -- 黑暗封印 参与击杀
                        local darkseals, darkseal_found = LOLWP_S:findEquipments(p,'lol_wp_s11_darkseal')
                        if darkseal_found then
                            for _,darkseal in pairs(darkseals) do
                                if darkseal.components.lol_wp_s11_darkseal_num then
                                    darkseal.components.lol_wp_s11_darkseal_num:WhenKillMob(victim)
                                end
                                if p.components.lol_wp_player_dmg_adder then
                                    local dmg = darkseal.components.lol_wp_s11_darkseal_num:GetVal() * TUNING.MOD_LOL_WP.DARKSEAL.SKILL_HONOR.EXTRA_PLANAR_DMG_PER_STACK + TUNING.MOD_LOL_WP.DARKSEAL.PLANAR_DMG
                                    p.components.lol_wp_player_dmg_adder:Modifier(darkseal,dmg,'lol_wp_s11_darkseal','planar')
                                end
                            end
                        end
                        local darkseal_ineyestone = LOLWP_U:getEquipInEyeStone(p,'lol_wp_s11_darkseal')
                        if darkseal_ineyestone then
                            if darkseal_ineyestone.components.lol_wp_s11_darkseal_num then
                                darkseal_ineyestone.components.lol_wp_s11_darkseal_num:WhenKillMob(victim)
                            end
                            if p.components.lol_wp_player_dmg_adder then
                                local dmg = darkseal_ineyestone.components.lol_wp_s11_darkseal_num:GetVal() * TUNING.MOD_LOL_WP.DARKSEAL.SKILL_HONOR.EXTRA_PLANAR_DMG_PER_STACK + TUNING.MOD_LOL_WP.DARKSEAL.PLANAR_DMG
                                dmg = dmg*TUNING.MOD_LOL_WP.ITEM_EFFECT_RATE_IN_EYESTONE

                                p.components.lol_wp_player_dmg_adder:Modifier(darkseal_ineyestone,dmg,'lol_wp_s11_darkseal','planar')
                            end
                        end
                        -- 梅贾的窃魂卷 参与击杀 和 亲手击杀
                        local is_true_killer = false
                        if afflicter and afflicter.GUID and afflicter.GUID == guid then
                            is_true_killer = true
                        end
                        local mejais, mejai_found = LOLWP_S:findEquipments(p,'lol_wp_s11_mejaisoulstealer')
                        if mejai_found then
                            for _, mejai in pairs(mejais) do
                                if mejai.components.lol_wp_s11_mejaisoulstealer_num then
                                    mejai.components.lol_wp_s11_mejaisoulstealer_num:WhenKillMob(victim,is_true_killer)
                                end
                                if p.components.lol_wp_player_dmg_adder then
                                    local dmg = mejai.components.lol_wp_s11_mejaisoulstealer_num:GetVal() * TUNING.MOD_LOL_WP.MEJAISOULSTEALER.SKILL_HONOR.EXTRA_PLANAR_DMG_PER_STACK + TUNING.MOD_LOL_WP.MEJAISOULSTEALER.PLANAR_DMG
                                    p.components.lol_wp_player_dmg_adder:Modifier(mejai,dmg,'lol_wp_s11_mejaisoulstealer','planar')
                                end
                            end
                        end
                        local mejai_ineyestone = LOLWP_U:getEquipInEyeStone(p,'lol_wp_s11_mejaisoulstealer')
                        if mejai_ineyestone then
                            if mejai_ineyestone.components.lol_wp_s11_mejaisoulstealer_num then
                                mejai_ineyestone.components.lol_wp_s11_mejaisoulstealer_num:WhenKillMob(victim,is_true_killer)
                            end
                            if p.components.lol_wp_player_dmg_adder then
                                local dmg = mejai_ineyestone.components.lol_wp_s11_mejaisoulstealer_num:GetVal() * TUNING.MOD_LOL_WP.MEJAISOULSTEALER.SKILL_HONOR.EXTRA_PLANAR_DMG_PER_STACK + TUNING.MOD_LOL_WP.MEJAISOULSTEALER.PLANAR_DMG
                                dmg = dmg*TUNING.MOD_LOL_WP.ITEM_EFFECT_RATE_IN_EYESTONE
                                p.components.lol_wp_player_dmg_adder:Modifier(mejai_ineyestone,dmg,'lol_wp_s11_mejaisoulstealer','planar')
                            end
                        end

                        -----------------------------------------
                        -- s14 狂妄 参与击杀和亲手击杀都是一层
                        local hubris,hubris_found = LOLWP_S:findEquipments(p,'lol_wp_s14_hubris')
                        if hubris_found then
                            for _,v in pairs(hubris) do
                                if v.components.lol_wp_s14_hubris_skill_reputation then
                                    v.components.lol_wp_s14_hubris_skill_reputation:DoDelta(TUNING.MOD_LOL_WP.HUBRIS.SKILL_REPUTATION.BOSSKILL_BY_SELF_STACK)

                                    if p.components.lol_wp_player_dmg_adder then
                                        local atk_add = v.components.lol_wp_s14_hubris_skill_reputation:CalcAtkDmg()
                                        p.components.lol_wp_player_dmg_adder:Modifier('lol_wp_s14_hubris',atk_add,'lol_wp_s14_hubris'..'skill_reputation','physical')
                                    end
                                end
                            end
                        end
                        -----------------------------------------
                    end
                end
            end
        end
        return unpack(res)
    end
end)


-- 物品下方会显示叠加的被动层数。
local Text = require 'widgets/text'
AddClassPostConstruct("widgets/itemtile", function(self, invitem)
    -- 黑暗封印
    self.set_lol_wp_s11_darkseal = function(self, num)
        if self.item.prefab == 'lol_wp_s11_darkseal' then
            if not self.lol_wp_s11_darkseal_val then
                self.lol_wp_s11_darkseal_val = self:AddChild(Text(NUMBERFONT, 42))
                if JapaneseOnPS4() then
                    self.lol_wp_s11_darkseal_val:SetHorizontalSqueeze(0.7)
                end
                self.lol_wp_s11_darkseal_val:SetPosition(5, -32 + 15, 0)
            end

            local val_to_show = num or 0
            if self.item.replica.lol_wp_s11_darkseal_num then
                val_to_show = self.item.replica.lol_wp_s11_darkseal_num:GetVal()
            end
            -- self.lol_wp_s11_darkseal_val:SetColour({1,0,0,1})
            self.lol_wp_s11_darkseal_val:SetString(val_to_show)

            if not self.dragging and self.item:HasTag("show_broken_ui") then
                if self.lol_wp_s11_darkseal_val > 0 then
                    self.bg:Hide()
                    -- self.spoilage:Hide()
                else
                    self.bg:Show()
                    -- self:SetPerishPercent(0)
                end
            end
            -- return
        end
    end

    if self.item.prefab == 'lol_wp_s11_darkseal' then
        if self.item.replica.lol_wp_s11_darkseal_num then
            self:set_lol_wp_s11_darkseal(self.item.replica.lol_wp_s11_darkseal_num:GetVal())
        end
    end

    self.inst:ListenForEvent("lol_wp_s11_darkseal_num_val_change",function(invitem, data)
        self:set_lol_wp_s11_darkseal(self.item.replica.lol_wp_s11_darkseal_num:GetVal())
    end, invitem)

    -- 梅贾的窃魂卷
    self.set_lol_wp_s11_mejaisoulstealer = function(self, num)
        if self.item.prefab == 'lol_wp_s11_mejaisoulstealer' then
            if not self.lol_wp_s11_mejaisoulstealer_val then
                self.lol_wp_s11_mejaisoulstealer_val = self:AddChild(Text(NUMBERFONT, 42))
                if JapaneseOnPS4() then
                    self.lol_wp_s11_mejaisoulstealer_val:SetHorizontalSqueeze(0.7)
                end
                self.lol_wp_s11_mejaisoulstealer_val:SetPosition(5, -32 + 15, 0)
            end

            local val_to_show = num or 0
            if self.item.replica.lol_wp_s11_mejaisoulstealer_num then
                val_to_show = self.item.replica.lol_wp_s11_mejaisoulstealer_num:GetVal()
            end
            -- self.lol_wp_s11_mejaisoulstealer_val:SetColour({1,0,0,1})
            self.lol_wp_s11_mejaisoulstealer_val:SetString(val_to_show)

            if not self.dragging and self.item:HasTag("show_broken_ui") then
                if self.lol_wp_s11_mejaisoulstealer_val > 0 then
                    self.bg:Hide()
                    -- self.spoilage:Hide()
                else
                    self.bg:Show()
                    -- self:SetPerishPercent(0)
                end
            end
            -- return
        end
    end

    if self.item.prefab == 'lol_wp_s11_mejaisoulstealer' then
        if self.item.replica.lol_wp_s11_mejaisoulstealer_num then
            self:set_lol_wp_s11_mejaisoulstealer(self.item.replica.lol_wp_s11_mejaisoulstealer_num:GetVal())
        end
    end

    self.inst:ListenForEvent("lol_wp_s11_mejaisoulstealer_num_val_change",function(invitem, data)
        self:set_lol_wp_s11_mejaisoulstealer(self.item.replica.lol_wp_s11_mejaisoulstealer_num:GetVal())
    end, invitem)

end)


-- -- 佩戴时提供5点额外位面伤害
-- AddComponentPostInit('combat',
-- ---comment
-- ---@param self component_combat
-- function (self)
--     local old_GetAttacked = self.GetAttacked
--     function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
--         if stimuli and stimuli == 'lol_wp_trinity_terraprisma' and attacker and attacker.damage_from_lol_wp_trinity_terraprisma_amulet then
--         else
--             if attacker and attacker:HasTag('player') then
--                 if spdamage == nil then
--                     spdamage = {}
--                 end
--                 -- 黑暗封印
--                 local has_darkseal = false
--                 local darkseals,darkseal_found = LOLWP_S:findEquipments(attacker,'lol_wp_s11_darkseal')
--                 if darkseal_found then
--                     has_darkseal = true
--                     for _, darkseal in ipairs(darkseals) do
--                         if darkseal.components.lol_wp_s11_darkseal_num then
--                             local num = darkseal.components.lol_wp_s11_darkseal_num:GetVal()
--                             if num > 0 then
--                                 spdamage['planar'] = (spdamage['planar'] or 0) + num*db_darkseal.SKILL_HONOR.EXTRA_PLANAR_DMG_PER_STACK
--                             end
--                         end
--                     end
--                 end
--                 local darkseal_ineyestone = LOLWP_U:getEquipInEyeStone(attacker,'lol_wp_s11_darkseal')
--                 if darkseal_ineyestone then
--                     has_darkseal = true
--                     if darkseal_ineyestone.components.lol_wp_s11_darkseal_num then
--                         local num = darkseal_ineyestone.components.lol_wp_s11_darkseal_num:GetVal()
--                         if num > 0 then
--                             spdamage['planar'] = (spdamage['planar'] or 0) + num*db_darkseal.SKILL_HONOR.EXTRA_PLANAR_DMG_PER_STACK
--                         end
--                     end
--                 end
--                 if has_darkseal then
--                     spdamage['planar'] = (spdamage['planar'] or 0) + db_darkseal.PLANAR_DMG
--                 end
--                 -- 梅贾的窃魂卷
--                 local has_mejaisoulstealer = false
--                 local mejaisoulstealers,mejaisoulstealer_found = LOLWP_S:findEquipments(attacker,'lol_wp_s11_mejaisoulstealer')
--                 if mejaisoulstealer_found then
--                     has_mejaisoulstealer = true
--                     for _, mejaisoulstealer in ipairs(mejaisoulstealers) do
--                         if mejaisoulstealer.components.lol_wp_s11_mejaisoulstealer_num then
--                             local num = mejaisoulstealer.components.lol_wp_s11_mejaisoulstealer_num:GetVal()
--                             if num > 0 then
--                                 spdamage['planar'] = (spdamage['planar'] or 0) + num*db_mejai.SKILL_HONOR.EXTRA_PLANAR_DMG_PER_STACK
--                             end
--                         end
--                     end
--                 end
--                 local mejaisoulstealer_ineyestone = LOLWP_U:getEquipInEyeStone(attacker,'lol_wp_s11_mejaisoulstealer')
--                 if mejaisoulstealer_ineyestone then
--                     has_mejaisoulstealer = true
--                     if mejaisoulstealer_ineyestone.components.lol_wp_s11_mejaisoulstealer_num then
--                         local num = mejaisoulstealer_ineyestone.components.lol_wp_s11_mejaisoulstealer_num:GetVal()
--                         if num > 0 then
--                             spdamage['planar'] = (spdamage['planar'] or 0) + num*db_mejai.SKILL_HONOR.EXTRA_PLANAR_DMG_PER_STACK
--                         end
--                     end
--                 end
--                 if has_mejaisoulstealer then
--                     spdamage['planar'] = (spdamage['planar'] or 0) + db_mejai.PLANAR_DMG
--                 end
--             end
--         end
--         return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
--     end
-- end)


