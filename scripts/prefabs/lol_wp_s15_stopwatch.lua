
--[[ 
local db = TUNING.MOD_LOL_WP.STOPWATCH

local prefab_id = "lol_wp_s15_stopwatch"
local assets_id = "lol_wp_s15_stopwatch"

local assets =
{
    Asset( "ANIM", "anim/"..assets_id..".zip"),
    -- Asset( "ANIM", "anim/swap_"..assets_id..".zip"),
    Asset( "ATLAS", "images/inventoryimages/"..assets_id..".xml" ),
}

local prefabs =
{
    'lol_wp_s15_stopwatch_footprint',
}

-- ---onequipfn
-- ---@param inst ent
-- ---@param owner ent
-- ---@param from_ground boolean
-- local function onequip(inst, owner,from_ground)
--     owner.AnimState:OverrideSymbol("swap_object", "swap_"..assets_id, "swap_"..assets_id)
--     owner.AnimState:Show("ARM_carry")
--     owner.AnimState:Hide("ARM_normal")
-- end

-- ---onunequipfn
-- ---@param inst ent
-- ---@param owner ent
-- local function onunequip(inst, owner)
--     owner.AnimState:Hide("ARM_carry")
--     owner.AnimState:Show("ARM_normal")
-- end

-- local function onfinished(inst)
--     inst:Remove()
-- end

-- ---onattack
-- ---@param inst ent
-- ---@param attacker ent
-- ---@param target ent
-- local function onattack(inst,attacker,target)

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

    ---@type ent|nil
    local last_owner
    local flag_dropped_once_or_never_putininv = true
    inst:ListenForEvent('onputininventory',
    function ()
        if flag_dropped_once_or_never_putininv then
            last_owner = LOLWP_S:GetOwnerReal(inst)
            if last_owner and last_owner.components.lol_wp_player_footprint_traceback then
                last_owner.components.lol_wp_player_footprint_traceback:StartGenFootPrint()
            end
        end
    end)

    inst:ListenForEvent('ondropped',
    function ()
        flag_dropped_once_or_never_putininv = true
        if last_owner and last_owner.components.lol_wp_player_footprint_traceback then
            last_owner.components.lol_wp_player_footprint_traceback:StopGenFootPrint()
            last_owner = nil
        end
    end)

    inst:AddComponent('lol_wp_allow_footprint_traceback')

    -- inst:AddComponent("equippable")
    -- inst.components.equippable:SetOnEquip(onequip)
    -- inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.walkspeedmult = 1.2
    -- inst.components.equippable.dapperness = 2

    -- inst:AddComponent("weapon")
    -- inst.components.weapon:SetDamage(34)
    -- inst.components.weapon:SetOnAttack(onattack)

    -- inst:AddComponent("finiteuses")
    -- inst.components.finiteuses:SetMaxUses(500)
    -- inst.components.finiteuses:SetUses(500)
    -- inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetChargeTime(db.SKILL_TRACEBACK.CD)
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

local function makeFootPrint()
    local fp_id = 'lol_wp_s15_stopwatch_footprint'

    local _assets =
    {
        Asset( 'ANIM', 'anim/'..fp_id..'.zip'),

    }

    local function _fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        inst.entity:AddNetwork()
        inst.entity:AddSoundEmitter()
        -- MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(fp_id)
        inst.AnimState:SetBuild(fp_id)
        -- inst.AnimState:SetDeltaTimeMultiplier(0.2)
        -- inst.AnimState:PlayAnimation('gen',true)

        -- inst.AnimState:PlayAnimation('idle_pre',true)
        -- inst.AnimState:PushAnimation('idle_loop',true)

        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
        inst.AnimState:SetSortOrder(1)

        inst:AddTag("FX")
        inst:AddTag('NOCLICK')

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        return inst
    end
    return Prefab(fp_id, _fn, _assets)
end

return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs),makeFootPrint()

 ]]


local db = TUNING.MOD_LOL_WP.STOPWATCH

local prefab_id = "lol_wp_s15_stopwatch"

local assets =
{
    Asset( "ANIM", "anim/"..prefab_id..".zip"),
    -- Asset( "ANIM", "anim/swap_"..assets_id..".zip"),
    Asset( "ATLAS", "images/inventoryimages/"..prefab_id..".xml" ),
}

