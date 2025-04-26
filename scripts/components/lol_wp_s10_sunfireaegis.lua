---@class components
---@field lol_wp_s10_sunfireaegis component_lol_wp_s10_sunfireaegis

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_s10_sunfireaegis:SetVal(value)
-- end

---@class component_lol_wp_s10_sunfireaegis
local lol_wp_s10_sunfireaegis = Class(function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_s10_sunfireaegis:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_s10_sunfireaegis:OnLoad(data)
--     -- self.val = data.val or 0
-- end



return lol_wp_s10_sunfireaegis