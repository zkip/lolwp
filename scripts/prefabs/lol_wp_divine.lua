---@diagnostic disable: undefined-global, trailing-space

local prefab_id = "lol_wp_divine"

local assets =
{
    Asset( "ANIM", "anim/"..prefab_id..".zip"),
    -- Asset("ANIM","anim/swap_"..prefab_id..".zip"),
    Asset( "ATLAS", "images/inventoryimages/"..prefab_id..".xml" ),

    Asset("ANIM","anim/"..prefab_id.."_skin_kamaeru.zip"),
    -- Asset("ANIM","anim/swap_"..prefab_id.."_skin_kamaeru.zip"),
    Asset("ATLAS","images/inventoryimages/"..prefab_id.."_skin_kamaeru.xml"),
}

local prefabs = 
{
    prefab_id,
}

---comment
---@param inst ent
---@param owner ent
local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
	if skin_build ~= nil then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_"..skin_build, inst.GUID, prefab_id)
	else
		-- owner.AnimState:OverrideSymbol("swap_object", "swap_"..tmp_assets_id, "swap_"..tmp_assets_id)
        owner.AnimState:OverrideSymbol("swap_object", prefab_id, "swap_"..prefab_id)
	end


    -- owner.AnimState:OverrideSymbol("swap_object", prefab_id, "swap_"..prefab_id)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    inst.Light:Enable(true)

    
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
	if skin_build ~= nil then
		owner:PushEvent("unequipskinneditem", inst:GetSkinName())
	end

    inst.Light:Enable(false)

   
end

local function onfinished(inst)

    if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner
        if owner ~= nil and owner.components.inventory ~= nil then
            local item = owner.components.inventory:Unequip(inst.components.equippable.equipslot)
            if item ~= nil then
                owner.components.inventory:GiveItem(item, nil, owner:GetPosition())
            end
        end
    end

    inst:AddTag('lol_wp_divine_nofiniteuses')
    -- local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    -- if owner then
    --     inst.components.equippable:Unequip(owner)
    -- end
end

local function onattack(inst,attacker,target)
    -- local fx = SpawnPrefab("crab_king_shine")
    -- fx.Transform:SetScale(.7,.7,.7)
    -- fx.Transform:SetPosition(target:GetPosition():Get())

    if attacker ~= nil and attacker:IsValid() and target ~= nil and target:IsValid() then
        SpawnPrefab("hitsparks_fx"):Setup(attacker, target)
    end

    -- inst.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_shoot", nil, nil, true)
    
end



local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(prefab_id)
    inst.AnimState:SetBuild(prefab_id)
    inst.AnimState:PlayAnimation("idle",true)

    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.Light:SetFalloff(TUNING.MOD_LOL_WP.DIVINE.LIGHT_FALLOFF)
    inst.Light:SetIntensity(TUNING.MOD_LOL_WP.DIVINE.LIGHT_INTENSITY)
    inst.Light:SetRadius(TUNING.MOD_LOL_WP.DIVINE.LIGHT_RADIUS)
    inst.Light:SetColour(unpack(TUNING.MOD_LOL_WP.DIVINE.LIGHT_COLOR))
    inst.Light:Enable(false)

    inst.entity:SetPristine()

    inst:AddTag("nosteal")

    -- inst.MiniMapEntity:SetIcon(prefab_id..".tex")

    if not TheWorld.ismastersim then 
        return inst 
    end

    

    -- inst:AddComponent("talker")
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = prefab_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..prefab_id..".xml"
    -- inst.components.inventoryitem:SetOnDroppedFn(function()
    -- end)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = TUNING.MOD_LOL_WP.DIVINE.WALKSPEEDMULT
    -- inst.components.equippable.dapperness = 2

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.MOD_LOL_WP.DIVINE.DMG)
    inst.components.weapon:SetRange(TUNING.MOD_LOL_WP.DIVINE.RANGE,TUNING.MOD_LOL_WP.DIVINE.RANGE)
    -- inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.MOD_LOL_WP.DIVINE.FINITEUSES)
    inst.components.finiteuses:SetUses(TUNING.MOD_LOL_WP.DIVINE.FINITEUSES)
    inst.components.finiteuses:SetOnFinished(onfinished)
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP,TUNING.MOD_LOL_WP.DIVINE.ACTION_CONSUME.CHOP)
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE,TUNING.MOD_LOL_WP.DIVINE.ACTION_CONSUME.MINE)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1*TUNING.MOD_LOL_WP.DIVINE.EFFICIENCY)
    inst.components.tool:SetAction(ACTIONS.MINE, 1*TUNING.MOD_LOL_WP.DIVINE.EFFICIENCY)
    inst.components.tool:EnableToughWork(true)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetChargeTime(TUNING.MOD_LOL_WP.DIVINE.HOLY_CD)
    inst.components.rechargeable:SetOnDischargedFn(function(inst)  end)
    inst.components.rechargeable:SetOnChargedFn(function(inst) 
        if inst:HasTag('lol_wp_divine_holy_iscd') then
            inst:RemoveTag('lol_wp_divine_holy_iscd')
        end
    end)

    -- local planardamage = inst:AddComponent("planardamage")
    -- planardamage:SetBaseDamage(data_prefab.planardamage)

    -- inst.OnSave = onsave
    -- inst.OnPreLoad = onpreload

    return inst
end

return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs)


