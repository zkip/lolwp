local db = TUNING.MOD_LOL_WP.STORMRAZOR

local function makeSaya()
    local prefab_id = "lol_wp_s18_stormrazor"
    local assets_id = "lol_wp_s18_stormrazor"

    local assets =
    {
        Asset( "ANIM", "anim/"..assets_id..".zip"),
        Asset( "ANIM", "anim/swap_"..assets_id..".zip"),
        Asset( "ATLAS", "images/inventoryimages/"..assets_id..".xml" ),
    }

    local prefabs =
    {
    }

    ---onequipfn
    ---@param inst ent
    ---@param owner ent
    ---@param from_ground boolean
    local function onequip(inst, owner,from_ground)
        owner.AnimState:OverrideSymbol("swap_object", "swap_"..assets_id, "swap_"..assets_id)
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end

    ---onunequipfn
    ---@param inst ent
    ---@param owner ent
    local function onunequip(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")

    end

    local function onfinished(inst)
        LOLWP_S:unequipItem(inst)
        inst:AddTag(prefab_id..'_nofiniteuses')
    end

    ---onattack
    ---@param inst ent
    ---@param attacker ent
    ---@param target ent
    local function onattack(inst,attacker,target)

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

        inst.AnimState:SetBank(assets_id)
        inst.AnimState:SetBuild(assets_id)
        inst.AnimState:PlayAnimation("idle",true)

        MakeInventoryFloatable(inst, "med", nil, 0.75)

        -- inst.Light:SetFalloff(0.5)
        -- inst.Light:SetIntensity(.8)
        -- inst.Light:SetRadius(1.3)
        -- inst.Light:SetColour(128/255, 20/255, 128/255)
        -- inst.Light:Enable(true)

        inst.entity:SetPristine()

        inst:AddTag("nosteal")

        inst:AddTag('lunar_aligned')

        -- inst.MiniMapEntity:SetIcon(prefab_id..".tex")

        if not TheWorld.ismastersim then
            return inst
        end

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
        inst.components.equippable.walkspeedmult = db.WALKSPEEDMULT_WITH_SAYA
        -- inst.components.equippable.dapperness = 2

        -- inst:AddComponent("weapon")
        -- inst.components.weapon:SetDamage(34)
        -- inst.components.weapon:SetOnAttack(onattack)

        inst:AddComponent('lol_wp_s18_stormrazor_tf')

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(db.FINITEUSES)
        inst.components.finiteuses:SetUses(db.FINITEUSES)
        inst.components.finiteuses:SetOnFinished(onfinished)

        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetChargeTime(db.SKILL_ELECTRICSLASH.CD)
        inst.components.rechargeable:SetOnDischargedFn(function()
            inst:AddOrRemoveTag(prefab_id..'_iscd',true)
        end)
        inst.components.rechargeable:SetOnChargedFn(function()
            inst:AddOrRemoveTag(prefab_id..'_iscd',false)
        end)

        inst:DoPeriodicTask(db.SKILL_SHIV.REPAIR_INTERVAL,function ()
            if inst.components.finiteuses then
                inst.components.finiteuses:Repair(db.SKILL_SHIV.REPAIR)

                inst:AddOrRemoveTag(prefab_id..'_nofiniteuses',false)
                -- 推一个事件以便当物品在眼石中去监听
                inst:PushEvent('lol_wp_repair')
            end
        end)

        -- local planardamage = inst:AddComponent("planardamage")
        -- planardamage:SetBaseDamage(data_prefab.planardamage)

        -- inst.OnSave = onsave
        -- inst.OnPreLoad = onpreload

        return inst
    end
    -- 切换数据传递: 耐久, 被动CD, 
    return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs)
end

