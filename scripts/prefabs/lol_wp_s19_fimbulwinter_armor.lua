local db = TUNING.MOD_LOL_WP.FIMBULWINTER

local function makeArmor()
    local prefab_id = "lol_wp_s19_fimbulwinter_armor"
    local assets_id = "lol_wp_s19_fimbulwinter_armor"

    local assets =
    {
        Asset( "ANIM", "anim/"..assets_id..".zip"),
        Asset( "ATLAS", "images/inventoryimages/"..assets_id..".xml" ),
    }

    local prefabs =
    {
        prefab_id,
    }

    local function fn()
        ---@type ent|nil
        local _equip = nil

        local function OnBlocked(owner)
            owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
        end

        ---comment
        ---@param owner ent
        ---@param data event_data_onhitother
        local function owner_onhitother(owner,data)
            local victim = data and data.target
            if victim and _equip and _equip.components.rechargeable and _equip.components.rechargeable:IsCharged() and _equip.components.count_from_tearsofgoddness then
                local count = db.SKILL_COUNT.COUNT_PER_HIT
                if victim:HasTag('epic') then
                    count = db.SKILL_COUNT.COUNT_PER_HIT_BOSS
                end
                if _equip.components.count_from_tearsofgoddness then
                    _equip.components.rechargeable:Discharge(db.SKILL_COUNT.CD)
                    _equip.components.count_from_tearsofgoddness:DoDelta(count)
                end
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
                owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, prefab_id)
            else
                owner.AnimState:OverrideSymbol("swap_body", prefab_id, "swap_body")
            end

            inst:ListenForEvent("blocked", OnBlocked, owner)

            _equip = inst
            owner:ListenForEvent('onhitother',owner_onhitother)
        end

        ---onunequipfn
        ---@param inst ent
        ---@param owner ent
        local function onunequip(inst, owner)
            owner.AnimState:ClearOverrideSymbol("swap_body")

            local skin_build = inst:GetSkinBuild()
            if skin_build ~= nil then
                owner:PushEvent("unequipskinneditem", inst:GetSkinName())
            end

            inst:RemoveEventCallback("blocked", OnBlocked, owner)

            _equip = nil
            inst:RemoveEventCallback('onhitother',owner_onhitother)
        end

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
        inst.AnimState:PlayAnimation("anim",true)

        MakeInventoryFloatable(inst, "med", nil, 0.75)

        -- inst.Light:SetFalloff(0.5)
        -- inst.Light:SetIntensity(.8)
        -- inst.Light:SetRadius(1.3)
        -- inst.Light:SetColour(128/255, 20/255, 128/255)
        -- inst.Light:Enable(true)

        inst.entity:SetPristine()

        inst:AddTag("nosteal")

        inst:AddTag('hide_percentage')

        inst:AddTag('lunar_aligned')

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

        inst:AddComponent('armor')
        inst.components.armor:InitIndestructible(db.ABSORB)

        inst:AddComponent('planardefense')
        inst:DoTaskInTime(1,function ()
            if inst.components.planardefense then
                local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
                if owner and owner.components.sanity then
                    local max = owner.components.sanity.max
                    local defence = max * db.SKILL_FEAR.SAN_PERCENT
                    inst.components.planardefense:SetBaseDefense(defence)
                else
                    inst.components.planardefense:SetBaseDefense(0)
                end
            end
        end)


        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.equipslot = EQUIPSLOTS.BODY
        inst.components.equippable.walkspeedmult = db.WALKSPEEDMULT
        -- inst.components.equippable.dapperness = 2

        inst:AddComponent('insulator')
        inst.components.insulator:SetInsulation(db.AVOID_COLD)
        inst.components.insulator:SetWinter()

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(db.WATERPROOF)

        inst:AddComponent('count_from_tearsofgoddness')
        inst.components.count_from_tearsofgoddness:Init(db.SKILL_COUNT.MAX_COUNT,'lol_wp_s19_fimbulwinter_armor_upgrade')
        inst.components.count_from_tearsofgoddness:SetOnDelta(function (this, num)
            -- local old_dapperness = inst.components.equippable.dapperness or 0
            inst.components.equippable.dapperness = (num*db.SKILL_COUNT.DARPPERNESS_PER_COUNT)/54
        end)
        inst.components.count_from_tearsofgoddness:SetOnLoad(function (this, val)
            -- local old_dapperness = inst.components.equippable.dapperness or 0
            inst.components.equippable.dapperness = (val*db.SKILL_COUNT.DARPPERNESS_PER_COUNT)/54
        end)


        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetChargeTime(db.SKILL_COUNT.CD)
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
end


