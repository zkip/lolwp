local prefab_id = "lol_wp_s10_guinsoo"
local assets_id = "lol_wp_s10_guinsoo"

local db = TUNING.MOD_LOL_WP.GUINSOO

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

---comment
---@param add_or_remove boolean
---@param weapon ent
---@param player ent
---@param mult nil|number
local function controlAtkSpeed(add_or_remove,weapon,player,mult)
    if add_or_remove then
        if player.components.combat and player.components.combat.SetAtkPeriodModifier then
            player.components.combat:SetAtkPeriodModifier(weapon, mult,'lol_wp_s10_guinsoo_atkspd')
        end
    else
        if player.components.combat and player.components.combat.RemoveAtkPeriodModifier then
            player.components.combat:RemoveAtkPeriodModifier(weapon, 'lol_wp_s10_guinsoo_atkspd')
        end
    end
end

---comment
---@param to_normal boolean
---@param inst ent
local function switchImg(to_normal,inst)
    if inst.components.inventoryitem then
        if to_normal then
            inst.components.inventoryitem:ChangeImageName('lol_wp_s10_guinsoo')
        else
            inst.components.inventoryitem:ChangeImageName('lol_wp_s10_guinsoo_max')
        end
    end
end


---comment
---@param on_off boolean
---@param player ent
local function modifierTemperature(on_off,player)
    if player and player.components.temperature then
        if on_off then
            player.components.temperature:SetModifier('lol_wp_s10_guinsoo_max_buff',80)
        else
            player.components.temperature:RemoveModifier('lol_wp_s10_guinsoo_max_buff')
        end
    end
end

---comment
---@param on_off boolean
---@param inst ent
local function playBGM(on_off,inst)
    if inst.SoundEmitter then
        if on_off then
            inst.SoundEmitter:PlaySound('guinsoo/bgm/guinsoo_bgm','guinsoo_bgm',.3)
            -- inst.SoundEmitter:PlaySoundWithParams('guinsoo/bgm/guinsoo_bgm',{intensity = .1,size = .05}, .3)
        else
            inst.SoundEmitter:KillSound('guinsoo_bgm')
        end
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_"..assets_id, "swap_"..assets_id)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    inst.Light:Enable(false)

    -- 判断层数来决定是否升温buff
    if inst.lol_wp_s10_guinsoo_combo and inst.lol_wp_s10_guinsoo_combo >= db.SKILL_BOILSTRIKE.MAXSTACK then
        modifierTemperature(true,owner)
    end

    -- playBGM(true,inst)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    inst.Light:Enable(false)

    -- 卸除移除攻速buff
    controlAtkSpeed(false,inst,owner)

    -- 取消升温buff
    modifierTemperature(false,owner)

    -- playBGM(false,inst)
end

local function onfinished(inst)
    -- inst:Remove()
    LOLWP_S:unequipItem(inst)
    inst:AddTag(prefab_id..'_nofiniteuses')
end


