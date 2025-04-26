---@class components
---@field lol_wp_allow_footprint_traceback component_lol_wp_allow_footprint_traceback

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_allow_footprint_traceback:SetVal(value)
-- end

---@class component_lol_wp_allow_footprint_traceback # 挂在物品上的足迹组件
---@field inst ent
local lol_wp_allow_footprint_traceback = Class(

---@param self component_lol_wp_allow_footprint_traceback
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_allow_footprint_traceback:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_allow_footprint_traceback:OnLoad(data)
--     -- self.val = data.val or 0
-- end

return lol_wp_allow_footprint_traceback