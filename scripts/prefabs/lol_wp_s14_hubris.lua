local db = TUNING.MOD_LOL_WP.HUBRIS

local prefab_id = 'lol_wp_s14_hubris'
local assets_id = 'lol_wp_s14_hubris'

local assets =
{
    Asset("ANIM", "anim/"..assets_id..".zip"),
    Asset("ATLAS", "images/inventoryimages/"..assets_id..".xml"),
}

---comment
---@param owner ent
---@param data event_data_onhitother
local function onhitother(owner,data)
    if data then
        local victim = data.target
        if victim then
            -- 死亡才计算
            if victim.components.health and victim.components.health:IsDead() then
                -- 筛选
                if victim:HasTag('epic') then
                    local equips,found = LOLWP_S:findEquipments(owner,prefab_id)
                    if found then
                        for _,v in ipairs(equips) do
                            if v.components.lol_wp_s14_hubris_skill_reputation then
                                v.components.lol_wp_s14_hubris_skill_reputation:DoDelta(db.SKILL_REPUTATION.BOSSKILL_BY_SELF_STACK)

                                if owner.components.lol_wp_player_dmg_adder then
                                    local atk_add = v.components.lol_wp_s14_hubris_skill_reputation:CalcAtkDmg()
                                    owner.components.lol_wp_player_dmg_adder:Modifier(prefab_id,atk_add,prefab_id..'skill_reputation','physical')
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

---comment
---@param inst ent
---@param owner ent
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", assets_id, "swap_hat")

    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    -- owner.AnimState:Hide("HAIR_NOHAT")
    -- owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        -- owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
        owner.AnimState:Show("HEAD_HAT_NOHELM")
        -- owner.AnimState:Hide("HEAD_HAT_HELM")
    end

    -- inst.Light:Enable(true)

    -- if inst.deathcap_fx and inst.deathcap_fx:IsValid() then
    --     inst.deathcap_fx:Remove()
    -- end

    -- inst.deathcap_fx = SpawnPrefab('cane_victorian_fx')
    -- inst.deathcap_fx.entity:SetParent(inst.entity)
    -- inst.deathcap_fx.entity:AddFollower()
    -- inst.deathcap_fx.Follower:FollowSymbol(inst.GUID, nil, 0, -320, 0)

    if owner.components.lol_wp_player_dmg_adder then
        owner.components.lol_wp_player_dmg_adder:Modifier(prefab_id,db.DMG_WHEN_EQUIP,prefab_id,'physical')

        local atk_add = inst.components.lol_wp_s14_hubris_skill_reputation and inst.components.lol_wp_s14_hubris_skill_reputation:CalcAtkDmg()
        if atk_add then
            owner.components.lol_wp_player_dmg_adder:Modifier(prefab_id,atk_add,prefab_id..'skill_reputation','physical')
        end
    end

    -- owner:ListenForEvent('onhitother',onhitother)

end

---comment
---@param inst any
---@param owner ent
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

    if owner.components.lol_wp_player_dmg_adder then
        owner.components.lol_wp_player_dmg_adder:RemoveModifier(prefab_id,prefab_id,'physical')
        owner.components.lol_wp_player_dmg_adder:RemoveModifier(prefab_id,prefab_id..'skill_reputation','physical')
    end

    -- owner:RemoveEventCallback('onhitother',onhitother)
    -- inst.Light:Enable(false)

    -- if inst.deathcap_fx and inst.deathcap_fx:IsValid() then
    --     inst.deathcap_fx:Remove()
    --     inst.deathcap_fx = nil
    -- end

end

-- local function AttachShadowContainer(inst)
-- 	inst.components.container_proxy:SetMaster(TheWorld:GetPocketDimensionContainer("shadow"))
-- end
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

    inst.AnimState:SetBank(assets_id)
    inst.AnimState:SetBuild(assets_id)
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("wood")

    inst.foleysound = "dontstarve/movement/foley/logarmour"

    MakeInventoryFloatable(inst, "small", 0.2, 0.80)

    inst.entity:SetPristine()

    inst:AddTag("shadow_item")

	--shadowlevel (from shadowlevel component) added to pristine state for optimization
	inst:AddTag("shadowlevel")

    inst:AddTag("open_top_hat")

    -- inst.Light:SetFalloff(.2)
    -- inst.Light:SetIntensity(.9)
    -- inst.Light:SetRadius(TUNING.MOD_LOL_WP.DEATHCAP.LIGHT_RADIUS)
    -- inst.Light:SetColour(239/255,69/255,255/255)
    -- inst.Light:Enable(false)

    -- inst:AddTag("waterproofer")

    -- inst:AddTag(assets_id)

    -- inst:AddComponent("container_proxy")

    inst:AddTag('hide_percentage')

    -- inst:AddTag("shadowdominance")
    if not TheWorld.ismastersim then
        -- inst.OnEntityReplicated = function(inst)
        --     inst.replica.container:WidgetSetup("shadow_container")
        -- end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = assets_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..assets_id..".xml"

    -- inst:AddComponent("fuel")
    -- inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("armor")
    inst.components.armor:InitIndestructible(db.ABSORB)


    -- inst:AddComponent("planardefense")
    -- inst.components.planardefense:SetBaseDefense(TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.DEFEND_PLANAR)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = db.WALKSPEEDMULT
    -- inst.components.equippable.is_magic_dapperness = true
    inst.components.equippable.dapperness = db.DARPPERNESS/54
    -- inst.components.equippable.insulated = true

    inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(db.SHADOW_LEVEL)

    inst:AddComponent('lol_wp_s14_hubris_skill_reputation')

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
    -- inst.OnLoadPostPass = AttachShadowContainer

    --MakeHauntableLaunch(inst)
    -- MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    -- if not POPULATING then
	-- 	AttachShadowContainer(inst)
	-- end

    return inst
end

return Prefab(prefab_id, fn, assets)