local function makeShiv()
    local prefab_id = "lol_wp_s18_stormrazor_nosaya"
    local assets_id = "lol_wp_s18_stormrazor_nosaya"

    local assets =
    {
        Asset( "ANIM", "anim/"..assets_id..".zip"),
        Asset( "ANIM", "anim/swap_"..assets_id..".zip"),
        Asset( "ATLAS", "images/inventoryimages/"..assets_id..".xml" ),
    }

    local prefabs =
    {
        prefab_id,
    }

    ---onequipfn
    ---@param inst ent
    ---@param owner ent
    ---@param from_ground boolean
    local function onequip(inst, owner,from_ground)
        owner.AnimState:OverrideSymbol("swap_object", "swap_"..assets_id, "swap_"..assets_id)
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

        -- if inst.SoundEmitter then
        --     local path = 'lol_wp_s18_stormrazor/bgm/lol_wp_s18_stormrazor'
        --     local volume = .2
        --     if not inst['bgm_'..'lol_wp_s18_stormrazor'] then
        --         volume = 0
        --     end
        --     inst.SoundEmitter:PlaySound(path,'bgm_' .. 'lol_wp_s18_stormrazor',volume)
        -- end
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

        -- if inst.SoundEmitter then
        --     inst.SoundEmitter:KillSound('bgm_' .. 'lol_wp_s18_stormrazor')
        -- end
    end

    local function onfinished(inst)
        LOLWP_S:unequipItem(inst)
        inst:AddTag(prefab_id..'_nofiniteuses')
    end

    ---onattack
    ---@param inst ent
    ---@param attacker ent
    ---@param target ent
    local function onattack(inst,attacker,target)
        local pt = nil
        if target then
            pt = target:GetPosition()
            SpawnPrefab('shadowstrike_slash_fx').Transform:SetPosition(pt:Get())
        end

        if inst.components.rechargeable and inst.components.rechargeable:IsCharged() then
            inst.components.rechargeable:Discharge(db.SKILL_ELECTRICSLASH.CD)

            if pt then
                SpawnPrefab('crab_king_shine').Transform:SetPosition(pt:Get())
            end

            if attacker.components.locomotor then
                attacker.components.locomotor:SetExternalSpeedMultiplier(inst,'lol_wp_s18_stormrazor_tornado',db.SKILL_ELECTRICSLASH.WALKSPEEDMULT)
                attacker:DoTaskInTime(db.SKILL_ELECTRICSLASH.WALKSPEEDMULT_DURATION,function()
                    if attacker and attacker.components.locomotor then
                        attacker.components.locomotor:RemoveExternalSpeedMultiplier(inst,'lol_wp_s18_stormrazor_tornado')
                    end
                end)
            end


        end

        LOLWP_S:rechargeableReduceCD(inst,db.SKILL_CHARGE.REDUCE_SKILL_ELECTRICSLASH_PER_HIT)
        -- if inst.components.rechargeable and not inst.components.rechargeable:IsCharged() then
        --     local total = inst.components.rechargeable.total
        --     local chargetime = inst.components.rechargeable:GetChargeTime()
        --     local rest_cd = inst.components.rechargeable:GetTimeToCharge()
        --     local should_cd = math.max(0,rest_cd - db.SKILL_CHARGE.REDUCE_SKILL_ELECTRICSLASH_PER_HIT)

        --     local should_percent = math.clamp(1-should_cd/chargetime,0,1)

        --     inst.components.rechargeable:SetCharge(should_percent*total,true)
        -- end
    end

    -- local function onsave(inst,data)
    --     data['bgm_'..'lol_wp_s18_stormrazor'] = inst['bgm_'..'lol_wp_s18_stormrazor']
    -- end

    -- local function onload(inst,data)
    --     if data and data['bgm_'..'lol_wp_s18_stormrazor'] ~= nil then
    --         inst['bgm_'..'lol_wp_s18_stormrazor'] = data['bgm_'..'lol_wp_s18_stormrazor']
    --     end
    --     if inst.SoundEmitter then
    --         if inst['bgm_'..'lol_wp_s18_stormrazor'] then
    --             inst.SoundEmitter:SetVolume('bgm_'..'lol_wp_s18_stormrazor',.3)
    --         else
    --             inst.SoundEmitter:SetVolume('bgm_'..'lol_wp_s18_stormrazor',0)
    --         end
    --     end
    -- end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        -- inst.entity:AddLight()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
        inst.entity:AddSoundEmitter()
        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(assets_id)
        inst.AnimState:SetBuild(assets_id)
        inst.AnimState:PlayAnimation("idle",true)

        MakeInventoryFloatable(inst, "med", nil, 0.75)

        -- inst.Light:SetFalloff(0.5)
        -- inst.Light:SetIntensity(.8)
        -- inst.Light:SetRadius(1.3)
        -- inst.Light:SetColour(128/255, 20/255, 128/255)
        -- inst.Light:Enable(true)

        inst.entity:SetPristine()

        inst:AddTag("nosteal")

        inst:AddTag('lunar_aligned')

        -- inst.MiniMapEntity:SetIcon(prefab_id..".tex")

        if not TheWorld.ismastersim then
            return inst
        end

        inst['bgm_'..'lol_wp_s18_stormrazor'] = true

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
        inst.components.weapon:SetOnAttack(onattack)

        inst:AddComponent('planardamage')
        inst.components.planardamage:SetBaseDamage(db.SKILL_ELECTRICSLASH.PLANAR_DMG)

        inst:AddComponent('lol_wp_s18_stormrazor_tf')
        inst:AddComponent('lol_wp_s18_stormrazor_tornado')

        inst:AddComponent('lol_wp_cd_itemtile')
        inst.components.lol_wp_cd_itemtile:Init(db.SKILL_WIND_SLASH.CD)
        inst.components.lol_wp_cd_itemtile:ShowItemTile(false)

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(db.FINITEUSES)
        inst.components.finiteuses:SetUses(db.FINITEUSES)
        inst.components.finiteuses:SetOnFinished(onfinished)

        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetChargeTime(db.SKILL_ELECTRICSLASH.CD)
        inst.components.rechargeable:SetOnDischargedFn(function()
            inst:AddOrRemoveTag(prefab_id..'_iscd',true)
            if inst.components.planardamage then
                inst.components.planardamage:SetBaseDamage(0)
            end
        end)
        inst.components.rechargeable:SetOnChargedFn(function()
            inst:AddOrRemoveTag(prefab_id..'_iscd',false)
            if inst.components.planardamage then
                inst.components.planardamage:SetBaseDamage(db.SKILL_ELECTRICSLASH.PLANAR_DMG)
            end
        end)

        inst:ListenForEvent('unequipped',
        ---comment
        ---@param _ ent
        ---@param data event_data_unequipped
        function(_,data)
            local owner = data and data.owner
            if owner and owner:HasTag('player') and inst.components.lol_wp_s18_stormrazor_tf then
                inst.components.lol_wp_s18_stormrazor_tf:DoTF(owner)
            end
        end)

        inst:AddComponent("damagetypebonus")
        inst.components.damagetypebonus:AddBonus("shadow_aligned", inst, db.DMGMULT_TO_SHADOW)

        -- local planardamage = inst:AddComponent("planardamage")
        -- planardamage:SetBaseDamage(data_prefab.planardamage)

        -- inst.OnSave = onsave
        -- inst.OnLoad = onload
        -- inst.OnPreLoad = onpreload

        return inst
    end

    return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs)