local prefabs =
{
    -- 'lol_wp_s15_stopwatch_footprint',
}

------------------------------------
local function OnDropped(inst)
	local rechargeable = inst.components.rechargeable
	if rechargeable ~= nil and not rechargeable:IsCharged() then
		-- inst.AnimState:PlayAnimation(rechargeable.chargetime > 4 and "cooldown_long" or "cooldown_short")
		-- local anim_length = inst.AnimState:GetCurrentAnimationLength()
		-- inst.AnimState:SetTime(anim_length * rechargeable:GetPercent())
		-- inst.AnimState:SetDeltaTimeMultiplier(anim_length / rechargeable.chargetime)
	end
end

local function OnCharged(inst)
    if inst:HasTag(prefab_id..'_iscd') then
        inst:RemoveTag(prefab_id..'_iscd')
    end
	if inst.components.pocketwatch ~= nil then
	    inst.components.pocketwatch.inactive = true
		-- inst.AnimState:PlayAnimation("idle")
	end
end

local function OnDischarged(inst)
    inst:AddTag(prefab_id..'_iscd')
	if inst.components.pocketwatch ~= nil then
		inst.components.pocketwatch.inactive = false
	end
	OnDropped(inst)
end

local function GetStatus(inst)
	return (inst.components.rechargeable ~= nil and not inst.components.rechargeable:IsCharged()) and "RECHARGING"
			or nil
end


local function warp_hidemarker(inst)
	if inst.marker_owner ~= nil and inst.marker_owner:IsValid() then
		inst.marker_owner:PushEvent("hide_warp_marker")
	end
	inst.marker_owner = nil
end

local function warp_showmarker(inst)
	warp_hidemarker(inst)

	inst.marker_owner = inst.components.inventoryitem:GetGrandOwner()
	if inst.marker_owner ~= nil then

		inst.marker_owner:PushEvent("show_warp_marker")
	end
end

