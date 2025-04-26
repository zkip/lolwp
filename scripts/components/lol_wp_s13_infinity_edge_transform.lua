---@class components
---@field lol_wp_s13_infinity_edge_transform component_lol_wp_s13_infinity_edge_transform

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_s13_infinity_edge_transform:SetVal(value)
-- end

local tf_map = {
    lol_wp_s13_infinity_edge = 'lol_wp_s13_infinity_edge_amulet',
    lol_wp_s13_infinity_edge_amulet = 'lol_wp_s13_infinity_edge',
}

---@class component_lol_wp_s13_infinity_edge_transform
---@field inst ent
local lol_wp_s13_infinity_edge_transform = Class(

---@param self component_lol_wp_s13_infinity_edge_transform
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_s13_infinity_edge_transform:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_s13_infinity_edge_transform:OnLoad(data)
--     -- self.val = data.val or 0
-- end

---转换
---@param player ent
---@return boolean
---@nodiscard
function lol_wp_s13_infinity_edge_transform:Transform(player)
    -- 数据传输
    local durability = self.inst.components.finiteuses and self.inst.components.finiteuses:GetPercent() or 1
    -- local skin_build = self.inst:GetSkinBuild()
    local skin_name = self.inst:GetSkinName() or self.inst._skin_name_lol_wp_s13_infinity_edge

    local new = SpawnPrefab(tf_map[self.inst.prefab],skin_name)
    new._skin_name_lol_wp_s13_infinity_edge = skin_name

    if new.components.finiteuses then
        new.components.finiteuses:SetPercent(durability)
    end
    if player.components.inventory then
        player.components.inventory:GiveItem(new)
    else
        local pt = player:GetPosition()
        new.Transform:SetPosition(pt:Get())
    end
    -- 移除旧物品
    self.inst:Remove()

    return true
end

return lol_wp_s13_infinity_edge_transform