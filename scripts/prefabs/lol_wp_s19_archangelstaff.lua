local db = TUNING.MOD_LOL_WP.ARCHANGELSTAFF

local function makeWeapon()
    local prefab_id = "lol_wp_s19_archangelstaff"
    local assets_id = "lol_wp_s19_archangelstaff"

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
        inst:Remove()
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

        ---@cast inst ent_lol_wp_s19_archangelstaff

        inst.lol_wp_s19_archangelstaff_overload_hittimes = 0


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
        inst.components.equippable.dapperness = 0/54

        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(0)
        inst.components.weapon:SetRange(db.RANGE,db.RANGE+2)
        inst.components.weapon:SetProjectile('lol_wp_s19_archangelstaff_proj_bounce')
        inst.components.weapon:SetOnAttack(onattack)

        local old_OnAttack = inst.components.weapon.OnAttack
        function inst.components.weapon:OnAttack(attacker, target, projectile, ...)
            if self.inst.prefab == 'lol_wp_s19_archangelstaff' then
                if inst.lol_wp_s19_archangelstaff_isbounce then
                    -- 在bounce,弹跳时不会增加次数
                else
                    -- 非弹跳时,击中增加次数,但是有最大值,这个值在proj中被重置
                    inst.lol_wp_s19_archangelstaff_overload_hittimes = math.min(inst.lol_wp_s19_archangelstaff_overload_hittimes + 1,db.SKILL_OVERLOAD.PER_HIT_TIMES)
                end
                if self.onattack ~= nil then
                    self.onattack(self.inst, attacker, target)
                end
            else
                return old_OnAttack(attacker, target, projectile, ...)
            end
        end

        inst:AddComponent('planardamage')
        inst.components.planardamage:SetBaseDamage(db.PLANAR_DMG)

        inst:AddComponent('count_from_tearsofgoddness')
        inst.components.count_from_tearsofgoddness:Init(db.SKILL_COUNT.MAX_COUNT,'lol_wp_s19_archangelstaff_upgrade')
        inst.components.count_from_tearsofgoddness:SetOnDelta(function (this, num)
            -- local old_dapperness = inst.components.equippable.dapperness or 0
            inst.components.equippable.dapperness = (num*db.SKILL_COUNT.DARPPERNESS_PER_COUNT)/54
        end)
        inst.components.count_from_tearsofgoddness:SetOnLoad(function (this, val)
            -- local old_dapperness = inst.components.equippable.dapperness or 0
            inst.components.equippable.dapperness = (val*db.SKILL_COUNT.DARPPERNESS_PER_COUNT)/54
        end)

        -- inst:AddComponent("finiteuses")
        -- inst.components.finiteuses:SetMaxUses(500)
        -- inst.components.finiteuses:SetUses(500)
        -- inst.components.finiteuses:SetOnFinished(onfinished)

        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetChargeTime(db.SKILL_COUNT.CD)
        -- inst.components.rechargeable:SetOnDischargedFn(function(inst)  end)
        -- inst.components.rechargeable:SetOnChargedFn(function(inst)
        --     if inst:HasTag(prefab_id..'_iscd') then
        --         inst:RemoveTag(prefab_id..'_iscd')
        --     end
        -- end)

        inst:AddComponent("damagetypebonus")
        inst.components.damagetypebonus:AddBonus("shadow_aligned", inst, db.DMGMULT_TO_SHADOW)

        -- local planardamage = inst:AddComponent("planardamage")
        -- planardamage:SetBaseDamage(data_prefab.planardamage)

        -- inst.OnSave = onsave
        -- inst.OnPreLoad = onpreload

        return inst
    end

    return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs)
end

