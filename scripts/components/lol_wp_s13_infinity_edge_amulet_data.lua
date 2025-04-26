-- 这个组件是给眼石用的

local db = TUNING.MOD_LOL_WP.INFINITY_EDGE
local prefab_id = 'lol_wp_s13_infinity_edge_amulet'

---@class components
---@field lol_wp_s13_infinity_edge_amulet_data component_lol_wp_s13_infinity_edge_amulet_data

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_s13_infinity_edge_amulet_data:SetVal(value)
-- end

---@class component_lol_wp_s13_infinity_edge_amulet_data
---@field inst ent
local lol_wp_s13_infinity_edge_amulet_data = Class(

---@param self component_lol_wp_s13_infinity_edge_amulet_data
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_s13_infinity_edge_amulet_data:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_s13_infinity_edge_amulet_data:OnLoad(data)
--     -- self.val = data.val or 0
-- end


---comment
---@param inst ent
---@param owner ent
function lol_wp_s13_infinity_edge_amulet_data:WhenEquip(inst, owner)
    if owner and owner.components.combat then
        owner.components.combat.externaldamagemultipliers:SetModifier(inst,db.AS_AMULET.OWNER_DMGMULT_WHEN_EQUIP,prefab_id)
    end

    if owner.components.lol_wp_critical_hit_player then
        owner.components.lol_wp_critical_hit_player:Modifier('CriticalChance','add',inst,db.AS_AMULET.CRITICAL_CHANCE,prefab_id)
        owner.components.lol_wp_critical_hit_player:Modifier('CriticalDamage','mult',inst,db.AS_AMULET.CRITICAL_DMGMULT,prefab_id)
        owner.components.lol_wp_critical_hit_player:SetOnCriticalHit(prefab_id,function (victim)
            if victim then
                local victim_pt = victim:GetPosition()
                SpawnPrefab(db.FX_WHEN_CC).Transform:SetPosition(victim_pt:Get())
            end
        end)
        owner.components.lol_wp_critical_hit_player:SetOnHitAlways(prefab_id,function (victim)
            if inst.components.finiteuses then
                inst.components.finiteuses:Use(1)
            end
        end)
        -- owner.components.lol_wp_critical_hit_player:SetOnHit(prefab_id,function (victim)
        --     if self.inst.components.finiteuses then
        --         self.inst.components.finiteuses:Use(1)
        --     end
        -- end)
    end

end

---comment
---@param inst ent
---@param owner ent
function lol_wp_s13_infinity_edge_amulet_data:WhenUnequip(inst, owner)
    if owner and owner.components.combat then
        owner.components.combat.externaldamagemultipliers:RemoveModifier(inst,prefab_id)
    end

    if owner.components.lol_wp_critical_hit_player then
        owner.components.lol_wp_critical_hit_player:RemoveModifier('CriticalChance','add',inst,prefab_id)
        owner.components.lol_wp_critical_hit_player:RemoveModifier('CriticalDamage','mult',inst,prefab_id)
        owner.components.lol_wp_critical_hit_player:RemoveOnCriticalHit(prefab_id)
        -- owner.components.lol_wp_critical_hit_player:RemoveOnHit(prefab_id)
        owner.components.lol_wp_critical_hit_player:RemoveOnHitAlways(prefab_id)
    end

end

return lol_wp_s13_infinity_edge_amulet_data