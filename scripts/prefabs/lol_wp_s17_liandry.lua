local db = TUNING.MOD_LOL_WP.LIANDRY

local function makeLiandry()

    local _prefab_id = 'lol_wp_s17_liandry'
    local prefab_id = 'lol_wp_s17_liandry'

    local assets =
    {
        Asset("ANIM", "anim/"..prefab_id..".zip"),
        Asset("ATLAS", "images/inventoryimages/"..prefab_id..".xml"),

    }


    local function fn()
        ---@type ent|nil # 引用被装备的装备
        local equipped = nil
        ---@type Periodic|nil # 被动【受苦】佩戴时会每10秒受到5点真实伤害。
        local _task = nil

        ---comment
        ---@param owner ent
        ---@param data event_data_onhitother
        local function ownerAtk(owner,data)
            local target = data and data.target
            -- 概率点燃敌人, 不能重复点燃
            if equipped and equipped.components.rechargeable and equipped.components.rechargeable:IsCharged() then

                if target and LOLWP_S:checkAlive(target) and not target._flag_lol_wp_s17_liandry_burning then
                    -- if target.components.burnable then

                        equipped.components.rechargeable:Discharge(db.SKILL_TORMENT.CD)

                        -- 标记正在燃烧
                        target._flag_lol_wp_s17_liandry_burning = true

                        -- 触发点燃时的特效
                        local fx = SpawnPrefab('campfirefire')
                        local scale = 2
                        fx.Transform:SetScale(scale,scale,scale)
                        fx.AnimState:SetAddColour(1,1,1,1)
                        fx.entity:SetParent(target.entity)
                        fx.entity:AddFollower()
                        fx.Follower:FollowSymbol(target.GUID,nil,0,-105,0)

                        -- target.components.burnable.controlled_burn = {
                        --     duration_creature = 3,
                        --     damage = 0,
                        -- }
                        -- target.components.burnable:SpawnFX(nil)

                        -- for _,fx in pairs( target.components.burnable.fxchildren or {}) do
                        --     if fx:IsValid() and fx.AnimState then
                        --         fx.AnimState:SetAddColour(1,1,1,1)
                        --     end
                        -- end
                        -- target.components.burnable.controlled_burn = nil

                        if target.taskperiod_lol_wp_s17_liandry_burning == nil then
                            target.taskperiod_lol_wp_s17_liandry_burning = target:DoPeriodicTask(db.SKILL_TORMENT.INTERVAL,function ()
                                if LOLWP_S:checkAlive(target) then
                                    local tar_maxhp = target.components.health.maxhealth
                                    local planar_dmg = tar_maxhp * db.SKILL_TORMENT.MAXHP_PERCENT_PLANAR_DMG
                                    target.components.combat:GetAttacked(owner,0,nil,nil,{planar = planar_dmg})
                                end
                            end)
                        end

                        target:DoTaskInTime(db.SKILL_TORMENT.DURATION+db.SKILL_TORMENT.INTERVAL,function ()
                            if target then
                                -- 标记停止燃烧
                                target._flag_lol_wp_s17_liandry_burning = false
                                -- if target.components.burnable then
                                --     target.components.burnable:KillFX()
                                -- end
                                if fx and fx:IsValid() then
                                    fx:Remove()
                                end
                                if target.taskperiod_lol_wp_s17_liandry_burning then
                                    target.taskperiod_lol_wp_s17_liandry_burning:Cancel()
                                    target.taskperiod_lol_wp_s17_liandry_burning = nil
                                end
                            end
                        end)
                    -- end
                end
            end

        end

        ---comment
        ---@param inst ent
        ---@param owner ent
        local function onequip(inst, owner)
            local skin_build = inst:GetSkinBuild()

            if skin_build ~= nil then
                owner:PushEvent("equipskinneditem", inst:GetSkinName())
                owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, 'swap_hat', inst.GUID, prefab_id)
            else
                owner.AnimState:OverrideSymbol("swap_hat", prefab_id, "swap_hat")
            end

            owner.AnimState:Show("HAT")
            owner.AnimState:Show("HAIR_HAT")
            -- owner.AnimState:Hide("HAIR_NOHAT")
            -- owner.AnimState:Hide("HAIR")
            if owner:HasTag("player") then
                -- owner.AnimState:Hide("HEAD")
                owner.AnimState:Show("HEAD_HAT")
                owner.AnimState:Show("HEAD_HAT_NOHELM")
                -- owner.AnimState:Hide("HEAD_HAT_HELM")
            end

            equipped = inst
            owner:ListenForEvent('onhitother',ownerAtk)

            owner.lol_wp_s17_liandry_no_sleep = true

            if _task ~= nil then
                _task:Cancel()
                _task = nil
            end
            _task = owner:DoPeriodicTask(db.SKILL_SUFFER.INTERVAL,function()
                -- if owner and LOLWP_S:checkAlive(owner) then
                --     LOLWP_S:dealTrueDmg(db.SKILL_SUFFER.TRUE_DMG,owner)
                -- end
            end)


            if owner.components.lol_wp_player_dmg_adder then
                owner.components.lol_wp_player_dmg_adder:ModifierMult(inst,(1+db.SKILL_SUFFER.PLANAR_DMG),prefab_id,'planar')
                owner.components.lol_wp_player_dmg_adder:ModifierMult(inst,(1+db.SKILL_SUFFER.PLANAR_DMG),prefab_id,'physical')
            end

            if owner.components.playervision ~= nil then
                owner:AddDebuff("nightvision_buff", "nightvision_buff")
                if owner.task_period_extend_lol_wp_s17_liandry_buffnightvision ~= nil then
                    owner.task_period_extend_lol_wp_s17_liandry_buffnightvision:Cancel()
                    owner.task_period_extend_lol_wp_s17_liandry_buffnightvision = nil
                end
                owner.task_period_extend_lol_wp_s17_liandry_buffnightvision = owner:DoPeriodicTask(5,function ()
                    if owner and owner.components.playervision ~= nil then
                        owner:AddDebuff("nightvision_buff", "nightvision_buff")
                    end
                end)
            end

            inst.Light:Enable(true)
        end

        ---comment
        ---@param inst ent
        ---@param owner ent
        local function onunequip(inst, owner)
            owner.AnimState:ClearOverrideSymbol("headbase_hat")

            owner.AnimState:ClearOverrideSymbol("swap_hat")
            owner.AnimState:Hide("HAT")
            owner.AnimState:Hide("HAIR_HAT")
            owner.AnimState:Show("HAIR_NOHAT")
            owner.AnimState:Show("HAIR")

            if owner:HasTag("player") then
                owner.AnimState:Show("HEAD")
                owner.AnimState:Hide("HEAD_HAT")
                owner.AnimState:Hide("HEAD_HAT_NOHELM")
                owner.AnimState:Hide("HEAD_HAT_HELM")
            end

            equipped = nil
            owner:RemoveEventCallback('onhitother',ownerAtk)

            owner.lol_wp_s17_liandry_no_sleep = false

            if _task ~= nil then
                _task:Cancel()
                _task = nil
            end

            if owner.components.lol_wp_player_dmg_adder then
                owner.components.lol_wp_player_dmg_adder:RemoveModifierMult(inst,prefab_id,'planar')
                owner.components.lol_wp_player_dmg_adder:RemoveModifierMult(inst,prefab_id,'physical')
            end

            if owner.task_period_extend_lol_wp_s17_liandry_buffnightvision ~= nil then
                owner.task_period_extend_lol_wp_s17_liandry_buffnightvision:Cancel()
                owner.task_period_extend_lol_wp_s17_liandry_buffnightvision = nil
            end
            owner:RemoveDebuff('nightvision_buff')

            inst.Light:Enable(false)
        end

        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddLight()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(prefab_id)
        inst.AnimState:SetBuild(prefab_id)
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("wood")

        inst.foleysound = "dontstarve/movement/foley/logarmour"

        MakeInventoryFloatable(inst, "small", 0.2, 0.80)

        inst.entity:SetPristine()

        inst:AddTag('lunar_aligned')

        inst.Light:SetFalloff(.2)
        inst.Light:SetIntensity(.9)
        inst.Light:SetRadius(2)
        inst.Light:SetColour(239/255,255/255,255/255)
        inst.Light:Enable(false)

        -- inst:AddTag("shadowdominance")
        inst:AddTag("goggles")

        inst:AddTag('hide_percentage')

        -- inst:AddOrRemoveTag('nightvision',true)

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = prefab_id
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..prefab_id..".xml"
        inst.components.inventoryitem:SetOnDroppedFn(function()
            inst.Light:Enable(true)
        end)
        inst.components.inventoryitem:SetOnPutInInventoryFn(function()
            inst.Light:Enable(false)
        end)

        inst:AddComponent("armor")
        inst.components.armor:InitIndestructible(db.ABSORB)

        inst:AddComponent("planardefense")
        inst.components.planardefense:SetBaseDefense(db.DEFEND_PLANAR)

        inst:AddComponent("equippable")
        inst.components.equippable.insulated = true
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.dapperness = db.DARPPERNESS/54
        -- inst.components.equippable.is_magic_dapperness = true
        -- inst.components.equippable.dapperness = (TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.DARPPERNESS+TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.WHEN_MASKED.DARPPERNESS)/54

        -- inst:AddComponent("shadowlevel")
        -- inst.components.shadowlevel:SetDefaultLevel(TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.SHADOW_LEVEL)

        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetChargeTime(db.SKILL_TORMENT.CD)
        -- inst.components.rechargeable:SetOnDischargedFn(function(inst) end)
        -- inst.components.rechargeable:SetOnChargedFn(OnChargedFn)

        inst:AddComponent('lol_wp_s17_liandry_tf')

        inst:DoPeriodicTask(1,function()
            local owner = inst and inst.components.inventoryitem and inst.components.inventoryitem.owner
            if owner and owner:IsValid() then
                if owner.components.locomotor and owner._lol_wp_s16_potion_corruption_after_debuff_self ~= nil and owner._lol_wp_s16_potion_corruption_after_debuff_self:IsValid() then
                    owner.components.locomotor:RemoveExternalSpeedMultiplier(owner._lol_wp_s16_potion_corruption_after_debuff_self,'lol_wp_s16_potion_corruption_after_debuff')
                end
                owner:AddOrRemoveTag('groggy',false)
                if owner.components.grogginess then
                    owner.components.grogginess:ResetGrogginess()
                end
            end
        end)

        -- inst:AddComponent("resistance")
        -- inst.components.resistance:SetShouldResistFn(ShouldResistFn)
        -- inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
        -- for i, v in ipairs(RESISTANCES) do
        --     inst.components.resistance:AddResistance(v)
        -- end

        -- inst:AddComponent("waterproofer")
        -- inst.components.waterproofer:SetEffectiveness(TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.WATERPROOF)

        -- inst:ListenForEvent('percentusedchange',onpercentusedchange)

        -- inst:AddComponent('shadowdominance')


        -- inst.OnSave = onsave 
        -- inst.OnLoad = onload
        -- inst.OnPreLoad = onpreload

        --MakeHauntableLaunch(inst)
        -- MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
        MakeSmallPropagator(inst)

        return inst
    end

    return Prefab(_prefab_id, fn, assets)

