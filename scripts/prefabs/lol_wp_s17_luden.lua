local db = TUNING.MOD_LOL_WP.LUDEN

local prefab_id = "lol_wp_s17_luden"
local assets_id = "lol_wp_s17_luden"
--[[ 
---comment
---@param player ent
---@param wp ent
---@param shooter ent
---@param victim ent
---@param planar_dmg number
---@param should_divine boolean
local function LaunchProj(player,wp, shooter, victim,planar_dmg,should_divine)
    local proj = SpawnPrefab('lol_wp_s17_luden_projectile_fx')
    if proj ~= nil then
        if proj.components.projectile ~= nil then
            proj.Transform:SetPosition(shooter.Transform:GetWorldPosition())
            proj.components.projectile:SetOnHitFn(function(inst, _attacker, _target)

                if victim and should_divine then
                    -- if wp.components.rechargeable then
                    --     wp.components.rechargeable:Discharge(db.SKILL_ECHO.CD)
                    -- end
                    local new_planar_dmg = db.SKILL_ECHO.PLANAR_DMG
                    local _x,_,_z = victim:GetPosition():Get()
                    local ents = LOLWP_C:findClosestMobToPoint(_x,0,_z,db.RANGE+3,db.SKILL_ECHO.MISSILE+20)
                    local times = db.SKILL_ECHO.MISSILE
                    for _,v in ipairs(ents) do
                        if times > 0 and v ~= shooter and v ~= victim and LOLWP_S:checkAlive(v) and v.components.combat and not v.components.combat:IsAlly(player) then
                            times = times - 1
                            LaunchProj(player,wp, victim, v, new_planar_dmg, false)
                        end
                    end
                end

                local new_fx = SpawnPrefab('fireball_hit_fx')
                new_fx.AnimState:SetAddColour(184/255,41/255,251/255,1)
                local blast = SpawnPrefab("lol_wp_s17_luden_projectile_blast_fx")
                local x, y, z
                if victim:IsValid() then
                    local radius = victim:GetPhysicsRadius(0) + .2
                    local angle = (inst.Transform:GetRotation() + 180) * DEGREES
                    x, y, z = victim.Transform:GetWorldPosition()
                    x = x + math.cos(angle) * radius + GetRandomMinMax(-.2, .2)
                    y = GetRandomMinMax(.1, .3)
                    z = z - math.sin(angle) * radius + GetRandomMinMax(-.2, .2)
                    blast:PushFlash(victim)
                else
                    x, y, z = inst.Transform:GetWorldPosition()
                end
                blast.Transform:SetPosition(x, y, z)
                new_fx.Transform:SetPosition(x, y, z)

                inst:Remove()

                if victim.components.combat and LOLWP_S:checkAlive(victim) then
                    victim.components.combat:GetAttacked(player,0,wp,nil,{planar = planar_dmg})
                end
            end)
            proj.components.projectile:Throw(wp, victim, shooter)
        end
    end
end
 ]]
