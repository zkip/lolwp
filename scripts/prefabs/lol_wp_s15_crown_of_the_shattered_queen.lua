local db = TUNING.MOD_LOL_WP.CROWN_OF_THE_SHATTERED_QUEEN

local prefab_id = 'lol_wp_s15_crown_of_the_shattered_queen'
local assets_id = 'lol_wp_s15_crown_of_the_shattered_queen'

local assets =
{
    Asset("ANIM", "anim/"..assets_id..".zip"),
    Asset("ATLAS", "images/inventoryimages/"..assets_id..".xml"),
}

local prefabs = {
    'lol_wp_s15_crown_of_the_shattered_queen_forcefieldfx',
}


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

    ---@type ent|nil # 护盾
    local shield
    ---@type ent|nil # 引用自己
    local the_equip

    ---comment
    ---@param player ent
    ---@param data any
    local function on_owner_attacked(player,data)
        if shield and shield:IsValid() then
            if the_equip and the_equip.components.equippable then
                the_equip.components.equippable.dapperness = (db.DARPPERNESS/54)
            end

            shield.AnimState:PlayAnimation('idle_loop_broken',true)
            player:DoTaskInTime(db.SKILL_GUARD.FADE_WHEN_ATTACKED,function ()
                if shield and shield:IsValid() then
                    shield.AnimState:PlayAnimation('close_broken',false)
                end
            end)
            player:DoTaskInTime(db.SKILL_GUARD.FADE_WHEN_ATTACKED+.15,function ()
                player.lol_wp_s15_crown_of_the_shattered_queen_invincible = false
                if shield and shield:IsValid() then
                    shield:Remove()
                    shield = nil
                end
                if the_equip and the_equip.components.rechargeable then
                    the_equip.components.rechargeable:Discharge(db.SKILL_GUARD.CD)
                end
            end)
        end

    end
    ---comment
    ---@param enable boolean
    ---@param inst ent
    ---@param owner ent
    local function skill_guard(enable,inst,owner)
        if enable then
            -- 被动：【护卫】
            if inst.components.rechargeable and inst.components.rechargeable:IsCharged() then
                if owner:HasTag('player') and LOLWP_S:checkAlive(owner) then
                    if shield and shield:IsValid() then
                        shield:Remove()
                        shield = nil
                    end
                    shield = SpawnPrefab('lol_wp_s15_crown_of_the_shattered_queen_forcefieldfx')
                    shield.entity:SetParent(owner.entity)
                    ---@class ent
                    ---@field lol_wp_s15_crown_of_the_shattered_queen_invincible boolean|nil # S15 破碎王后之冕 被动：【护卫】 佩戴时生成一个铥矿皇冠同样的护盾 免疫所有伤害 受到攻击2秒后消失 

                    owner.lol_wp_s15_crown_of_the_shattered_queen_invincible = true

                end
                if inst.components.equippable then
                    inst.components.equippable.dapperness = (db.DARPPERNESS/54)*2
                end

                owner:ListenForEvent('attacked',on_owner_attacked)
                owner:ListenForEvent('blocked',on_owner_attacked)

                the_equip = inst
            end
        else
            -- 被动：【护卫】
            if shield and shield:IsValid() then
                shield:Remove()
                shield = nil
                if owner:HasTag("player") then
                    owner.lol_wp_s15_crown_of_the_shattered_queen_invincible = false
                end

                if inst.components.equippable then
                    inst.components.equippable.dapperness = (db.DARPPERNESS/54)
                end

                owner:RemoveEventCallback('attacked',on_owner_attacked)
                owner:RemoveEventCallback('blocked',on_owner_attacked)


                -- if inst.components.rechargeable then
                --     inst.components.rechargeable:Discharge(db.SKILL_GUARD.CD)
                -- end
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
        -- 额外位面伤害
        if owner.components.lol_wp_player_dmg_adder then
            owner.components.lol_wp_player_dmg_adder:Modifier(prefab_id,db.PLANAR_DMG_WHEN_EQUIP,prefab_id,'planar')
        end


        skill_guard(true,inst,owner)
        -- inst.Light:Enable(true)

    end

    ---comment
    ---@param inst ent
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
        -- 额外位面伤害
        if owner.components.lol_wp_player_dmg_adder then
            owner.components.lol_wp_player_dmg_adder:RemoveModifier(prefab_id,prefab_id,'planar')
        end

        skill_guard(false,inst,owner)
    end


    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddLight()
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

    -- inst:AddTag("shadow_item")

	--shadowlevel (from shadowlevel component) added to pristine state for optimization
	-- inst:AddTag("shadowlevel")

    inst:AddTag('lunar_aligned')

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

    inst:AddComponent("planardefense")
    inst.components.planardefense:SetBaseDefense(db.DEFEND_PLANAR)
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

    -- inst:AddComponent("shadowlevel")
	-- inst.components.shadowlevel:SetDefaultLevel(db.SHADOW_LEVEL)


    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetChargeTime(db.SKILL_GUARD.CD)
    -- inst.components.rechargeable:SetOnDischargedFn(function(inst) end)
    inst.components.rechargeable:SetOnChargedFn(function ()
        local search_owner = LOLWP_S:GetOwnerReal(inst)
        if search_owner and search_owner:HasTag('player') and inst.components.equippable and inst.components.equippable:IsEquipped() then
            skill_guard(true,inst,search_owner)
        end
    end)


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

local function makeShield()
    local _assets =
    {
        Asset("ANIM", "anim/lol_wp_s15_crown_of_the_shattered_queen_forcefieldfx.zip"),
    }

    local function _fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        -- inst.entity:AddLight()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("lol_wp_s15_crown_of_the_shattered_queen_forcefieldfx")
        inst.AnimState:SetBuild("lol_wp_s15_crown_of_the_shattered_queen_forcefieldfx")
        inst.AnimState:PlayAnimation("open")
        inst.AnimState:PushAnimation("idle_loop", true)

        inst.SoundEmitter:PlaySound("dontstarve/wilson/forcefield_LP", "loop")

        -- inst.Light:SetRadius(0)
        -- inst.Light:SetIntensity(.9)
        -- inst.Light:SetFalloff(.9)
        -- inst.Light:SetColour(1, 1, 1)
        -- inst.Light:Enable(true)
        -- inst.Light:EnableClientModulation(true)

        -- inst._lightframe = net_tinybyte(inst.GUID, "forcefieldfx._lightframe", "lightdirty")
        -- inst._islighton = net_bool(inst.GUID, "forcefieldfx._islighton", "lightdirty")
        -- inst._lighttask = nil
        -- inst._islighton:set(true)

        inst.entity:SetPristine()

        inst.AnimState:SetMultColour(234/255,241/255,43/255,1)

        if not TheWorld.ismastersim then
            -- inst:ListenForEvent("lightdirty", OnLightDirty)

            return inst
        end

        inst.persists = false

        -- inst.kill_fx = kill_fx

        return inst
    end

    return Prefab("lol_wp_s15_crown_of_the_shattered_queen_forcefieldfx", _fn, _assets)

end

return Prefab(prefab_id, fn, assets,prefabs),makeShield()
