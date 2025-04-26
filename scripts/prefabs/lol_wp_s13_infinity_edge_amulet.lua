local db = TUNING.MOD_LOL_WP.INFINITY_EDGE

local prefab_id = 'lol_wp_s13_infinity_edge_amulet'
local assest_id = prefab_id

local assets =
{
    Asset("ANIM", "anim/"..assest_id..".zip"),
    Asset("ANIM", "anim/torso_"..assest_id..".zip"),

    Asset("ATLAS", "images/inventoryimages/"..assest_id..".xml"),
}


---onequipfn
---@param inst ent
---@param owner ent
---@param from_ground boolean
local function onequip(inst, owner,from_ground)
    owner.AnimState:OverrideSymbol("swap_body", "torso_"..assest_id, assest_id)

    if owner and owner.components.combat then
        owner.components.combat.externaldamagemultipliers:SetModifier(inst,db.AS_AMULET.OWNER_DMGMULT_WHEN_EQUIP,prefab_id)
    end

    if owner.components.lol_wp_critical_hit_player then
        owner.components.lol_wp_critical_hit_player:Modifier('CriticalChance','add',inst,db.AS_AMULET.CRITICAL_CHANCE,prefab_id)
        owner.components.lol_wp_critical_hit_player:Modifier('CriticalDamage','mult',inst,db.AS_AMULET.CRITICAL_DMGMULT,prefab_id)
        owner.components.lol_wp_critical_hit_player:SetOnCriticalHit(prefab_id,function (victim)
            if victim then
                local victim_pt = victim:GetPosition()
                SpawnPrefab(db.FX_WHEN_CC).Transform:SetPosition(victim_pt:Get())
            end
        end)
        owner.components.lol_wp_critical_hit_player:SetOnHitAlways(prefab_id,function (victim)
            if inst.components.finiteuses then
                inst.components.finiteuses:Use(1)
            end
        end)
        -- owner.components.lol_wp_critical_hit_player:SetOnHit(prefab_id,function (victim)
        --     if inst.components.finiteuses then
        --         inst.components.finiteuses:Use(1)
        --     end
        -- end)
    end
end

---onunequipfn
---@param inst ent
---@param owner ent
local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    if owner and owner.components.combat then
        owner.components.combat.externaldamagemultipliers:RemoveModifier(inst,prefab_id)
    end

    if owner.components.lol_wp_critical_hit_player then
        owner.components.lol_wp_critical_hit_player:RemoveModifier('CriticalChance','add',inst,prefab_id)
        owner.components.lol_wp_critical_hit_player:RemoveModifier('CriticalDamage','mult',inst,prefab_id)
        owner.components.lol_wp_critical_hit_player:RemoveOnCriticalHit(prefab_id)
        -- owner.components.lol_wp_critical_hit_player:RemoveOnHit(prefab_id)
        owner.components.lol_wp_critical_hit_player:RemoveOnHitAlways(prefab_id)
    end
end

local function onfinished(inst)
    LOLWP_S:unequipItem(inst)
    inst:AddTag(prefab_id..'_nofiniteuses')
    inst:PushEvent('lol_wp_runout_durability')
end


local function onsave(inst, data)
    data._skin_name_lol_wp_s13_infinity_edge = inst._skin_name_lol_wp_s13_infinity_edge
end
local function onpreload( inst,data )
    inst._skin_name_lol_wp_s13_infinity_edge = data and data._skin_name_lol_wp_s13_infinity_edge
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    -- inst.entity:AddLight()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(assest_id)
    inst.AnimState:SetBuild(assest_id)
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    inst:AddTag("nosteal")

    MakeInventoryFloatable(inst, "med", nil, 0.75)

    -- inst.Light:SetFalloff(0.5)
    -- inst.Light:SetIntensity(.8)
    -- inst.Light:SetRadius(1.3)
    -- inst.Light:SetColour(128/255, 20/255, 128/255)
    -- inst.Light:Enable(true)

    inst:AddTag("amulet")

    if not TheWorld.ismastersim then
        return inst
    end

    inst._skin_name_lol_wp_s13_infinity_edge = nil

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.walkspeedmult = .8
    -- inst.components.equippable.is_magic_dapperness = true
    inst.components.equippable.dapperness = db.AS_AMULET.DARPPERNESS/54


    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/jewlery"
    inst.components.inventoryitem.imagename = assest_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..assest_id..".xml"


    -- inst:AddComponent("rechargeable")
    -- inst.components.rechargeable:SetChargeTime(4)
    -- inst.components.rechargeable:SetOnDischargedFn(function(inst) end)
    -- inst.components.rechargeable:SetOnChargedFn(OnChargedFn)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(db.FINITEUSES)
    inst.components.finiteuses:SetUses(db.FINITEUSES)
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent('lol_wp_s13_infinity_edge_transform')

    inst:AddComponent('lol_wp_s13_infinity_edge_amulet_data')

    -- inst:AddComponent("fueled")
    -- inst.components.fueled.fueltype = "MAGIC"
    -- inst.components.fueled:InitializeFuelLevel(1000)
    -- inst.components.fueled:SetDepletedFn(inst.Remove)

    -- inst:AddComponent("oxygensupplier")
    -- inst.components.oxygensupplier:SetSupplyRate()

    inst.OnSave = onsave
    inst.OnPreLoad = onpreload

    

    return inst
end

return Prefab(prefab_id, fn, assets)