end

local function makeTornado()
    local prefab_id = "lol_wp_s18_stormrazor_tornado"
    local assets_id = "lol_wp_s18_stormrazor_tornado"

    local assets =
    {
        Asset( "ANIM", "anim/"..assets_id..".zip"),
    }

    local prefabs =
    {
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        -- inst.entity:AddLight()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
        inst.entity:AddSoundEmitter()

        inst.AnimState:SetBank(assets_id)
        inst.AnimState:SetBuild(assets_id)
        inst.AnimState:PlayAnimation("tornado_pre")
        inst.AnimState:PushAnimation("tornado_loop",true)

        inst.AnimState:SetSortOrder(5)

        -- inst.Light:SetFalloff(0.5)
        -- inst.Light:SetIntensity(.8)
        -- inst.Light:SetRadius(1.3)
        -- inst.Light:SetColour(128/255, 20/255, 128/255)
        -- inst.Light:Enable(true)

        inst.entity:SetPristine()

        inst:AddTag('NOCLICK')
        inst:AddTag('FX')

        -- inst.MiniMapEntity:SetIcon(prefab_id..".tex")

        if not TheWorld.ismastersim then
            return inst
        end
        ---@class ent_lol_wp_s18_stormrazor_tornado : ent
        ---@field _lol_wp_s18_stormrazor_tornado_belongs_to ent|nil # doer
        ---@field _lol_wp_s18_stormrazor_tornado_weapon ent|nil # weapon
        ---@field _lol_wp_s18_stormrazor_tornado_target_pos Vector3|nil

        ---@cast inst ent_lol_wp_s18_stormrazor_tornado 


        inst.persists = false
        inst._lol_wp_s18_stormrazor_tornado_belongs_to = nil
        inst._lol_wp_s18_stormrazor_tornado_weapon = nil
        inst._lol_wp_s18_stormrazor_tornado_target_pos = nil

        local tar_x,tar_z = nil,nil

        inst:DoPeriodicTask(FRAMES,function()
            local x,_,z = inst:GetPosition():Get()

            if tar_x == nil then
                tar_x = inst._lol_wp_s18_stormrazor_tornado_target_pos and inst._lol_wp_s18_stormrazor_tornado_target_pos.x
            end
            if tar_z == nil then
                tar_z = inst._lol_wp_s18_stormrazor_tornado_target_pos and inst._lol_wp_s18_stormrazor_tornado_target_pos.z
            end
            if tar_x and tar_z then
                local dist = LOLWP_C:calcDist(x,z,tar_x,tar_z,true)
                if dist > .5 then
                    local res_x,res_z = LOLWP_C:findPointOnLine(x,z,tar_x,tar_z,dist,0.5)
                    inst.Transform:SetPosition(res_x,0,res_z)
                end
            end
        end)

        inst:DoPeriodicTask(db.SKILL_WIND_SLASH.INTERVAL,function ()
            if inst and inst:IsValid() then
                local x,_,z = inst:GetPosition():Get()

                -- if tar_x == nil then
                --     tar_x = inst._lol_wp_s18_stormrazor_tornado_target_pos and inst._lol_wp_s18_stormrazor_tornado_target_pos.x
                -- end
                -- if tar_z == nil then
                --     tar_z = inst._lol_wp_s18_stormrazor_tornado_target_pos and inst._lol_wp_s18_stormrazor_tornado_target_pos.z
                -- end
                -- if tar_x and tar_z then
                --     local dist = LOLWP_C:calcDist(x,z,tar_x,tar_z,true)
                --     if dist > .3 then
                --         local res_x,res_z = LOLWP_C:findPointOnLine(x,z,tar_x,tar_z,dist,0.2)
                --         inst.Transform:SetPosition(res_x,0,res_z)
                --     end
                -- end



                local ents = TheSim:FindEntities(x, 0, z, 2, nil, {'player',"companion","structure","wall","abigail","glommer"})
                for _,ent in pairs(ents) do
                    if ent.components.combat and LOLWP_S:checkAlive(ent) then
                        local isTarget = true
                        if inst._lol_wp_s18_stormrazor_tornado_belongs_to ~= nil and inst._lol_wp_s18_stormrazor_tornado_belongs_to:IsValid() then
                            if inst._lol_wp_s18_stormrazor_tornado_belongs_to.components.combat and inst._lol_wp_s18_stormrazor_tornado_belongs_to.components.combat:IsAlly(ent) then
                                isTarget = false
                            end
                        end
                        if isTarget then
                            -- ent.components.combat:GetAttacked(inst._lol_wp_s18_stormrazor_tornado_belongs_to,db.SKILL_WIND_SLASH.DMG,inst._lol_wp_s18_stormrazor_tornado_weapon)
                            local owner = inst._lol_wp_s18_stormrazor_tornado_belongs_to
                            if owner and owner.components and owner.components.combat then
                                local dmgmult = owner.components.combat.externaldamagemultipliers:Get()
                                local dmg = db.SKILL_WIND_SLASH.DMG * (dmgmult or 1)
                                ent.components.combat:GetAttacked(nil,dmg)
                                ---@type event_data_attacked
                                local event_data_attacked = { attacker = owner, damage = dmg, damageresolved = dmg, original_damage = dmg, weapon = inst._lol_wp_s18_stormrazor_tornado_weapon}
                                ent:PushEvent("attacked",event_data_attacked)
                            end
                        end
                    end
                    if ent:HasTag('boulder') or ent:HasTag('tree') then
                        if ent.components.workable and ent.components.workable:CanBeWorked() then
                            ent.components.workable:Destroy(inst._lol_wp_s18_stormrazor_tornado_belongs_to)
                        end
                    end

                end
            end
        end)

        inst:DoTaskInTime(db.SKILL_WIND_SLASH.LIFETIME,function ()
            if inst and inst:IsValid() then
                inst.AnimState:PlayAnimation("tornado_pst",false)
                inst:DoTaskInTime(.2,function ()
                    if inst and inst:IsValid() then
                        inst:Remove()
                    end
                end)
            end
        end)

        return inst
    end

    return Prefab(prefab_id, fn, assets, prefabs)
end

local function makeTornado2()
    local assets =
    {
        Asset("ANIM", "anim/tornado.zip"),
        -- Asset("ANIM", "anim/tornado_stick.zip"),
        -- Asset("ANIM", "anim/swap_tornado_stick.zip"),
    }

    local brain = require("brains/tornadobrain")

    local function ontornadolifetime(inst)
        inst.task = nil
        inst.sg:GoToState("despawn")
    end

    local function SetDuration(inst, duration)
        if inst.task ~= nil then
            inst.task:Cancel()
        end
        inst.task = inst:DoTaskInTime(duration, ontornadolifetime)
    end

    local function tornado_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.AnimState:SetFinalOffset(2)
        inst.AnimState:SetBank("tornado")
        inst.AnimState:SetBuild("tornado")
        inst.AnimState:PlayAnimation("tornado_pre")
        inst.AnimState:PushAnimation("tornado_loop")

        inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")

        MakeInventoryPhysics(inst)
        RemovePhysicsColliders(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("knownlocations")

        inst:AddComponent("locomotor")
        inst.components.locomotor.walkspeed = TUNING.TORNADO_WALK_SPEED * .33
        inst.components.locomotor.runspeed = TUNING.TORNADO_WALK_SPEED

        inst:SetStateGraph("SGlol_wp_s18_stormrazor_tornado")
        inst:SetBrain(brain)

        inst.WINDSTAFF_CASTER = nil
        inst.persists = false

        inst.SetDuration = SetDuration
        inst:SetDuration(TUNING.MOD_LOL_WP.STORMRAZOR.SKILL_WIND_SLASH.LIFETIME)

        return inst
    end

    return Prefab("lol_wp_s18_stormrazor_tornado_2", tornado_fn, assets)
end

return makeSaya(),makeShiv(),makeTornado(),makeTornado2()