end


local function makeLiandryNomask()

    local _prefab_id = 'lol_wp_s17_liandry_nomask'
    local prefab_id = 'lol_wp_s17_liandry_nomask'

    local assets =
    {
        Asset("ANIM", "anim/"..prefab_id..".zip"),
        Asset("ATLAS", "images/inventoryimages/"..prefab_id..".xml"),

    }


    local function fn()
        ---@type ent|nil # 引用被装备的装备
        local equipped = nil
        ---@type Periodic|nil # 被动【受苦】佩戴时会每10秒受到5点真实伤害。
        local _task = nil

        ---comment
        ---@param owner ent
        ---@param data event_data_onhitother
        local function ownerAtk(owner,data)
            local target = data and data.target
            -- 概率点燃敌人, 不能重复点燃
            if equipped and equipped.components.rechargeable and equipped.components.rechargeable:IsCharged() then

                if target and LOLWP_S:checkAlive(target) and not target._flag_lol_wp_s17_liandry_burning then
                    -- if target.components.burnable then

                        equipped.components.rechargeable:Discharge(db.SKILL_TORMENT.CD)

                        -- 标记正在燃烧
                        target._flag_lol_wp_s17_liandry_burning = true

                        -- 触发点燃时的特效
                        local fx = SpawnPrefab('campfirefire')
                        local scale = 2
                        fx.Transform:SetScale(scale,scale,scale)
                        fx.AnimState:SetAddColour(1,1,1,1)
                        fx.entity:SetParent(target.entity)
                        fx.entity:AddFollower()
                        fx.Follower:FollowSymbol(target.GUID,nil,0,-105,0)

                        -- target.components.burnable.controlled_burn = {
                        --     duration_creature = 3,
                        --     damage = 0,
                        -- }
                        -- target.components.burnable:SpawnFX(nil)

                        -- for _,fx in pairs( target.components.burnable.fxchildren or {}) do
                        --     if fx:IsValid() and fx.AnimState then
                        --         fx.AnimState:SetAddColour(1,1,1,1)
                        --     end
                        -- end
                        -- target.components.burnable.controlled_burn = nil

                        if target.taskperiod_lol_wp_s17_liandry_burning == nil then
                            target.taskperiod_lol_wp_s17_liandry_burning = target:DoPeriodicTask(db.SKILL_TORMENT.INTERVAL,function ()
                                if LOLWP_S:checkAlive(target) then
                                    local tar_maxhp = target.components.health.maxhealth
                                    local planar_dmg = tar_maxhp * db.SKILL_TORMENT.MAXHP_PERCENT_PLANAR_DMG
                                    target.components.combat:GetAttacked(owner,0,nil,nil,{planar = planar_dmg})
                                end
                            end)
                        end

                        target:DoTaskInTime(db.SKILL_TORMENT.DURATION+db.SKILL_TORMENT.INTERVAL,function ()
                            if target then
                                -- 标记停止燃烧
                                target._flag_lol_wp_s17_liandry_burning = false
                                -- if target.components.burnable then
                                --     target.components.burnable:KillFX()
                                -- end
                                if fx and fx:IsValid() then
                                    fx:Remove()
                                end
                                if target.taskperiod_lol_wp_s17_liandry_burning then
                                    target.taskperiod_lol_wp_s17_liandry_burning:Cancel()
                                    target.taskperiod_lol_wp_s17_liandry_burning = nil
                                end
                            end
                        end)
                    -- end
                end
            end

        end

        ---comment
        ---@param inst ent
        ---@param owner ent
        local function onequip(inst, owner)
            local skin_build = inst:GetSkinBuild()

            if skin_build ~= nil then
                owner:PushEvent("equipskinneditem", inst:GetSkinName())
                owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, 'swap_hat', inst.GUID, prefab_id)
            else
                owner.AnimState:OverrideSymbol("swap_hat", prefab_id, "swap_hat")
            end

            owner.AnimState:Show("HAT")
            owner.AnimState:Show("HAIR_HAT")
            -- owner.AnimState:Hide("HAIR_NOHAT")
            -- owner.AnimState:Hide("HAIR")
            if owner:HasTag("player") then
                -- owner.AnimState:Hide("HEAD")
                owner.AnimState:Show("HEAD_HAT")
                owner.AnimState:Show("HEAD_HAT_NOHELM")
                -- owner.AnimState:Hide("HEAD_HAT_HELM")
            end

            equipped = inst
            owner:ListenForEvent('onhitother',ownerAtk)

            owner.lol_wp_s17_liandry_no_sleep = true

            if _task ~= nil then
                _task:Cancel()
                _task = nil
            end
            _task = owner:DoPeriodicTask(db.SKILL_SUFFER.INTERVAL,function()
                -- if owner and LOLWP_S:checkAlive(owner) then
                --     LOLWP_S:dealTrueDmg(db.SKILL_SUFFER.TRUE_DMG,owner)
                -- end
            end)


            if owner.components.lol_wp_player_dmg_adder then
                owner.components.lol_wp_player_dmg_adder:ModifierMult(inst,(1+db.SKILL_SUFFER.PLANAR_DMG),prefab_id,'planar')
                owner.components.lol_wp_player_dmg_adder:ModifierMult(inst,(1+db.SKILL_SUFFER.PLANAR_DMG),prefab_id,'physical')
            end

            inst.Light:Enable(true)
        end

        ---comment
        ---@param inst ent
        ---@param owner ent
        local function onunequip(inst, owner)
            owner.AnimState:ClearOverrideSymbol("headbase_hat")

            owner.AnimState:ClearOverrideSymbol("swap_hat")
            owner.AnimState:Hide("HAT")
            owner.AnimState:Hide("HAIR_HAT")
            owner.AnimState:Show("HAIR_NOHAT")
            owner.AnimState:Show("HAIR")

            if owner:HasTag("player") then
                owner.AnimState:Show("HEAD")
                owner.AnimState:Hide("HEAD_HAT")
                owner.AnimState:Hide("HEAD_HAT_NOHELM")
                owner.AnimState:Hide("HEAD_HAT_HELM")
            end

            equipped = nil
            owner:RemoveEventCallback('onhitother',ownerAtk)

            owner.lol_wp_s17_liandry_no_sleep = false

            if _task ~= nil then
                _task:Cancel()
                _task = nil
            end

            if owner.components.lol_wp_player_dmg_adder then
                owner.components.lol_wp_player_dmg_adder:RemoveModifierMult(inst,prefab_id,'planar')
                owner.components.lol_wp_player_dmg_adder:RemoveModifierMult(inst,prefab_id,'physical')
            end

            inst.Light:Enable(false)
        end

        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddLight()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(prefab_id)
        inst.AnimState:SetBuild(prefab_id)
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("wood")

        inst.foleysound = "dontstarve/movement/foley/logarmour"

        MakeInventoryFloatable(inst, "small", 0.2, 0.80)

        inst.entity:SetPristine()

        inst:AddTag('lunar_aligned')

        inst.Light:SetFalloff(.2)
        inst.Light:SetIntensity(.9)
        inst.Light:SetRadius(2)
        inst.Light:SetColour(239/255,255/255,255/255)
        inst.Light:Enable(false)

        -- inst:AddTag("shadowdominance")
        -- inst:AddTag("goggles")

        inst:AddTag('hide_percentage')

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = prefab_id
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..prefab_id..".xml"
        inst.components.inventoryitem:SetOnDroppedFn(function()
            inst.Light:Enable(true)
        end)
        inst.components.inventoryitem:SetOnPutInInventoryFn(function()
            inst.Light:Enable(false)
        end)

        inst:AddComponent("armor")
        inst.components.armor:InitIndestructible(db.ABSORB)

        inst:AddComponent("planardefense")
        inst.components.planardefense:SetBaseDefense(db.DEFEND_PLANAR)

        inst:AddComponent("equippable")
        inst.components.equippable.insulated = true
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.dapperness = db.WHEN_NOMASK.DARPPERNESS/54
        -- inst.components.equippable.is_magic_dapperness = true
        -- inst.components.equippable.dapperness = (TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.DARPPERNESS+TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.WHEN_MASKED.DARPPERNESS)/54

        -- inst:AddComponent("shadowlevel")
        -- inst.components.shadowlevel:SetDefaultLevel(TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.SHADOW_LEVEL)

        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetChargeTime(db.SKILL_TORMENT.CD)
        -- inst.components.rechargeable:SetOnDischargedFn(function(inst) end)
        -- inst.components.rechargeable:SetOnChargedFn(OnChargedFn)

        inst:AddComponent('lol_wp_s17_liandry_tf')

        -- inst:AddComponent("resistance")
        -- inst.components.resistance:SetShouldResistFn(ShouldResistFn)
        -- inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
        -- for i, v in ipairs(RESISTANCES) do
        --     inst.components.resistance:AddResistance(v)
        -- end

        -- inst:AddComponent("waterproofer")
        -- inst.components.waterproofer:SetEffectiveness(TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.WATERPROOF)

        -- inst:ListenForEvent('percentusedchange',onpercentusedchange)

        -- inst:AddComponent('shadowdominance')


        -- inst.OnSave = onsave 
        -- inst.OnLoad = onload
        -- inst.OnPreLoad = onpreload

        --MakeHauntableLaunch(inst)
        -- MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
        MakeSmallPropagator(inst)

        return inst
    end

    return Prefab(_prefab_id, fn, assets)

end

return makeLiandry(),makeLiandryNomask()