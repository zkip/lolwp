local prefab_id = "lol_wp_s13_collector"
local assets_id = "lol_wp_s13_collector"

local db = TUNING.MOD_LOL_WP.COLLECTOR

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
    owner.AnimState:OverrideSymbol("lol_fishgun", assets_id, assets_id)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if owner.components.lol_wp_critical_hit_player then
        owner.components.lol_wp_critical_hit_player:Modifier('CriticalChance','add',inst,db.CRITICAL_CHANCE,prefab_id)
        owner.components.lol_wp_critical_hit_player:Modifier('CriticalDamage','mult',inst,db.CRITICAL_DMGMULT,prefab_id)
        owner.components.lol_wp_critical_hit_player:SetOnCriticalHit(prefab_id,function (victim)
            if victim then
                local victim_pt = victim:GetPosition()
                SpawnPrefab(db.FX_WHEN_CC).Transform:SetPosition(victim_pt:Get())
            end
        end)
    end

    if inst.components.container and owner then
        inst.components.container:Open(owner)
    end

    -- if owner.components.combat then
    --     owner.components.combat:SetAtkPeriodModifier(inst,db.ATK_PERIOD,prefab_id)
    -- end
    --     if owner.components.combat then
    -- ---@diagnostic disable-next-line: inject-field
    --         owner._old_min_attack_period_lol_wp_s13_collector = owner.components.combat.min_attack_period
    --         owner.components.combat.min_attack_period = owner.components.combat.min_attack_period * db.ATK_PERIOD
    --     end
end

---onunequipfn
---@param inst ent
---@param owner ent
local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("lol_fishgun")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if owner.components.lol_wp_critical_hit_player then
        owner.components.lol_wp_critical_hit_player:RemoveModifier('CriticalChance','add',inst,prefab_id)
        owner.components.lol_wp_critical_hit_player:RemoveModifier('CriticalDamage','mult',inst,prefab_id)
        owner.components.lol_wp_critical_hit_player:RemoveOnCriticalHit(prefab_id)
    end

    if inst.components.container and owner then
        inst.components.container:Close(owner)
    end

    -- if owner.components.combat then
    --     owner.components.combat:RemoveAtkPeriodModifier(inst,prefab_id)
    -- end
    --     if owner.components.combat then
    -- ---@diagnostic disable-next-line: undefined-field
    --         owner.components.combat.min_attack_period = owner._old_min_attack_period_lol_wp_s13_collector / db.ATK_PERIOD
    --     end
end

-- local function onfinished(inst)
--     inst:Remove()
-- end

---onattack
---@param inst ent
---@param attacker ent
---@param target ent
local function onattack(inst,attacker,target)
    -- LOLWP_S:declare('onattack')
    if inst.components.container then
        local golds = inst.components.container:GetAllItems()
        for _,v in ipairs(golds) do
            if v.prefab == 'goldnugget' then
                LOLWP_S:consumeOneItem(v)
                break
            end
        end
    end
end