local function makeWeapon_upgrade()
    local prefab_id = "lol_wp_s19_archangelstaff_upgrade"
    local assets_id = "lol_wp_s19_archangelstaff_upgrade"

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

    local function fn()
        ---@type ent|nil
        local _equip = nil
        ---@type ent|nil
        local _shield = nil
        ---@type ent|nil
        local _equipfx = nil

        ---comment
        ---@param player ent
        ---@param data event_data_attacked
        local function owner_attacked(player,data)
            if _equip and player and player.components.lol_wp_player_invincible and LOLWP_S:checkAlive(player) and player.components.health:GetPercent() <= db.UPGRADE.SKILL_SHIELD.HP_PERCENT_BELOW then
                if _equip.components.rechargeable and _equip.components.rechargeable:IsCharged() then
                    _equip.components.rechargeable:Discharge(db.UPGRADE.SKILL_SHIELD.CD)
                    if _shield and _shield:IsValid() then
                        _shield:Remove()
                        _shield = nil
                    end
                    _shield = SpawnPrefab('forcefieldfx')
                    _shield.AnimState:SetAddColour(33/255,169/255,232/255,1)
                    _shield.entity:SetParent(player.entity)
                    player.components.lol_wp_player_invincible:Push()
                    player:DoTaskInTime(db.UPGRADE.SKILL_SHIELD.SHIELD_DURATION,function ()
                        if _shield and _shield:IsValid() then
                            _shield:Remove()
                            _shield = nil
                        end
                        player.components.lol_wp_player_invincible:Pop()
                    end)
                end
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

            inst.Light:Enable(true)

            _equip = inst
            owner:ListenForEvent('attacked',owner_attacked)

            if _equipfx and _equipfx:IsValid() then
                _equipfx:Remove()
            end

            _equipfx = SpawnPrefab('cane_victorian_fx')
            _equipfx.entity:SetParent(owner.entity)
            _equipfx.entity:AddFollower()
            _equipfx.Follower:FollowSymbol(owner.GUID, 'swap_object', 0, 0, 0)
        end

        ---onunequipfn
        ---@param inst ent
        ---@param owner ent
        local function onunequip(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")

            inst.Light:Enable(false)

            _equip = nil
            owner:RemoveEventCallback('attacked',owner_attacked)

            if _equipfx and _equipfx:IsValid() then
                _equipfx:Remove()
            end
        end

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

        inst.Light:SetFalloff(db.UPGRADE.LIGHT.FALLOFF)
        inst.Light:SetIntensity(db.UPGRADE.LIGHT.INTENSITY)
        inst.Light:SetRadius(db.UPGRADE.LIGHT.RADIUS)
        inst.Light:SetColour(unpack(db.UPGRADE.LIGHT.COLOR))
        inst.Light:Enable(false)

        inst.entity:SetPristine()

        inst:AddTag("nosteal")

        inst:AddTag('lunar_aligned')

        -- inst.MiniMapEntity:SetIcon(prefab_id..".tex")

        if not TheWorld.ismastersim then
            return inst
        end

        ---@class ent_lol_wp_s19_archangelstaff : ent
        ---@field lol_wp_s19_archangelstaff_overload_hittimes integer
        ---@field lol_wp_s19_archangelstaff_isbounce boolean|nil

        ---@cast inst ent_lol_wp_s19_archangelstaff

        inst.lol_wp_s19_archangelstaff_overload_hittimes = 0


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
        inst.components.equippable.walkspeedmult = db.WALKSPEEDMULT
        inst.components.equippable.dapperness = db.UPGRADE.DARPPERNESS/54

        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(0)
        inst.components.weapon:SetRange(db.UPGRADE.RANGE,db.UPGRADE.RANGE+2)
        inst.components.weapon:SetProjectile('lol_wp_s19_archangelstaff_proj_bounce')
        -- inst.components.weapon:SetOnAttack(onattack)

        local old_OnAttack = inst.components.weapon.OnAttack
        function inst.components.weapon:OnAttack(attacker, target, projectile, ...)
            if self.inst.prefab == 'lol_wp_s19_archangelstaff_upgrade' then
                if inst.lol_wp_s19_archangelstaff_isbounce then
                    -- 在bounce,弹跳时不会增加次数
                else
                    -- 非弹跳时,击中增加次数,但是有最大值,这个值在proj中被重置
                    inst.lol_wp_s19_archangelstaff_overload_hittimes = math.min(inst.lol_wp_s19_archangelstaff_overload_hittimes + 1,db.SKILL_OVERLOAD.PER_HIT_TIMES)
                end
                if self.onattack ~= nil then
                    self.onattack(self.inst, attacker, target)
                end
            else
                return old_OnAttack(attacker, target, projectile, ...)
            end
        end

        inst:AddComponent('planardamage')
        inst.components.planardamage:SetBaseDamage(db.UPGRADE.PLANAR_DMG)

        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetChargeTime(db.UPGRADE.SKILL_SHIELD.CD)
        -- inst.components.rechargeable:SetOnDischargedFn(function(inst)
        -- end)
        -- inst.components.rechargeable:SetOnChargedFn(function(inst)
        -- end)

        inst:AddComponent("damagetypebonus")
        inst.components.damagetypebonus:AddBonus("shadow_aligned", inst, db.UPGRADE.DMGMULT_TO_SHADOW)

        -- local planardamage = inst:AddComponent("planardamage")
        -- planardamage:SetBaseDamage(data_prefab.planardamage)

        -- inst.OnSave = onsave
        -- inst.OnPreLoad = onpreload

        return inst
    end

    return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs)
