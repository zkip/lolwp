local db = TUNING.MOD_LOL_WP.BLOODTHIRSTER

local prefab_id = "lol_wp_s18_bloodthirster"
local assets_id = "lol_wp_s18_bloodthirster"

local assets =
{
    Asset( "ANIM", "anim/"..assets_id..".zip"),
    Asset( "ANIM", "anim/swap_"..assets_id..".zip"),
    Asset( "ATLAS", "images/inventoryimages/"..assets_id..".xml" ),

    Asset( "ANIM", "anim/"..assets_id.."_skin_evil_blade.zip"),
    Asset( "ANIM", "anim/swap_"..assets_id.."_skin_evil_blade.zip"),
    Asset( "ATLAS", "images/inventoryimages/"..assets_id.."_skin_evil_blade.xml" ),
}

local prefabs =
{
    prefab_id,
}

local TRAIL_FLAGS = { "shadowtrail" }
local function do_trail(inst)
    if not inst.entity:IsVisible() then
        return
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    if inst.sg ~= nil and inst.sg:HasStateTag("moving") then
        local theta = -inst.Transform:GetRotation() * DEGREES
        local speed = inst.components.locomotor:GetRunSpeed() * .1
        x = x + speed * math.cos(theta)
        z = z + speed * math.sin(theta)
    end
    local mounted = inst.components.rider ~= nil and inst.components.rider:IsRiding()
    local map = TheWorld.Map
    local offset = FindValidPositionByFan(
        math.random() * 2 * PI,
        (mounted and 1 or .5) + math.random() * .5,
        4,
        function(offset)
            local pt = Vector3(x + offset.x, 0, z + offset.z)
            return map:IsPassableAtPoint(pt:Get())
                and not map:IsPointNearHole(pt)
                and #TheSim:FindEntities(pt.x, 0, pt.z, .7, TRAIL_FLAGS) <= 0
        end
    )

    if offset ~= nil then
        SpawnPrefab("cane_ancient_fx").Transform:SetPosition(x + offset.x, 0, z + offset.z)
    end
end

---和虚空风帽，虚空长袍同时装备时，获得额外5点吸血和10点位面伤害
---@source ..\core_lol_wp\hooks\lol_wp_dmgsys.lua:145
local __see_______________

---onequipfn
---@param inst ent
---@param owner ent
---@param from_ground boolean
local function onequip(inst, owner,from_ground)
    local skin_build = inst:GetSkinBuild()
	if skin_build ~= nil then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideItemSkinSymbol("swap_object", "swap_"..skin_build, "swap_"..skin_build, inst.GUID, "swap_"..assets_id)
	else
		owner.AnimState:OverrideSymbol("swap_object", "swap_"..assets_id, "swap_"..assets_id)
	end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if owner.components.lol_wp_critical_hit_player then
        owner.components.lol_wp_critical_hit_player:Modifier('CriticalChance','add',inst,db.CRITICAL_CHANCE,prefab_id)
        owner.components.lol_wp_critical_hit_player:Modifier('CriticalDamage','mult',inst,db.CRITICAL_DMGMULT,prefab_id)
        owner.components.lol_wp_critical_hit_player:SetOnCriticalHit(prefab_id,function (victim)
            if victim then
                local victim_pt = victim:GetPosition()
                local fx = nil
                local _skin_build = inst:GetSkinBuild()
	            if _skin_build ~= nil then
                    if _skin_build == 'lol_wp_s18_bloodthirster_skin_evil_blade' then
                        fx = 'wanda_attack_pocketwatch_old_fx'
                    end
                else
                    fx = 'wanda_attack_pocketwatch_old_fx'
                end
                if fx then
                    SpawnPrefab(fx).Transform:SetPosition(victim_pt:Get())
                end
            end
        end)
    end

    if owner.taskperiod_lol_wp_s18_bloodthirster_fx == nil then
        ---@diagnostic disable-next-line: inject-field
        owner.taskperiod_lol_wp_s18_bloodthirster_fx = owner:DoPeriodicTask(6 * FRAMES, do_trail, 2 * FRAMES)
    end
end

