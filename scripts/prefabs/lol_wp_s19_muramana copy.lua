local db = TUNING.MOD_LOL_WP.MURAMANA

local function makeWeapon()
    local prefab_id = "lol_wp_s19_muramana"
    local assets_id = "lol_wp_s19_muramana"

    local assets =
    {
        Asset( "ANIM", "anim/"..assets_id..".zip"),
        Asset( "ANIM", "anim/swap_"..assets_id..".zip"),
        Asset( "ATLAS", "images/inventoryimages/"..assets_id..".xml" ),

        Asset( "ANIM", "anim/"..assets_id.."_skin_magic_sword.zip"),
        Asset( "ANIM", "anim/swap_"..assets_id.."_skin_magic_sword.zip"),
        Asset( "ATLAS", "images/inventoryimages/"..assets_id.."_skin_magic_sword.xml" ),
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

        owner._lol_wp_s19_muramana_wp = nil
    end

    ---onattack
    ---@param inst ent
    ---@param attacker ent
    ---@param target ent
    local function onattack(inst,attacker,target)
        if target then
            local pt_tar = target:GetPosition()
            SpawnPrefab('fire_fail_fx').Transform:SetPosition(pt_tar:Get())

            if inst.components.rechargeable and inst.components.rechargeable:IsCharged() then
                inst.components.rechargeable:Discharge(db.SKILL_COUNT.CD)
                local count = db.SKILL_COUNT.COUNT_PER_HIT
                if target:HasTag('epic') then
                    count = db.SKILL_COUNT.COUNT_PER_HIT_BOSS
                end
                if inst.components.count_from_tearsofgoddness then
                    inst.components.count_from_tearsofgoddness:DoDelta(count)
                end
            end
        end
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
        inst.components.weapon:SetDamage(db.DMG)
        inst.components.weapon:SetRange(db.RANGE,db.RANGE+2)
        inst.components.weapon:SetOnAttack(onattack)

        local old_OnAttack = inst.components.weapon.OnAttack
        function inst.components.weapon:OnAttack(attacker, target, projectile, ...)
            if self.inst.prefab == 'lol_wp_s19_muramana' then
                if attacker.lol_wp_s19_muramana_hittimes == nil then
                    attacker.lol_wp_s19_muramana_hittimes = 0
                end
                attacker._lol_wp_s19_muramana_wp = inst
                if attacker.lol_wp_s19_muramana_is_tri_atk then
                else
                    attacker.lol_wp_s19_muramana_hittimes = math.min(attacker.lol_wp_s19_muramana_hittimes + 1,(db.SKILL_WINDSLASH.PER_HIT_TIMES-1))
                    if attacker.lol_wp_s19_muramana_hittimes == (db.SKILL_WINDSLASH.PER_HIT_TIMES-1) then
                        inst:AddTag('lol_wp_s12_malignance_tri_atk')
                        attacker.lol_wp_s19_muramana_hittimes = 0
                    else
                        inst:RemoveTag('lol_wp_s12_malignance_tri_atk')
                    end
                end
                if self.onattack ~= nil then
                    self.onattack(self.inst, attacker, target)
                end
            else
                return old_OnAttack(attacker, target, projectile, ...)
            end
        end

        inst:AddComponent('count_from_tearsofgoddness')
        inst.components.count_from_tearsofgoddness:Init(db.SKILL_COUNT.MAX_COUNT,'lol_wp_s19_muramana_upgrade')
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
    local prefab_id = "lol_wp_s19_muramana_upgrade"
    local assets_id = "lol_wp_s19_muramana_upgrade"

    local assets =
    {
        Asset( "ANIM", "anim/"..assets_id..".zip"),
        Asset( "ANIM", "anim/swap_"..assets_id..".zip"),
        Asset( "ATLAS", "images/inventoryimages/"..assets_id..".xml" ),

        Asset( "ANIM", "anim/"..assets_id.."_skin_glory_days.zip"),
        Asset( "ANIM", "anim/swap_"..assets_id.."_skin_glory_days.zip"),
        Asset( "ATLAS", "images/inventoryimages/"..assets_id.."_skin_glory_days.xml" ),

        Asset( "ANIM", "anim/"..assets_id.."_skin_magic_sword.zip"),
        Asset( "ANIM", "anim/swap_"..assets_id.."_skin_magic_sword.zip"),
        Asset( "ATLAS", "images/inventoryimages/"..assets_id.."_skin_magic_sword.xml" ),
    }

    local prefabs =
    {
        prefab_id,
    }

    ---onattack
    ---@param inst ent
    ---@param attacker ent
    ---@param target ent
    local function onattack(inst,attacker,target)
        if target then
            local pt_tar = target:GetPosition()
            SpawnPrefab('fire_fail_fx').Transform:SetPosition(pt_tar:Get())
        end
    end

    local function fn()
        ---@type ent|nil
        local _equipfx = nil

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

            local skin_build = inst:GetSkinBuild()
            if skin_build ~= nil then
                owner:PushEvent("unequipskinneditem", inst:GetSkinName())
            end

            owner._lol_wp_s19_muramana_wp = nil

            inst.Light:Enable(false)

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
        inst.components.weapon:SetDamage(db.UPGRADE.DMG)
        inst.components.weapon:SetRange(db.UPGRADE.RANGE,db.UPGRADE.RANGE+2)
        inst.components.weapon:SetOnAttack(onattack)

        local old_OnAttack = inst.components.weapon.OnAttack
        function inst.components.weapon:OnAttack(attacker, target, projectile, ...)
            if self.inst.prefab == 'lol_wp_s19_muramana_upgrade' then
                if attacker.lol_wp_s19_muramana_hittimes == nil then
                    attacker.lol_wp_s19_muramana_hittimes = 0
                end
                attacker._lol_wp_s19_muramana_wp = inst
                if attacker.lol_wp_s19_muramana_is_tri_atk then
                else
                    attacker.lol_wp_s19_muramana_hittimes = math.min(attacker.lol_wp_s19_muramana_hittimes + 1,(db.SKILL_WINDSLASH.PER_HIT_TIMES-1))
                    if attacker.lol_wp_s19_muramana_hittimes == (db.SKILL_WINDSLASH.PER_HIT_TIMES-1) then
                        self.inst:AddTag('lol_wp_s12_malignance_tri_atk')
                        attacker.lol_wp_s19_muramana_hittimes = 0
                    else
                        self.inst:RemoveTag('lol_wp_s12_malignance_tri_atk')
                    end
                end
                if self.onattack ~= nil then
                    self.onattack(self.inst, attacker, target)
                end
            else
                return old_OnAttack(attacker, target, projectile, ...)
            end
        end

        -- inst:AddComponent("rechargeable")
        -- inst.components.rechargeable:SetChargeTime(db.UPGRADE.)
        -- inst.components.rechargeable:SetOnDischargedFn(function(inst)  end)
        -- inst.components.rechargeable:SetOnChargedFn(function(inst)
        --     if inst:HasTag(prefab_id..'_iscd') then
        --         inst:RemoveTag(prefab_id..'_iscd')
        --     end
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

return makeWeapon(),makeWeapon_upgrade()