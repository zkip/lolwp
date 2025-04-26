---@diagnostic disable: undefined-global, trailing-space
local prefab_id = 'lol_wp_s14_thornmail'
local assets_id = 'lol_wp_s14_thornmail'

local db = TUNING.MOD_LOL_WP.THORNMAIL

local assets =
{
    Asset("ANIM", "anim/"..assets_id..".zip"),
    Asset("ATLAS", "images/inventoryimages/"..assets_id..".xml"),
}

local prefabs =
{
    'lol_wp_s14_bramble_vest_fx'
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

    local function onpercentusedchange(inst,data)
        if inst.lol_wp_s14_thornmail_san_repair == nil then
            inst.lol_wp_s14_thornmail_san_repair = inst:DoPeriodicTask(1,function()
                local cur_durability_percent = inst and inst:IsValid() and inst.components.armor and inst.components.armor:GetPercent()
                if cur_durability_percent then
                    if cur_durability_percent >= 1 then
                        -- 耐久回满 掉san恢复正常
                        if inst.components.equippable then
                            inst.components.equippable.dapperness = db.DARPPERNESS/54
                        end
        
                        if inst.lol_wp_s14_thornmail_san_repair then
                            inst.lol_wp_s14_thornmail_san_repair:Cancel()
                            inst.lol_wp_s14_thornmail_san_repair = nil
                        end
                    else
                        -- 耐久不满
                        if inst.components.equippable then
                            inst.components.equippable.dapperness = (-20)/54
                        end

                        if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
                            local owner = inst.components.inventoryitem.owner
                            local san_percent = owner and owner.components.sanity and owner.components.sanity:GetPercent()
                            if san_percent then
                                local delta = (840/(900+600*san_percent))*.6
                                local max_durability = inst.components.armor.maxcondition
                                local cur_durability = inst.components.armor.condition
                                local new_durability = math.min(cur_durability+delta, max_durability)
                                inst.components.armor:SetCondition(new_durability)
                            end
                        end
                    end
                end
            end)
        end
    end

    ---comment
    ---@param inst ent
    local function onfinished(inst)
        LOLWP_S:unequipItem(inst)
        inst:AddTag(prefab_id..'_nofiniteuses')
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

    inst:AddTag("shadow_item")

	--shadowlevel (from shadowlevel component) added to pristine state for optimization
	inst:AddTag("shadowlevel")


    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = assets_id
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..assets_id..".xml"


    inst:AddComponent("armor")
    inst.components.armor:InitCondition(db.FINITEUSES, db.ABSORB)
    inst.components.armor:SetKeepOnFinished(true) -- 耐久用完保留
    inst.components.armor:SetOnFinished(onfinished)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = db.WALKSPEEDMULT
    inst.components.equippable.dapperness = db.DARPPERNESS/54

    inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(TUNING.MOD_LOL_WP.OVERLORDBLOOD.SHADOW_LEVEL)

    inst:AddComponent('waterproofer')
    inst.components.waterproofer:SetEffectiveness(db.WATERPROOF)

    inst:ListenForEvent('percentusedchange',onpercentusedchange)
    --MakeHauntableLaunch(inst)
    -- MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    return inst
end

return Prefab(prefab_id, fn, assets, prefabs)
