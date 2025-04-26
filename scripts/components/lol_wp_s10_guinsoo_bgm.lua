-- -@class components
-- -@field lol_wp_s10_guinsoo_bgm component_lol_wp_s10_guinsoo_bgm

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_s10_guinsoo_bgm:SetVal(value)
-- end

-- -@class component_lol_wp_s10_guinsoo_bgm
local lol_wp_s10_guinsoo_bgm = Class(function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_s10_guinsoo_bgm:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_s10_guinsoo_bgm:OnLoad(data)
--     -- self.val = data.val or 0
-- end

return lol_wp_s10_guinsoo_bgm