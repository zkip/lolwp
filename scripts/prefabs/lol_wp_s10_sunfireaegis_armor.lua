---@diagnostic disable: undefined-global, trailing-space
local prefab_id = 'lol_wp_s10_sunfireaegis_armor'

local modid = 'lol_wp'

local db = TUNING.MOD_LOL_WP.SUNFIREAEGIS

local assets =
{
    Asset("ANIM", "anim/"..prefab_id..".zip"),
    Asset("ATLAS", "images/inventoryimages/"..prefab_id..".xml"),
}

local prefabs =
{
    "reticulearc",
    "reticulearcping",
    "lol_wp_s10_sunfireaegis_circle",
}

---comment
---@param spawn_or_kill boolean
---@param target ent
local function circleFollow(spawn_or_kill,target)
    if target.lol_wp_s10_sunfireaegis_fx and target.lol_wp_s10_sunfireaegis_fx:IsValid() then
        target.lol_wp_s10_sunfireaegis_fx:Remove()
        target.lol_wp_s10_sunfireaegis_fx = nil
    else
        target.lol_wp_s10_sunfireaegis_fx = nil
    end

    if spawn_or_kill then
        -- target.lol_wp_s10_sunfireaegis_fx = SpawnPrefab('reticuleaoesmallhostiletarget')
        target.lol_wp_s10_sunfireaegis_fx = SpawnPrefab('lol_wp_s10_sunfireaegis_circle')
        -- target.lol_wp_s10_sunfireaegis_fx.entity:SetParent(target.entity)
        target.lol_wp_s10_sunfireaegis_fx.entity:AddFollower()
        target.lol_wp_s10_sunfireaegis_fx.Follower:FollowSymbol(target.GUID,nil,0,0,0)

    end

end

---comment
---@param enable boolean
---@param owner ent
local function circleDmg(enable,owner)
    circleFollow(enable,owner)

    if owner.taskperiod_lol_wp_s10_sunfireaegis_circledmg then
        owner.taskperiod_lol_wp_s10_sunfireaegis_circledmg:Cancel()
        owner.taskperiod_lol_wp_s10_sunfireaegis_circledmg = nil
    end
    if enable then
        local owner_maxhp = owner and owner.components.health and owner.components.health.maxhealth
        local bonus = (owner_maxhp or 0) * db.SKILL_SUNSHELTER.SUCCESS_BLOCK.EXTRA_DMG_OF_MAXHEALTH
        owner.taskperiod_lol_wp_s10_sunfireaegis_circledmg = owner:DoPeriodicTask(db.SKILL_SACRIFICE.INTERVAL,function ()
            local x,_,z = owner:GetPosition():Get()
            local ents = TheSim:FindEntities(x,0,z,db.SKILL_SACRIFICE.RANGE,{'_health','_combat'},{'player',"INLIMBO","wall","companion"})
            for _,v in pairs(ents) do
                if LOLWP_S:checkAlive(v) and v.components.combat and not v:HasTag('companion') and not v:HasTag('wall') and not v:HasTag('structure') and not v.components.combat:IsAlly(owner) then
                    -- v.components.combat:GetAttacked(owner,0,nil,nil,{planar = db.SKILL_SACRIFICE.PER_PLANARDMG + bonus})
                    local dmg = db.SKILL_SACRIFICE.PER_PLANARDMG + bonus
                    v.components.health:DoDelta(-dmg)
                    v:PushEvent("attacked", { attacker = owner, damage = dmg ,damageresolved = dmg, original_damage = dmg})
                end
            end
        end)
    end
end

---comment
---@param whenequip boolean
---@param owner ent
---@param other_sunfire_prefab string
local function ifOwnerHasSunfire(whenequip,owner,other_sunfire_prefab)
    if owner and owner.components.inventory then
        if not owner.components.inventory:EquipHasTag(other_sunfire_prefab) then
            if TUNING[string.upper('CONFIG_'..modid..'sunfire_aura')] then
                circleDmg(whenequip,owner)
            end
            
        end
    end