---comment
---@param inst ent
---@param victim ent
---@param attacker ent
local function on_critical_hit(inst,victim,attacker)
    if victim then
        local victim_pt = victim:GetPosition()
        SpawnPrefab(db.FX_WHEN_CC).Transform:SetPosition(victim_pt:Get())
    end
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
    inst:AddTag("rangedweapon")
    inst:AddTag(prefab_id)

    -- inst:AddTag('lunar_aligned')
    -- inst:AddTag('stronggrip')

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
    -- inst.components.equippable.walkspeedmult = 1.2
    -- inst.components.equippable.dapperness = 2

    inst:AddComponent('planardamage')
    inst.components.planardamage:SetBaseDamage(db.PLANAR_DMG)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(db.DMG)
    inst.components.weapon:SetRange(db.RANGE,20)
    inst.components.weapon:SetProjectile("lol_wp_handcanon_proj")
    inst.components.weapon:SetOnAttack(onattack)

    -- inst:AddComponent('lol_wp_critical_hit')
    -- inst.components.lol_wp_critical_hit:Init(db.CRITICAL_CHANCE,db.CRITICAL_DMGMULT,true,'all')
    -- inst.components.lol_wp_critical_hit:SetOnCriticalHit(on_critical_hit)

    -- inst:AddComponent("damagetypebonus")
    -- inst.components.damagetypebonus:AddBonus("shadow_aligned", inst, db.DMGMULT_TO_SHADOW)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup(prefab_id)
    local _isempty = true
    for _,v in ipairs(inst.components.container:GetAllItems()) do
        if v.prefab and v.prefab == 'goldnugget' then
            _isempty = false
            break
        end
    end
    if _isempty then
        inst:AddTag('lol_wp_s13_collector_container_isempty')
    else
        inst:RemoveTag('lol_wp_s13_collector_container_isempty')
    end

    inst:ListenForEvent('itemget',function ()
        if inst and inst.components.container then
            local isempty = true
            for _,v in ipairs(inst.components.container:GetAllItems()) do
                if v.prefab and v.prefab == 'goldnugget' then
                    isempty = false
                    break
                end
            end
            if isempty then
                inst:AddTag('lol_wp_s13_collector_container_isempty')
            else
                inst:RemoveTag('lol_wp_s13_collector_container_isempty')
            end
        end
    end)

    inst:ListenForEvent('itemlose',function ()
        if inst and inst.components.container then
            local isempty = true
            for _,v in ipairs(inst.components.container:GetAllItems()) do
                if v.prefab and v.prefab == 'goldnugget' then
                    isempty = false
                    break
                end
            end
            if isempty then
                inst:AddTag('lol_wp_s13_collector_container_isempty')
            else
                inst:RemoveTag('lol_wp_s13_collector_container_isempty')
            end
        end
    end)


    -- inst:AddComponent("finiteuses")
    -- inst.components.finiteuses:SetMaxUses(500)
    -- inst.components.finiteuses:SetUses(500)
    -- inst.components.finiteuses:SetOnFinished(onfinished)

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