local function makeArmor_upgrade()
    local prefab_id = "lol_wp_s19_fimbulwinter_armor_upgrade"
    local assets_id = "lol_wp_s19_fimbulwinter_armor_upgrade"

    local assets =
    {
        Asset( "ANIM", "anim/"..assets_id..".zip"),
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
        local _equipfx = nil

        ---comment
        ---@param wp ent
        ---@param player ent
        ---@param target ent
        local function skill_enternal(wp,player,target)
            if wp and wp.components.rechargeable and wp.components.rechargeable:IsCharged() and target and target:HasTag('epic') and player and player.components.lol_wp_player_invincible then
                wp.components.rechargeable:Discharge(db.UPGRADE.SKILL_ENTERNAL.CD)

                local shield = SpawnPrefab('forcefieldfx')
                shield.AnimState:SetAddColour(33/255,169/255,232/255,1)
                shield.entity:SetParent(player.entity)

                if player.components.lol_wp_player_invincible then
                    player.components.lol_wp_player_invincible:Push()
                    player:DoTaskInTime(db.UPGRADE.SKILL_ENTERNAL.DURANTION,function()
                        if shield and shield:IsValid() then
                            shield:Remove()
                        end
                        player.components.lol_wp_player_invincible:Pop()
                    end)
                end
            end
        end

        local function OnBlocked(owner)
            owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
        end

        ---comment
        ---@param player ent
        ---@param data table
        local function owner_onattackother(player,data)
            ---@type ent|nil
            local victim = data and data.target
            if victim then
                -- victim.lol_wp_s19_fimbulwinter_armor_upgrade_attacker = player
                -- victim.lol_wp_s19_fimbulwinter_armor_upgrade_wp = _equip
                if _equip and _equip.components.rechargeable and _equip.components.rechargeable:IsCharged() and victim:HasTag('epic') and player and player.components.lol_wp_player_invincible then
                    _equip.components.rechargeable:Discharge(db.UPGRADE.SKILL_ENTERNAL.CD)

                    local shield = SpawnPrefab('forcefieldfx')
                    shield.AnimState:SetAddColour(33/255,169/255,232/255,1)
                    shield.entity:SetParent(player.entity)

                    if player.components.lol_wp_player_invincible then
                        player.components.lol_wp_player_invincible:Push()
                        player:DoTaskInTime(db.UPGRADE.SKILL_ENTERNAL.DURANTION,function()
                            if shield and shield:IsValid() then
                                shield:Remove()
                            end
                            player.components.lol_wp_player_invincible:Pop()
                        end)
                    end
                end
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
                owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, prefab_id)
            else
                owner.AnimState:OverrideSymbol("swap_body", prefab_id, "swap_body")
            end

            inst:ListenForEvent("blocked", OnBlocked, owner)

            inst.Light:Enable(true)

            owner:ListenForEvent('onattackother',owner_onattackother)
            _equip = inst

            if _equipfx and _equipfx:IsValid() then
                _equipfx:Remove()
            end

            _equipfx = SpawnPrefab('cane_candy_fx')
            _equipfx.entity:SetParent(owner.entity)
            _equipfx.entity:AddFollower()
            _equipfx.Follower:FollowSymbol(owner.GUID, nil, 0, 0, 0)

            if owner.components.hunger then
                owner.components.hunger.burnratemodifiers:SetModifier(inst,db.UPGRADE.HUNGER_BURN_RATE,'lol_wp_s19_fimbulwinter_armor_upgrade')
            end
        end

        ---onunequipfn
        ---@param inst ent
        ---@param owner ent
        local function onunequip(inst, owner)
            owner.AnimState:ClearOverrideSymbol("swap_body")

            local skin_build = inst:GetSkinBuild()
            if skin_build ~= nil then
                owner:PushEvent("unequipskinneditem", inst:GetSkinName())
            end

            inst:RemoveEventCallback("blocked", OnBlocked, owner)

            inst.Light:Enable(false)

            owner:RemoveEventCallback('onattackother',owner_onattackother)
            _equip = nil

            if _equipfx and _equipfx:IsValid() then
                _equipfx:Remove()
            end

            if owner.components.hunger then
                owner.components.hunger.burnratemodifiers:RemoveModifier(inst,'lol_wp_s19_fimbulwinter_armor_upgrade')
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
        inst.AnimState:PlayAnimation("anim",true)

        MakeInventoryFloatable(inst, "med", nil, 0.75)

        inst.Light:SetFalloff(db.UPGRADE.LIGHT.FALLOFF)
        inst.Light:SetIntensity(db.UPGRADE.LIGHT.INTENSITY)
        inst.Light:SetRadius(db.UPGRADE.LIGHT.RADIUS)
        inst.Light:SetColour(unpack(db.UPGRADE.LIGHT.COLOR))
        inst.Light:Enable(false)

        inst.entity:SetPristine()

        inst:AddTag("nosteal")

        inst:AddTag('hide_percentage')

        inst:AddTag('lunar_aligned')

        -- inst.MiniMapEntity:SetIcon(prefab_id..".tex")

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

        inst:AddComponent('armor')
        inst.components.armor:InitIndestructible(db.UPGRADE.ABSORB)

        inst:AddComponent('planardefense')
        inst:DoTaskInTime(1,function ()
            if inst.components.planardefense then
                local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
                if owner and owner.components.sanity then
                    local max = owner.components.sanity.max
                    local defence = max * db.UPGRADE.SKILL_FEAR.SAN_PERCENT
                    inst.components.planardefense:SetBaseDefense(defence)
                else
                    inst.components.planardefense:SetBaseDefense(0)
                end
            end
        end)

        inst:AddComponent("equippable")
        inst.components.equippable.insulated = true
        inst.components.equippable.equipslot = EQUIPSLOTS.BODY
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.walkspeedmult = db.UPGRADE.WALKSPEEDMULT
        inst.components.equippable.dapperness = db.UPGRADE.DARPPERNESS/54

        inst:AddComponent('insulator')
        inst.components.insulator:SetInsulation(db.UPGRADE.AVOID_COLD)
        inst.components.insulator:SetWinter()

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(db.UPGRADE.WATERPROOF)

        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetChargeTime(db.UPGRADE.SKILL_ENTERNAL.CD)
        -- -- inst.components.rechargeable:SetOnDischargedFn(function(inst)  end)
        -- inst.components.rechargeable:SetOnChargedFn(function(inst)
        --     if inst:HasTag(prefab_id..'_iscd') then
        --         inst:RemoveTag(prefab_id..'_iscd')
        --     end
        -- end)

        -- inst.skill_enternal = skill_enternal -- 不用减速触发 太绕了 改成冰冻触发

        -- local planardamage = inst:AddComponent("planardamage")
        -- planardamage:SetBaseDamage(data_prefab.planardamage)

        -- inst.OnSave = onsave
        -- inst.OnPreLoad = onpreload

        return inst
    end

    return Prefab("common/inventory/"..prefab_id, fn, assets, prefabs)
end

return makeArmor(),makeArmor_upgrade()