local function makeLuden()

    local assets =
    {
        Asset( "ANIM", "anim/"..assets_id..".zip"),
        Asset( "ANIM", "anim/swap_"..assets_id..".zip"),
        Asset( "ATLAS", "images/inventoryimages/"..assets_id..".xml" ),

        Asset( "ANIM", "anim/"..assets_id.."_skin_elder_wand.zip"),
        Asset( "ANIM", "anim/swap_"..assets_id.."_skin_elder_wand.zip"),
        Asset( "ATLAS", "images/inventoryimages/"..assets_id.."_skin_elder_wand.xml" ),

    }

    local prefabs =
    {
        'lol_wp_s17_luden_projectile_fx',
        'lol_wp_s17_luden_projectile_blast_fx',
    }

    local TRAIL_FLAGS = { "shadowtrail" }
    local function do_trail(inst)
        if not inst.entity:IsVisible() then
            return
        end

        local x, y, z = inst.Transform:GetWorldPosition()
        if inst.sg ~= nil and inst.sg:HasStateTag("moving") then
            local theta = -inst.Transform:GetRotation() * DEGREES
            local speed = inst.components.locomotor:GetRunSpeed() * .1
            x = x + speed * math.cos(theta)
            z = z + speed * math.sin(theta)
        end
        local mounted = inst.components.rider ~= nil and inst.components.rider:IsRiding()
        local map = TheWorld.Map
        local offset = FindValidPositionByFan(
            math.random() * 2 * PI,
            (mounted and 1 or .5) + math.random() * .5,
            4,
            function(offset)
                local pt = Vector3(x + offset.x, 0, z + offset.z)
                return map:IsPassableAtPoint(pt:Get())
                    and not map:IsPointNearHole(pt)
                    and #TheSim:FindEntities(pt.x, 0, pt.z, .7, TRAIL_FLAGS) <= 0
            end
        )

        if offset ~= nil then
            SpawnPrefab("cane_ancient_fx").Transform:SetPosition(x + offset.x, 0, z + offset.z)
        end
    end

    ---onequipfn
    ---@param inst ent
    ---@param owner ent
    ---@param from_ground boolean
    local function onequip(inst, owner,from_ground)
        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_object", "swap_"..skin_build, "swap_"..skin_build, inst.GUID, "swap_"..assets_id)
        else
            owner.AnimState:OverrideSymbol("swap_object", "swap_"..assets_id, "swap_"..assets_id)
        end
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")

        if skin_build ~= nil then
            if skin_build == 'lol_wp_s17_luden_skin_elder_wand' then
                if owner.taskperiod_lol_wp_s17_luden_fx == nil then
                    ---@diagnostic disable-next-line: inject-field
                    owner.taskperiod_lol_wp_s17_luden_fx = owner:DoPeriodicTask(6 * FRAMES, do_trail, 2 * FRAMES)
                end
            end
        end
    end

    ---onunequipfn
    ---@param inst ent
    ---@param owner ent
    local function onunequip(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")

        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("unequipskinneditem", inst:GetSkinName())
        end

        if owner.taskperiod_lol_wp_s17_luden_fx then
            owner.taskperiod_lol_wp_s17_luden_fx:Cancel()
            ---@diagnostic disable-next-line: inject-field
            owner.taskperiod_lol_wp_s17_luden_fx = nil
        end
    end

    local function onfinished(inst)
        LOLWP_S:unequipItem(inst)
        inst:AddTag(prefab_id..'_nofiniteuses')
    end

    ---onattack
    ---@param inst ent
    ---@param attacker ent
    ---@param target ent
    local function OnAttack(inst, attacker, target)
        -- if inst.skin_sound then
        -- 	attacker.SoundEmitter:PlaySound(inst.skin_sound)
        -- end
        -- if target == nil then
        --     return
        -- end

        -- if not target:IsValid() then
        --     --target killed or removed in combat damage phase
        --     return
        -- end

        -- if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
        --     target.components.sleeper:WakeUp()
        -- end
        -- if target.components.combat ~= nil then
        --     target.components.combat:SuggestTarget(attacker)
        -- end
        -- target:PushEvent("attacked", { attacker = attacker, damage = 0, weapon = inst })

        -- inst.components.weapon:LaunchProjectile(attacker,target)
        -- if target and target:IsValid() and LOLWP_S:checkAlive(target) and attacker and attacker:IsValid() and inst.components.rechargeable and inst.components.rechargeable:IsCharged() and inst.components.weapon then
        --     inst.components.rechargeable:Discharge(db.SKILL_ECHO.CD)
            -- local x,_,z = attacker:GetPosition():Get()
            -- local ents = LOLWP_C:findClosestMobToPoint(x,0,z,db.RANGE+3,db.SKILL_ECHO.MISSILE)
            -- for i,v in ipairs(ents) do
            --     local planar_dmg = i == 1 and db.PLANAR_DMG or db.SKILL_ECHO.PLANAR_DMG
            --     if v.components.combat and LOLWP_S:checkAlive(v) then
            --         LaunchProj(inst,attacker,v,planar_dmg)
            --     end
            -- end

            -- local planar_dmg = db.PLANAR_DMG
            -- LaunchProj(attacker,inst,attacker,target,planar_dmg,true)
        -- end

        -- if inst.components.rechargeable then
        --     if inst.components.rechargeable:IsCharged() then
        --         local planar_dmg = db.PLANAR_DMG
        --         LaunchProj(attacker,inst,attacker,target,planar_dmg,true)

        --         inst.components.rechargeable:Discharge(db.SKILL_ECHO.CD)
        --     else
        --         local planar_dmg = db.PLANAR_DMG
        --         LaunchProj(attacker,inst,attacker,target,planar_dmg,false)
        --     end
        -- end
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
        -- inst:AddTag("rangedweapon")

        inst:AddTag("shadow_item")

        inst:AddTag("blink")

        --shadowlevel (from shadowlevel component) added to pristine state for optimization
        inst:AddTag("shadowlevel")

        inst:AddTag('rangedweapon')

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
        inst.components.equippable.walkspeedmult = db.WALKSPEEDMULT
        inst.components.equippable.dapperness = db.DARPPERNESS/54

        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(0)
        inst.components.weapon:SetRange(db.RANGE, db.RANGE + 2)
        -- inst.components.weapon:SetOnAttack(OnAttack)
        inst.components.weapon:SetProjectile("lol_wp_s17_luden_projectile_fx")
        -- inst.components.weapon:SetOnProjectileLaunch(function (wp, attacker, target)
        --     -- wp._lol_wp_s17_luden_before_first_hit = true
        --     if wp.components.rechargeable then
        --         wp.components.rechargeable:Discharge(db.SKILL_ECHO.CD)
        --     end
        -- end)
        local old_OnAttack = inst.components.weapon.OnAttack
        function inst.components.weapon:OnAttack(attacker, target, projectile, ...)
            if self.inst.prefab == 'lol_wp_s17_luden' then
                if self.onattack ~= nil then
                    self.onattack(self.inst, attacker, target)
                end
            else
                return old_OnAttack(attacker, target, projectile, ...)
            end
        end

        inst:AddComponent("planardamage")
        inst.components.planardamage:SetBaseDamage(db.PLANAR_DMG)

        -- local setbonus = inst:AddComponent("setbonus")
        -- setbonus:SetSetName(EQUIPMENTSETNAMES.LUNARPLANT)

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(db.FINITEUSES)
        inst.components.finiteuses:SetUses(db.FINITEUSES)
        inst.components.finiteuses:SetOnFinished(onfinished)

        inst:AddComponent("shadowlevel")
        inst.components.shadowlevel:SetDefaultLevel(db.SHADOW_LEVEL)

        inst:AddComponent("damagetypebonus")
        inst.components.damagetypebonus:AddBonus("lunar_aligned", inst, db.DMGMULT_TO_PLANAR)

        inst:AddComponent('lol_wp_s17_luden_tele')

        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetChargeTime(db.SKILL_ECHO.CD)
        inst.components.rechargeable:SetOnDischargedFn(function()
            inst:AddTag(prefab_id..'_iscd')
        end)
        inst.components.rechargeable:SetOnChargedFn(function()
            if inst:HasTag(prefab_id..'_iscd') then
                inst:RemoveTag(prefab_id..'_iscd')
            end
        end)

        -- local planardamage = inst:AddComponent("planardamage")
        -- planardamage:SetBaseDamage(data_prefab.planardamage)

        -- inst.OnSave = onsave
        -- inst.OnPreLoad = onpreload

        return inst
    end

    return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs)
