local prefab_id = "lol_wp_s8_lichbane"
local assets_id = prefab_id

local assets =
{
    Asset( "ANIM", "anim/"..assets_id..".zip"),
    Asset( "ANIM", "anim/swap_"..assets_id..".zip"),

    Asset( "ANIM", "anim/"..assets_id.."_noglow.zip"),
    Asset( "ANIM", "anim/swap_"..assets_id.."_noglow.zip"),

    Asset( "ATLAS", "images/inventoryimages/"..assets_id..".xml" ),
}

local prefabs =
{
    'lol_wp_s8_lichbane_fx',
}

---comment
---@param enable boolean
---@param inst ent
---@param owner ent
local function equipFX(enable,inst,owner)
    if inst.lol_wp_s8_lichbane_fx and inst.lol_wp_s8_lichbane_fx:IsValid() then
        inst.lol_wp_s8_lichbane_fx:Remove()
        inst.lol_wp_s8_lichbane_fx = nil
    end
    if enable then
        inst.lol_wp_s8_lichbane_fx = SpawnPrefab('lol_wp_s8_lichbane_fx')
        inst.lol_wp_s8_lichbane_fx.entity:SetParent(owner.entity)
        inst.lol_wp_s8_lichbane_fx.entity:AddFollower()
        inst.lol_wp_s8_lichbane_fx.Follower:FollowSymbol(owner.GUID,'swap_object',nil, nil, nil, true)
    end
end

local function onequip(inst, owner)
    local build = (not inst.lol_wp_s8_lichbane_nofuel) and ("swap_"..assets_id) or ("swap_"..assets_id.."_noglow")
    owner.AnimState:OverrideSymbol("swap_object", build, build)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if not inst.lol_wp_s8_lichbane_nofuel then
        inst.Light:Enable(true)
    end

    inst.components.fueled:StartConsuming()

    if not inst.lol_wp_s8_lichbane_nofuel then
        equipFX(true,inst,owner)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    inst.Light:Enable(false)

    inst.components.fueled:StopConsuming()

    -- if inst.lol_wp_s8_lichbane_fx and inst.lol_wp_s8_lichbane_fx:IsValid() then
    --     inst.lol_wp_s8_lichbane_fx:Remove()
    --     inst.lol_wp_s8_lichbane_fx = nil
    -- end
    equipFX(false,inst,owner)
end

local function whennofuel(inst)
    -- flag
    inst.lol_wp_s8_lichbane_nofuel = true

    inst.components.weapon:SetDamage(TUNING.MOD_LOL_WP.LICHBANE.DMG_WHEN_NO_DURABILITY)
    inst.components.planardamage:SetBaseDamage(0)
    inst.Light:Enable(false)

    inst.AnimState:SetBank(assets_id..'_noglow')
    inst.AnimState:SetBuild(assets_id..'_noglow')
    if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner
        if owner then
            owner.AnimState:OverrideSymbol("swap_object", 'swap_'..prefab_id..'_noglow', 'swap_'..prefab_id..'_noglow')
            equipFX(false,inst,owner)
        end
    end

    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName(prefab_id..'_noglow')
    end

end

local function whentakefuel(inst)
    -- flag
    inst.lol_wp_s8_lichbane_nofuel = false

    inst.components.weapon:SetDamage(TUNING.MOD_LOL_WP.LICHBANE.DMG)
    inst.components.planardamage:SetBaseDamage(TUNING.MOD_LOL_WP.LICHBANE.PLANAR_DMG)

    inst.AnimState:SetBank(assets_id)
    inst.AnimState:SetBuild(assets_id)
    if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
        inst.Light:Enable(true)
        local owner = inst.components.inventoryitem.owner
        if owner then
            owner.AnimState:OverrideSymbol("swap_object", 'swap_'..prefab_id, 'swap_'..prefab_id)
            equipFX(true,inst,owner)
        end
    end
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName(prefab_id)
    end
end

local function onfinished(inst)
    -- inst:Remove()

    whennofuel(inst)
end



