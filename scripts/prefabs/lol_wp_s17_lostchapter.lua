local db = TUNING.MOD_LOL_WP.LOSTCHAPTER

local prefab_id = 'lol_wp_s17_lostchapter'
local assest_id = prefab_id

local assets =
{
    Asset("ANIM", "anim/"..assest_id..".zip"),
    -- Asset("ANIM", "anim/torso_"..assest_id..".zip"),

    Asset("ATLAS", "images/inventoryimages/"..assest_id..".xml"),
}

-- local function onfinished(inst)
--     LOLWP_S:unequipItem(inst)
--     inst:AddTag(prefab_id..'_nofiniteuses')
--     inst:PushEvent('lol_wp_runout_durability')
-- end


-- local function onsave(inst, data)
--     data._skin_name_lol_wp_s13_infinity_edge = inst._skin_name_lol_wp_s13_infinity_edge
-- end
-- local function onpreload( inst,data )
--     inst._skin_name_lol_wp_s13_infinity_edge = data and data._skin_name_lol_wp_s13_infinity_edge
-- end

local function fn()
    ---comment
    ---@param player ent
    ---@param isday boolean
    local function OnIsDay(player, isday)
        if isday then
            if player and player.components.sanity then
                local cur = player.components.sanity:GetPercent()
                local should = math.min(1,cur + db.SKILL_ENLIGHTENMENT.RECOVER_SAN_PERCENT)
                player.components.sanity:SetPercent(should)
            end
        end
    end

    local is_equip = false

    ---onequipfn
    ---@param inst ent
    ---@param owner ent
    ---@param from_ground boolean
    local function onequip(inst, owner,from_ground)
        if not is_equip then
            is_equip = true
            -- owner.AnimState:OverrideSymbol("swap_body", "torso_"..assest_id, assest_id)
            if owner.components.lol_wp_player_dmg_adder then
                owner.components.lol_wp_player_dmg_adder:Modifier('lol_wp_s17_lostchapter',db.PLANAR_DMG_WHEN_EQUIP,'lol_wp_s17_lostchapter','planar')
            end
            owner:WatchWorldState('isday',OnIsDay)
        end
    end

    ---onunequipfn
    ---@param inst ent
    ---@param owner ent
    local function onunequip(inst, owner)
        if is_equip then
            is_equip = false
            owner.AnimState:ClearOverrideSymbol("swap_body")
            if owner.components.lol_wp_player_dmg_adder then
                owner.components.lol_wp_player_dmg_adder:RemoveModifier('lol_wp_s17_lostchapter','lol_wp_s17_lostchapter','planar')
            end
            owner:StopWatchingWorldState('isday',OnIsDay)
        end

    end

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

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

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

    inst:AddComponent('lol_wp_s17_lostchapter_data')


    -- inst:AddComponent("rechargeable")
    -- inst.components.rechargeable:SetChargeTime(4)
    -- inst.components.rechargeable:SetOnDischargedFn(function(inst) end)
    -- inst.components.rechargeable:SetOnChargedFn(OnChargedFn)

    -- inst:AddComponent("finiteuses")
    -- inst.components.finiteuses:SetMaxUses(db.FINITEUSES)
    -- inst.components.finiteuses:SetUses(db.FINITEUSES)
    -- inst.components.finiteuses:SetOnFinished(onfinished)


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