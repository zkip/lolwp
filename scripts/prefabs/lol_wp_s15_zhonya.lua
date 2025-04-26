local db = TUNING.MOD_LOL_WP.ZHONYA

local prefab_id = 'lol_wp_s15_zhonya'
local assest_id = prefab_id

local assets =
{
    Asset("ANIM", "anim/"..assest_id..".zip"),
    Asset("ANIM", "anim/torso_"..assest_id..".zip"),

    Asset("ATLAS", "images/inventoryimages/"..assest_id..".xml"),
}

local function fn()
    ---@type boolean
    local equipped = false
    ---@type number
    local delta_rate
    ---onequipfn
    ---@param inst ent
    ---@param owner ent
    ---@param from_ground boolean
    local function onequip(inst, owner,from_ground)
        if not equipped then
            equipped = true

            owner.AnimState:OverrideSymbol("swap_body", "torso_"..assest_id, assest_id)

            if owner.components.lol_wp_player_dmg_adder then
                owner.components.lol_wp_player_dmg_adder:Modifier(prefab_id,db.PLANAR_DMG_WHEN_EQUIP,prefab_id,'planar')
            end

            if owner.components.oldager then
                delta_rate = owner.components.oldager.rate - 0
                owner.components.oldager.rate = 0
            end
        end
    end

    ---onunequipfn
    ---@param inst ent
    ---@param owner ent
    local function onunequip(inst, owner)
        if equipped then
            equipped = false

            owner.AnimState:ClearOverrideSymbol("swap_body")

            if owner.components.lol_wp_player_dmg_adder then
                owner.components.lol_wp_player_dmg_adder:RemoveModifier(prefab_id,prefab_id,'planar')
            end

            if owner.components.oldager then
                owner.components.oldager.rate = owner.components.oldager.rate + delta_rate
            end
        end
    end

    -- local function onfinished(inst)  
    --     LOLWP_S:unequipItem(inst)
    --     inst:AddTag(prefab_id..'_nofiniteuses')
    --     inst:PushEvent('lol_wp_runout_durability')
    -- end

    -- local function onsave(inst, data)
    -- end
    -- local function onpreload( inst,data )
    -- end

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

    inst:AddTag('lunar_aligned')

    inst:AddTag('hide_percentage')

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("armor")
    inst.components.armor:InitIndestructible(db.ABSORB)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.walkspeedmult = .8
    -- inst.components.equippable.is_magic_dapperness = true
    inst.components.equippable.dapperness = db.DARPPERNESS/54


    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/jewlery"
    inst.components.inventoryitem.imagename = assest_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..assest_id..".xml"


    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetChargeTime(db.SKILL_FREEZE.CD)
    inst.components.rechargeable:SetOnDischargedFn(function()
        inst:AddTag(prefab_id..'_iscd')
    end)
    inst.components.rechargeable:SetOnChargedFn(function ()
        if inst:HasTag(prefab_id..'_iscd') then
            inst:RemoveTag(prefab_id..'_iscd')
        end
    end)

    inst:AddComponent('lol_wp_s15_zhonya')

    -- inst.OnSave = onsave
    -- inst.OnPreLoad = onpreload

    return inst
end

return Prefab(prefab_id, fn, assets)