local function onattack(inst,attacker,target)
    if not inst.lol_wp_s8_lichbane_nofuel then
        if target then
            local pos = target:GetPosition()
            -- SpawnPrefab('winters_feast_depletefood').Transform:SetPosition(pos:Get())
            if attacker ~= nil and attacker:IsValid() and target ~= nil and target:IsValid() then
                SpawnPrefab("hitsparks_fx"):Setup(attacker, target)
            end
        end

        -- 概率点燃敌人, 不能重复点燃
        if not target._flag_lol_wp_s10_guinsoo_burning then
            if math.random() <= TUNING.MOD_LOL_WP.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_CHANCE then
                if target.components.burnable then
                    -- 标记正在燃烧
                    target._flag_lol_wp_s10_guinsoo_burning = true

                    -- 触发点燃时的特效
                    -- SpawnPrefab(TUNING.MOD_LOL_WP.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_FX).Transform:SetPosition(pt:Get())

                    target.components.burnable.controlled_burn = {
                        duration_creature = 3,
                        damage = 0,
                    }
                    target.components.burnable:SpawnFX(nil)
                    target.components.burnable.controlled_burn = nil

                    if target.taskperiod_lol_wp_s8_lichbane_burning == nil then
                        target.taskperiod_lol_wp_s8_lichbane_burning = target:DoPeriodicTask(TUNING.MOD_LOL_WP.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_PERIOD,function ()
                            if LOLWP_S:checkAlive(target) then
                                -- if target.components.combat then
                                --     target.components.combat:GetAttacked(attacker,TUNING.MOD_LOL_WP.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_DMG,inst)
                                -- end
                                target.components.health:DoDelta(-TUNING.MOD_LOL_WP.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_DMG)
                            end
                        end)
                    end

                    target:DoTaskInTime(TUNING.MOD_LOL_WP.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_LAST,function ()
                        if target then
                            -- 标记停止燃烧
                            target._flag_lol_wp_s10_guinsoo_burning = false
                            if target.components.burnable then
                                target.components.burnable:KillFX()
                            end
                            if target.taskperiod_lol_wp_s8_lichbane_burning then
                                target.taskperiod_lol_wp_s8_lichbane_burning:Cancel()
                                target.taskperiod_lol_wp_s8_lichbane_burning = nil
                            end
                        end
                    end)
                end
            end
        end
    end



end

-- local function onsave(inst,data)

-- end

local function onload(inst,data)
    if inst.components.fueled then
        if inst.components.fueled:IsEmpty() then
            whennofuel(inst)
        else
            whentakefuel(inst)
        end
    end
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

    inst.AnimState:SetBank(assets_id)
    inst.AnimState:SetBuild(assets_id)
    inst.AnimState:PlayAnimation("idle",true)

    inst.AnimState:SetDeltaTimeMultiplier(.7)

    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.Light:SetFalloff(TUNING.MOD_LOL_WP.LICHBANE.LIGHT_FALLOFF)
    inst.Light:SetIntensity(TUNING.MOD_LOL_WP.LICHBANE.LIGHT_INTENSITY)
    inst.Light:SetRadius(TUNING.MOD_LOL_WP.LICHBANE.LIGHT_RADIUS)
    inst.Light:SetColour(unpack(TUNING.MOD_LOL_WP.LICHBANE.LIGHT_COLOR))
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
    inst.components.inventoryitem.imagename = assets_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..assets_id..".xml"
    inst.components.inventoryitem:SetOnDroppedFn(function()
        inst.Light:Enable(true)
    end)
    inst.components.inventoryitem:SetOnPutInInventoryFn(function()
        inst.Light:Enable(false)
    end)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = TUNING.MOD_LOL_WP.LICHBANE.WALKSPEEDMULT
    inst.components.equippable.dapperness = TUNING.MOD_LOL_WP.LICHBANE.DARPPERNESS/54

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.MOD_LOL_WP.LICHBANE.DMG)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("planardamage")
	inst.components.planardamage:SetBaseDamage(TUNING.MOD_LOL_WP.LICHBANE.PLANAR_DMG)

    -- inst:AddComponent("finiteuses")
    -- inst.components.finiteuses:SetMaxUses(500)
    -- inst.components.finiteuses:SetUses(500)
    -- inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.MAGIC
    inst.components.fueled:InitializeFuelLevel(TUNING.MOD_LOL_WP.LICHBANE.FUELED*60)
    inst.components.fueled:SetDepletedFn(onfinished)
    -- inst.components.fueled.ontakefuelfn = 
    -- inst.components.fueled.accepting = true

    inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(TUNING.MOD_LOL_WP.LICHBANE.SHADOW_LEVEL)


    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetChargeTime(TUNING.MOD_LOL_WP.LICHBANE.SKILL_CURSEBLADE.CD)
    -- inst.components.rechargeable:SetOnDischargedFn(function(inst)  end)
    -- inst.components.rechargeable:SetOnChargedFn(function(inst)
    --     if inst:HasTag(prefab_id..'_iscd') then
    --         inst:RemoveTag(prefab_id..'_iscd')
    --     end
    -- end)

    -- local planardamage = inst:AddComponent("planardamage")
    -- planardamage:SetBaseDamage(data_prefab.planardamage)

    inst.lol_wp_whentakefuel = whentakefuel

    -- inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end


local function makeFX()
    local assets =
    {
        Asset("ANIM","anim/lol_wp_s8_lichbane_fx.zip")
    }

    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("lol_wp_s8_lichbane_fx")
        inst.AnimState:SetBuild("lol_wp_s8_lichbane_fx")
        inst.AnimState:PlayAnimation("idle",true)

        inst.AnimState:SetDeltaTimeMultiplier(.7)

        inst:AddTag("FX")
        inst:AddTag("NOCLICK")

        -- inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        -- inst.AnimState:SetLayer(LAYER_BACKGROUND)
        -- inst.AnimState:SetSortOrder(3)--1) --was 1 in forge
        -- local SCALE = 1.3
        -- inst.AnimState:SetScale(SCALE, SCALE)
        -- inst.AnimState:SetMultColour(1,1,1,db.SKILL_SACRIFICE.ALPHA)
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        return inst
    end

    return Prefab('lol_wp_s8_lichbane_fx', fn, assets)
end

return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs),makeFX()


