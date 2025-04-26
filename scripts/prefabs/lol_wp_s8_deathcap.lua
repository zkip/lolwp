---@diagnostic disable: undefined-global, trailing-space
local prefab_id = 'lol_wp_s8_deathcap'

local assets =
{
    Asset("ANIM", "anim/"..prefab_id..".zip"),
    Asset("ATLAS", "images/inventoryimages/"..prefab_id..".xml"),
}


local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", prefab_id, "swap_hat")

    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
        owner.AnimState:Show("HEAD_HAT_NOHELM")
        owner.AnimState:Hide("HEAD_HAT_HELM")
    end

    inst.Light:Enable(true)

    if inst.deathcap_fx and inst.deathcap_fx:IsValid() then
        inst.deathcap_fx:Remove()
    end

    inst.deathcap_fx = SpawnPrefab('cane_victorian_fx')
    inst.deathcap_fx.entity:SetParent(inst.entity)
    inst.deathcap_fx.entity:AddFollower()
    inst.deathcap_fx.Follower:FollowSymbol(inst.GUID, nil, 0, -320, 0)

end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("headbase_hat") 
    
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
        owner.AnimState:Hide("HEAD_HAT_NOHELM")
        owner.AnimState:Hide("HEAD_HAT_HELM")
    end

    inst.Light:Enable(false)

    if inst.deathcap_fx and inst.deathcap_fx:IsValid() then
        inst.deathcap_fx:Remove()
        inst.deathcap_fx = nil
    end

end

local function AttachShadowContainer(inst)
	inst.components.container_proxy:SetMaster(TheWorld:GetPocketDimensionContainer("shadow"))
end
-- local function onsave(inst, data)
--     data.lol_wp_demonicembracehat_nomask = inst.lol_wp_demonicembracehat_nomask
-- end

-- local function onload(inst, data)
--     inst.lol_wp_demonicembracehat_nomask = data and data.lol_wp_demonicembracehat_nomask ~= nil and data.lol_wp_demonicembracehat_nomask or false
--     inst.lol_wp_demonicembracehat_nomask = not inst.lol_wp_demonicembracehat_nomask
--     transfer(inst)
-- end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(prefab_id)
    inst.AnimState:SetBuild(prefab_id)
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("wood")

    inst.foleysound = "dontstarve/movement/foley/logarmour"

    MakeInventoryFloatable(inst, "small", 0.2, 0.80)

    inst.entity:SetPristine()

    inst:AddTag("shadow_item")

	--shadowlevel (from shadowlevel component) added to pristine state for optimization
	inst:AddTag("shadowlevel")

    inst.Light:SetFalloff(.2)
    inst.Light:SetIntensity(.9)
    inst.Light:SetRadius(TUNING.MOD_LOL_WP.DEATHCAP.LIGHT_RADIUS)
    inst.Light:SetColour(239/255,69/255,255/255)
    inst.Light:Enable(false)

    inst:AddTag("waterproofer")

    inst:AddTag(prefab_id)

    inst:AddComponent("container_proxy")

    -- inst:AddTag("shadowdominance")
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("shadow_container")
        end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = prefab_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..prefab_id..".xml"

    -- inst.components.container_proxy:SetMaster(TheWorld:GetPocketDimensionContainer("shadow"))

    -- inst:AddComponent("fuel")
    -- inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    -- inst:AddComponent("armor")
    -- inst.components.armor:InitCondition(TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.DURABILITY, TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.ABSORB)
    -- inst.components.armor:SetKeepOnFinished(true) -- 耐久用完保留
    -- inst.components.armor:SetOnFinished(onfinished)

    -- inst:AddComponent("planardefense")
    -- inst.components.planardefense:SetBaseDefense(TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.DEFEND_PLANAR)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.is_magic_dapperness = true
    inst.components.equippable.dapperness = TUNING.MOD_LOL_WP.DEATHCAP.DARPPERNESS/54
    inst.components.equippable.insulated = true

    inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(TUNING.MOD_LOL_WP.DEATHCAP.SHADOW_LEVEL)

    -- inst:AddComponent("rechargeable")
    -- inst.components.rechargeable:SetChargeTime(TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.SKILL_STARE.CD)
    -- inst.components.rechargeable:SetOnDischargedFn(function(inst) end)
    -- inst.components.rechargeable:SetOnChargedFn(OnChargedFn)

    -- inst:AddComponent("resistance")
    -- inst.components.resistance:SetShouldResistFn(ShouldResistFn)
    -- inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
    -- for i, v in ipairs(RESISTANCES) do
    --     inst.components.resistance:AddResistance(v)
    -- end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("shadow_container")

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.MOD_LOL_WP.DEATHCAP.WATERPROOF)

    -- inst:DoTaskInTime(1,function()
    --     local fx = SpawnPrefab('cane_victorian_fx')
    --     fx.entity:SetParent(inst.entity)
    --     fx.entity:AddFollower()
    --     fx.Follower:FollowSymbol(inst.GUID, nil, 0, -320, 0)
    -- end)

    -- inst:AddComponent('shadowdominance')

    -- inst.OnSave = onsave 
    -- inst.OnLoad = onload
    -- inst.OnPreLoad = onpreload
    inst.OnLoadPostPass = AttachShadowContainer

    --MakeHauntableLaunch(inst)
    -- MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    if not POPULATING then
		AttachShadowContainer(inst)
	end

    return inst
end

return Prefab(prefab_id, fn, assets)
