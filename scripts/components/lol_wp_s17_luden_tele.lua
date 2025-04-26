---@class components
---@field lol_wp_s17_luden_tele component_lol_wp_s17_luden_tele

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_s17_luden_tele:SetVal(value)
-- end

---@class component_lol_wp_s17_luden_tele
---@field inst ent
local lol_wp_s17_luden_tele = Class(

---@param self component_lol_wp_s17_luden_tele
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_s17_luden_tele:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_s17_luden_tele:OnLoad(data)
--     -- self.val = data.val or 0
-- end

---comment
---@param doer ent
---@param pt Vector3
---@return boolean
---@nodiscard
function lol_wp_s17_luden_tele:Tele(doer,pt)
    if self.inst.components.finiteuses then
        self.inst.components.finiteuses:Use(TUNING.MOD_LOL_WP.LUDEN.SKILL_ARCANE_TELE.CONSUME)
    end
    if doer.components.sanity then
        doer.components.sanity:DoDelta(TUNING.MOD_LOL_WP.LUDEN.SKILL_ARCANE_TELE.CONSUME_SAN)
    end
    local start_x,_,start_z = doer:GetPosition():Get()
    local end_x,_,end_z = pt:Get()
    SpawnPrefab('shadow_puff_large_front').Transform:SetPosition(start_x,0,start_z)
    doer.Physics:Teleport(end_x,0,end_z)
    SpawnPrefab('shadow_puff_large_front').Transform:SetPosition(end_x,0,end_z)
    if doer.SoundEmitter then
        doer.SoundEmitter:PlaySound("dontstarve/common/staff_blink")
    end
    return true
end

return lol_wp_s17_luden_tele