---comment
---@param inst ent
---@param attacker ent
---@param target ent
local function onattack(inst,attacker,target)
    local pt = target:GetPosition()
    -- SpawnPrefab('winters_feast_depletefood').Transform:SetPosition(pt:Get())
    SpawnPrefab("hitsparks_fx"):Setup(attacker, target)

    -- 每次攻击叠加一层combo,不超过最大值
    inst.lol_wp_s10_guinsoo_combo = math.min(db.SKILL_BOILSTRIKE.MAXSTACK,inst.lol_wp_s10_guinsoo_combo + 1)

    -- 被动叠满后
    if inst.lol_wp_s10_guinsoo_combo >= db.SKILL_BOILSTRIKE.MAXSTACK then
        -- 攻击附带特效
        SpawnPrefab(db.SKILL_BOILSTRIKE.WHEN_MAXSTACK_ATK_FX).Transform:SetPosition(attacker:GetPosition():Get())

        -- 叠满才发光
        inst.Light:Enable(true)

        -- 羊刀在叠满是做一个特殊显示 物品栏上盖一个红色滤镜
        switchImg(false,inst)

        -- 升温
        modifierTemperature(true,attacker)

        -- 概率点燃敌人, 不能重复点燃
        if not target._flag_lol_wp_s10_guinsoo_burning then
            if math.random() <= db.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_CHANCE then
                if target.components.burnable then
                    -- 标记正在燃烧
                    target._flag_lol_wp_s10_guinsoo_burning = true

                    -- 触发点燃时的特效
                    SpawnPrefab(db.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_FX).Transform:SetPosition(pt:Get())

                    target.components.burnable.controlled_burn = {
                        duration_creature = 3,
                        damage = 0,
                    }
                    target.components.burnable:SpawnFX(nil)
                    target.components.burnable.controlled_burn = nil

                    if target.taskperiod_lol_wp_s10_guinsoo_burning == nil then
                        target.taskperiod_lol_wp_s10_guinsoo_burning = target:DoPeriodicTask(db.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_PERIOD,function ()
                            if LOLWP_S:checkAlive(target) then
                                -- if target.components.combat then
                                --     target.components.combat:GetAttacked(attacker,db.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_DMG,inst)
                                -- end
                                target.components.health:DoDelta(-db.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_DMG)
                            end
                        end)
                    end

                    target:DoTaskInTime(db.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_LAST,function ()
                        if target then
                            -- 标记停止燃烧
                            target._flag_lol_wp_s10_guinsoo_burning = false
                            if target.components.burnable then
                                target.components.burnable:KillFX()
                            end
                            if target.taskperiod_lol_wp_s10_guinsoo_burning then
                                target.taskperiod_lol_wp_s10_guinsoo_burning:Cancel()
                                target.taskperiod_lol_wp_s10_guinsoo_burning = nil
                            end
                        end
                    end)
                end
            end
        end
    end

    -- 计算攻速
    local spmult = (db.SKILL_BOILSTRIKE.SPEED_PER * inst.lol_wp_s10_guinsoo_combo) + 1
    if attacker and attacker:HasTag('player') then
        controlAtkSpeed(true,inst,attacker,spmult)
    end

    -- 每次攻击取消上一个计时器
    if inst.taskintime_cancel_lol_wp_s10_guinsoo_combo then
        inst.taskintime_cancel_lol_wp_s10_guinsoo_combo:Cancel()
        inst.taskintime_cancel_lol_wp_s10_guinsoo_combo = nil
    end

    -- 倒计时减combo
    if inst.taskintime_cancel_lol_wp_s10_guinsoo_combo == nil then
        inst.taskintime_cancel_lol_wp_s10_guinsoo_combo = inst:DoTaskInTime(db.SKILL_BOILSTRIKE.COMBO_KEEPTIME, function()
            inst.lol_wp_s10_guinsoo_combo = math.max(0, inst.lol_wp_s10_guinsoo_combo - db.SKILL_BOILSTRIKE.COMBO_DECREASE_OVERTIME)

            -- 修正攻速
            local spmult = (db.SKILL_BOILSTRIKE.SPEED_PER * inst.lol_wp_s10_guinsoo_combo) + 1
            controlAtkSpeed(true,inst,attacker,spmult)

            -- 停止发光
            inst.Light:Enable(false)

            -- 羊刀恢复滤镜
            switchImg(true,inst)

            -- 取消升温buff
            modifierTemperature(false,attacker)
        end)
    end
end

local function Lightning_ReticuleTargetFn()
    --Cast range is 8, leave room for error (6.5 lunge)
    return Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0))
end
local function Lightning_ReticuleMouseTargetFn(inst, mousepos)
    if mousepos ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local dx = mousepos.x - x
        local dz = mousepos.z - z
        local l = dx * dx + dz * dz
        if l <= 0 then
            return inst.components.reticule.targetpos
        end
        l = 6.5 / math.sqrt(l)
        return Vector3(x + dx * l, 0, z + dz * l)
    end
end

local function Lightning_ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
    local x, y, z = inst.Transform:GetWorldPosition()
    reticule.Transform:SetPosition(x, 0, z)
    local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
    if ease and dt ~= nil then
        local rot0 = reticule.Transform:GetRotation()
        local drot = rot - rot0
        rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
    end
    reticule.Transform:SetRotation(rot)
end


local function Lightning_SpellFn(inst, doer, pos)
    doer:PushEvent("combat_lunge", { targetpos = pos, weapon = inst })
end

local function Lightning_OnLunged(inst, doer, startingpos, targetpos)
    -- local fx = SpawnPrefab("spear_wathgrithr_lightning_lunge_fx")
    local fx = SpawnPrefab("firesplash_fx")
    fx.Transform:SetPosition(targetpos:Get())
    fx.Transform:SetRotation(doer:GetRotation())

    inst.components.rechargeable:Discharge(db.SKILL_ALPHA.CD)

    inst._lunge_hit_count = nil


end

local function Lightning_OnLungedHit(inst, doer, target)

    inst._lunge_hit_count = inst._lunge_hit_count or 0

    if inst._lunge_hit_count < TUNING.SPEAR_WATHGRITHR_LIGHTNING_CHARGED_MAX_REPAIRS_PER_LUNGE and
        inst.components.upgradeable == nil and
        doer.IsValidVictim ~= nil and
        doer.IsValidVictim(target)
    then
        inst.components.finiteuses:Repair(TUNING.SPEAR_WATHGRITHR_LIGHTNING_CHARGED_LUNGE_REPAIR_AMOUNT)
        inst._lunge_hit_count = inst._lunge_hit_count + 1
    end

    -- 标记位移结束
    inst.flag_lol_wp_s10_guinsoo_islunge = false
end

local function Lightning_OnDischarged(inst)
    inst.components.aoetargeting:SetEnabled(false)
end

