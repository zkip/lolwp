

---@class components
---@field lol_wp_player_invincible component_lol_wp_player_invincible # 不保存 设置玩家无敌

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_player_invincible:SetVal(value)
-- end

---@class component_lol_wp_player_invincible
---@field inst ent
---@field num integer
local lol_wp_player_invincible = Class(
---@param self component_lol_wp_player_invincible
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
    self.num = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_player_invincible:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_player_invincible:OnLoad(data)
--     -- self.val = data.val or 0
-- end

---设置为无敌
function lol_wp_player_invincible:Push()
    self.num = self.num + 1
end

---取消无敌
function lol_wp_player_invincible:Pop()
    self.num = self.num - 1
end

---是否无敌
---@return boolean
---@nodiscard
function lol_wp_player_invincible:IsInvincible()
    return self.num > 0
end

return lol_wp_player_invincible