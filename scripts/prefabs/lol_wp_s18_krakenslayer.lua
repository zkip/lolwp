local db = TUNING.MOD_LOL_WP.KRAKENSLAYER

local function makeGun()

    local prefab_id = "lol_wp_s18_krakenslayer"
    local assets_id = "lol_wp_s18_krakenslayer"

    local assets =
    {
        Asset( "ANIM", "anim/blunderbuss.zip"),
        -- Asset( "ANIM", "anim/swap_blunderbuss.zip"),
        -- Asset( "ANIM", "anim/"..assets_id..".zip"),
        -- Asset( "ANIM", "anim/swap_"..assets_id..".zip"),
        -- Asset( "ANIM", "anim/swap_lol_wp_s18_krakenslayer_pipe.zip"),

        -- Asset( "ANIM", "anim/swap_lol_wp_s18_krakenslayer_hand.zip"),
        Asset( "ATLAS", "images/inventoryimages/"..assets_id..".xml" ),
    }

    local prefabs =
    {
        prefab_id,
    }

    local function fn_electricattacks(attacker,data)
        if data.weapon ~= nil then
            if data.projectile == nil then
                --in combat, this is when we're just launching a projectile, so don't do FX yet
                if data.weapon.components.projectile ~= nil then
                    return
                elseif data.weapon.components.complexprojectile ~= nil then
                    return
                elseif data.weapon.components.weapon:CanRangedAttack() then
                    return
                end
            end
            if data.weapon.components.weapon ~= nil and data.weapon.components.weapon.stimuli == "electric" then
                --weapon already has electric stimuli, so probably does its own FX
                return
            end
        end
        if data.target ~= nil and data.target:IsValid() and attacker:IsValid() then
            SpawnPrefab("electrichitsparks"):AlignToTarget(data.target, data.projectile ~= nil and data.projectile:IsValid() and data.projectile or attacker, true)
        end
    end

    ---启用攻击带电
    ---@param enable boolean
    ---@param player ent
    ---@param weapon ent
    local function enable_electricattacks(enable,player,weapon)
        if enable then
            if player.components.electricattacks == nil then
                player:AddComponent("electricattacks")
            end
            player.components.electricattacks:AddSource(weapon)
            player:ListenForEvent("onattackother", fn_electricattacks)
            SpawnPrefab("electricchargedfx"):SetTarget(player)
        else
            if player.components.electricattacks ~= nil then
                player.components.electricattacks:RemoveSource(weapon)
            end
            player:RemoveEventCallback("onattackother",fn_electricattacks)
        end
    end

    ---onequipfn
    ---@param inst ent
    ---@param owner ent
    ---@param from_ground boolean
    local function onequip(inst, owner,from_ground)
        -- owner.AnimState:OverrideSymbol("swap_object", 'swap_lol_wp_s18_krakenslayer', "swap_blunderbuss")
        -- owner.AnimState:OverrideSymbol("swap_object", 'swap_lol_wp_s18_krakenslayer_pipe', "swap_blowdart_pipe")
        owner.AnimState:OverrideSymbol("swap_object", 'blunderbuss', 'swap_object')
        -- owner.AnimState:OverrideSymbol("swap_object", 'swap_'..assets_id, 'swap_'..assets_id)
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")

        if owner.components.lol_wp_critical_hit_player then
            owner.components.lol_wp_critical_hit_player:Modifier('CriticalChance','add',inst,db.CRITICAL_CHANCE,prefab_id)
            owner.components.lol_wp_critical_hit_player:Modifier('CriticalDamage','mult',inst,db.CRITICAL_DMGMULT,prefab_id)
            owner.components.lol_wp_critical_hit_player:SetOnCriticalHit(prefab_id,function (victim)
                if victim then
                    local victim_pt = victim:GetPosition()
                    SpawnPrefab('fx_dock_pop').Transform:SetPosition(victim_pt:Get())
                end
            end)
        end

        if owner then
            enable_electricattacks(true,owner,inst)
        end

        TUNING.MOD_LOL_WP.ATKSPEED = TUNING.MOD_LOL_WP.ATKSPEED * 2
    end

    ---onunequipfn
    ---@param inst ent
    ---@param owner ent
    local function onunequip(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")

        if owner.components.lol_wp_critical_hit_player then
            owner.components.lol_wp_critical_hit_player:RemoveModifier('CriticalChance','add',inst,prefab_id)
            owner.components.lol_wp_critical_hit_player:RemoveModifier('CriticalDamage','mult',inst,prefab_id)
            owner.components.lol_wp_critical_hit_player:RemoveOnCriticalHit(prefab_id)
        end

        if owner then
            enable_electricattacks(false,owner,inst)
        end

        TUNING.MOD_LOL_WP.ATKSPEED = TUNING.MOD_LOL_WP.ATKSPEED / 2
    end

    local function onfinished(inst)
        LOLWP_S:unequipItem(inst)
        inst:AddTag(prefab_id..'_nofiniteuses')
    end

    ---onattack
    ---@param inst ent_lol_wp_s18_krakenslayer
    ---@param attacker ent
    ---@param target ent
    local function onattack(inst,attacker,target)
        inst.lol_wp_s18_krakenslayer_hit_times = inst.lol_wp_s18_krakenslayer_hit_times%3 + 1
        if inst.lol_wp_s18_krakenslayer_hit_times >= 3 then
            if target and LOLWP_S:checkAlive(target) and attacker and attacker.components.combat then
                local dmgmult = attacker.components.combat.externaldamagemultipliers:Get()
                local truedmg = db.SKILL_TAKEDOWN.TRUEDMG
                if target.components.health:GetPercent() < db.SKILL_TAKEDOWN.GP_PERCENT_LESS_THAN then
                    truedmg = db.SKILL_TAKEDOWN.NEW_TRUEDMG
                end
                local res = truedmg*dmgmult

                -- 海妖附带的真伤 受到三相攻击倍率影响。
                local equip,found = LOLWP_S:findEquipments(attacker,'lol_wp_trinity')
                if found then
                    res = res * TUNING.MOD_LOL_WP.TRINITY.DMGMULT
                end

                ---@type event_data_attacked
                local event_data_attacked = { attacker = attacker, damage = res, damageresolved = res, weapon = inst }
                target:PushEvent('attacked',event_data_attacked)
                LOLWP_S:dealTrueDmg(res,target)
            end
        end

        inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/explode")
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        -- inst.entity:AddLight()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
        inst.entity:AddSoundEmitter()
        MakeInventoryPhysics(inst)

        -- inst.AnimState:SetBank('lol_wp_s18_krakenslayer')
        -- inst.AnimState:SetBuild('lol_wp_s18_krakenslayer')
        inst.AnimState:SetBank('blunderbuss')
        inst.AnimState:SetBuild('blunderbuss')
        inst.AnimState:PlayAnimation("idle",true)

        MakeInventoryFloatable(inst, "med", nil, 0.75)

        -- inst.Light:SetFalloff(0.5)
        -- inst.Light:SetIntensity(.8)
        -- inst.Light:SetRadius(1.3)
        -- inst.Light:SetColour(128/255, 20/255, 128/255)
        -- inst.Light:Enable(true)

        inst.entity:SetPristine()

        inst:AddTag("nosteal")

        -- inst:AddTag("lol_wp_shotgun")
        inst:AddTag('blowpipe')

        inst:AddTag('lunar_aligned')

        inst:AddTag('rangedweapon')

        -- inst.Transform:SetScale(.7,.7,.7)

        -- inst.MiniMapEntity:SetIcon(prefab_id..".tex")

        if not TheWorld.ismastersim then
            return inst
        end

        ---@class ent_lol_wp_s18_krakenslayer : ent
        ---@field lol_wp_s18_krakenslayer_hit_times integer

        ---@cast inst ent_lol_wp_s18_krakenslayer

        inst.lol_wp_s18_krakenslayer_hit_times = 0

        -- inst:AddComponent("talker")
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = assets_id
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..assets_id..".xml"
        -- inst.components.inventoryitem:SetOnDroppedFn(function()
        -- end)

        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.walkspeedmult = db.WALKSPEEDMULT
        -- inst.components.equippable.dapperness = 2

        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(db.DMG)
        inst.components.weapon:SetRange(db.RANGE,db.RANGE+2)
        inst.components.weapon:SetOnAttack(onattack)
        inst.components.weapon:SetProjectile("lol_wp_s18_krakenslayer_proj")

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(db.FINITEUSES)
        inst.components.finiteuses:SetUses(db.FINITEUSES)
        inst.components.finiteuses:SetOnFinished(onfinished)

        inst:AddComponent("damagetypebonus")
        inst.components.damagetypebonus:AddBonus("shadow_aligned", inst, db.DMGMULT_TO_SHADOW)

        -- inst:AddComponent("rechargeable")
        -- inst.components.rechargeable:SetChargeTime(100)
        -- -- inst.components.rechargeable:SetOnDischargedFn(function(inst)  end)
        -- inst.components.rechargeable:SetOnChargedFn(function(inst)
        --     if inst:HasTag(prefab_id..'_iscd') then
        --         inst:RemoveTag(prefab_id..'_iscd')
        --     end
        -- end)

        -- local planardamage = inst:AddComponent("planardamage")
        -- planardamage:SetBaseDamage(data_prefab.planardamage)

        -- inst.OnSave = onsave
        -- inst.OnPreLoad = onpreload

        return inst
    end

    return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs)
