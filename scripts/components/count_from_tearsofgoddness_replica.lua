---@class replica_components
---@field count_from_tearsofgoddness replica_count_from_tearsofgoddness

---@class replica_count_from_tearsofgoddness
---@field inst ent
---@field val netvar
---@field max netvar
local count_from_tearsofgoddness = Class(

---@param self replica_count_from_tearsofgoddness
---@param inst ent
function(self, inst)
    self.inst = inst
    self.val = net_ushortint(inst.GUID, "count_from_tearsofgoddness.val",'count_from_tearsofgoddness_val_change')

    self.max = net_ushortint(inst.GUID, "count_from_tearsofgoddness.max")
end)

function count_from_tearsofgoddness:SetVal(num)
    self.val:set(num)
end

function count_from_tearsofgoddness:GetVal()
    return self.val:value()
end

---comment
---@return boolean
---@nodiscard
function count_from_tearsofgoddness:IsMax()
    local max = self.max:value()
    local val = self.val:value()
    if max ~= 0 then
        return val >= max
    else
        return false
    end
end

return count_from_tearsofgoddness