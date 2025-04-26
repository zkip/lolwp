local db = TUNING.MOD_LOL_WP.LOSTCHAPTER

---@class components
---@field lol_wp_s17_lostchapter_data component_lol_wp_s17_lostchapter_data

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_s17_lostchapter_data:SetVal(value)
-- end

---@class component_lol_wp_s17_lostchapter_data
---@field inst ent
local lol_wp_s17_lostchapter_data = Class(

---@param self component_lol_wp_s17_lostchapter_data
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_s17_lostchapter_data:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_s17_lostchapter_data:OnLoad(data)
--     -- self.val = data.val or 0
-- end

---comment
---@param player ent
---@param isday boolean
local function OnIsDay(player, isday)
    if isday then
        if player and player.components.sanity then
            local cur = player.components.sanity:GetPercent()
            local should = math.min(1,cur + (db.SKILL_ENLIGHTENMENT.RECOVER_SAN_PERCENT*TUNING.MOD_LOL_WP.ITEM_EFFECT_RATE_IN_EYESTONE))
            player.components.sanity:SetPercent(should)
        end
    end
end

---comment
---@param inst ent
---@param owner ent
function lol_wp_s17_lostchapter_data:WhenEquip(inst,owner)
    if owner.components.lol_wp_player_dmg_adder then
        local dmg = TUNING.MOD_LOL_WP.ITEM_EFFECT_RATE_IN_EYESTONE * db.PLANAR_DMG_WHEN_EQUIP
        owner.components.lol_wp_player_dmg_adder:Modifier('lol_wp_s17_lostchapter',dmg,'lol_wp_s17_lostchapter','planar')
    end
    owner:WatchWorldState('isday',OnIsDay)
end

---comment
---@param inst ent
---@param owner ent
function lol_wp_s17_lostchapter_data:WhenUnequip(inst,owner)
    if owner.components.lol_wp_player_dmg_adder then
        owner.components.lol_wp_player_dmg_adder:RemoveModifier('lol_wp_s17_lostchapter','lol_wp_s17_lostchapter','planar')
    end
    owner:StopWatchingWorldState('isday',OnIsDay)
end

return lol_wp_s17_lostchapter_data