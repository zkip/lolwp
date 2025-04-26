-- 无耐久不能装备
-- S10 之后的装备统一在此处管理

---@type table<string,boolean>
local data = TUNING.MOD_LOL_WP.CANTEQUIP_WHENNODURABILITY

AddComponentPostInit('equippable',function (self)
    local old_IsRestricted = self.IsRestricted
    function self:IsRestricted(target,...)
        local prefab = self.inst.prefab
        if prefab and data[prefab] then
            if self.inst:HasTag(prefab..'_nofiniteuses') then
                return true
            end
        end
        return old_IsRestricted(self,target,...)
    end
end)

AddClassPostConstruct("components/equippable_replica", function(self)
    local old_IsRestricted = self.IsRestricted
    function self:IsRestricted(target,...)
        local prefab = self.inst.prefab
        if prefab and data[prefab] then
            if self.inst:HasTag(prefab..'_nofiniteuses') then
                return true
            end
        end
        return old_IsRestricted(self,target,...)
    end
end)