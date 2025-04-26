local prefab_id = 'lol_wp_s9_guider'
local assets_id = 'lol_wp_s9_guider'

local assets =
{
    Asset("ANIM", "anim/"..assets_id..".zip"),
    Asset("ANIM", "anim/swap_"..assets_id..".zip"),
    Asset( "ATLAS", "images/inventoryimages/"..assets_id..".xml" ),
    -- Asset("ANIM", "anim/ui_backpack_2x4.zip"),
}

local prefabs =
{
    -- "ash",
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("backpack", skin_build, "backpack", inst.GUID, "swap_"..assets_id )
        owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "swap_"..assets_id )
    else
        owner.AnimState:OverrideSymbol("backpack", "swap_"..assets_id, "backpack")
        owner.AnimState:OverrideSymbol("swap_body", "swap_"..assets_id, "swap_body")
    end
    inst.components.container:Open(owner)

    inst.Light:Enable(true)

    if inst.taskperiod_lol_wp_s9_guider == nil then
        inst.taskperiod_lol_wp_s9_guider = inst:DoPeriodicTask(1,function()
            local x,_,z = inst:GetPosition()
            if x and z then
                local ents = TheSim:FindEntities(x, 0, z, TUNING.MOD_LOL_WP.GUIDER.SKILL_GUIDE.RADIUS, {"player"}, {"INLIMBO"})
                for _,v in pairs(ents) do
                    if v.taskperiod_lol_wp_s9_guider_check == nil then
                        if v.components.locomotor then
                            v.components.locomotor:SetExternalSpeedMultiplier(inst,prefab_id..'_buff',TUNING.MOD_LOL_WP.GUIDER.SKILL_GUIDE.WALKSPEEDMULT)

                            if v:HasTag('epic') then
                                local _player = v.lol_wp_s19_fimbulwinter_armor_upgrade_attacker
                                local _wp = v.lol_wp_s19_fimbulwinter_armor_upgrade_wp
                                if _player and _wp and _wp.skill_enternal then
                                    _wp.skill_enternal(_wp,_player,v)
                                end
                            end
                        end
                        v.taskperiod_lol_wp_s9_guider_check = v:DoPeriodicTask(1,function()
                            local tar_x,_,tar_z = v:GetPosition()
                            if tar_x and tar_z then
                                local check_guider = TheSim:FindEntities(tar_x, 0, tar_z, TUNING.MOD_LOL_WP.GUIDER.SKILL_GUIDE.RADIUS, {'_inventoryitem','INLIMBO',prefab_id})
                                local exist_guider = false
                                for _,v2 in pairs(check_guider) do
                                    if v2.prefab and v2.prefab == prefab_id then
                                        exist_guider = true
                                        break
                                    end
                                end
                                if not exist_guider then
                                    if v.components.locomotor then
                                        v.components.locomotor:RemoveExternalSpeedMultiplier(inst,prefab_id..'_buff')
                                    end
                                    if v.taskperiod_lol_wp_s9_guider_check ~= nil then
                                        v.taskperiod_lol_wp_s9_guider_check:Cancel()
                                        v.taskperiod_lol_wp_s9_guider_check = nil
                                    end
                                end
                            end
                        end)
                    end
                end
            end
        end)
    end
end

local function onunequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end

    inst.Light:Enable(false)

    if inst.taskperiod_lol_wp_s9_guider ~= nil then
        inst.taskperiod_lol_wp_s9_guider:Cancel()
        inst.taskperiod_lol_wp_s9_guider = nil
    end
end

local function onequiptomodel(inst, owner, from_ground)
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
end

-- local function onburnt(inst)
--     if inst.components.container ~= nil then
--         inst.components.container:DropEverything()
--         inst.components.container:Close()
--     end

--     SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())

--     inst:Remove()
-- end

-- local function onignite(inst)
--     if inst.components.container ~= nil then
--         inst.components.container.canbeopened = false
--     end
-- end

-- local function onextinguish(inst)
--     if inst.components.container ~= nil then
--         inst.components.container.canbeopened = true
--     end
-- end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(assets_id)
    inst.AnimState:SetBuild("swap_"..assets_id)
    inst.AnimState:PlayAnimation("anim")

    inst.Light:SetFalloff(TUNING.MOD_LOL_WP.GUIDER.LIGHT.FALLOFF)
    inst.Light:SetIntensity(TUNING.MOD_LOL_WP.GUIDER.LIGHT.INTENSITY)
    inst.Light:SetRadius(TUNING.MOD_LOL_WP.GUIDER.LIGHT.RADIUS)
    inst.Light:SetColour(unpack(TUNING.MOD_LOL_WP.GUIDER.LIGHT.COLOR))
    inst.Light:Enable(false)

    inst:AddTag("backpack")
    inst:AddTag("fridge")
    inst:AddTag("nocool")

    -- inst.MiniMapEntity:SetIcon("backpack.png")

    inst.foleysound = "dontstarve/movement/foley/backpack"

    local swap_data = {bank = "backpack1", anim = "anim"}
    MakeInventoryFloatable(inst, "small", 0.2, nil, nil, nil, swap_data)

    inst.entity:SetPristine()

    inst:AddTag("hide_percentage")

    -- inst:AddTag("fridge")

    inst:AddTag(prefab_id)

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup(prefab_id)
        end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = assets_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..assets_id..".xml"
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem:SetOnDroppedFn(function()
        inst.Light:Enable(false)
    end)

    inst:AddComponent("armor")
    inst.components.armor:InitIndestructible(TUNING.MOD_LOL_WP.GUIDER.ABSORB)
    inst.components.armor:SetKeepOnFinished(true) -- 耐久用完保留



    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)
    inst.components.equippable.walkspeedmult = TUNING.MOD_LOL_WP.GUIDER.WALKSPEEDMULT
    inst.components.equippable.dapperness = TUNING.MOD_LOL_WP.GUIDER.DARPPERNESS/54

    inst:AddComponent("container")
    inst.components.container:WidgetSetup(prefab_id)

    inst:AddComponent('insulator')
    inst.components.insulator:SetInsulation(TUNING.MOD_LOL_WP.GUIDER.AVOID_COLD)
    inst.components.insulator:SetWinter()

    inst:AddComponent('waterproofer')
    inst.components.waterproofer:SetEffectiveness(TUNING.MOD_LOL_WP.GUIDER.WATERPROOF)

    -- inst:AddComponent("preserver")
    -- local perishmult = type(TUNING.PERISH_FRIDGE_MULT) == 'number' and TUNING.PERISH_FRIDGE_MULT or TUNING.MOD_LOL_WP.GUIDER.PRESERVER
    -- inst.components.preserver:SetPerishRateMultiplier(perishmult)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetChargeTime(TUNING.MOD_LOL_WP.GUIDER.SKILL_GUIDE.CD)
    -- inst.components.rechargeable:SetOnDischargedFn(function(inst)  end)
    -- inst.components.rechargeable:SetOnChargedFn(function(inst)
    --     if inst:HasTag(prefab_id..'_iscd') then
    --         inst:RemoveTag(prefab_id..'_iscd')
    --     end
    -- end)

    -- MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    -- inst.components.burnable:SetOnBurntFn(onburnt)
    -- inst.components.burnable:SetOnIgniteFn(onignite)
    -- inst.components.burnable:SetOnExtinguishFn(onextinguish)

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab(prefab_id, fn, assets, prefabs)
