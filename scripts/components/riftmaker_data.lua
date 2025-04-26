---@class components
---@field riftmaker_data component_riftmaker_data

-- local function on_val(self, value)
    -- self.inst.replica.riftmaker_data:SetVal(value)
-- end

---@class component_riftmaker_data
local riftmaker_data = Class(function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function riftmaker_data:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function riftmaker_data:OnLoad(data)
--     -- self.val = data.val or 0
-- end

local function dapperness_switch(inst,to_normal)
    if to_normal then
        if inst.components.equippable then
            inst.components.equippable.dapperness = -5/54
        end
    else
        if inst.components.equippable then
            inst.components.equippable.dapperness = -20/54
        end
    end
end

local function StopRegen(inst)
    dapperness_switch(inst,true)
	if inst.regentask ~= nil then
		inst.regentask:Cancel()
		inst.regentask = nil
	end
end

local function DoRegen(inst, owner)
	-- if owner.components.sanity ~= nil and owner.components.sanity:IsInsanityMode() then
	-- 	local setbonus = inst.components.setbonus ~= nil and inst.components.setbonus:IsEnabled(EQUIPMENTSETNAMES.DREADSTONE) and TUNING.ARMOR_DREADSTONE_REGEN_SETBONUS or 1
	-- 	local rate = 1 / Lerp(1 / TUNING.ARMOR_DREADSTONE_REGEN_MAXRATE, 1 / TUNING.ARMOR_DREADSTONE_REGEN_MINRATE, owner.components.sanity:GetPercent())
	-- 	inst.components.finiteuses:Repair(inst.components.finiteuses.total * rate * setbonus)

    if owner.components.sanity ~= nil then
		inst.components.finiteuses:Repair(0.2)
        if inst:HasTag('riftmaker_amulet'..'_nofiniteuses') then
            inst:RemoveTag('riftmaker_amulet'..'_nofiniteuses')
        end
        if inst:HasTag('riftmaker_weapon'..'_nofiniteuses') then
            inst:RemoveTag('riftmaker_weapon'..'_nofiniteuses')
        end
        if inst.components.finiteuses:GetPercent() >= 1 then
            dapperness_switch(inst,true)
        else
            dapperness_switch(inst,false)
        end
	end
end

local function StartRegen(inst, owner)
    dapperness_switch(inst,false)
	if inst.regentask == nil then
		inst.regentask = inst:DoPeriodicTask(TUNING.ARMOR_DREADSTONE_REGEN_PERIOD, DoRegen, nil, owner)
	end
end



local function turnon(inst)
    local owner = inst.components.inventoryitem.owner
    if inst._fx ~= nil then
        inst._fx:Remove()
    end
    inst._fx = SpawnPrefab("riftmaker_light")
    inst._fx.entity:SetParent((owner or inst).entity)
    inst._fx.Transform:SetPosition(0, 0, 0)
end

local function turnoff(inst)
    if inst._fx ~= nil then
        inst._fx:Remove()
    end
end

---comment
---@param inst ent
---@param data event_data_onhitother
local function riftmaker_amulet_onhitother(inst, data)
    if data then
        local stimuli = data.stimuli
        -- 三项不触发峡谷制造者
        if stimuli ~= nil and stimuli == 'lol_wp_trinity_terraprisma' then
            return
        end
        local dmg = data.damageresolved or 0
        local victim = data.target
        if dmg and victim and LOLWP_S:checkAlive(victim) then
            -- 每次攻击会附带当前攻击力25%的额外真实伤害
            LOLWP_S:dealTrueDmg(dmg*.1,victim)
        end
    end
end

function riftmaker_data:onequip(inst,owner)

    if owner.components.sanity ~= nil then
        StartRegen(inst, owner)
    else
        StopRegen(inst)
    end

    turnon(inst)

    owner:ListenForEvent("onhitother", riftmaker_amulet_onhitother)
end

function riftmaker_data:onunequip(inst,owner)
    StopRegen(inst)

    turnoff(inst)

    owner:RemoveEventCallback("onhitother", riftmaker_amulet_onhitother)
end

return riftmaker_data