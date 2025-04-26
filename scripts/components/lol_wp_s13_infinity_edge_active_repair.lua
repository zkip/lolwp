---@class components
---@field lol_wp_s13_infinity_edge_active_repair component_lol_wp_s13_infinity_edge_active_repair

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_s13_infinity_edge_active_repair:SetVal(value)
-- end

---@class component_lol_wp_s13_infinity_edge_active_repair
---@field inst ent
local lol_wp_s13_infinity_edge_active_repair = Class(

---@param self component_lol_wp_s13_infinity_edge_active_repair
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_s13_infinity_edge_active_repair:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_s13_infinity_edge_active_repair:OnLoad(data)
--     -- self.val = data.val or 0
-- end

local function dozap(inst)
    if inst.zaptask ~= nil then
        inst.zaptask:Cancel()
    end

    inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
    SpawnPrefab("lightning_rod_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst.zaptask = inst:DoTaskInTime(math.random(10, 40), dozap)
end

---comment
---@param target ent
---@return boolean
---@nodiscard
function lol_wp_s13_infinity_edge_active_repair:Main(target)
    local allow_repair = false
    local tar_prefab = target.prefab
    if tar_prefab then
        if tar_prefab == 'lightning_rod' then
            if target.chargeleft and target.chargeleft > 1 then
                dozap(target)
                target.chargeleft = target.chargeleft - 1
                allow_repair = true
            end
        elseif (tar_prefab == 'winona_battery_low' or tar_prefab == 'winona_battery_high') then
            if target.components.fueled then
                local cur = target.components.fueled:GetPercent()
                if cur > 1/6 then
                    local new = math.max(0,cur - 1/6)
                    target.components.fueled:SetPercent(new)
                    allow_repair = true
                end
            end
        end
    end
    if allow_repair then
        if self.inst.components.finiteuses then
            self.inst.components.finiteuses:SetPercent(1)
            -- lol_wp_divine_nofiniteuses
            if self.inst:HasTag(self.inst.prefab..'_nofiniteuses') then
                self.inst:RemoveTag(self.inst.prefab..'_nofiniteuses')
            end
        end
    end
    return allow_repair
end

return lol_wp_s13_infinity_edge_active_repair