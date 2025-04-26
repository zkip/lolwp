local db = TUNING.MOD_LOL_WP.ECLIPSE

local prefab_id = "lol_wp_s12_eclipse"
local assets_id = "lol_wp_s12_eclipse"

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
    local skin_build = inst:GetSkinBuild()
	if skin_build ~= nil then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideItemSkinSymbol("swap_object", "swap_"..skin_build, "swap_"..skin_build, inst.GUID, "swap_"..assets_id)
	else
		owner.AnimState:OverrideSymbol("swap_object", "swap_"..assets_id, "swap_"..assets_id)
	end

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    inst.Light:Enable(true)
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

    inst.Light:Enable(false)
end

local function onfinished(inst)
    inst:Remove()
end

---onattack
---@param inst ent
---@param attacker ent
---@param target ent
local function onattack(inst,attacker,target)
    if target ~= nil and target:IsValid() then
		SpawnPrefab("hitsparks_fx"):Setup(attacker, target)
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

    inst:AddTag('lunar_aligned')

    -- inst.MiniMapEntity:SetIcon(prefab_id..".tex")

    -- inst:AddComponent("aoetargeting")
    -- inst.components.aoetargeting:SetAllowRiding(false)
    -- inst.components.aoetargeting.reticule.reticuleprefab = "reticuleline"
    -- inst.components.aoetargeting.reticule.pingprefab = "reticulelineping"
    -- inst.components.aoetargeting.reticule.targetfn = Lightning_ReticuleTargetFn
    -- inst.components.aoetargeting.reticule.mousetargetfn = Lightning_ReticuleMouseTargetFn
    -- inst.components.aoetargeting.reticule.updatepositionfn = Lightning_ReticuleUpdatePositionFn
    -- inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    -- inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    -- inst.components.aoetargeting.reticule.ease = true
    -- inst.components.aoetargeting.reticule.mouseenabled = true

    -- local old_StartTargeting = inst.components.aoetargeting.StartTargeting
    -- function inst.components.aoetargeting:StartTargeting(...)
    --     inst:AddTag('lol_wp_s12_malignance_aoetargeting')
    --     return old_StartTargeting(self, ...)
    -- end

    -- local old_StopTargeting = inst.components.aoetargeting.StopTargeting
    -- function inst.components.aoetargeting:StopTargeting(...)
    --     inst:RemoveTag('lol_wp_s12_malignance_aoetargeting')
    --     return old_StopTargeting(self, ...)
    -- end

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
    inst.components.equippable.walkspeedmult = db.WALKSPEEDMULT
    inst.components.equippable.dapperness = db.DARPPERNESS/54

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(db.DMG)
    inst.components.weapon:SetRange(db.RANGE,db.RANGE)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent('planardamage')
    inst.components.planardamage:SetBaseDamage(db.PLANAR_DMG)

    inst:AddComponent('lol_wp_s12_eclipse_leap_laser')

    -- inst:AddComponent("finiteuses")
    -- inst.components.finiteuses:SetMaxUses(500)
    -- inst.components.finiteuses:SetUses(500)
    -- inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetChargeTime(db.SKILL_NEWMOON_STRIKE.CD)
    inst.components.rechargeable:SetOnDischargedFn(function()
        inst:AddTag(prefab_id..'_iscd') 
        -- inst.components.aoetargeting:SetEnabled(false)
    end)
    inst.components.rechargeable:SetOnChargedFn(function()
        if inst:HasTag(prefab_id..'_iscd') then
            inst:RemoveTag(prefab_id..'_iscd')
        end
        -- inst.components.aoetargeting:SetEnabled(true)
    end)

    inst:AddComponent('lol_wp_cd_itemtile')
    inst.components.lol_wp_cd_itemtile:Init(db.SKILL_EVERMOON.CD)

    -- local planardamage = inst:AddComponent("planardamage")
    -- planardamage:SetBaseDamage(data_prefab.planardamage)

    -- inst.OnSave = onsave
    -- inst.OnPreLoad = onpreload

    return inst
end

return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs)