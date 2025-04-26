local prefab_id = 'lol_wp_s9_eyestone_high'
local assest_id = 'lol_wp_s9_eyestone_high'

local assets =
{
    Asset("ANIM", "anim/"..assest_id..".zip"),
    Asset("ANIM", "anim/torso_"..assest_id..".zip"),

    Asset("ATLAS", "images/inventoryimages/"..assest_id..".xml"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "torso_"..assest_id, assest_id)

    if not inst.lol_wp_s9_eyestone_low_isequip then
        inst.components.container:Open(owner)
        inst.lol_wp_s9_eyestone_low_isequip = true
    end

end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    if inst.lol_wp_s9_eyestone_low_isequip then
        if inst.components.container ~= nil then
            inst.components.container:Close(owner)
        end
        inst.lol_wp_s9_eyestone_low_isequip = false
    end

end

-- local function onsave(inst, data)
-- end
-- local function onpreload( inst,data )
-- end

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


    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY -- 适配五格
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    
    -- inst.components.equippable.walkspeedmult = .8
    -- inst.components.equippable.is_magic_dapperness = true
    -- inst.components.equippable.dapperness = TUNING.MOD_LOL_WP.TEARSOFGODDESS.DAPPERNESS/54

    -- inst:AddComponent("planardefense")
    -- inst.components.planardefense:SetBaseDefense(TUNING.MOD_LOL_WP)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/jewlery"
    inst.components.inventoryitem.imagename = assest_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..assest_id..".xml"

    inst:AddTag("amulet") -- 适配六格

    inst:AddComponent("container")
    inst.components.container:WidgetSetup(prefab_id)

    -- inst:AddComponent("rechargeable")
    -- inst.components.rechargeable:SetChargeTime(TUNING.MOD_LOL_WP.TEARSOFGODDESS.SKILL_SPELLFLOW.CD)
    -- inst.components.rechargeable:SetOnDischargedFn(function(inst) end)
    -- inst.components.rechargeable:SetOnChargedFn(function(inst)

    -- end)


    -- inst:AddComponent("fueled")
    -- inst.components.fueled.fueltype = "MAGIC"
    -- inst.components.fueled:InitializeFuelLevel(1000)
    -- inst.components.fueled:SetDepletedFn(inst.Remove)

    -- inst:AddComponent("oxygensupplier")
    -- inst.components.oxygensupplier:SetSupplyRate()

    -- inst.OnSave = onsave
    -- inst.OnPreLoad = onpreload

    return inst
end

return Prefab(prefab_id, fn, assets)
