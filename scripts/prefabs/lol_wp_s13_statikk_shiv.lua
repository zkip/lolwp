local prefab_id = "lol_wp_s13_statikk_shiv"
local assets_id = "lol_wp_s13_statikk_shiv"

local db = TUNING.MOD_LOL_WP.STATIKK_SHIV

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
    owner.AnimState:OverrideSymbol("swap_object", "swap_"..assets_id, "swap_"..assets_id)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if owner then
        enable_electricattacks(true,owner,inst)
    end

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
end

---onunequipfn
---@param inst ent
---@param owner ent
local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if owner then
        enable_electricattacks(false,owner,inst)
    end

    if owner.components.lol_wp_critical_hit_player then
        owner.components.lol_wp_critical_hit_player:RemoveModifier('CriticalChance','add',inst,prefab_id)
        owner.components.lol_wp_critical_hit_player:RemoveModifier('CriticalDamage','mult',inst,prefab_id)
        owner.components.lol_wp_critical_hit_player:RemoveOnCriticalHit(prefab_id)
    end
end

local function onfinished(inst)
    LOLWP_S:unequipItem(inst)
    inst:AddTag(prefab_id..'_nofiniteuses')
end


local chargetime = 0

---onattack
---@param inst ent
---@param attacker ent
---@param target ent
local function onattack(inst,attacker,target)
    if inst.lol_wp_s13_statikk_shiv_electric_spark_num and inst.lol_wp_s13_statikk_shiv_electric_spark_num > 0 then
        inst.lol_wp_s13_statikk_shiv_electric_spark_num = inst.lol_wp_s13_statikk_shiv_electric_spark_num - 1

        if inst.components.lol_wp_electric_spark_chain and attacker then
            inst.components.lol_wp_electric_spark_chain:Launch(attacker)
        end

    end
    if inst.lol_wp_s13_statikk_shiv_electric_spark_num and inst.lol_wp_s13_statikk_shiv_electric_spark_num <= 0 then
        if inst.components.rechargeable and inst.components.rechargeable:IsCharged() then
            inst.components.rechargeable:Discharge(db.SKILL_ELECTRIC_SPARK.CD)
            chargetime = 0
        end
    end

    -- 每次攻击会减少1秒被动技能冷却时间
    if inst.components.rechargeable and not inst.components.rechargeable:IsCharged() then
        local cur = inst.components.rechargeable:GetCharge()
        local new = math.min(db.SKILL_ELECTRIC_SPARK.CD, cur + db.SKILL_CHARGE.REDUCE_SKILL_ELECTRIC_SPARK_PER_HIT)
        inst.components.rechargeable:SetCharge(new,true)
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

---comment
---@param inst ent
---@param pos any
local function OnLightningStrike(inst,pos)
    local pt = inst:GetPosition()
    inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
    SpawnPrefab('lol_wp_s13_statikk_shiv_charged').Transform:SetPosition(pt:Get())
    -- SpawnPrefab("lightning_rod_fx").Transform:SetPosition(pt:Get())
    SpawnPrefab("lightning").Transform:SetPosition(pt:Get())
    inst:Remove()
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

    -- inst.MiniMapEntity:SetIcon(prefab_id..".tex")

    if not TheWorld.ismastersim then
        return inst
    end

    ---@class ent
    ---@field lol_wp_s13_statikk_shiv_electric_spark_num integer # 斯塔缇克电刃 被动：【电火花 使前三次攻击在命中时发射连锁闪电

    inst.lol_wp_s13_statikk_shiv_electric_spark_num = db.SKILL_ELECTRIC_SPARK.HIT_TIMES

    -- inst:AddComponent("talker")
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = assets_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..assets_id..".xml"
    inst.components.inventoryitem:SetOnDroppedFn(function()
        if inst.components.lightningblocker then
            inst.components.lightningblocker:SetBlockRange(20)
        end
    end)
    inst.components.inventoryitem:SetOnPutInInventoryFn(function()
        if inst.components.lightningblocker then
            inst.components.lightningblocker:SetBlockRange(0)
        end
    end)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = db.WALKSPEEDMULT
    -- inst.components.equippable.dapperness = 2

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(db.DMG)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(db.FINITEUSES)
    inst.components.finiteuses:SetUses(db.FINITEUSES)
    inst.components.finiteuses:SetOnFinished(onfinished)

    -- inst:AddComponent('lol_wp_critical_hit')
    -- inst.components.lol_wp_critical_hit:Init(db.CRITICAL_CHANCE,db.CRITICAL_DMGMULT,true,'all')
    -- inst.components.lol_wp_critical_hit:SetOnCriticalHit(on_critical_hit)

    inst:AddComponent('lol_wp_electric_spark_chain')
    inst.components.lol_wp_electric_spark_chain:Init(db.SKILL_ELECTRIC_SPARK.CHAIN_MAX_TARGET,db.SKILL_ELECTRIC_SPARK.CHAIN_RANGE,function (mob,attacker)
        if mob.components.combat then
            mob.components.health:DoDelta(-db.SKILL_ELECTRIC_SPARK.PLANAR_DMG_WHEN_CHAIN)
            ---@type event_data_attacked
            local event_data_attacked = { attacker = attacker, damage = 0, damageresolved = db.SKILL_ELECTRIC_SPARK.PLANAR_DMG_WHEN_CHAIN}
            mob:PushEvent('attacked',event_data_attacked)
            -- mob.components.combat:GetAttacked(attacker,0,inst,nil,{ planar = db.SKILL_ELECTRIC_SPARK.PLANAR_DMG_WHEN_CHAIN })
        end
    end)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetMaxCharge(db.SKILL_ELECTRIC_SPARK.CD)
    inst.components.rechargeable:SetChargeTime(db.SKILL_ELECTRIC_SPARK.CD)
    -- inst.components.rechargeable:SetOnDischargedFn(function(inst)  end)
    inst.components.rechargeable:SetOnChargedFn(function(inst)
        -- if inst:HasTag(prefab_id..'_iscd') then
        --     inst:RemoveTag(prefab_id..'_iscd')
        -- end
        inst.lol_wp_s13_statikk_shiv_electric_spark_num = db.SKILL_ELECTRIC_SPARK.HIT_TIMES
    end)

    inst:AddComponent('lol_wp_s13_infinity_edge_active_repair')

    inst:AddComponent('lightningblocker')
    inst.components.lightningblocker:SetBlockRange(0)
    inst.components.lightningblocker:SetOnLightningStrike(OnLightningStrike)

    -- local planardamage = inst:AddComponent("planardamage")
    -- planardamage:SetBaseDamage(data_prefab.planardamage)

    -- inst.OnSave = onsave
    -- inst.OnPreLoad = onpreload

    return inst
end

return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs)