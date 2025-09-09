local utils_equippable = require('utils/equippable')
local item_database = require('item_database')

local mana_flow = Class(function(self, args)
    self.equipping = false
end)

function mana_flow:DoManaDelta(delta)
    if self:IsMax() then return end

    local owner = self.passive_owner and self.passive_owner.inst
    self.mana = math.clamp(self.mana + delta, 0, TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.SAN_LIMIT_MAX)
 
    if owner and owner.components.sanity then
        local san = delta * TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.SAN_LIMIT_PER_NUM
        local maxsan = owner.components.sanity.max
        owner.components.sanity.max = maxsan + san
        owner.components.sanity:DoDelta(0)
    end
end

function mana_flow:IsMax()
    return self.mana >= TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.SAN_LIMIT_MAX
end

-- 如果充能完毕，攻击时增加一层被动
function mana_flow:WhenAttack()
    local controller_owner = self.passive_controller.inst

    if self.equipping and controller_owner and controller_owner.components.rechargeable and controller_owner.components.rechargeable:IsCharged() then
        self:DoManaDelta(TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.NUM_PER_HIT)
        controller_owner.components.rechargeable:Discharge(TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.CD)
    end
end

-- 装备时增加 san 值上限
function mana_flow:WhenInvGet()
    self.passive_owner:Activate(self)
end

-- 装备时增加 san 值上限
function mana_flow:WhenInvLose()
    self.passive_owner:Deactivate(self)
end

-- 装备时增加 san 值上限
function mana_flow:WhenEquip()
    self.equipping = true

    local owner = self.passive_owner.inst
    if not self.passive_owner:IsActivate(self) and owner.components.sanity then
        local san = self.mana * TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.SAN_LIMIT_PER_NUM
        local maxsan = owner.components.sanity.max
        -- TODO: 考虑使用避免潜在竞态条件冲突的方案
        owner.components.sanity.max = maxsan + san
        owner.components.sanity:DoDelta(0)
    end

    self.passive_owner:Activate(self)
end

-- 取消装备时减去增加的 san 值上限
function mana_flow:WhenUnequip()
    self.equipping = false

    local owner = self.passive_owner.inst
    if self.passive_owner:IsActivate(self) and owner.components.sanity then
        local san = self.mana * TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.SAN_LIMIT_PER_NUM
        local maxsan = owner.components.sanity.max
        -- TODO: 考虑使用避免潜在竞态条件冲突的方案
        owner.components.sanity.max = math.max(0, maxsan - san)
        owner.components.sanity:DoDelta(0)
    end

    self.passive_owner:Deactivate(self)
end

-- 增加 san 值回复，装备中、物品栏中均生效
function mana_flow:WhenSanityRate(sanity_rate)
    return sanity_rate + TUNING.MOD_LOL_WP.TEARSOFGODDESS.DAPPERNESS / 54
end

--[[
    静态成员 data 会被 controller 进行特殊处理，用以指示如何持久化数据，
    在组件内部应以 self.<dataname> 来进行访问，如 self.mana
--]]
mana_flow.data = {
    mana = { 0, 'ushortint' }
}

--[[
    静态方法
--]]
local Text = require 'widgets/text'
function mana_flow.WhenItemtileSetup(itemtile, invitem)
    local controller_replica = invitem.replica.lolwp_passive_controller

    local mana_text = itemtile:AddChild(Text(NUMBERFONT, 42))
    local function on_mana_dirty(inst, mana)
        if JapaneseOnPS4() then
            mana_text:SetHorizontalSqueeze(0.7)
        end
        mana_text:SetPosition(5, -32 + 15, 0)
        
        -- mana_text:SetColour({1,0,0,1})
        mana_text:SetString(tostring(mana))

        if not itemtile.dragging and itemtile.item:HasTag("show_broken_ui") then
            if mana > 0 then
                itemtile.bg:Hide()
            else
                itemtile.bg:Show()
            end
        end
    end

    controller_replica:ListenOnDataDirty("mana_flow", "mana", on_mana_dirty, true)
end

return mana_flow