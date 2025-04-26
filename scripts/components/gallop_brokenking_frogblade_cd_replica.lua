---@class replica_components
---@field gallop_brokenking_frogblade_cd replica_gallop_brokenking_frogblade_cd

---@class replica_gallop_brokenking_frogblade_cd
---@field inst ent
---@field val netvar
local gallop_brokenking_frogblade_cd = Class(function(self, inst)
    self.inst = inst
    self.val = net_smallbyte(inst.GUID, "gallop_brokenking_frogblade_cd.val",'gallop_brokenking_frogblade_cd_val_change')
end)

function gallop_brokenking_frogblade_cd:SetVal(num)
    self.val:set(num)
end

function gallop_brokenking_frogblade_cd:GetVal()
    return self.val:value()
end

return gallop_brokenking_frogblade_cd