end

---comment
---@param owner ent
---@param data event_data_blocked
local function OnBlocked(owner, data)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_scalemail")
    -- if data.attacker ~= nil and 
    --     not (data.attacker.components.health ~= nil and data.attacker.components.health:IsDead()) and
    --     (data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil)) and
    --     data.attacker.components.burnable ~= nil and
    --     not data.redirected and
    --     not data.attacker:HasTag("thorny") then
    --     -- data.attacker.components.burnable:Ignite(nil,nil,owner)
    -- end
    local target = data and data.attacker
    if target and LOLWP_S:checkAlive(target) then
        if target.taskperiod_lol_wp_s10_sunfireaegis_armor_firetouch == nil then
            local dmg = db.SKILL_FIRETOUCH.BURN_DMG
            if target.components.burnable then
                target.components.burnable.controlled_burn = {
                    duration_creature = 3,
                    dmg = 0,
                }
                target.components.burnable:SpawnFX(false)
                target.components.burnable.controlled_burn = nil
            end

            target.taskperiod_lol_wp_s10_sunfireaegis_armor_firetouch = target:DoPeriodicTask(db.SKILL_FIRETOUCH.BURN_PERIOD, function()
                if LOLWP_S:checkAlive(target) then
                    -- if target.components.combat then
                    --     target.components.combat:GetAttacked(attacker, db.SKILL_FIRETOUCH.BURN_DMG,inst)
                    -- end
                    target.components.health:DoDelta(-dmg)
                    -- target:PushEvent("attacked", { attacker = owner, damage = dmg ,damageresolved = dmg, original_damage = dmg})

                end
            end)

            target:DoTaskInTime(db.SKILL_FIRETOUCH.BURN_LAST,function ()
                if target then
                    if target.components.burnable then
                        target.components.burnable:KillFX()
                    end
                    if target.taskperiod_lol_wp_s10_sunfireaegis_armor_firetouch then
                        target.taskperiod_lol_wp_s10_sunfireaegis_armor_firetouch:Cancel()
                        target.taskperiod_lol_wp_s10_sunfireaegis_armor_firetouch = nil
                    end
                end
            end)

        end
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", prefab_id, "swap_body")
    inst:ListenForEvent("blocked", OnBlocked, owner)
    inst:ListenForEvent("attacked", OnBlocked, owner)

    ifOwnerHasSunfire(true,owner,'lol_wp_s10_sunfireaegis')
    if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 1 - TUNING.ARMORDRAGONFLY_FIRE_RESIST)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    inst:RemoveEventCallback("attacked", OnBlocked, owner)

    ifOwnerHasSunfire(false,owner,'lol_wp_s10_sunfireaegis')
    if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
    end
end

local function onfinished(inst)
    LOLWP_S:unequipItem(inst)
    inst:AddTag(prefab_id..'_nofiniteuses')
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(prefab_id)
    inst.AnimState:SetBuild(prefab_id)
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("wood")
    inst:AddTag(prefab_id)

    inst.foleysound = "dontstarve/movement/foley/logarmour"

    MakeInventoryFloatable(inst, "small", 0.2, 0.80)

    inst.entity:SetPristine()


    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..prefab_id..".xml"

    inst.lol_wp_s10_sunfireaegis_circleDmg = circleDmg

    -- inst:AddComponent("fuel")
    -- inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(db.FINITEUSE, db.ABSORB)
    inst.components.armor:SetKeepOnFinished(true) -- 耐久用完保留
    inst.components.armor:SetOnFinished(onfinished)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = db.WALKSPEEDMULT

    inst:AddComponent('insulator')
    inst.components.insulator:SetInsulation(db.AVOID_COLD)
    inst.components.insulator:SetWinter()

    inst:AddComponent('lol_wp_s10_sunfireaegis')

    --MakeHauntableLaunch(inst)
    -- MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    return inst
end

return Prefab(prefab_id, fn, assets, prefabs)
