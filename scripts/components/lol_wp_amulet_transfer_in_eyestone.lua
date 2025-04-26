---comment
---@param itm ent
---@param doer ent
local function unequipItemInEyeStone(itm,doer)
    local eyestone = itm.components.inventoryitem and itm.components.inventoryitem.owner
    if eyestone and eyestone.components.container then
        local slot = eyestone.components.container:GetItemSlot(itm)
        -- local unequipped_itm = eyestone.components.container:RemoveItemBySlot(slot)
        eyestone.components.container:DropItem(itm)

        if doer.components.inventory then
            doer.components.inventory:GiveItem(itm, nil, doer:GetPosition())
        end
    end
end

---@alias lol_wp_amulet_transfer_in_eyestone_prefab_id string
---| 'lol_wp_trinity'
---| 'riftmaker_amulet'
---| 'lol_wp_s13_infinity_edge_amulet'

---@class components
---@field lol_wp_amulet_transfer_in_eyestone component_lol_wp_amulet_transfer_in_eyestone

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_amulet_transfer_in_eyestone:SetVal(value)
-- end

---@class component_lol_wp_amulet_transfer_in_eyestone
---@field inst ent
---@field tbl table<lol_wp_amulet_transfer_in_eyestone_prefab_id,fun(doer:ent):boolean>
local lol_wp_amulet_transfer_in_eyestone = Class(
---@param self component_lol_wp_amulet_transfer_in_eyestone
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0

    self.tbl = {
        lol_wp_trinity = function(doer)
            local obj = self.inst
            if obj.components.equippable then
                unequipItemInEyeStone(obj,doer)
                obj.components.equippable.equipslot = EQUIPSLOTS.HANDS
                obj.lol_wp_trinity_type = 'weapon'
                obj:RemoveTag('amulet')

                if obj:HasTag('lol_wp_trinity_type_'..'amulet') then
                    obj:RemoveTag('lol_wp_trinity_type_'..'amulet')
                end
                obj:AddTag('lol_wp_trinity_type_'..'weapon')

                obj.components.equippable.walkspeedmult = 1
            end
            return true
        end,
        riftmaker_amulet = function(doer)
            local obj = self.inst
            local transfered_item = SpawnPrefab('riftmaker_weapon')
            local finiteuse_percent = obj.components.finiteuses and obj.components.finiteuses:GetPercent() or 1
            if transfered_item.components.finiteuses then
                transfered_item.components.finiteuses:SetPercent(finiteuse_percent)
            end
            obj:Remove()
            if doer.components.inventory then
                doer.components.inventory:GiveItem(transfered_item)
            end
            return true
        end,
        lol_wp_s13_infinity_edge_amulet = function(doer)
            local obj = self.inst
            if obj.components.lol_wp_s13_infinity_edge_transform then
                return obj.components.lol_wp_s13_infinity_edge_transform:Transform(doer)
            end
            return false
        end
    }
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_amulet_transfer_in_eyestone:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_amulet_transfer_in_eyestone:OnLoad(data)
--     -- self.val = data.val or 0
-- end

---护符状态变形到普通状态
---@param id lol_wp_amulet_transfer_in_eyestone_prefab_id # amulet prefab_id
---@param doer ent
---@return boolean
---@nodiscard
function lol_wp_amulet_transfer_in_eyestone:AmuletTransfer(id,doer)
    if self.tbl[id] then
        return self.tbl[id](doer)
    end
    return false
end

return lol_wp_amulet_transfer_in_eyestone