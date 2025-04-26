local data = require('core_lol_wp/data/lol_wp_potion')


---@class replica_components
---@field lol_wp_potion_drinker replica_lol_wp_potion_drinker

---@class replica_lol_wp_potion_drinker
---@field inst ent
---@field unique_type netvar
local lol_wp_potion_drinker = Class(
---@param self replica_lol_wp_potion_drinker
---@param inst ent
function(self, inst)
    self.inst = inst
    self.unique_type = net_tinybyte(inst.GUID, "lol_wp_potion_drinker.unique_type")
end)

function lol_wp_potion_drinker:SetType(num)
    self.unique_type:set(num)
end

---是否可以引用药水
---@param potion ent
---@return boolean
---@nodiscard
function lol_wp_potion_drinker:CanDrink(potion)
    local prefab = potion.prefab
    if prefab and data[prefab] then
        local cur_unique_type = self.unique_type:value()
        -- 如果没有使用任何药水,则可以饮用,除非有限制条件
        if cur_unique_type == 0 then
            local test_drink = data[prefab].test_drink
            if test_drink ~= nil then
                return test_drink(potion)
            end
            return true
        end
        -- 如果正在使用相同的药水,则可以饮用,除非有限制条件
        if cur_unique_type == data[prefab].unique_type then
            local test_drink = data[prefab].test_drink
            if test_drink ~= nil then
                return test_drink(potion)
            end
            return true
        end
    end
    return false
end

return lol_wp_potion_drinker