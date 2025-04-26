local db = TUNING.MOD_LOL_WP.MALIGNANCE

local prefab_id = "lol_wp_s12_malignance"
local assets_id = "lol_wp_s12_malignance"

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
    if target then
        local pt = target:GetPosition()
        SpawnPrefab(db.HIT_FX).Transform:SetPosition(pt:Get())
    end

    if target then
        if target.taskintime_lol_wp_s12_malignance_tri_atk_cd == nil then
            target:AddTag('cant_be_lol_wp_s12_malignance_tri_atk')
            ---@diagnostic disable-next-line: inject-field
            target.taskintime_lol_wp_s12_malignance_tri_atk_cd = target:DoTaskInTime(db.SKILL_GLOWSHIELD_STRIKE.CD_PER_TARGET,function ()
                if target then
                    target:RemoveTag('cant_be_lol_wp_s12_malignance_tri_atk')
                    if target.taskintime_lol_wp_s12_malignance_tri_atk_cd then
                        target.taskintime_lol_wp_s12_malignance_tri_atk_cd:Cancel()
                        ---@diagnostic disable-next-line: inject-field
                        target.taskintime_lol_wp_s12_malignance_tri_atk_cd = nil
                    end
                end
            end)
        end
    end

    -- 吸血
    if target and not target:HasTag('structure') and not target:HasTag('wall') and target:HasTag('epic') then
---@diagnostic disable-next-line: undefined-field
        if attacker and attacker.is_tri_atk then
            local player = attacker
            if player and LOLWP_S:checkAlive(player) then
                local curpercent = player.components.health:GetPercent()
                local lose_hp_percent = 1 - curpercent
                local maxhp = player.components.health.maxhealth
                local lose_hp = maxhp * lose_hp_percent * db.SKILL_GLOWSHIELD_STRIKE.HEAL_LOST_RATE_HP
                player.components.health:DoDelta(db.SKILL_GLOWSHIELD_STRIKE.HEAL_HP + lose_hp)
            end
        end
    end
end

local function ReticuleTargetFn()
    return Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0))
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

    inst:AddTag("sharp")
    inst:AddTag("weapon")
    inst:AddTag("nopunch")
    inst:AddTag("nosteal")
    inst:AddTag("jab")
    inst:AddTag("aoeweapon_leap")
    inst:AddTag("superjump")

    -- inst:AddTag('gallop_triple_atk')
    inst:AddTag('lol_wp_s12_malignance_tri_atk')

    inst:AddTag('lunar_aligned')

    -- inst.MiniMapEntity:SetIcon(prefab_id..".tex")

    inst:AddComponent("aoetargeting")
    --inst.components.aoetargeting:SetAlwaysValid(true) 
    inst.components.aoetargeting:SetAllowRiding(false)
    inst.components.aoetargeting.reticule.reticuleprefab = "reticule_gallop_brokenking"
    inst.components.aoetargeting.reticule.pingprefab = "reticuleping_gallop_brokenking"
    inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true
    inst.components.aoetargeting.reticule.mouseenabled = true
    inst.components.aoetargeting:SetRange(25)


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
    inst.components.equippable.walkspeedmult = db.WALKSPEEDMULT
    -- inst.components.equippable.dapperness = 2

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(db.DMG)
    inst.components.weapon:SetRange(db.RANGE,db.RANGE)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(db.FINITEUSES)
    inst.components.finiteuses:SetUses(db.FINITEUSES)
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(function(inst, caster, pt)
        caster:PushEvent("combat_superjump", {
            targetpos = pt,
            weapon = inst,
        })

        --[[local light = SpawnPrefab("gallop_ad_d_light")
        light.Transform:SetPosition(caster:GetPosition():Get())
        light.Light:SetIntensity(0.8)
        light.Light:SetRadius(5)
        light:DoTaskInTime(.8, light.Remove)]]
    end)

    inst:AddComponent("aoeweapon_leap")
    inst.components.aoeweapon_leap:SetDamage(0)
    inst.components.aoeweapon_leap.aoeradius = db.SKILL_FALLEN_BLOW.RADIUS
    inst.components.aoeweapon_leap.physicspadding = 0
    inst.components.aoeweapon_leap:SetOnHitFn(
    ---comment
    ---@param inst ent
    ---@param doer ent
    ---@param target ent
    function(inst, doer, target)
        -- if target.components.combat then
        --     local spdmg = 100 * (inst.link_active and 2 or 1)
        --     target.components.combat:GetAttacked(doer, 0, nil, nil, {planar=spdmg})
        -- end
        
    end)
    inst.components.aoeweapon_leap:SetOnPreLeapFn(function(inst, doer, startingpos, targetpos)
        -- doer.gallop_brokenking_jumping = true
    end)
    inst.components.aoeweapon_leap:SetOnLeaptFn(function(inst, doer, startingpos, targetpos)
        -- doer.gallop_brokenking_jumping = nil
        -- inst.components.finiteuses:SetPercent(1)
        -- inst.components.rechargeable:Discharge(inst.link_active and 5 or 20)

        -- if doer.components.sanity then
        --     doer.components.sanity:DoDelta(-10)
        -- end

        -- if doer.components.talker then
        --     doer.components.talker:Say(STRINGS.GALLOP_BROKENKING.JIMPING, 2, true)
        -- end

        -- local fx = SpawnPrefab("moonpulse_fx")
        -- fx.Transform:SetPosition(targetpos:Get())

        -- fx = SpawnPrefab("moonstorm_glass_ground_fx")
        -- fx.Transform:SetPosition(targetpos:Get())

        -- fx = SpawnPrefab("lightning")
        -- fx.Transform:SetPosition(targetpos:Get())

        if inst.components.rechargeable then
            inst.components.rechargeable:Discharge(db.SKILL_FALLEN_BLOW.CD)
        end
        if inst.components.finiteuses then
            inst.components.finiteuses:Use(1)
        end


        local x,y,z = doer:GetPosition():Get()
        local fx1 =  SpawnPrefab('groundpoundring_fx')
        fx1.Transform:SetPosition(x,y,z)
        fx1.Transform:SetScale(.7,.7,.7)
        local fx2 = SpawnPrefab('alterguardian_spintrail_fx')
        fx2.Transform:SetPosition(x,y,z)
        fx2.Transform:SetScale(1.2,1.2,1.2)
        -- SpawnPrefab('moonpulse2_fx').Transform:SetPosition(x,y,z)
        SpawnPrefab('groundpound_fx').Transform:SetPosition(x,y,z)

        doer.SoundEmitter:PlaySound('soundfx_lol_wp_divine/divine/hammer_smash',nil,.2)
    end)
    inst.components.aoeweapon_leap.OnHit = function(self, doer, target)
        if self.onprehitfn ~= nil then
            self.onprehitfn(self.inst, doer, target)
        end
        local did_hit = false
        -- if doer.components.combat:CanTarget(target) and not doer.components.combat:IsAlly(target) then
        --     doer.components.combat:DoAttack(target, nil, nil, self.stimuli)

        --     did_hit = true
        -- end