end

local function makeProj()
    local _assets =
    {
        Asset("ANIM", "anim/brilliance_projectile_fx.zip"),
        Asset("ANIM", "anim/fireball_2_fx.zip"),
        Asset("ANIM", "anim/deer_fire_charge.zip"),
    }

    local _prefabs =
    {
        "lol_wp_s17_luden_projectile_blast_fx",
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

    -- local function OnThrown(inst, owner, target, attacker)
    --     inst.owner = owner
    --     if inst.bounces == nil then
    --         local hat = attacker ~= nil and attacker.components.inventory ~= nil and attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
    --         inst.bounces = hat ~= nil and hat.prefab == "lunarplanthat" and TUNING.STAFF_LUNARPLANT_SETBONUS_BOUNCES or TUNING.STAFF_LUNARPLANT_BOUNCES
    --         inst.initial_hostile = target ~= nil and target:IsValid() and target:HasTag("hostile")
    --     end
    --     if owner and owner.prefab == 'lol_wp_s17_luden' and owner.components.finiteuses then
    --         owner.components.finiteuses:Use(1)
    --     end
    -- end

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

    local function launchWhenHit(player,wp,shooter,victim)
        local proj = SpawnPrefab('lol_wp_s17_luden_projectile_fx_divine')
        if proj ~= nil then
            if proj.components.projectile ~= nil then
                proj.Transform:SetPosition(shooter.Transform:GetWorldPosition())
                -- proj.components.projectile:SetOnHitFn(function(inst, _attacker, _victim)
                --     local new_fx = SpawnPrefab('fireball_hit_fx')
                --     local blast = SpawnPrefab("lol_wp_s17_luden_projectile_blast_fx")
                --     local x, y, z
                --     if victim:IsValid() then
                --         local radius = victim:GetPhysicsRadius(0) + .2
                --         local angle = (inst.Transform:GetRotation() + 180) * DEGREES
                --         x, y, z = victim.Transform:GetWorldPosition()
                --         x = x + math.cos(angle) * radius + GetRandomMinMax(-.2, .2)
                --         y = GetRandomMinMax(.1, .3)
                --         z = z - math.sin(angle) * radius + GetRandomMinMax(-.2, .2)
                --         blast:PushFlash(victim)
                --     else
                --         x, y, z = inst.Transform:GetWorldPosition()
                --     end
                --     blast.Transform:SetPosition(x, y, z)
                --     new_fx.Transform:SetPosition(x, y, z)

                --     -- if inst.bounces ~= nil and inst.bounces > 1 and attacker ~= nil and attacker.components.combat ~= nil and attacker:IsValid() then
                --     --     inst.bounces = inst.bounces - 1
                --     --     inst.Physics:Stop()
                --     --     inst:Hide()
                --     --     -- inst:DoTaskInTime(.1, TryBounce, x, z, attacker, target)
                --     -- else
                --         inst:Remove()
                -- end)
                -- victim._riftmaker_dont_drain = true
                proj.components.projectile:Throw(wp, victim, shooter)
                -- victim._riftmaker_dont_drain = nil
            end
        end
    end

    local function OnHit(inst, attacker, target)
        -- if target then
        --     target._riftmaker_dont_drain = nil
        -- end
        ---@type ent
        local wp = inst.owner
        if wp and wp.prefab and wp.prefab == 'lol_wp_s17_luden' and wp.components.rechargeable then
            if wp.components.rechargeable:IsCharged() then
                wp.components.rechargeable:Discharge(db.SKILL_ECHO.CD)

                if target and LOLWP_S:checkAlive(target) then
                    -- target._riftmaker_dont_drain = true
                    target.components.combat:GetAttacked(attacker,0,inst.owner,nil,{ planar = db.SKILL_ECHO.PLANAR_DMG})
                    -- target._riftmaker_dont_drain = nil
                end

                local new_planar_dmg = db.SKILL_ECHO.PLANAR_DMG

                local _x,_,_z = target:GetPosition():Get()
                local ents = LOLWP_C:findClosestMobToPoint(_x,0,_z,db.RANGE+3,db.SKILL_ECHO.MISSILE+20)
                local times = db.SKILL_ECHO.MISSILE
                for _,v in ipairs(ents) do
                    if times > 0 and v ~= target and v ~= attacker and LOLWP_S:checkAlive(v) and v.components.combat and not v.components.combat:IsAlly(attacker) then
                        times = times - 1
                        -- LaunchProj(attacker,wp, target, v, new_planar_dmg, false)
                        launchWhenHit(attacker,wp, target, v)
                    end
                end
            else

            end
        end

        local new_fx = SpawnPrefab('fireball_hit_fx')
        -- if wp and wp.prefab and wp.prefab == 'lol_wp_s17_luden' then
        --     local skin_build = wp:GetSkinBuild()
        --     if skin_build then
        --         if skin_build == '_skin_elder_wand' then
                    
        --         end
        --     end
        -- end
        new_fx.AnimState:SetAddColour(184/255,41/255,251/255,1)
        local blast = SpawnPrefab("lol_wp_s17_luden_projectile_blast_fx")
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
        new_fx.Transform:SetPosition(x, y, z)

        inst:Remove()


    end

    local function OnMiss(inst, attacker, target)
        if not inst.AnimState:IsCurrentAnimation("disappear") then
            PlayAnimAndRemove(inst, "disappear")
        end
    end

    local function CreateTail(bank, build, lightoverride, addcolour, multcolour,owner_skin)
        local inst = CreateEntity()

        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        --[[Non-networked entity]]
        inst.entity:SetCanSleep(false)
        inst.persists = false

        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        MakeInventoryPhysics(inst)
        inst.Physics:ClearCollisionMask()

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("disappear")
        if owner_skin then
            if owner_skin == 'lol_wp_s17_luden_skin_elder_wand' then
                inst.AnimState:SetAddColour(20/255,250/255,112/255,1)
                inst.AnimState:SetMultColour(20/255,250/255,112/255,1)
            end
        else
            inst.AnimState:SetAddColour(184/255,41/255,251/255,1)
            inst.AnimState:SetMultColour(147/255,82/255,203/255,1)
        end
        -- if addcolour ~= nil then
            
        -- end
        -- if multcolour ~= nil then
            
        -- end
        if lightoverride > 0 then
            -- inst.AnimState:SetLightOverride(lightoverride)
        end
        inst.AnimState:SetFinalOffset(3)

        inst:ListenForEvent("animover", inst.Remove)

        return inst
    end

    local function OnUpdateProjectileTail(inst, bank, build, speed, lightoverride, addcolour, multcolour, hitfx, tails)
        local x, y, z = inst.Transform:GetWorldPosition()
        for tail, _ in pairs(tails) do
            tail:ForceFacePoint(x, y, z)
        end
        if inst.entity:IsVisible() then
            local skin_build = inst.owner and inst.owner:GetSkinBuild()
            local tail = CreateTail(bank, build, lightoverride, addcolour, multcolour,skin_build)
            local rot = inst.Transform:GetRotation()
            tail.Transform:SetRotation(rot)
            rot = rot * DEGREES
            local offsangle = math.random() * TWOPI
            local offsradius = math.random() * .2 + .2
            local hoffset = math.cos(offsangle) * offsradius
            local voffset = math.sin(offsangle) * offsradius
            tail.Transform:SetPosition(x + math.sin(rot) * hoffset, y + voffset, z + math.cos(rot) * hoffset)
            tail.Physics:SetMotorVel(speed * (.2 + math.random() * .3), 0, 0)
            tails[tail] = true
            inst:ListenForEvent("onremove", function(tail) tails[tail] = nil end, tail)
            tail:ListenForEvent("onremove", function(inst)
                tail.Transform:SetRotation(tail.Transform:GetRotation() + math.random() * 30 - 15)
            end, inst)
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

        -- inst.AnimState:SetBank("brilliance_projectile_fx")
        -- inst.AnimState:SetBuild("brilliance_projectile_fx")
        -- inst.AnimState:PlayAnimation("idle_loop", true)
        inst.AnimState:SetBank('fireball_fx')
        inst.AnimState:SetBuild('fireball_2_fx')
        inst.AnimState:PlayAnimation("idle_loop", true)

        -- inst.AnimState:SetSymbolMultColour("light_bar", 1, 1, 1, .5)
        -- inst.AnimState:SetSymbolBloom("light_bar")
        -- --inst.AnimState:SetSymbolBloom("pb_energy_loop")
        -- inst.AnimState:SetSymbolBloom("glow")
        -- --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        -- inst.AnimState:SetLightOverride(.5)

        --projectile (from projectile component) added to pristine state for optimization
        inst:AddTag("projectile")

        inst.AnimState:SetAddColour(184/255,41/255,251/255,1)
        inst.AnimState:SetMultColour(184/255,41/255,251/255,1)

        if not TheNet:IsDedicated() then
            inst:DoPeriodicTask(0, OnUpdateProjectileTail, nil, 'fireball_fx', 'fireball_2_fx', 15, 1, nil, nil, 'fireball_hit_fx', {})
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("projectile")
        inst.components.projectile:SetSpeed(26)
        inst.components.projectile:SetRange(25)
        inst.components.projectile:SetOnThrownFn(function (inst, owner, target, attacker)
            inst.owner = owner
            if inst.bounces == nil then
                local hat = attacker ~= nil and attacker.components.inventory ~= nil and attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
                inst.bounces = hat ~= nil and hat.prefab == "lunarplanthat" and TUNING.STAFF_LUNARPLANT_SETBONUS_BOUNCES or TUNING.STAFF_LUNARPLANT_BOUNCES
                inst.initial_hostile = target ~= nil and target:IsValid() and target:HasTag("hostile")
            end
            if owner and owner.prefab == 'lol_wp_s17_luden' then
                if owner.components.finiteuses then
                    owner.components.finiteuses:Use(1)
                end
                local skin_build = owner:GetSkinBuild()
                if skin_build ~= nil then
                    if skin_build == 'lol_wp_s17_luden_skin_elder_wand' then
                        inst.AnimState:SetAddColour(20/255,250/255,112/255,1)
                        inst.AnimState:SetMultColour(20/255,250/255,112/255,1)
                    end
                end
            end
        end)
        -- inst.components.projectile:SetOnPreHitFn(function (inst, attacker, target)
        --     if target then
        --         target._riftmaker_dont_drain = true
        --     end
        -- end)
        inst.components.projectile:SetOnHitFn(OnHit)
        inst.components.projectile:SetOnMissFn(OnMiss)

        inst.persists = false

        return inst
    end

    local function fn2()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddPhysics()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        RemovePhysicsColliders(inst)

        inst:AddTag("FX")
        inst:AddTag("NOCLICK")

        -- inst.AnimState:SetBank("brilliance_projectile_fx")
        -- inst.AnimState:SetBuild("brilliance_projectile_fx")
        -- inst.AnimState:PlayAnimation("idle_loop", true)
        inst.AnimState:SetBank('fireball_fx')
        inst.AnimState:SetBuild('fireball_2_fx')
        inst.AnimState:PlayAnimation("idle_loop", true)

        -- inst.AnimState:SetSymbolMultColour("light_bar", 1, 1, 1, .5)
        -- inst.AnimState:SetSymbolBloom("light_bar")
        -- --inst.AnimState:SetSymbolBloom("pb_energy_loop")
        -- inst.AnimState:SetSymbolBloom("glow")
        -- --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        -- inst.AnimState:SetLightOverride(.5)

        --projectile (from projectile component) added to pristine state for optimization
        inst:AddTag("projectile")

        inst.AnimState:SetAddColour(184/255,41/255,251/255,1)
        inst.AnimState:SetMultColour(184/255,41/255,251/255,1)

        if not TheNet:IsDedicated() then
            inst:DoPeriodicTask(0, OnUpdateProjectileTail, nil, 'fireball_fx', 'fireball_2_fx', 15, 1, nil, nil, 'fireball_hit_fx', {})
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("projectile")
        inst.components.projectile:SetSpeed(26)
        inst.components.projectile:SetRange(25)
        inst.components.projectile:SetOnThrownFn(function(inst, owner, target, attacker)
            inst.owner = owner
            if inst.bounces == nil then
                local hat = attacker ~= nil and attacker.components.inventory ~= nil and attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
                inst.bounces = hat ~= nil and hat.prefab == "lunarplanthat" and TUNING.STAFF_LUNARPLANT_SETBONUS_BOUNCES or TUNING.STAFF_LUNARPLANT_BOUNCES
                inst.initial_hostile = target ~= nil and target:IsValid() and target:HasTag("hostile")
            end
            if owner then
                local skin_build = owner:GetSkinBuild()
                if skin_build ~= nil then
                    if skin_build == 'lol_wp_s17_luden_skin_elder_wand' then
                        inst.AnimState:SetAddColour(20/255,250/255,112/255,1)
                        inst.AnimState:SetMultColour(20/255,250/255,112/255,1)
                    end
                end
            end

        end)
        inst.components.projectile:SetOnPreHitFn(function (inst, attacker, target)
            if target then
                target._riftmaker_dont_drain = true
            end
        end)
        inst.components.projectile:SetOnHitFn(function (inst, attacker, target)
            if target then
                target._riftmaker_dont_drain = nil
            end
            local new_fx = SpawnPrefab('fireball_hit_fx')
            new_fx.AnimState:SetAddColour(184/255,41/255,251/255,1)
            local blast = SpawnPrefab("lol_wp_s17_luden_projectile_blast_fx")
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
            new_fx.Transform:SetPosition(x, y, z)

            inst:Remove()


        end)
        inst.components.projectile:SetOnMissFn(OnMiss)
        local old_Throw = inst.components.projectile.Throw
        function inst.components.projectile:Throw(owner, target, attacker,...)
            if target then
                target._riftmaker_dont_drain = true
            end
            local res = old_Throw ~= nil and {old_Throw(self,owner, target, attacker,...)} or {}
            if target then
                target._riftmaker_dont_drain = nil
            end
            return unpack(res)
        end

        inst.persists = false

        return inst
    end

    --------------------------------------------------------------------------

    local function PushColour(inst, r, g, b)
        if inst.target:IsValid() then
            if inst.target.components.colouradder == nil then
                inst.target:AddComponent("colouradder")
            end
            inst.target.components.colouradder:PushColour(inst, r, g, b, 0)
        end
    end

    local function PopColour(inst)
        inst.OnRemoveEntity = nil
        if inst.target.components.colouradder ~= nil and inst.target:IsValid() then
            inst.target.components.colouradder:PopColour(inst)
        end
    end

    local function PushFlash(inst, target)
        -- inst.target = target
        -- PushColour(inst, .1, .1, .1)
        -- inst:DoTaskInTime(4 * FRAMES, PushColour, .075, .075, .075)
        -- inst:DoTaskInTime(7 * FRAMES, PushColour, .05, .05, .05)
        -- inst:DoTaskInTime(9 * FRAMES, PushColour, .025, .025, .025)
        -- inst:DoTaskInTime(10 * FRAMES, PopColour)
        -- inst.OnRemoveEntity = PopColour
    end

    local function blastfn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst:AddTag("FX")
        inst:AddTag("NOCLICK")

        inst.AnimState:SetBank("brilliance_projectile_fx")
        inst.AnimState:SetBuild("brilliance_projectile_fx")
        inst.AnimState:PlayAnimation("blast1")
        inst.AnimState:SetSymbolMultColour("light_bar", 1, 1, 1, .5)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetLightOverride(.5)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        if math.random() < 0.5 then
            inst.AnimState:PlayAnimation("blast2")
        end

        inst:ListenForEvent("animover", inst.Remove)
        inst.persists = false

        inst.PushFlash = PushFlash

        return inst
    end

    --------------------------------------------------------------------------

    return Prefab("lol_wp_s17_luden_projectile_fx", fn, _assets, _prefabs),
    Prefab("lol_wp_s17_luden_projectile_fx_divine", fn2, _assets, _prefabs),
        Prefab("lol_wp_s17_luden_projectile_blast_fx", blastfn, _assets)

end


return makeLuden(),makeProj()