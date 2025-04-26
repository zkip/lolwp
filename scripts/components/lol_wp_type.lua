-- 装备类型 法师 战士?

---@alias lol_wp_type string
---| 'warrior'
---| 'mage'
---| 'tank'
---| 'support'

---@class components
---@field lol_wp_type component_lol_wp_type

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_type:SetVal(value)
-- end

---@class component_lol_wp_type
---@field inst ent
---@field type nil|lol_wp_type # 类型
local lol_wp_type = Class(
---@param self component_lol_wp_type
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
    self.type = nil
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_type:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_type:OnLoad(data)
--     -- self.val = data.val or 0
-- end

---设置类型
---@param type lol_wp_type
function lol_wp_type:SetType(type)
    self.type = type
end

---获取类型
---@return lol_wp_type|nil
---@nodiscard
function lol_wp_type:GetType()
    return self.type
end

return lol_wp_type