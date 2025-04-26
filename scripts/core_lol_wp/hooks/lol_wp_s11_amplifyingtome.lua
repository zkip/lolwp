local modid = 'lol_wp'

local db = TUNING.MOD_LOL_WP.AMPLIFYINGTOME

-- ban掉 增幅典籍 绑定的官方组件动作
local data = LOLWP_S:upvalueFind(EntityScript.CollectActions,'COMPONENT_ACTIONS')
if data then
    local old_book = data.INVENTORY.book
    ---comment
    ---@param inst ent
    ---@param doer any
    ---@param actions any
    data.INVENTORY.book = function(inst, doer, actions)
        if inst.prefab and inst.prefab == 'lol_wp_s11_amplifyingtome' then
            return false
        end
        return old_book(inst, doer, actions)
    end
end

-- ---comment
-- ---@param inst ent
-- local function dealItem(inst)
--     if inst.components.finiteuses then
--         inst.components.finiteuses:Use(db.CONSUME_PER_HIT)
--     end
-- end

-- AddComponentPostInit("combat", function(self)
--     local old_GetAttacked = self.GetAttacked
--     ---comment
--     ---@param attacker ent
--     ---@param damage any
--     ---@param weapon any
--     ---@param stimuli any
--     ---@param spdamage any
--     ---@param ... unknown
--     ---@return unknown
--     function self:GetAttacked(attacker,damage,weapon,stimuli,spdamage,...)
--         if stimuli and stimuli == 'lol_wp_trinity_terraprisma' and attacker and attacker.damage_from_lol_wp_trinity_terraprisma_amulet then
--         else
--             if attacker and attacker:HasTag("player")  then
--                 local hasItem = false
--                 local equips,found = LOLWP_S:findEquipments(attacker,'lol_wp_s11_amplifyingtome')
--                 if found then
--                     hasItem = true
--                     for _, v in pairs(equips) do
--                         dealItem(v)
--                     end
--                 end

--                 local isEyeStone = false
--                 local eyestone_itm = LOLWP_U:getEquipInEyeStone(attacker,'lol_wp_s11_amplifyingtome')
--                 if eyestone_itm then
--                     hasItem = true
--                     isEyeStone = true
--                     dealItem(eyestone_itm)
--                 end

--                 if hasItem then
--                     if spdamage == nil then
--                         spdamage = {}
--                     end
--                     spdamage['planar'] = (spdamage['planar'] or 0) + (TUNING[string.upper('CONFIG_'..modid..'lol_wp_eyestone_item_effect_half')] and hasItem and isEyeStone and db.PLANAR_DMG/2 or db.PLANAR_DMG)
--                 end
--             end
--         end

--         return old_GetAttacked(self,attacker,damage,weapon,stimuli,spdamage,...)
--     end
-- end)