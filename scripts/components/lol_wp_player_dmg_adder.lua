
---@type SourceModifierList
local SourceModifierList = require("util/sourcemodifierlist")


---@class components
---@field lol_wp_player_dmg_adder component_lol_wp_player_dmg_adder # 玩家伤害加成组件

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_player_dmg_adder:SetVal(value)
-- end

---@class component_lol_wp_player_dmg_adder
---@field inst ent
---@field physical SourceModifierList
---@field spdamage table<spdamage_type,SourceModifierList>
---@field mult_physical SourceModifierList
---@field mult_spdamage table<spdamage_type,SourceModifierList>
---@field on_hit_fn_always table<PrefabID,fun(victim:ent)> # 无论如何都会再击中时触发的函数 最后执行
local lol_wp_player_dmg_adder = Class(
---@param self component_lol_wp_player_dmg_adder
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
    self.physical = SourceModifierList(self.inst, 0, SourceModifierList.additive)
    self.spdamage = {}

    self.mult_physical = SourceModifierList(self.inst, 1, SourceModifierList.multiply)
    self.mult_spdamage = {}

    self.on_hit_fn_always = {}
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_player_dmg_adder:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_player_dmg_adder:OnLoad(data)
--     -- self.val = data.val or 0
-- end

---comment
---@param source ent|string
---@param val number
---@param key string
---@param type 'physical'|spdamage_type
function lol_wp_player_dmg_adder:Modifier(source,val,key,type)
    if type == 'physical' then
        self.physical:SetModifier(source,val,key)
    else
        if self.spdamage[type] == nil then
            self.spdamage[type] = SourceModifierList(self.inst, 0, SourceModifierList.additive)
        end
        self.spdamage[type]:SetModifier(source,val,key)
    end
end

---@param source ent|string
---@param key string
---@param type 'physical'|spdamage_type
function lol_wp_player_dmg_adder:RemoveModifier(source,key,type)
    if type == 'physical' then
        self.physical:RemoveModifier(source,key)
    else
        if self.spdamage[type] then
            self.spdamage[type]:RemoveModifier(source,key)
            if self.spdamage[type]:IsEmpty() then
                self.spdamage[type] = nil
            end
        end
    end
end

---comment
---@param source ent|string
---@param val number
---@param key string
---@param type 'physical'|spdamage_type
function lol_wp_player_dmg_adder:ModifierMult(source,val,key,type)
    if type == 'physical' then
        self.mult_physical:SetModifier(source,val,key)
    else
        if self.mult_spdamage[type] == nil then
            self.mult_spdamage[type] = SourceModifierList(self.inst, 1, SourceModifierList.multiply)
        end
        self.mult_spdamage[type]:SetModifier(source,val,key)
    end
end

---@param source ent|string
---@param key string
---@param type 'physical'|spdamage_type
function lol_wp_player_dmg_adder:RemoveModifierMult(source,key,type)
    if type == 'physical' then
        self.mult_physical:RemoveModifier(source,key)
    else
        if self.mult_spdamage[type] then
            self.mult_spdamage[type]:RemoveModifier(source,key)
            if self.mult_spdamage[type]:IsEmpty() then
                self.mult_spdamage[type] = nil
            end
        end
    end
end

---设置 无论如何都会再击中时触发 函数
---@param prefab_id PrefabID
---@param fn fun(victim:ent)
function lol_wp_player_dmg_adder:SetOnHitAlways(prefab_id,fn)
    self.on_hit_fn_always[prefab_id] = fn
end

---移除 无论如何都会再击中时触发 的函数
---@param prefab_id any
function lol_wp_player_dmg_adder:RemoveOnHitAlways(prefab_id)
    self.on_hit_fn_always[prefab_id] = nil
end

---运行所有 无论如何都会再击中时触发 函数
---@param victim ent
function lol_wp_player_dmg_adder:RunOnHitAlways(victim)
    for _,v in pairs(self.on_hit_fn_always) do
        v(victim)
    end
end

function lol_wp_player_dmg_adder:RunOnHitAlwaysWithKey(victim,key)
    local fn = self.on_hit_fn_always[key]
    if fn then
        fn(victim)
    end
end

return lol_wp_player_dmg_adder