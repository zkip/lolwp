---@class replica_components
---@field lol_wp_s14_hubris_skill_reputation replica_lol_wp_s14_hubris_skill_reputation

---@class replica_lol_wp_s14_hubris_skill_reputation
---@field inst ent
---@field val netvar
local lol_wp_s14_hubris_skill_reputation = Class(

---@param self replica_lol_wp_s14_hubris_skill_reputation
---@param inst ent
function(self, inst)
    self.inst = inst
    if not TUNING.MOD_LOL_WP.HUBRIS.SKILL_REPUTATION.MAXSTACK then
        self.val = net_ushortint(inst.GUID, "lol_wp_s14_hubris_skill_reputation.val",'lol_wp_s14_hubris_skill_reputation_val_change')
    else
        self.val = net_byte(inst.GUID, "lol_wp_s14_hubris_skill_reputation.val",'lol_wp_s14_hubris_skill_reputation_val_change')
    end
end)

function lol_wp_s14_hubris_skill_reputation:SetVal(num)
    self.val:set(num)
end

function lol_wp_s14_hubris_skill_reputation:GetVal()
    return self.val:value()
end

return lol_wp_s14_hubris_skill_reputation