end


local function makeProjBounce()
    local assets =
    {
        Asset("ANIM", "anim/brilliance_projectile_fx.zip"),
    }

    local prefabs =
    {
        "brilliance_projectile_blast_fx",
    }

    local SPEED = 15
    local BOUNCE_RANGE = 12
    local BOUNCE_SPEED = 10

    local function PlayAnimAndRemove(inst, anim)
        inst.AnimState:PlayAnimation(anim)
        if not inst.removing then
            inst.removing = true
            inst:ListenForEvent("animover", inst.Remove)
        end
    end

    local function OnThrown(inst, owner, target, attacker)
        inst.owner = owner
        if inst.bounces == nil then
            local hat = attacker ~= nil and attacker.components.inventory ~= nil and attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
            inst.bounces = hat ~= nil and hat.prefab == "lunarplanthat" and TUNING.STAFF_LUNARPLANT_SETBONUS_BOUNCES or TUNING.STAFF_LUNARPLANT_BOUNCES
            inst.initial_hostile = target ~= nil and target:IsValid() and target:HasTag("hostile")
        end
    end

    local BOUNCE_MUST_TAGS = { "_combat" }
    local BOUNCE_NO_TAGS = { "INLIMBO", "wall", "notarget", "player", "companion", "flight", "invisible", "noattack", "hiding" }

    local function TryBounce(inst, x, z, attacker, target)
        if attacker.components.combat == nil or not attacker:IsValid() then
            inst:Remove()
            return
        end
        local newtarget, newrecentindex, newhostile
        for i, v in ipairs(TheSim:FindEntities(x, 0, z, BOUNCE_RANGE, BOUNCE_MUST_TAGS, BOUNCE_NO_TAGS)) do
            if v ~= target and v.entity:IsVisible() and
                not (v.components.health ~= nil and v.components.health:IsDead()) and
                attacker.components.combat:CanTarget(v) and not attacker.components.combat:IsAlly(v)
                then
                local vhostile = v:HasTag("hostile")
                local vrecentindex
                if inst.recenttargets ~= nil then
                    for i1, v1 in ipairs(inst.recenttargets) do
                        if v == v1 then
                            vrecentindex = i1
                            break
                        end
                    end
                end
                if inst.initial_hostile and not vhostile and vrecentindex == nil and v.components.locomotor == nil then
                    --attack was initiated against a hostile target
                    --skip if non-hostile, can't move, and has never been targeted
                elseif newtarget == nil then
                    newtarget = v
                    newrecentindex = vrecentindex
                    newhostile = vhostile
                elseif vhostile and not newhostile then
                    newtarget = v
                    newrecentindex = vrecentindex
                    newhostile = vhostile
                elseif vhostile or not newhostile then
                    if vrecentindex == nil then
                        if newrecentindex ~= nil or (newtarget.prefab ~= target.prefab and v.prefab == target.prefab) then
                            newtarget = v
                            newrecentindex = vrecentindex
                            newhostile = vhostile
                        end
                    elseif newrecentindex ~= nil and vrecentindex < newrecentindex then
                        newtarget = v
                        newrecentindex = vrecentindex
                        newhostile = vhostile
                    end
                end
            end
        end

        if newtarget ~= nil then
            inst.Physics:Teleport(x, 0, z)
            inst:Show()
            inst.components.projectile:SetSpeed(BOUNCE_SPEED)
            if inst.recenttargets ~= nil then
                if newrecentindex ~= nil then
                    table.remove(inst.recenttargets, newrecentindex)
                end
                table.insert(inst.recenttargets, target)
            else
                inst.recenttargets = { target }
            end
            inst.components.projectile:SetBounced(true)
            inst.components.projectile.overridestartpos = Vector3(x, 0, z)
            inst.components.projectile:Throw(inst.owner, newtarget, attacker)
        else
            inst:Remove()
        end
    end

    ---comment
    ---@param inst ent
    ---@param attacker ent
    ---@param target ent
    local function OnHit(inst, attacker, target)
        local blast = SpawnPrefab("brilliance_projectile_blast_fx")
        local x, y, z
        if target:IsValid() then
            local radius = target:GetPhysicsRadius(0) + .2
            local angle = (inst.Transform:GetRotation() + 180) * DEGREES
            x, y, z = target.Transform:GetWorldPosition()
            x = x + math.cos(angle) * radius + GetRandomMinMax(-.2, .2)
            y = GetRandomMinMax(.1, .3)
        z = z - math.sin(angle) * radius + GetRandomMinMax(-.2, .2)
            blast:PushFlash(target)
        else
            x, y, z = inst.Transform:GetWorldPosition()
        end
        blast.Transform:SetPosition(x, y, z)

        ---@type ent|nil
        local wp = inst.owner
        if wp then
            if wp.lol_wp_s19_archangelstaff_overload_hittimes == db.SKILL_OVERLOAD.PER_HIT_TIMES then
                if inst.bounces ~= nil and inst.bounces > 1 and attacker ~= nil and attacker.components.combat ~= nil and attacker:IsValid() then
                    inst.bounces = inst.bounces - 1
                    inst.Physics:Stop()
                    inst:Hide()
                    inst:DoTaskInTime(.1, TryBounce, x, z, attacker, target)
                    -- 
                    wp.lol_wp_s19_archangelstaff_isbounce = true
                else
                    inst:Remove()
                    wp.lol_wp_s19_archangelstaff_isbounce = nil
                    wp.lol_wp_s19_archangelstaff_overload_hittimes = 0
                end
            else
                --
                inst:Remove()
            end

            if wp.prefab == 'lol_wp_s19_archangelstaff' then
                if wp.components.rechargeable and wp.components.rechargeable:IsCharged() then
                    wp.components.rechargeable:Discharge(db.SKILL_COUNT.CD)
                    if wp.components.count_from_tearsofgoddness then
                        local should_count = db.SKILL_COUNT.COUNT_PER_HIT
                        if target and target:HasTag('epic') then
                            should_count = db.SKILL_COUNT.COUNT_PER_HIT_BOSS
                        end
                        wp.components.count_from_tearsofgoddness:DoDelta(should_count)
                    end
                end
            end


        else
            inst:Remove()
        end

    end

    local function OnMiss(inst, attacker, target)
        if not inst.AnimState:IsCurrentAnimation("disappear") then
            PlayAnimAndRemove(inst, "disappear")
        end

        local wp = inst.owner
        if wp then
            wp.lol_wp_s19_archangelstaff_isbounce = false
        end
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddPhysics()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        RemovePhysicsColliders(inst)

        inst:AddTag("FX")
        inst:AddTag("NOCLICK")

        inst.AnimState:SetBank("brilliance_projectile_fx")
        inst.AnimState:SetBuild("brilliance_projectile_fx")
        inst.AnimState:PlayAnimation("idle_loop", true)
        inst.AnimState:SetSymbolMultColour("light_bar", 1, 1, 1, .5)
        inst.AnimState:SetSymbolBloom("light_bar")
        --inst.AnimState:SetSymbolBloom("pb_energy_loop")
        inst.AnimState:SetSymbolBloom("glow")
        --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetLightOverride(.5)

        --projectile (from projectile component) added to pristine state for optimization
        inst:AddTag("projectile")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("projectile")
        inst.components.projectile:SetSpeed(SPEED)
        inst.components.projectile:SetRange(25)
        inst.components.projectile:SetOnThrownFn(OnThrown)
        inst.components.projectile:SetOnHitFn(OnHit)
        inst.components.projectile:SetOnMissFn(OnMiss)

        inst.persists = false

        return inst
    end

    return Prefab("lol_wp_s19_archangelstaff_proj_bounce", fn, assets, prefabs)
end

return  makeWeapon(),makeWeapon_upgrade(),makeProjBounce()