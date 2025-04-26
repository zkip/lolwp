---@class components
---@field for_componentaction_alchemy_chainsaw component_for_componentaction_alchemy_chainsaw

-- local function on_val(self, value)
    -- self.inst.replica.for_componentaction_alchemy_chainsaw:SetVal(value)
-- end

---@class component_for_componentaction_alchemy_chainsaw
local for_componentaction_alchemy_chainsaw = Class(function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

function for_componentaction_alchemy_chainsaw:OnSave()
    return {
        -- val = self.val
    }
end

function for_componentaction_alchemy_chainsaw:OnLoad(data)
    -- self.val = data.val or 0
end

return for_componentaction_alchemy_chainsaw