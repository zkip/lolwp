local prefab_id = "lol_wp_s13_infinity_edge"
local assets_id = "lol_wp_s13_infinity_edge"

local db = TUNING.MOD_LOL_WP.INFINITY_EDGE

local assets =
{
    Asset( "ANIM", "anim/"..assets_id..".zip"),
    Asset( "ANIM", "anim/swap_"..assets_id..".zip"),
    Asset( "ATLAS", "images/inventoryimages/"..assets_id..".xml" ),

    Asset( "ANIM", "anim/"..assets_id.."_skin_curse_blade.zip"),
    Asset( "ANIM", "anim/swap_"..assets_id.."_skin_curse_blade.zip"),
    Asset( "ATLAS", "images/inventoryimages/"..assets_id.."_skin_curse_blade.xml" ),
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

---onequipfn
---@param inst ent
---@param owner ent
---@param from_ground boolean
local function onequip(inst, owner,from_ground)
    -- owner.AnimState:OverrideSymbol("swap_object", "swap_"..assets_id, "swap_"..assets_id)
    local skin_build = inst:GetSkinBuild()
	if skin_build ~= nil then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideItemSkinSymbol("swap_object", "swap_"..skin_build, "swap_"..skin_build, inst.GUID, "swap_"..assets_id)
	else
		owner.AnimState:OverrideSymbol("swap_object", "swap_"..assets_id, "swap_"..assets_id)
	end

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.lol_wp_s13_infinity_edge_fx and inst.lol_wp_s13_infinity_edge_fx:IsValid() then
        inst.lol_wp_s13_infinity_edge_fx:Remove()
    end

    if owner and owner.components.combat then
        owner.components.combat.externaldamagemultipliers:SetModifier(inst,db.SKILL_INFINITY_EDGE.OWNER_DMGMULT_WHEN_EQUIP,prefab_id)
    end

    local is_default = true
    if skin_build ~= nil then
        if skin_build == prefab_id.."_skin_curse_blade" then
            is_default = false
            if owner.taskperiod_lol_wp_s13_infinity_edge_skin_curse_blade == nil then
                ---@diagnostic disable-next-line: inject-field
                owner.taskperiod_lol_wp_s13_infinity_edge_skin_curse_blade = owner:DoPeriodicTask(6 * FRAMES, do_trail, 2 * FRAMES)
            end
        end
    end
    if is_default then
        ---@diagnostic disable-next-line: inject-field
        inst.lol_wp_s13_infinity_edge_fx = SpawnPrefab('cane_victorian_fx')
        inst.lol_wp_s13_infinity_edge_fx.entity:SetParent(owner.entity)
        inst.lol_wp_s13_infinity_edge_fx.entity:AddFollower()
        inst.lol_wp_s13_infinity_edge_fx.Follower:FollowSymbol(owner.GUID, 'swap_object', 0, 0, 0)
    end

    if owner.components.lol_wp_critical_hit_player then
        owner.components.lol_wp_critical_hit_player:Modifier('CriticalChance','add',inst,db.CRITICAL_CHANCE,prefab_id)
        owner.components.lol_wp_critical_hit_player:Modifier('CriticalDamage','mult',inst,db.CRITICAL_DMGMULT,prefab_id)
        owner.components.lol_wp_critical_hit_player:SetOnCriticalHit(prefab_id,function (victim)
            if victim then
                local FX_WHEN_CC = db.FX_WHEN_CC
                if skin_build ~= nil then
                    if skin_build == prefab_id.."_skin_curse_blade" then
                        FX_WHEN_CC = 'wanda_attack_pocketwatch_old_fx'
                    end
                end
                local victim_pt = victim:GetPosition()
                SpawnPrefab(FX_WHEN_CC).Transform:SetPosition(victim_pt:Get())
            end
        end)
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

    if owner and owner.components.combat then
        owner.components.combat.externaldamagemultipliers:RemoveModifier(inst,prefab_id)
    end

    if inst.lol_wp_s13_infinity_edge_fx and inst.lol_wp_s13_infinity_edge_fx:IsValid() then
        inst.lol_wp_s13_infinity_edge_fx:Remove()
        ---@diagnostic disable-next-line: inject-field
        inst.lol_wp_s13_infinity_edge_fx = nil
    end

    if owner then
        if owner.taskperiod_lol_wp_s13_infinity_edge_skin_curse_blade then
            owner.taskperiod_lol_wp_s13_infinity_edge_skin_curse_blade:Cancel()
            ---@diagnostic disable-next-line: inject-field
            owner.taskperiod_lol_wp_s13_infinity_edge_skin_curse_blade = nil
        end
    end

    if owner.components.lol_wp_critical_hit_player then
        owner.components.lol_wp_critical_hit_player:RemoveModifier('CriticalChance','add',inst,prefab_id)
        owner.components.lol_wp_critical_hit_player:RemoveModifier('CriticalDamage','mult',inst,prefab_id)
        owner.components.lol_wp_critical_hit_player:RemoveOnCriticalHit(prefab_id)
    end
end

local function onfinished(inst)
    LOLWP_S:unequipItem(inst)
    inst:AddTag(prefab_id..'_nofiniteuses')
    -- inst:PushEvent('lol_wp_runout_durability')
end

---onattack
---@param inst ent
---@param attacker ent
---@param target ent
local function onattack(inst,attacker,target)
    if target then
        local tar_pt = target:GetPosition()
        SpawnPrefab(db.HIF_FX).Transform:SetPosition(tar_pt:Get())
    end
end

---comment
---@param inst ent
---@param victim ent
---@param attacker ent
local function on_critical_hit(inst,victim,attacker)
    if victim then
        local victim_pt = victim:GetPosition()
        SpawnPrefab(db.FX_WHEN_CC).Transform:SetPosition(victim_pt:Get())
    end
end

local function onsave(inst, data)
    data._skin_name_lol_wp_s13_infinity_edge = inst._skin_name_lol_wp_s13_infinity_edge
end
local function onpreload( inst,data )
    inst._skin_name_lol_wp_s13_infinity_edge = data and data._skin_name_lol_wp_s13_infinity_edge
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

    -- inst.MiniMapEntity:SetIcon(prefab_id..".tex")

    if not TheWorld.ismastersim then
        return inst
    end

    inst._skin_name_lol_wp_s13_infinity_edge = nil

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
    inst.components.equippable.walkspeedmult = db.WALKSPEEDMULT
    -- inst.components.equippable.dapperness = 2

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(db.DMG)
    inst.components.weapon:SetRange(db.RANGE,db.RANGE)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(db.FINITEUSES)
    inst.components.finiteuses:SetUses(db.FINITEUSES)
    inst.components.finiteuses:SetOnFinished(onfinished)

    -- inst:AddComponent('lol_wp_critical_hit')
    -- inst.components.lol_wp_critical_hit:Init(db.CRITICAL_CHANCE,db.CRITICAL_DMGMULT,true,'all')
    -- inst.components.lol_wp_critical_hit:SetOnCriticalHit(on_critical_hit)

    inst:AddComponent('lol_wp_s13_infinity_edge_transform')

    -- inst:AddComponent("rechargeable")
    -- inst.components.rechargeable:SetChargeTime(100)
    -- -- inst.components.rechargeable:SetOnDischargedFn(function(inst)  end)
    -- inst.components.rechargeable:SetOnChargedFn(function(inst)
    --     if inst:HasTag(prefab_id..'_iscd') then
    --         inst:RemoveTag(prefab_id..'_iscd')
    --     end
    -- end)

    -- local planardamage = inst:AddComponent("planardamage")
    -- planardamage:SetBaseDamage(data_prefab.planardamage)

    inst.OnSave = onsave
    inst.OnPreLoad = onpreload

    return inst
end

return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs)