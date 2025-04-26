local prefab_id = "lol_wp_s11_amplifyingtome"
local assets_id = "lol_wp_s11_amplifyingtome"

local db = TUNING.MOD_LOL_WP.AMPLIFYINGTOME

local assets =
{
    Asset( "ANIM", "anim/"..assets_id..".zip"),
    -- Asset( "ANIM", "anim/swap_"..assets_id..".zip"),
    Asset( "ATLAS", "images/inventoryimages/"..assets_id..".xml" ),
}

local prefabs =
{
    prefab_id,
}
---comment
---@param inst ent
---@param owner ent
local function onequip(inst, owner)
    if not inst.lol_wp_s11_amplifyingtome_isequip then
        inst.lol_wp_s11_amplifyingtome_isequip = true

        if owner.components.lol_wp_player_dmg_adder then
            owner.components.lol_wp_player_dmg_adder:Modifier(inst,TUNING.MOD_LOL_WP.AMPLIFYINGTOME.PLANAR_DMG,prefab_id,'planar')
            owner.components.lol_wp_player_dmg_adder:SetOnHitAlways(prefab_id,function(victim)
                if inst.components.finiteuses then
                   inst.components.finiteuses:Use(1)
                end
            end)
        end
    end
end
---comment
---@param inst ent
---@param owner ent
local function onunequip(inst, owner)
    if inst.lol_wp_s11_amplifyingtome_isequip then
        owner.AnimState:ClearOverrideSymbol("swap_body")
        inst.lol_wp_s11_amplifyingtome_isequip = false

        if owner.components.lol_wp_player_dmg_adder then
            owner.components.lol_wp_player_dmg_adder:RemoveModifier(inst,prefab_id,'planar')
            owner.components.lol_wp_player_dmg_adder:RemoveOnHitAlways(prefab_id)
        end
    end
end

local function onfinished(inst)
    inst:AddTag(prefab_id..'_nofiniteuses')
    inst:Remove()
end

local function onattack(inst,attacker,target)

end

---comment
---@param inst ent
---@param reader ent
local function onread(inst,reader)
    if inst.components.finiteuses then
        local maxfiniteuse = inst.components.finiteuses.total
        local consume = maxfiniteuse * db.CONSUME_WHEN_READ
        inst.components.finiteuses:Use(consume)
    end

    if TheWorld.net == nil or TheWorld.net.components.weather == nil then
        return false
    end

    local pt = reader:GetPosition()
    local num_lightnings = 16

    reader:StartThread(function()
        for k = 0, num_lightnings do
            local rad = math.random(3, 15)
            local angle = k * 4 * PI / num_lightnings
            local pos = pt + Vector3(rad * math.cos(angle), 0, rad * math.sin(angle))
            TheWorld:PushEvent("ms_sendlightningstrike", pos)
            Sleep(.3 + math.random() * .2)
        end
    end)
    return true
end

local function perusefn(inst,reader)
    if reader.peruse_brimstone then
        reader.peruse_brimstone(reader)
    end
    -- reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_BRIMSTONE"))
    return true
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

    inst:AddTag("book")
    inst:AddTag("bookcabinet_item")

    inst:AddTag('shadow_item')

    inst:AddTag('shadowlevel')

    -- inst.MiniMapEntity:SetIcon(prefab_id..".tex")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.swap_build = "swap_books"
    inst.swap_prefix = 'book_brimstone'

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
    inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY -- 适配五格
    -- inst.components.equippable.walkspeedmult = 1.2
    -- inst.components.equippable.dapperness = 2

    inst:AddTag("amulet") -- 适配六格

    -- inst:AddComponent("weapon")
    -- inst.components.weapon:SetDamage(34)
    -- inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(db.FINITEUSES)
    inst.components.finiteuses:SetUses(db.FINITEUSES)
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent('book')
    inst.components.book:SetOnRead(onread)
    inst.components.book:SetOnPeruse(perusefn)

    inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(db.SHADOW_LEVEL)

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