end

local function makeProj()
    local assets =
    {
        Asset("ANIM", "anim/lol_wp_s18_krakenslayer_proj.zip"),
    }

    local WEIGHTED_TAIL_FXS =
    {
        ["tail_5_8"] = 1,
        ["tail_5_9"] = .5,
    }

    local LAUNCH_OFFSET_Y = 0.75


    local function Projectile_CreateTailFx(inst)
        local inst = CreateEntity()

        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        --[[Non-networked entity]]
        inst.entity:SetCanSleep(false)
        inst.persists = false

        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        inst.AnimState:SetBank("lavaarena_blowdart_attacks")
        inst.AnimState:SetBuild("lavaarena_blowdart_attacks")
        inst.AnimState:PlayAnimation(weighted_random_choice(WEIGHTED_TAIL_FXS))
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

        inst.AnimState:SetLightOverride(0.3)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

        inst.AnimState:SetAddColour(1, 1, 1, 0)

        inst:ListenForEvent("animover", inst.Remove)

        return inst
    end

    local function Projectile_UpdateTail(inst)
        local c = (not inst.entity:IsVisible() and 0) or 1
        local target = inst._target:value()

        -- Does not spawn the tail if it is close to the target (visual bug).
        if c > 0 and not (target ~= nil and target:IsValid() and inst:IsNear(target, 1.5)) then
            local tail = inst:CreateTailFx()
            tail.Transform:SetPosition(inst.Transform:GetWorldPosition())
            tail.Transform:SetRotation(inst.Transform:GetRotation())
            if c < 1 then
                tail.AnimState:SetTime(c * tail.AnimState:GetCurrentAnimationLength())
            end

            return tail -- Mods.
        end
    end

    local function common(anim, bloom, lightoverride)
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        RemovePhysicsColliders(inst)

        inst.AnimState:SetBank("lol_wp_s18_krakenslayer_proj")
        inst.AnimState:SetBuild("lol_wp_s18_krakenslayer_proj")
        inst.AnimState:PlayAnimation('idle', true)

        inst.AnimState:SetLightOverride(0.2)

        inst.AnimState:SetSymbolBloom("flametail")
        inst.AnimState:SetSymbolLightOverride("flametail", 0.5)

        -- inst.Transform:SetNoFaced()
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

        --projectile (from projectile component) added to pristine state for optimization
        inst:AddTag("projectile")
        inst:AddTag("NOCLICK")
        inst:AddTag("NOBLOCK")

        if not TheNet:IsDedicated() then
            inst.CreateTailFx  = Projectile_CreateTailFx
            inst.UpdateTail    = Projectile_UpdateTail

            inst:DoPeriodicTask(0, inst.UpdateTail)
        end

        inst._target = net_entity(inst.GUID, "houndstooth_proj._target")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        inst:AddComponent("projectile")
        inst.components.projectile:SetSpeed(50)
        inst.components.projectile:SetOnThrownFn(function(_, owner, target, attacker)
            inst._target:set(target)
            ---@cast owner ent_lol_wp_s18_krakenslayer

            inst._lol_wp_s18_krakenslayer_proj_owner = owner

            local times = owner and owner.lol_wp_s18_krakenslayer_hit_times or 0
            if times == 2 then
                -- inst.AnimState:SetAddColour(1,1,1,.9)
                inst.AnimState:PlayAnimation('idle2',true)
            end
        end)
        inst.components.projectile:SetOnHitFn(function (_, attacker, target)
            -- -@cast attacker ent_lol_wp_s18_krakenslayer

            local owner = inst._lol_wp_s18_krakenslayer_proj_owner
            local times = owner and owner.lol_wp_s18_krakenslayer_hit_times or 0

            if times == 3 then
                if target then
                    local pt = target:GetPosition()
                    SpawnPrefab('chester_transform_fx').Transform:SetPosition(pt:Get())
                end
            end
            inst._lol_wp_s18_krakenslayer_proj_owner = nil
            inst:Remove()
        end)
        inst.components.projectile:SetOnMissFn(function (_, attacker, target)
            inst._lol_wp_s18_krakenslayer_proj_owner = nil
            inst:Remove()
        end)
        inst.components.projectile:SetLaunchOffset(Vector3(2.5, LAUNCH_OFFSET_Y, 2.5))

        return inst
    end

    return Prefab("lol_wp_s18_krakenslayer_proj", common, assets)
end

return makeGun(),makeProj()
