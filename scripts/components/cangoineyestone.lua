---@class components
---@field cangoineyestone component_cangoineyestone

-- local function on_val(self, value)
    -- self.inst.replica.cangoineyestone:SetVal(value)
-- end

---@class component_cangoineyestone
local cangoineyestone = Class(function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function cangoineyestone:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function cangoineyestone:OnLoad(data)
--     -- self.val = data.val or 0
-- end

return cangoineyestone