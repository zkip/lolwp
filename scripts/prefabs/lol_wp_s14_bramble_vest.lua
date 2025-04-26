---@diagnostic disable: undefined-global, trailing-space
local prefab_id = 'lol_wp_s14_bramble_vest'
local assets_id = 'lol_wp_s14_bramble_vest'

local db = TUNING.MOD_LOL_WP.BRAMBLE_VEST

local assets =
{
    Asset("ANIM", "anim/"..assets_id..".zip"),
    Asset("ATLAS", "images/inventoryimages/"..assets_id..".xml"),
}

local prefabs =
{
    'lol_wp_s14_bramble_vest_fx',
}


local function fn()
    
    local _task
    ---comment
    ---@param owner ent
    ---@param data event_data_attacked
    local function OnAttacked(owner, data)
        if owner and owner:HasTag('player') then
            if data then
                local dmg = data.original_damage
                local attacker = data.attacker
                if dmg and attacker and LOLWP_S:checkAlive(attacker) and attacker.components.combat and not attacker:HasTag('player') then
                    local reflect = dmg * db.SKILL_BRAMBLE.REFLECT_DMG_PERCENT + db.SKILL_BRAMBLE.REFLECT_DMG
                    SpawnPrefab("lol_wp_s14_bramble_vest_fx").Transform:SetPosition(owner:GetPosition():Get())
        
                    if owner.SoundEmitter ~= nil then
                        owner.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
                    end
        
        
                    -- attacker.components.combat:GetAttacked(owner,reflect)
                    local amount = math.abs(attacker.components.health:DoDelta(-reflect))
                    ---@type event_data_attacked
                    local event_data_attacked = { attacker = owner, damage = amount, damageresolved = amount, original_damage = amount }
                    attacker:PushEvent('attacked',event_data_attacked)
        
                    if LOLWP_S:checkAlive(attacker) then
                        local old_externalabsorbmodifiers = attacker.components.health.externalabsorbmodifiers:Get()
                        if -db.SKILL_BRAMBLE.REFLECTED_TARGET_DMGTAKEN < old_externalabsorbmodifiers then
                            attacker.components.health.externalabsorbmodifiers:SetModifier('lol_wp_bramble_vest_reflect_dmg',-db.SKILL_BRAMBLE.REFLECTED_TARGET_DMGTAKEN,'lol_wp_bramble_vest_reflect_dmg')
        
                            if _task ~= nil then
                                _task:Cancel()
                                _task = nil
                            end
                            _task = attacker:DoTaskInTime(db.SKILL_BRAMBLE.DMGTAKEN_LAST,function ()
                                if attacker and LOLWP_S:checkAlive(attacker) then
                                    attacker.components.health.externalabsorbmodifiers:RemoveModifier('lol_wp_bramble_vest_reflect_dmg','lol_wp_bramble_vest_reflect_dmg')
                                end
                            end)
                        end
                    end
                end
            end
        end
    end

    local function onequip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_body", assets_id, "swap_body")
        -- inst:ListenForEvent("blocked", OnBlocked, owner)
        inst:ListenForEvent("attacked", OnAttacked, owner)

    end

    local function onunequip(inst, owner)
        owner.AnimState:ClearOverrideSymbol("swap_body")
        -- inst:RemoveEventCallback("blocked", OnBlocked, owner)
        inst:RemoveEventCallback("attacked", OnAttacked, owner)

    end

    ---comment
    ---@param inst ent
    local function onfinished(inst)
        -- LOLWP_S:unequipItem(inst)
        -- inst:AddTag(assets_id..'_nofiniteuses')
        -- inst:Remove()
    end
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(assets_id)
    inst.AnimState:SetBuild(assets_id)
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("wood")
    inst:AddTag(assets_id)

    ---@diagnostic disable-next-line: inject-field
    inst.foleysound = "dontstarve/movement/foley/logarmour"

    MakeInventoryFloatable(inst, "small", 0.2, 0.80)

    inst.entity:SetPristine()


    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = assets_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..assets_id..".xml"


    inst:AddComponent("armor")
    inst.components.armor:InitCondition(db.FINITEUSES, db.ABSORB)
    -- inst.components.armor:SetKeepOnFinished(false) -- 耐久用完保留
    -- inst.components.armor:SetOnFinished(onfinished)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.walkspeedmult = db.WALKSPEEDMULT
    -- inst.components.equippable.dapperness = db.da

    inst:AddComponent('waterproofer')
    inst.components.waterproofer:SetEffectiveness(db.WATERPROOF)
    --MakeHauntableLaunch(inst)
    -- MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    return inst
end


local function MakeFX()
    local _assets =
    {
        Asset("ANIM", "anim/bramblefx.zip"),
    }
    local function fx_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")


        inst:AddTag("FX")

        inst.Transform:SetFourFaced()

        inst.AnimState:SetBank("bramblefx")
        inst.AnimState:SetBuild("bramblefx")
        inst.AnimState:PlayAnimation('idle')

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:ListenForEvent("animover", inst.Remove)

        return inst
    end

    return Prefab('lol_wp_s14_bramble_vest_fx', fx_fn, _assets)
end

return Prefab(prefab_id, fn, assets, prefabs),MakeFX()