local function Lightning_OnCharged(inst)

    inst.components.aoetargeting:SetEnabled(true)

end


local function OnPreLungeFn(inst, doer, startingpos, targetpos)
    -- 标记正在位移
    inst.flag_lol_wp_s10_guinsoo_islunge = true
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

    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.Light:SetFalloff(db.LIGHT.FALLOFF)
    inst.Light:SetIntensity(db.LIGHT.INTENSITY)
    inst.Light:SetRadius(db.LIGHT.RADIUS)
    inst.Light:SetColour(unpack(db.LIGHT.COLOR))
    inst.Light:Enable(false)

    inst.entity:SetPristine()

    inst:AddTag("nosteal")

    -- inst.MiniMapEntity:SetIcon(prefab_id..".tex")

    -- aoeweapon_lunge (from aoeweapon_lunge component) added to pristine state for optimization.
    inst:AddTag("aoeweapon_lunge")

    -- rechargeable (from rechargeable component) added to pristine state for optimization.
    inst:AddTag("rechargeable")

    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting:SetAllowRiding(false)
    inst.components.aoetargeting.reticule.reticuleprefab = "reticuleline"
    inst.components.aoetargeting.reticule.pingprefab = "reticulelineping"
    inst.components.aoetargeting.reticule.targetfn = Lightning_ReticuleTargetFn
    inst.components.aoetargeting.reticule.mousetargetfn = Lightning_ReticuleMouseTargetFn
    inst.components.aoetargeting.reticule.updatepositionfn = Lightning_ReticuleUpdatePositionFn
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true
    inst.components.aoetargeting.reticule.mouseenabled = true

    if not TheWorld.ismastersim then
        return inst
    end

    ---@class ent
    ---@field lol_wp_s10_guinsoo_combo number # 鬼索连击

    inst.lol_wp_s10_guinsoo_combo = 0

    -- inst:AddComponent("talker")
    inst:AddComponent("inspectable")

    inst:AddComponent('lol_wp_s10_guinsoo_bgm')

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = assets_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..assets_id..".xml"
    inst.components.inventoryitem:SetOnDroppedFn(function()
        inst.Light:Enable(false)
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
    inst.components.finiteuses:SetMaxUses(db.FINITEUSE)
    inst.components.finiteuses:SetUses(db.FINITEUSE)
    inst.components.finiteuses:SetOnFinished(onfinished)

    -- inst:AddComponent("rechargeable")
    -- inst.components.rechargeable:SetChargeTime(100)
    -- -- inst.components.rechargeable:SetOnDischargedFn(function(inst)  end)
    -- inst.components.rechargeable:SetOnChargedFn(function(inst)
    --     if inst:HasTag(prefab_id..'_iscd') then
    --         inst:RemoveTag(prefab_id..'_iscd')
    --     end
    -- end)

    local planardamage = inst:AddComponent("planardamage")
    planardamage:SetBaseDamage(db.PLANAR_DMG)

    inst.components.aoetargeting:SetEnabled(true)

    inst:AddComponent("aoeweapon_lunge")
    inst.components.aoeweapon_lunge:SetDamage(db.SKILL_ALPHA.DMG-db.DMG)
    inst.components.aoeweapon_lunge:SetSound("meta3/wigfrid/spear_lighting_lunge")
    inst.components.aoeweapon_lunge:SetSideRange(1)
    inst.components.aoeweapon_lunge:SetOnPreLungeFn(OnPreLungeFn)
    inst.components.aoeweapon_lunge:SetOnLungedFn(Lightning_OnLunged)
    inst.components.aoeweapon_lunge:SetOnHitFn(Lightning_OnLungedHit)
    -- inst.components.aoeweapon_lunge:SetStimuli("electric")
    inst.components.aoeweapon_lunge:SetWorkActions()
    inst.components.aoeweapon_lunge:SetTags("_combat")

    inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(Lightning_SpellFn)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetOnDischargedFn(Lightning_OnDischarged)
    inst.components.rechargeable:SetOnChargedFn(Lightning_OnCharged)

    -- inst:ListenForEvent('ms_simunpaused',function()
    --     if inst.SoundEmitter then
    --         inst.SoundEmitter:SetParameter('guinsoo_bgm','volume',0)
    --     end
    -- end,TheWorld)

    -- inst:ListenForEvent('serverpauseddirty',function ()
    --     -- local owner = inst and inst.components.inventoryitem and inst.components.inventoryitem.owner
    --     if TheNet:IsServerPaused() and inst and inst.SoundEmitter then
    --         inst.SoundEmitter:SetVolume('guinsoo_bgm',0)
    --     else
    --         if inst and not inst.lol_wp_s10_guinsoo_ismute then
    --             inst.SoundEmitter:SetVolume('guinsoo_bgm',0.3)
    --         end
    --     end
    -- end,TheWorld)

    -- inst.OnSave = onsave
    -- inst.OnPreLoad = onpreload

    return inst
end

return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs)


