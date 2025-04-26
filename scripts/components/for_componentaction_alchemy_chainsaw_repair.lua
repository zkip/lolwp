---@class components
---@field for_componentaction_alchemy_chainsaw_repair component_for_componentaction_alchemy_chainsaw_repair

-- local function on_val(self, value)
    -- self.inst.replica.for_componentaction_alchemy_chainsaw_repair:SetVal(value)
-- end

---@class component_for_componentaction_alchemy_chainsaw_repair
---@field inst ent
local for_componentaction_alchemy_chainsaw_repair = Class(

---@param self component_for_componentaction_alchemy_chainsaw_repair
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function for_componentaction_alchemy_chainsaw_repair:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function for_componentaction_alchemy_chainsaw_repair:OnLoad(data)
--     -- self.val = data.val or 0
-- end

return for_componentaction_alchemy_chainsaw_repair