-- 这个是给玩家的组件 用于调整暴击 伤害系统

---@type SourceModifierList
local SourceModifierList = require("util/sourcemodifierlist")


---@class components
---@field lol_wp_critical_hit_player component_lol_wp_critical_hit_player

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_critical_hit_player:SetVal(value)
-- end

---@class component_lol_wp_critical_hit_player
---@field inst ent
---@field cc number # 暴击几率
---@field cd number # 爆伤倍率
---@field modifier_add_cc SourceModifierList
---@field modifier_add_cd SourceModifierList
---@field modifier_mult_cc SourceModifierList
---@field modifier_mult_cd SourceModifierList
---@field on_critical_hit_fn table<PrefabID,fun(victim:ent)> # 暴击回调函数
---@field on_hit_fn table<PrefabID,fun(victim:ent)> # 允许暴击的武器击中就会触发,无论暴击与否 在 暴击回调函数 前执行
---@field on_hit_fn_always table<PrefabID,fun(victim:ent)> # 无论如何都会再击中时触发的函数 最后执行
local lol_wp_critical_hit_player = Class(

---@param self component_lol_wp_critical_hit_player
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0

    self.cc = 0
    self.cd = 1

    self.modifier_add_cc = SourceModifierList(self.inst, 0, SourceModifierList.additive)
    self.modifier_add_cd = SourceModifierList(self.inst, 0, SourceModifierList.additive)

    self.modifier_mult_cc = SourceModifierList(self.inst, 1, SourceModifierList.multiply)
    self.modifier_mult_cd = SourceModifierList(self.inst, 1, SourceModifierList.multiply)

    self.on_critical_hit_fn = {}

    self.on_hit_fn = {}

    self.on_hit_fn_always = {}
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_critical_hit_player:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_critical_hit_player:OnLoad(data)
--     -- self.val = data.val or 0
-- end

---修饰
---@param attri 'CriticalChance'|'CriticalDamage' # 暴击几率/暴击伤害
---@param modifier_type 'add'|'mult'
---@param source ent|string # 来源: 如果是实体,那么实体被移除时, 该修饰也会被移除
---@param m number
---@param key string
function lol_wp_critical_hit_player:Modifier(attri,modifier_type,source,m,key)
    if attri == 'CriticalChance' then
        if modifier_type == 'add' then
            self.modifier_add_cc:SetModifier(source,m,key)
        elseif modifier_type == 'mult' then
            self.modifier_mult_cc:SetModifier(source,m,key)
        end
    elseif attri == 'CriticalDamage' then
        if modifier_type == 'add' then
            self.modifier_add_cd:SetModifier(source,m,key)
        elseif modifier_type == 'mult' then
            self.modifier_mult_cd:SetModifier(source,m,key)
        end
    end
end

---移除修饰
---@param attri 'CriticalChance'|'CriticalDamage' # 暴击几率/暴击伤害
---@param modifier_type 'add'|'mult'
---@param source ent|string # 来源: 如果是实体,那么实体被移除时, 该修饰也会被移除
---@param key string
function lol_wp_critical_hit_player:RemoveModifier(attri,modifier_type,source,key)
    if attri == 'CriticalChance' then
        if modifier_type == 'add' then
            self.modifier_add_cc:RemoveModifier(source,key)
        elseif modifier_type == 'mult' then
            self.modifier_mult_cc:RemoveModifier(source,key)
        end
    elseif attri == 'CriticalDamage' then
        if modifier_type == 'add' then
            self.modifier_add_cd:RemoveModifier(source,key)
        elseif modifier_type == 'mult' then
            self.modifier_mult_cd:RemoveModifier(source,key)
        end
    end
end

---获取修饰后的暴击几率
---@return number
---@nodiscard
function lol_wp_critical_hit_player:GetCriticalChanceWithModifier()
    return ( self.cc + self.modifier_add_cc:Get() ) * self.modifier_mult_cc:Get()
end

---获取修饰后的爆伤倍率
---@return number
---@nodiscard
function lol_wp_critical_hit_player:GetCriticalDamageWithModifier()
    return ( self.cd + self.modifier_add_cd:Get() ) * self.modifier_mult_cd:Get()
end

---设置暴击触发函数
---@param prefab_id PrefabID
---@param fn fun(victim:ent)
function lol_wp_critical_hit_player:SetOnCriticalHit(prefab_id,fn)
    self.on_critical_hit_fn[prefab_id] = fn
end

---移除暴击触发函数
---@param prefab_id PrefabID
function lol_wp_critical_hit_player:RemoveOnCriticalHit(prefab_id)
    self.on_critical_hit_fn[prefab_id] = nil
end

---运行所有暴击触发函数
---@param victim ent
function lol_wp_critical_hit_player:RunOnCriticalHit(victim)
    for _,v in pairs(self.on_critical_hit_fn) do
        v(victim)
    end
end

---设置 允许暴击的武器击中就会触发,无论暴击与否 函数
---@param prefab_id PrefabID
---@param fn fun(victim:ent)
function lol_wp_critical_hit_player:SetOnHit(prefab_id,fn)
    self.on_hit_fn[prefab_id] = fn
end

---移除 允许暴击的武器击中就会触发,无论暴击与否 函数
---@param prefab_id PrefabID
function lol_wp_critical_hit_player:RemoveOnHit(prefab_id)
    self.on_hit_fn[prefab_id] = nil
end

---运行所有 允许暴击的武器击中就会触发,无论暴击与否 函数
---@param victim ent
function lol_wp_critical_hit_player:RunOnHit(victim)
    for _,v in pairs(self.on_hit_fn) do
        v(victim)
    end
end

---设置 无论如何都会再击中时触发 函数
---@param prefab_id PrefabID
---@param fn fun(victim:ent)
function lol_wp_critical_hit_player:SetOnHitAlways(prefab_id,fn)
    self.on_hit_fn_always[prefab_id] = fn
end

---移除 无论如何都会再击中时触发 的函数
---@param prefab_id any
function lol_wp_critical_hit_player:RemoveOnHitAlways(prefab_id)
    self.on_hit_fn_always[prefab_id] = nil
end

---运行所有 无论如何都会再击中时触发 函数
---@param victim ent
function lol_wp_critical_hit_player:RunOnHitAlways(victim)
    for _,v in pairs(self.on_hit_fn_always) do
        v(victim)
    end
end

return lol_wp_critical_hit_player