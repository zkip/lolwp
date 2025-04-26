local db = TUNING.MOD_LOL_WP.ZHONYA
local prefab_id = 'lol_wp_s15_zhonya'
---@class components
---@field lol_wp_s15_zhonya component_lol_wp_s15_zhonya

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_s15_zhonya:SetVal(value)
-- end

---@class component_lol_wp_s15_zhonya
---@field inst ent
---@field _delta_rate number
---@field _light ent|nil
local lol_wp_s15_zhonya = Class(
---@param self component_lol_wp_s15_zhonya
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
    self._delta_rate = 0
    self._light = nil
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_s15_zhonya:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_s15_zhonya:OnLoad(data)
--     -- self.val = data.val or 0
-- end

---comment
---@param doer ent
---@return boolean
function lol_wp_s15_zhonya:DoAction(doer)
    ---@class ent
    ---@field lol_wp_s15_zhonya_invincible boolean # 中娅沙漏 主动：【凝滞】 无敌

    self.inst.SoundEmitter:PlaySound('lol_wp_s15_zhonya/fx/zhonya')

    if self.inst.components.rechargeable then
        self.inst.components.rechargeable:Discharge(db.SKILL_FREEZE.CD)
    end

    if self._light ~= nil and self._light:IsValid() then
        self._light:Remove()
        self._light = nil
    end
    self._light = SpawnPrefab('yellowamuletlight')
    if self._light.Light then
        self._light.Light:SetRadius(1)
        self._light.Light:SetColour(232/255,229/255,9/255)
    end
    self._light.entity:SetParent(doer.entity)

    doer.lol_wp_s15_zhonya_invincible = true
    doer.AnimState:SetAddColour(232/255,229/255,9/255,1)
    local pt = doer:GetPosition()
    SpawnPrefab('pocketwatch_heal_fx').Transform:SetPosition(pt:Get())
    SpawnPrefab('fx_book_temperature').Transform:SetPosition(pt:Get())

    doer:DoTaskInTime(db.SKILL_FREEZE.DURATION,function()
        doer.lol_wp_s15_zhonya_invincible = false
        doer.AnimState:SetAddColour(0,0,0,0)

        if self._light ~= nil and self._light:IsValid() then
            self._light:Remove()
            self._light = nil
        end

        SpawnPrefab('pocketwatch_heal_fx').Transform:SetPosition(doer:GetPosition():Get())
    end)

    return true
end

---comment
---@param inst ent
---@param owner ent
function lol_wp_s15_zhonya:WhenEquipInEyeStone(inst,owner)
    if owner.components.lol_wp_player_dmg_adder then
        owner.components.lol_wp_player_dmg_adder:Modifier(prefab_id,db.PLANAR_DMG_WHEN_EQUIP,prefab_id,'planar')
    end

    if owner.components.oldager then
        self._delta_rate = owner.components.oldager.rate - 0
        owner.components.oldager.rate = 0
    end
end
---comment
---@param inst ent
---@param owner ent
function lol_wp_s15_zhonya:WhenUnEquipInEyeStone(inst,owner)
    if owner.components.lol_wp_player_dmg_adder then
        owner.components.lol_wp_player_dmg_adder:RemoveModifier(prefab_id,prefab_id,'planar')
    end

    if owner.components.oldager then
        owner.components.oldager.rate = owner.components.oldager.rate + self._delta_rate
    end
end

return lol_wp_s15_zhonya