local function make_proj_fire()
    local _assets =
    {
        -- Asset("ANIM", "anim/staff_projectile.zip"),
    }

    local fire_prefabs =
    {
        "fire_fail_fx",
    }

    local function NoHoles(pt)
        return not TheWorld.Map:IsPointNearHole(pt)
    end

    local function SpawnShadowTentacle(inst, attacker, target, pt, starting_angle)
        local offset = FindWalkableOffset(pt, starting_angle, 2, 3, false, true, NoHoles, false, true)
        if offset ~= nil then
            local tentacle = SpawnPrefab("shadowtentacle")
            if tentacle ~= nil then
                tentacle.owner = attacker
                tentacle.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
                tentacle.components.combat:SetTarget(target)

                tentacle.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shadowTentacleAttack_1")
                tentacle.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shadowTentacleAttack_2")
            end
        end
    end

    local function OnHit_Thulecite(inst, attacker, target)
        if math.random() < 0.5 then
            local pt
            if target ~= nil and target:IsValid() then
                pt = target:GetPosition()
            else
                pt = inst:GetPosition()
                target = nil
            end

            local theta = math.random() * TWOPI
            SpawnShadowTentacle(inst, attacker, target, pt, theta)
        end

        inst:Remove()
    end

    local function OnHitFire(inst, owner, target)
        if target:IsValid() and not (target.components.burnable ~= nil and target.components.burnable:IsBurning()) then
            local radius = target:GetPhysicsRadius(0) + .2
            local x1, y1, z1 = target.Transform:GetWorldPosition()
            local x, y, z = inst.Transform:GetWorldPosition()
            if x ~= x1 or z ~= z1 then
                local dx = x - x1
                local dz = z - z1
                local k = radius / math.sqrt(dx * dx + dz * dz)
                x1 = x1 + dx * k
                z1 = z1 + dz * k
            end
            local fx = SpawnPrefab("fire_fail_fx")
            fx.Transform:SetPosition(
                x1 + GetRandomMinMax(-.2, .2),
                GetRandomMinMax(.1, .3),
                z1 + GetRandomMinMax(-.2, .2)
            )
        end
        inst:Remove()
    end

    local function common(anim, bloom, lightoverride)
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        RemovePhysicsColliders(inst)

        -- inst.AnimState:SetBank("projectile")
        -- inst.AnimState:SetBuild("staff_projectile")
        -- inst.AnimState:PlayAnimation(anim, true)

        inst.AnimState:SetBank("slingshotammo")
        inst.AnimState:SetBuild("slingshotammo")
        inst.AnimState:PlayAnimation('spin_loop', true)
        inst.AnimState:OverrideSymbol("rock", "slingshotammo", 'thulecite')

        if bloom ~= nil then
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end
        if lightoverride ~= nil then
            inst.AnimState:SetLightOverride(lightoverride)
        end

        --projectile (from projectile component) added to pristine state for optimization
        inst:AddTag("projectile")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        inst:AddComponent("projectile")
        inst.components.projectile:SetSpeed(50)
        inst.components.projectile:SetOnHitFn(
        ---comment
        ---@param inst ent
        ---@param attacker ent
        ---@param target ent
        function(inst,attacker,target)
            -- OnHit_Thulecite(inst,attacker,target)
            -- OnHitFire(inst,attacker,target)
            local pt = inst:GetPosition()
            -- local fx = SpawnPrefab('slingshotammo_hitfx_thulecite')
            local fx = SpawnPrefab('slingshotammo_hitfx_gunpowder')
            fx.Transform:SetPosition(pt:Get())
            -- fx:DoTaskInTime(.2,function ()
            --     fx:Remove()
            -- end)
            inst:Remove()

            if target then
                if target:HasTag('wall') or target:HasTag('structure') then
                    return
                end
                if target.components.combat and target.components.health then
                    local isdead = false
                    if target.components.health:IsDead() then
                        isdead = true
                    else
                        local cur_percent = target.components.health:GetPercent()
                        if cur_percent <= db.SKILL_DEATH_AND_TAX.SEC_KILL_HP_LINE then
                            ---@type event_data_killed
                            local event_data_killed = { attacker = attacker, victim = target}
                            target:PushEvent('killed',event_data_killed)
                            target.components.health:Kill()
                            isdead = true
                        end
                    end
                    if isdead then
                        ---@type event_data_attacked
                        local event_data_attacked = { attacker = attacker, weapon = attacker.last_atk_weapon ,damage = 0, spdamage = {planar = db.SKILL_DEATH_AND_TAX.PLANAR_DMG_WHEN_SEC_KILL}, damageresolved = db.SKILL_DEATH_AND_TAX.PLANAR_DMG_WHEN_SEC_KILL}
                        target:PushEvent('attacked',event_data_attacked)
                        -- -- 掉落黄金
                        -- local golds
                        -- if target:HasTag('epic') then
                        --     golds = LOLWP_S:spawnPrefabByStack('goldnugget',db.SKILL_DEATH_AND_TAX.GOLDNUGGET_WHEN_KILL_BOSS)
                        -- else
                        --     golds = LOLWP_S:spawnPrefabByStack('goldnugget',db.SKILL_DEATH_AND_TAX.GOLDNUGGET_WHEN_KILL_NORMAL)
                        -- end
                        -- local tar_pt = target:GetPosition()
                        -- for _,v in ipairs(golds) do
                        --     LOLWP_S:flingItem(v,tar_pt)
                        -- end
                    end
                end
            end
        end)
        inst.components.projectile:SetOnMissFn(inst.Remove)
        inst.components.projectile:SetLaunchOffset(Vector3(2.3,0,0))

        return inst
    end

    local function fire()
        local inst = common("fire_spin_loop", "shaders/anim.ksh", 1)

        if not TheWorld.ismastersim then
            return inst
        end

        return inst
    end

    return Prefab("lol_wp_handcanon_proj", fire, _assets, fire_prefabs)
end

return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs),make_proj_fire()