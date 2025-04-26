---@class replica_components
---@field lol_wp_cd_itemtile replica_lol_wp_cd_itemtile

---@class replica_lol_wp_cd_itemtile
---@field inst ent
---@field cur_cd netvar
---@field _show_itemtile netvar
local lol_wp_cd_itemtile = Class(
---@param self replica_lol_wp_cd_itemtile
---@param inst ent
function(self, inst)
    self.inst = inst
    self.cur_cd = net_byte(inst.GUID, "lol_wp_cd_itemtile.cur_cd",'lol_wp_cd_itemtile_cur_cd_change')

    self._show_itemtile = net_bool(inst.GUID, "lol_wp_cd_itemtile._show_itemtile")
end)

function lol_wp_cd_itemtile:SetCurCD(num)
    self.cur_cd:set(num)
end

function lol_wp_cd_itemtile:GetCurCD()
    return self.cur_cd:value()
end

---是否显示在itemtile上
---@return boolean
---@nodiscard
function lol_wp_cd_itemtile:ShouldShown()
    local res = self._show_itemtile:value() and true or false
    return res
end

---
---@return boolean
---@nodiscard
function lol_wp_cd_itemtile:IsCD()
    return (self.cur_cd:value() or 0) > 0
end

return lol_wp_cd_itemtile