---@diagnostic disable-next-line: inject-field
        inst.is_using_lol_wp_s12_malignance_skill_fallen_blow = true
        if target and not target:HasTag('structure') and not target:HasTag('companion') and not target:HasTag('player') and target.components.combat and not target.components.combat:IsAlly(doer) and LOLWP_S:checkAlive(target) and not target:HasTag('wall') then
            target.components.combat:GetAttacked(doer, db.SKILL_FALLEN_BLOW.DAMAGE,inst)
        end
        if target and target.components.workable then
            local destory = false

            if target:HasTag('boulder') or target:HasTag('tree') then
                destory = true
            end

            local tar_prefab = target.prefab
            if not destory and tar_prefab then
                if string.find(tar_prefab,'_oversized') then
                    destory = true
                end
            end
            if destory then
                target.components.workable:Destroy(doer)
            end
        end
---@diagnostic disable-next-line: inject-field
        inst.is_using_lol_wp_s12_malignance_skill_fallen_blow = false

        if did_hit then
            if self.onhitfn then
                self.onhitfn(self.inst, doer, target)
            end
        else
            if self.onmissfn then
                self.onmissfn(self.inst, doer, target)
            end
        end
    end

    -- inst:AddComponent("rechargeable")
    -- inst.components.rechargeable:SetOnChargedFn(function() inst.components.aoetargeting:SetEnabled(true) end)
    -- inst.components.rechargeable:SetOnDischargedFn(function() inst.components.aoetargeting:SetEnabled(false) end)

    inst:AddComponent("damagetypebonus")
    inst.components.damagetypebonus:AddBonus("shadow_aligned", inst, db.DMGMULT_TO_SHADOW)



    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetChargeTime(db.SKILL_FALLEN_BLOW.CD)
    inst.components.rechargeable:SetOnDischargedFn(function()
        if inst.components.aoetargeting then
            inst.components.aoetargeting:SetEnabled(false)
        end
    end)
    inst.components.rechargeable:SetOnChargedFn(function()
        -- if inst:HasTag(prefab_id..'_iscd') then
        --     inst:RemoveTag(prefab_id..'_iscd')
        -- end
        if inst.components.aoetargeting then
            inst.components.aoetargeting:SetEnabled(true)
        end
    end)

    -- local planardamage = inst:AddComponent("planardamage")
    -- planardamage:SetBaseDamage(data_prefab.planardamage)

    -- inst.OnSave = onsave
    -- inst.OnPreLoad = onpreload

    return inst
end

return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs)