---@class components
---@field world_data_lol_wp component_world_data_lol_wp

-- local function on_val(self, value)
    -- self.inst.replica.world_data_lol_wp:SetVal(value)
-- end

---@class component_world_data_lol_wp
---@field inst ent
---@field alterguardian_phase3_defeat boolean # 天体被击杀
local world_data_lol_wp = Class(

---@param self component_world_data_lol_wp
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
    self.alterguardian_phase3_defeat = false
end,
nil,
{
    -- val = on_val,
})

function world_data_lol_wp:OnSave()
    return {
        -- val = self.val
        alterguardian_phase3_defeat = self.alterguardian_phase3_defeat
    }
end

function world_data_lol_wp:OnLoad(data)
    -- self.val = data.val or 0
    self.alterguardian_phase3_defeat = data.alterguardian_phase3_defeat
end


return world_data_lol_wp