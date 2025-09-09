---@class components
---@field lol_heartsteel_data component_lol_heartsteel_data

-- local function on_val(self, value)
    -- self.inst.replica.lol_heartsteel_data:SetVal(value)
-- end

---@class component_lol_heartsteel_data
local lol_heartsteel_data = Class(function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_heartsteel_data:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_heartsteel_data:OnLoad(data)
--     -- self.val = data.val or 0
-- end


local DETECT_INTERVAL = 1
local CD,max_num,per_hp = TUNING.HEARTSTEEL_CD,40,10
local regen_interval,hp_per_hit = 10,5
local new_hp_per_hit_percent = .01

-- 设置装备栏位,注意如果没有开启五格装备栏,但是设置中设置了项链栏位,那么要确保在身体栏位
local HEARTSTEEL_EQIPSLOT = EQUIPSLOTS.BODY
if TUNING.CONFIG_LIMIT_LOL_HEARTSTEEL_EQUIPSLOT == 1 then
    HEARTSTEEL_EQIPSLOT = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
end

local function owner_onhitother(inst, data)
    local itm = inst.components.inventory:GetEquippedItem(HEARTSTEEL_EQIPSLOT)

    if itm and itm.components and itm.components.lol_heartsteel_num then
    else
        itm = LOLWP_U:getEquipInEyeStone(inst,'lol_heartsteel')
    end

    if itm and itm.components and itm.components.lol_heartsteel_num then
        -- if itm.task_period_lol_heartsteel_findmob then 
        --     itm.task_period_lol_heartsteel_findmob:Cancel()
        --     itm.task_period_lol_heartsteel_findmob = nil
        -- end
        -- if TUNING.CONFIG_LIMIT_LOL_HEARTSTEEL then
        --     if itm.components.lol_heartsteel_num:GetNum() >= max_num then return end
        -- end
    else
        return
    end


    local victim = data.target
    if victim and victim:IsValid() and victim.components and victim.components.health and victim.components.combat and not victim.components.health:IsDead() then
        if victim.lol_heartsteel_hited ~= nil then
            if not victim.lol_heartsteel_hited then -- 没有攻击过
                if victim.fx_lol_heartsteel and victim.fx_lol_heartsteel.stage and victim.fx_lol_heartsteel.stage >= 5 then -- 满充能
                else
                    return
                end

                if victim.task_period_lol_heartsteel_cd == nil then
                    victim.task_period_lol_heartsteel_cd = victim:DoTaskInTime(CD,function()
                        if victim and victim:IsValid() then victim.lol_heartsteel_hited = false end
                        if victim.task_period_lol_heartsteel_cd then
                            victim.task_period_lol_heartsteel_cd:Cancel()
                            victim.task_period_lol_heartsteel_cd = nil
                        end
                    end)
                    victim.lol_heartsteel_hited = true

                    local bonus_dmg = 60 + inst.components.health.maxhealth*.1
                    victim.components.combat:GetAttacked(inst, bonus_dmg)
                    -- 移除特效
                    if victim.fx_lol_heartsteel then
                        victim.fx_lol_heartsteel:Remove()
                        victim.fx_lol_heartsteel = nil
                        SpawnPrefab('lavaarena_firebomb_explosion').Transform:SetPosition(victim:GetPosition():Get())
                    end

                    if itm.SoundEmitter then
                        itm.SoundEmitter:PlaySound('soundfx_lol_heartsteel/lol_heartsteel/atk')
                    end

                    -- 如果超过最大层数,则不继续叠加,但是可以继续触发充能攻击
                    if TUNING.CONFIG_LIMIT_LOL_HEARTSTEEL then
                        if itm.components.lol_heartsteel_num:GetNum() >= TUNING.CONFIG_LIMIT_LOL_HEARTSTEEL then return end
                    end
                    itm.components.lol_heartsteel_num:DoDelta(1)
                    itm.components.lol_heartsteel_num:AddHP(inst)
                end
            end
        end
    end
end

function lol_heartsteel_data:onequip(inst,owner)
    if inst and inst.prefab == 'wurt' then
        return
    end

    owner:ListenForEvent('onhitother',owner_onhitother)

    if owner.equipped_lol_heartsteel == nil or not owner.equipped_lol_heartsteel then
        owner.equipped_lol_heartsteel = true
        inst.components.lol_heartsteel_num:UpdateHP(owner)
        if inst.task_period_lol_heartsteel_findmob == nil and inst.components and inst.components.lol_heartsteel_num then
            -- if TUNING.CONFIG_LIMIT_LOL_HEARTSTEEL and inst.components.lol_heartsteel_num:GetNum()>=max_num then 
            --     return 
            -- end

            inst.task_period_lol_heartsteel_findmob = inst:DoPeriodicTask(DETECT_INTERVAL,function()
                inst.components.lol_heartsteel_num:FindMob()
            end)
        end
    end

    -- 恢复
    if owner.taskperiod_lol_heartsteel_regen == nil then
        owner.taskperiod_lol_heartsteel_regen = owner:DoPeriodicTask(regen_interval,function()
            if owner and owner:IsValid() and owner.components and owner.components.health then
                local maxhealth = owner.components.health.maxhealth
                local delta = maxhealth * new_hp_per_hit_percent
                owner.components.health:DoDelta(delta)
            end
        end)
    end
end

function lol_heartsteel_data:onunequip(inst, owner)
    if inst and inst.prefab == 'wurt' then
        return
    end

    owner:RemoveEventCallback('onhitother',owner_onhitother)

    if owner.equipped_lol_heartsteel then
        owner.equipped_lol_heartsteel = false
        inst.components.lol_heartsteel_num:UpdateHP(owner,true)
        if inst.task_period_lol_heartsteel_findmob then
            inst.task_period_lol_heartsteel_findmob:Cancel()
            inst.task_period_lol_heartsteel_findmob = nil
        end
    end

    -- cancel 恢复
    if owner.taskperiod_lol_heartsteel_regen then
        owner.taskperiod_lol_heartsteel_regen:Cancel()
        owner.taskperiod_lol_heartsteel_regen = nil
    end
end

return lol_heartsteel_data