local function common_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(prefab_id)
    inst.AnimState:SetBuild(prefab_id)
    inst.AnimState:PlayAnimation("idle")

    inst.scrapbook_deps = {}

    MakeInventoryFloatable(inst, "small", 0.05, {1.2, 0.75, 1.2})

	inst:AddTag("pocketwatch")
	inst:AddTag("cattoy")

	if true then
		inst:AddTag("pocketwatch_castfrominventory")
	end

    for _, tag in ipairs({"pocketwatch_warp", "pocketwatch_warp_casting"}) do
        inst:AddTag(tag)
    end

    inst:AddTag('pocketwatch_lol_wp')

	inst.entity:SetPristine()

    inst.GetActionVerb_CAST_POCKETWATCH = "WARP"

    if not TheWorld.ismastersim then
        return inst
    end

    inst.castfxcolour = {255 / 255, 241 / 255, 236 / 255}

    inst:AddComponent("lootdropper")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = prefab_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..prefab_id..".xml"
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

	inst:AddComponent("rechargeable")
	inst.components.rechargeable:SetOnDischargedFn(OnDischarged)
	inst.components.rechargeable:SetOnChargedFn(OnCharged)


    -- ---@type ent|nil
    -- local last_owner
    -- local flag_dropped_once_or_never_putininv = true
    -- inst:ListenForEvent('onputininventory',
    -- function ()
    --     if flag_dropped_once_or_never_putininv then
    --         last_owner = LOLWP_S:GetOwnerReal(inst)
    --         if last_owner and last_owner.components.lol_wp_player_footprint_traceback then
    --             last_owner.components.lol_wp_player_footprint_traceback:StartGenFootPrint()
    --         end
    --     end
    -- end)

    -- inst:ListenForEvent('ondropped',
    -- function ()
    --     flag_dropped_once_or_never_putininv = true
    --     if last_owner and last_owner.components.lol_wp_player_footprint_traceback then
    --         last_owner.components.lol_wp_player_footprint_traceback:StopGenFootPrint()
    --         last_owner = nil
    --     end
    -- end)

    -- inst:AddComponent('lol_wp_allow_footprint_traceback')


	inst:AddComponent("pocketwatch")
    ---comment
    ---@param _inst any
    ---@param doer ent
	inst.components.pocketwatch.DoCastSpell = function(_inst, doer)
        if doer and doer.components.positionalwarp then
            local tx, ty, tz = doer.components.positionalwarp:GetHistoryPosition(false)
            if tx ~= nil then
                if doer:HasTag('pocketwatchcaster') then
                    inst.components.rechargeable:Discharge(db.SKILL_JIKU.CD)
                else
                    inst.components.rechargeable:Discharge(db.SKILL_TRACEBACK.CD)
                end
                doer.sg.statemem.warpback = {dest_x = tx, dest_y = ty, dest_z = tz}


                local caster = doer
                local obj = inst
                if obj and caster and caster:HasTag('pocketwatchcaster') then
                    caster:DoTaskInTime(25*FRAMES,function ()
                        local x,_,z = caster:GetPosition():Get()
                        SpawnPrefab('moonpulse_fx').Transform:SetPosition(x,0,z)
                        SpawnPrefab('moonstorm_glass_ground_fx').Transform:SetPosition(x,0,z)
                        local ents = TheSim:FindEntities(x, 0, z, TUNING.MOD_LOL_WP.STOPWATCH.SKILL_JIKU.RADIUS, nil, {"player","companion","FX","wall","glommer","abigail"})
                        for _,v in ipairs(ents) do
                            if LOLWP_S:checkAlive(v) and v.components.combat then

                                v.components.combat:GetAttacked(nil,nil,nil,nil,{planar = TUNING.MOD_LOL_WP.STOPWATCH.SKILL_JIKU.PLANAR_DMG})
                                ---@type event_data_attacked
                                local event_data_attacked = { attacker = caster, damage = 0, damageresolved = TUNING.MOD_LOL_WP.STOPWATCH.SKILL_JIKU.PLANAR_DMG}
                                v:PushEvent('attacked',event_data_attacked)
                            end
                        end
                        local health = caster.components.health
                        if health ~= nil and not health:IsDead() and caster.components.oldager then
                            caster.components.oldager:StopDamageOverTime()
                            health:DoDelta(TUNING.POCKETWATCH_HEAL_HEALING, true, 'pocketwatch_heal')

                            local fx = SpawnPrefab((caster.components.rider ~= nil and caster.components.rider:IsRiding()) and "pocketwatch_heal_fx_mount" or "pocketwatch_heal_fx")
                            fx.entity:SetParent(caster.entity)
                        end
                        SpawnPrefab('oldager_become_younger_back_fx_mount').Transform:SetPosition(x,0,z)
                    end)

                end

                return true
            end

            return false, "WARP_NO_POINTS_LEFT"
        end
        return false
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

    MakeHauntableLaunch(inst)

	inst:ListenForEvent("onputininventory", warp_showmarker)
	inst:ListenForEvent("onownerputininventory", warp_showmarker)
	inst:ListenForEvent("ondropped", warp_hidemarker)
	inst:ListenForEvent("onownerdropped", warp_hidemarker)
	inst:ListenForEvent("onremove", warp_hidemarker)



    return inst
end
------------------------------------


local function makeFootPrint()
    local fp_id = 'lol_wp_s15_stopwatch_footprint'

    local _assets =
    {
        Asset( 'ANIM', 'anim/'..fp_id..'.zip'),

    }

    local function _fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        inst.entity:AddNetwork()
        inst.entity:AddSoundEmitter()
        -- MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(fp_id)
        inst.AnimState:SetBuild(fp_id)
        -- inst.AnimState:SetDeltaTimeMultiplier(0.2)
        -- inst.AnimState:PlayAnimation('gen',true)

        -- inst.AnimState:PlayAnimation('idle_pre',true)
        -- inst.AnimState:PushAnimation('idle_loop',true)

        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
        inst.AnimState:SetSortOrder(1)

        inst:AddTag("FX")
        inst:AddTag('NOCLICK')

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        return inst
    end
    return Prefab(fp_id, _fn, _assets)
end

return Prefab(prefab_id, common_fn, assets, prefabs),makeFootPrint()
