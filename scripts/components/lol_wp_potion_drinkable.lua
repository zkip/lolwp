---@class components
---@field lol_wp_potion_drinkable component_lol_wp_potion_drinkable

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_potion_drinkable:SetVal(value)
-- end

---@class component_lol_wp_potion_drinkable
---@field inst ent
local lol_wp_potion_drinkable = Class(

---@param self component_lol_wp_potion_drinkable
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_potion_drinkable:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_potion_drinkable:OnLoad(data)
--     -- self.val = data.val or 0
-- end

return lol_wp_potion_drinkable