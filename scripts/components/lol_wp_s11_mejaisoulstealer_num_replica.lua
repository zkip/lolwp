---@class replica_components
---@field lol_wp_s11_mejaisoulstealer_num replica_lol_wp_s11_mejaisoulstealer_num

---@class replica_lol_wp_s11_mejaisoulstealer_num
local lol_wp_s11_mejaisoulstealer_num = Class(function(self, inst)
    self.inst = inst
    self.val = net_ushortint(inst.GUID, "lol_wp_s11_mejaisoulstealer_num.val",'lol_wp_s11_mejaisoulstealer_num_val_change')
end)

function lol_wp_s11_mejaisoulstealer_num:SetVal(num)
        self.val:set(num)
end

function lol_wp_s11_mejaisoulstealer_num:GetVal()
    return self.val:value()
end

return lol_wp_s11_mejaisoulstealer_num