---onunequipfn
---@param inst ent
---@param owner ent
local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    local skin_build = inst:GetSkinBuild()
	if skin_build ~= nil then
		owner:PushEvent("unequipskinneditem", inst:GetSkinName())
	end

    if owner.components.lol_wp_critical_hit_player then
        owner.components.lol_wp_critical_hit_player:RemoveModifier('CriticalChance','add',inst,prefab_id)
        owner.components.lol_wp_critical_hit_player:RemoveModifier('CriticalDamage','mult',inst,prefab_id)
        owner.components.lol_wp_critical_hit_player:RemoveOnCriticalHit(prefab_id)
    end

    if owner.taskperiod_lol_wp_s18_bloodthirster_fx then
        owner.taskperiod_lol_wp_s18_bloodthirster_fx:Cancel()
        ---@diagnostic disable-next-line: inject-field
        owner.taskperiod_lol_wp_s18_bloodthirster_fx = nil
    end
end

local function onfinished(inst)
    LOLWP_S:unequipItem(inst)
    inst:AddTag(prefab_id..'_nofiniteuses')
end

---onattack
---@param inst ent
---@param attacker ent
---@param target ent
local function onattack(inst,attacker,target)
    if attacker then
        if target then
            local pt = target:GetPosition()
            SpawnPrefab('shadowstrike_slash_fx').Transform:SetPosition(pt:Get())
        end
        if attacker.components.sanity then
            attacker.components.sanity:DoDelta(db.ATK_DELTA_SAN)
        end

        if inst.components.rechargeable and inst.components.rechargeable:IsCharged() then
            inst.components.rechargeable:Discharge(db.SKILL_SPIRITUAL_LIQUID_SHIELD.CD)

            local shield = SpawnPrefab('forcefieldfx')
            shield.entity:SetParent(attacker.entity)

            if attacker.components.lol_wp_player_invincible then
                attacker.components.lol_wp_player_invincible:Push()
                attacker:DoTaskInTime(db.SKILL_SPIRITUAL_LIQUID_SHIELD.SHIELD_DURATION,function()
                    if shield and shield:IsValid() then
                        shield:Remove()
                    end
                    attacker.components.lol_wp_player_invincible:Pop()
                end)
            end
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddLight()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(assets_id)
    inst.AnimState:SetBuild(assets_id)
    inst.AnimState:PlayAnimation("idle",true)

    MakeInventoryFloatable(inst, "med", nil, 0.75)

    -- inst.Light:SetFalloff(0.5)
    -- inst.Light:SetIntensity(.8)
    -- inst.Light:SetRadius(1.3)
    -- inst.Light:SetColour(128/255, 20/255, 128/255)
    -- inst.Light:Enable(true)

    inst.entity:SetPristine()

    inst:AddTag("nosteal")

    inst:AddTag('shadow_item')
    inst:AddTag('shadowlevel')

    -- inst.MiniMapEntity:SetIcon(prefab_id..".tex")

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst:AddComponent("talker")
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = assets_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..assets_id..".xml"
    -- inst.components.inventoryitem:SetOnDroppedFn(function()
    -- end)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.walkspeedmult = 1.2
    inst.components.equippable.dapperness = db.DARPPERNESS/54

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(db.DMG)
    inst.components.weapon:SetRange(db.RANGE,db.RANGE)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(db.FINITEUSES)
    inst.components.finiteuses:SetUses(db.FINITEUSES)
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("shadowlevel")
    inst.components.shadowlevel:SetDefaultLevel(db.SHADOW_LEVEL)

    inst:AddComponent("damagetypebonus")
    inst.components.damagetypebonus:AddBonus("lunar_aligned", inst, db.DMGMULT_TO_PLANAR)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetChargeTime(db.SKILL_SPIRITUAL_LIQUID_SHIELD.CD)
    -- inst.components.rechargeable:SetOnDischargedFn(function(inst)  end)
    -- inst.components.rechargeable:SetOnChargedFn(function(inst)
    --     if inst:HasTag(prefab_id..'_iscd') then
    --         inst:RemoveTag(prefab_id..'_iscd')
    --     end
    -- end)

    -- local planardamage = inst:AddComponent("planardamage")
    -- planardamage:SetBaseDamage(data_prefab.planardamage)

    -- inst.OnSave = onsave
    -- inst.OnPreLoad = onpreload

    return inst
end

return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs)