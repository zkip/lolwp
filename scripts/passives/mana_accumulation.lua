local utils_equippable = require('utils/equippable')
local item_database = require('item_database')

local mana_accumulation = Class(function(self, args)
    self.delta = args.delta
    self.epic_delta = args.epic_delta
    self.max = args.max
    self.cd = args.cd
    self.sanity_rate_per_mana = args.sanity_rate_per_mana
end)

function mana_accumulation:ApplyDapperness()
    local owner = self.passive_owner and self.passive_owner.inst
    if owner and owner.components.equippable then
        owner.components.equippable.dapperness = (self.mana * self.sanity_rate_per_mana) / 54
    end
end

function mana_accumulation:DoManaDelta(delta)
    if self.mana >= self.max then return end

    self.mana = math.clamp(self.mana + delta, 0, self.max)
    
    self:ApplyDapperness()
end

-- 如果充能完毕，攻击时增加一层被动
function mana_accumulation:WhenAttack(combat_args)
    local controller_owner = self.passive_controller.inst

    local delta = combat_args.target and combat_args.target:HasTag("epic")
                    and self.epic_delta
                    or  self.delta
    if controller_owner and controller_owner.components.rechargeable and controller_owner.components.rechargeable:IsCharged() then
        controller_owner.components.rechargeable:Discharge(self.cd)
        self:DoManaDelta(delta)
    end
end

function mana_accumulation:WhenEquip()
    self.passive_owner:Activate(self)
end

function mana_accumulation:WhenUnequip()
    self.passive_owner:Deactivate(self)
end

--[[
    静态成员 data 会被 controller 进行特殊处理，用以指示如何持久化数据，
    在组件内部应以 self.<dataname> 来进行访问，如 self.mana
--]]
mana_accumulation.data = {
    mana = { 0, 'ushortint' }
}

--[[
    静态方法
--]]
local Text = require 'widgets/text'
function mana_accumulation.WhenItemtileSetup(itemtile, invitem)
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

    controller_replica:ListenOnDataDirty("mana_accumulation", "mana", on_mana_dirty, true)
end

return mana_accumulation