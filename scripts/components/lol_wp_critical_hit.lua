-- 暂时废弃

-- ---@type SourceModifierList
-- local SourceModifierList = require("util/sourcemodifierlist")

-- ---@class components
-- ---@field lol_wp_critical_hit component_lol_wp_critical_hit

-- -- local function on_val(self, value)
--     -- self.inst.replica.lol_wp_critical_hit:SetVal(value)
-- -- end

-- ---@class component_lol_wp_critical_hit
-- ---@field inst ent
-- ---@field enabled boolean # 是否启用组件(不读存)
-- ---@field cc number # 暴击几率
-- ---@field cd number # 爆伤倍率
-- ---@field modifier_add_cc SourceModifierList
-- ---@field modifier_add_cd SourceModifierList
-- ---@field modifier_mult_cc SourceModifierList
-- ---@field modifier_mult_cd SourceModifierList
-- ---@field affect_physical_damage boolean # 是否对物理伤害生效
-- ---@field affect_spdamage_types nil|spdamage_type[]|'all' # 影响哪些spdamage type,不填不影响, `all` 则全影响
-- ---@field on_critical_hit_fn nil|fun(inst:ent,victim:ent,attacker:ent|nil) # 暴击回调函数
-- local lol_wp_critical_hit = Class(
-- ---@param self component_lol_wp_critical_hit
-- ---@param inst ent
-- function(self, inst)
--     self.inst = inst
--     -- self.val = 0

--     self.enabled = true

--     self.cc = 0
--     self.cd = 1

--     self.modifier_add_cc = SourceModifierList(self.inst, 0, SourceModifierList.additive)
--     self.modifier_add_cd = SourceModifierList(self.inst, 0, SourceModifierList.additive)

--     self.modifier_mult_cc = SourceModifierList(self.inst, 1, SourceModifierList.multiply)
--     self.modifier_mult_cd = SourceModifierList(self.inst, 1, SourceModifierList.multiply)

--     self.affect_physical_damage = true
--     self.affect_spdamage_types = nil

--     self.on_critical_hit_fn = nil
-- end,
-- nil,
-- {
--     -- val = on_val,
-- })

-- function lol_wp_critical_hit:OnSave()
--     return {
--         -- val = self.val
--         cc = self.cc,
--         cd = self.cd
--     }
-- end

-- function lol_wp_critical_hit:OnLoad(data)
--     -- self.val = data.val or 0
--     self.cc = data.cc or 0
--     self.cd = data.cd or 1
-- end

-- ---初始化
-- ---@param cc number # 设置暴击几率
-- ---@param cd number # 设置爆伤倍率
-- ---@param affect_physical_damage boolean # 是否对物理伤害生效
-- ---@param affect_spdamage_types nil|spdamage_type[]|'all' # 影响哪些spdamage type,不填不影响, `all` 则全影响
-- function lol_wp_critical_hit:Init(cc,cd,affect_physical_damage,affect_spdamage_types)
--     self:SetCC(cc)
--     self:SetCD(cd)
--     self:AffectPhysicalDmg(affect_physical_damage)
--     self:AffectSpdamage(affect_spdamage_types)
-- end

-- ---设置暴击几率
-- ---@param val number
-- function lol_wp_critical_hit:SetCC(val)
--     self.cc = val
-- end

-- ---设置爆伤倍率
-- ---@param val number
-- function lol_wp_critical_hit:SetCD(val)
--     self.cd = val
-- end

-- ---是否对物理伤害生效
-- ---@param val boolean
-- function lol_wp_critical_hit:AffectPhysicalDmg(val)
--     self.affect_physical_damage = val
-- end

-- ---是否对spdamage伤害生效
-- ---@param val nil|spdamage_type[]|'all' # 影响哪些spdamage type,不填不影响, `all` 则全影响
-- function lol_wp_critical_hit:AffectSpdamage(val)
--     self.affect_spdamage_types = val
-- end

-- ---修饰
-- ---@param attri 'CriticalChance'|'CriticalDamage' # 暴击几率/暴击伤害
-- ---@param modifier_type 'add'|'mult'
-- ---@param source ent|string # 来源: 如果是实体,那么实体被移除时, 该修饰也会被移除
-- ---@param m number
-- ---@param key string
-- function lol_wp_critical_hit:Modifier(attri,modifier_type,source,m,key)
--     if attri == 'CriticalChance' then
--         if modifier_type == 'add' then
--             self.modifier_add_cc:SetModifier(source,m,key)
--         elseif modifier_type == 'mult' then
--             self.modifier_mult_cc:SetModifier(source,m,key)
--         end
--     elseif attri == 'CriticalDamage' then
--         if modifier_type == 'add' then
--             self.modifier_add_cd:SetModifier(source,m,key)
--         elseif modifier_type == 'mult' then
--             self.modifier_mult_cd:SetModifier(source,m,key)
--         end
--     end
-- end

-- ---移除修饰
-- ---@param attri 'CriticalChance'|'CriticalDamage' # 暴击几率/暴击伤害
-- ---@param modifier_type 'add'|'mult'
-- ---@param source ent|string # 来源: 如果是实体,那么实体被移除时, 该修饰也会被移除
-- ---@param key string
-- function lol_wp_critical_hit:RemoveModifier(attri,modifier_type,source,key)
--     if attri == 'CriticalChance' then
--         if modifier_type == 'add' then
--             self.modifier_add_cc:RemoveModifier(source,key)
--         elseif modifier_type == 'mult' then
--             self.modifier_mult_cc:RemoveModifier(source,key)
--         end
--     elseif attri == 'CriticalDamage' then
--         if modifier_type == 'add' then
--             self.modifier_add_cd:RemoveModifier(source,key)
--         elseif modifier_type == 'mult' then
--             self.modifier_mult_cd:RemoveModifier(source,key)
--         end
--     end
-- end

-- ---获取修饰后的暴击几率
-- ---@return number
-- ---@nodiscard
-- function lol_wp_critical_hit:GetCriticalChanceWithModifier()
--     return ( self.cc + self.modifier_add_cc:Get() ) * self.modifier_mult_cc:Get()
-- end

-- ---获取修饰后的爆伤倍率
-- ---@return number
-- ---@nodiscard
-- function lol_wp_critical_hit:GetCriticalDamageWithModifier()
--     return ( self.cd + self.modifier_add_cd:Get() ) * self.modifier_mult_cd:Get()
-- end

-- ---暴击回调函数
-- ---@param fn fun(inst:ent,victim:ent,attacker:ent|nil)
-- function lol_wp_critical_hit:SetOnCriticalHit(fn)
--     self.on_critical_hit_fn = fn
-- end

-- ---是否启用组件
-- ---@return boolean
-- ---@nodiscard
-- function lol_wp_critical_hit:IsEnabled()
--     return self.enabled
-- end

-- ---启用组件
-- ---@param boolean boolean
-- function lol_wp_critical_hit:Enable(boolean)
--     self.enabled = boolean
-- end

-- return lol_wp_critical_hit

