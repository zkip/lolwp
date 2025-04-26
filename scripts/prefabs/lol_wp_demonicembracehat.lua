---@diagnostic disable: undefined-global, trailing-space
local prefab_id = 'lol_wp_demonicembracehat'

local assets =
{
    Asset("ANIM", "anim/"..prefab_id..".zip"),
    Asset("ANIM", "anim/"..prefab_id.."_nomask.zip"),
    Asset("ATLAS", "images/inventoryimages/"..prefab_id..".xml"),

    Asset("ANIM", "anim/"..prefab_id.."_skin_black_nerd.zip"),
    Asset("ANIM", "anim/"..prefab_id.."_skin_black_nerd_nomask.zip"),
    Asset("ATLAS", "images/inventoryimages/"..prefab_id.."_skin_black_nerd.xml"),

    Asset("ANIM", "anim/"..prefab_id.."_skin_confess.zip"),
    Asset("ANIM", "anim/"..prefab_id.."_skin_confess_nomask.zip"),
    Asset("ATLAS", "images/inventoryimages/"..prefab_id.."_skin_confess.xml"),
}

local function unequipItem(inst)
    if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner
        if owner ~= nil and owner.components.inventory ~= nil then
            local item = owner.components.inventory:Unequip(inst.components.equippable.equipslot)
            if item ~= nil then
                owner.components.inventory:GiveItem(item, nil, owner:GetPosition())
            end
        end
    end
end
---comment
---@param inst ent
---@param owner ent
local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()


    if inst.lol_wp_demonicembracehat_nomask then
        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build..'_nomask', 'swap_hat', inst.GUID, prefab_id..'_nomask')

            if skin_build == 'lol_wp_demonicembracehat_skin_black_nerd' or skin_build == 'lol_wp_demonicembracehat_skin_confess' then
                owner.AnimState:Show("HAT")
                owner.AnimState:Show("HAIR_HAT")
                owner.AnimState:Hide("HAIR_NOHAT")
                owner.AnimState:Hide("HAIR")
                if owner:HasTag("player") then
                    owner.AnimState:Hide("HEAD")
                    owner.AnimState:Show("HEAD_HAT")
                    owner.AnimState:Show("HEAD_HAT_NOHELM")
                    owner.AnimState:Hide("HEAD_HAT_HELM")

                    owner.AnimState:HideSymbol("face")
                    owner.AnimState:HideSymbol("swap_face")
                    owner.AnimState:HideSymbol("beard")
                    owner.AnimState:HideSymbol("cheeks")
                    owner.AnimState:HideSymbol("headbase")
                    owner.AnimState:HideSymbol("headbase_hat")
                    owner.AnimState:HideSymbol("hairfront")
                    owner.AnimState:HideSymbol("hairpigtails")
                    owner.AnimState:HideSymbol('hair_hat')
                    owner.AnimState:HideSymbol('hair')
                end
            else
                owner.AnimState:Show("HAT")
                owner.AnimState:Show("HAIR_HAT")
                owner.AnimState:Hide("HAIR_NOHAT")
                owner.AnimState:Hide("HAIR")
                if owner:HasTag("player") then
                    owner.AnimState:Hide("HEAD")
                    owner.AnimState:Show("HEAD_HAT")
                    owner.AnimState:Show("HEAD_HAT_NOHELM")
                    owner.AnimState:Hide("HEAD_HAT_HELM")
                end
            end
        else
            -- owner.AnimState:OverrideSymbol("swap_object", prefab_id, "swap_"..prefab_id)
            owner.AnimState:OverrideSymbol("swap_hat", prefab_id..'_nomask', "swap_hat")

            owner.AnimState:Show("HAT")
            owner.AnimState:Show("HAIR_HAT")
            owner.AnimState:Hide("HAIR_NOHAT")
            owner.AnimState:Hide("HAIR")
            if owner:HasTag("player") then
                owner.AnimState:Hide("HEAD")
                owner.AnimState:Show("HEAD_HAT")
                owner.AnimState:Show("HEAD_HAT_NOHELM")
                owner.AnimState:Hide("HEAD_HAT_HELM")
            end
        end

        -- owner.AnimState:OverrideSymbol("swap_hat", prefab_id..'_nomask', "swap_hat")
    else
        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, 'swap_hat', inst.GUID, prefab_id)

            if skin_build == 'lol_wp_demonicembracehat_skin_black_nerd' or skin_build == 'lol_wp_demonicembracehat_skin_confess' then
                owner.AnimState:Show("HAT")
                owner.AnimState:Show("HAIR_HAT")
                owner.AnimState:Hide("HAIR_NOHAT")
                owner.AnimState:Hide("HAIR")
                if owner:HasTag("player") then
                    owner.AnimState:Hide("HEAD")
                    owner.AnimState:Show("HEAD_HAT")
                    owner.AnimState:Show("HEAD_HAT_NOHELM")
                    owner.AnimState:Hide("HEAD_HAT_HELM")

                    owner.AnimState:HideSymbol("face")
                    owner.AnimState:HideSymbol("swap_face")
                    owner.AnimState:HideSymbol("beard")
                    owner.AnimState:HideSymbol("cheeks")
                    owner.AnimState:HideSymbol("headbase")
                    owner.AnimState:HideSymbol("headbase_hat")
                    owner.AnimState:HideSymbol("hairfront")
                    owner.AnimState:HideSymbol("hairpigtails")
                    owner.AnimState:HideSymbol('hair_hat')
                    owner.AnimState:HideSymbol('hair')
                end
            else
                owner.AnimState:Show("HAT")
                owner.AnimState:Show("HAIR_HAT")
                owner.AnimState:Hide("HAIR_NOHAT")
                owner.AnimState:Hide("HAIR")
                if owner:HasTag("player") then
                    owner.AnimState:Hide("HEAD")
                    owner.AnimState:Show("HEAD_HAT")
                    owner.AnimState:Show("HEAD_HAT_NOHELM")
                    owner.AnimState:Hide("HEAD_HAT_HELM")
                end
            end
        else
            -- owner.AnimState:OverrideSymbol("swap_object", prefab_id, "swap_"..prefab_id)
            owner.AnimState:OverrideSymbol("swap_hat", prefab_id, "swap_hat")

            owner.AnimState:Show("HAT")
            owner.AnimState:Show("HAIR_HAT")
            owner.AnimState:Hide("HAIR_NOHAT")
            owner.AnimState:Hide("HAIR")
            if owner:HasTag("player") then
                owner.AnimState:Hide("HEAD")
                owner.AnimState:Show("HEAD_HAT")
                owner.AnimState:Show("HEAD_HAT_NOHELM")
                owner.AnimState:Hide("HEAD_HAT_HELM")
            end
        end

        -- owner.AnimState:OverrideSymbol("swap_hat", prefab_id, "swap_hat")
    end
    



    if not inst.lol_wp_demonicembracehat_nomask then
        if owner.components.sanity ~= nil then
            owner.components.sanity:SetInducedInsanity(inst, true)
        end
    end

    inst.Light:Enable(true)
    
    -- inst:ListenForEvent("blocked", OnBlocked, owner)
    if not inst.lol_wp_demonicembracehat_nomask then
        if not owner:HasTag("shadowdominance") then
            owner:AddTag("shadowdominance")
        end
    end

end

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

        owner.AnimState:ShowSymbol("face")
        owner.AnimState:ShowSymbol("swap_face")
        owner.AnimState:ShowSymbol("beard")
        owner.AnimState:ShowSymbol("cheeks")
        owner.AnimState:ShowSymbol("headbase")
        owner.AnimState:ShowSymbol("headbase_hat")
        owner.AnimState:ShowSymbol("hairfront")
        owner.AnimState:ShowSymbol("hairpigtails")
        owner.AnimState:ShowSymbol('hair_hat')
        owner.AnimState:ShowSymbol('hair')
    end

    -- if not inst.lol_wp_demonicembracehat_nomask then
        if owner.components.sanity ~= nil then
            owner.components.sanity:SetInducedInsanity(inst, false)
        end
    -- end

    inst.Light:Enable(false)
    -- inst:RemoveEventCallback("blocked", OnBlocked, owner)
    if owner:HasTag("shadowdominance") then
        owner:RemoveTag("shadowdominance")
    end
end

local function onfinished(inst)
    unequipItem(inst)
    inst:AddTag(prefab_id..'_nofiniteuses')
end

local function onpercentusedchange(inst,data)
    if inst.lol_wp_demonicembracehat_regen_san == nil then
        inst.lol_wp_demonicembracehat_regen_san = inst:DoPeriodicTask(1,function()
            local cur_durability_percent = inst and inst:IsValid() and inst.components.armor and inst.components.armor:GetPercent()
            if cur_durability_percent then
                if cur_durability_percent >= 1 then
                    -- 耐久回满 掉san恢复正常
                    if inst.components.equippable then
                        inst.components.equippable.dapperness = TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.DARPPERNESS/54
                    end
    
                    if inst.lol_wp_demonicembracehat_regen_san then
                        inst.lol_wp_demonicembracehat_regen_san:Cancel()
                        inst.lol_wp_demonicembracehat_regen_san = nil
                    end
                else
                    -- 耐久不满
                    if inst.components.equippable then
                        inst.components.equippable.dapperness = (TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.DARPPERNESS-20)/54
                    end

                    if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
                        local owner = inst.components.inventoryitem.owner
                        local san_percent = owner and owner.components.sanity and owner.components.sanity:GetPercent()
                        if san_percent then
                            local delta = 840/(900+600*san_percent)
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

local function transfer(inst)
    local skin_build = inst:GetSkinBuild()

    -- 如果没有面具,转化为默认有面具
    if inst.lol_wp_demonicembracehat_nomask then
        inst.lol_wp_demonicembracehat_nomask = false

        -- 修改物品栏贴图
        if inst.components.inventoryitem then
            if skin_build ~= nil then
                inst.components.inventoryitem:ChangeImageName(skin_build)
            else
                inst.components.inventoryitem:ChangeImageName(prefab_id)
            end
            -- inst.components.inventoryitem:ChangeImageName(prefab_id)
        end
        -- 装备掉san
        if inst.components.equippable then
            inst.components.equippable.dapperness = (TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.DARPPERNESS+TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.WHEN_MASKED.DARPPERNESS)/54
        end
        -- anim
        if skin_build ~= nil then
            inst.AnimState:SetBank(skin_build)
            inst.AnimState:SetBuild(skin_build)
        else
            inst.AnimState:SetBank(prefab_id)
            inst.AnimState:SetBuild(prefab_id)
        end
        
        -- 护目镜
        if not inst:HasTag("goggles") then
            inst:AddTag("goggles")
        end
        inst:AddOrRemoveTag('nightvision',true)
        -- 装备时 通道改变
        if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem.owner
            if owner then
                if skin_build ~= nil then
                    owner.AnimState:OverrideSymbol("swap_hat", skin_build, "swap_hat")
                else
                    owner.AnimState:OverrideSymbol("swap_hat", prefab_id, "swap_hat")
                end
                -- owner.AnimState:OverrideSymbol("swap_hat", prefab_id, "swap_hat")
            end
            -- 装备时 是否陷入0san状态
            if owner and owner.components.sanity ~= nil then
                owner.components.sanity:SetInducedInsanity(inst, true)
            end

            if not owner:HasTag("shadowdominance") then
                owner:AddTag("shadowdominance")
            end
            -- 刷新装备
            local slot = inst.components.equippable.equipslot
            owner:PushEvent("unequip", {item=inst,eslot=slot})
            owner:PushEvent('equip', {item=inst,eslot=slot,no_animation=true})
        end

        

    else -- 转换为无面具形态
        inst.lol_wp_demonicembracehat_nomask = true
        -- 修改物品栏贴图
        if inst.components.inventoryitem then
            if skin_build ~= nil then
                inst.components.inventoryitem:ChangeImageName(skin_build..'_nomask')
            else
                inst.components.inventoryitem:ChangeImageName(prefab_id..'_nomask')
            end
            -- inst.components.inventoryitem:ChangeImageName(prefab_id..'_nomask')
        end
        -- 装备掉san
        if inst.components.equippable then
            inst.components.equippable.dapperness = (TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.DARPPERNESS)/54
        end
        -- anim
        if skin_build ~= nil then
            inst.AnimState:SetBank(skin_build..'_nomask')
            inst.AnimState:SetBuild(skin_build..'_nomask')
        else
            inst.AnimState:SetBank(prefab_id..'_nomask')
            inst.AnimState:SetBuild(prefab_id..'_nomask')
        end

        -- 护目镜
        if inst:HasTag("goggles") then
            inst:RemoveTag("goggles")
        end
        inst:AddOrRemoveTag('nightvision',false)
        -- 装备时 通道改变
        if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem.owner
            if owner then
                if skin_build ~= nil then
                    owner.AnimState:OverrideSymbol("swap_hat", skin_build..'_nomask', "swap_hat")
                else
                    owner.AnimState:OverrideSymbol("swap_hat", prefab_id..'_nomask', "swap_hat")
                end
            end
            -- 装备时 是否陷入0san状态
            if owner and owner.components.sanity ~= nil then
                owner.components.sanity:SetInducedInsanity(inst, false)
            end

            if owner:HasTag("shadowdominance") then
                owner:RemoveTag("shadowdominance")
            end
            -- 刷新装备
            local slot = inst.components.equippable.equipslot
            owner:PushEvent("unequip", {item=inst,eslot=slot})
            owner:PushEvent('equip', {item=inst,eslot=slot,no_animation=true})
            -- owner:PushEvent("gogglevision", { enabled = false })
        end

        
    end

end

local function onsave(inst, data)
    data.lol_wp_demonicembracehat_nomask = inst.lol_wp_demonicembracehat_nomask
end

local function onload(inst, data)
    inst.lol_wp_demonicembracehat_nomask = data and data.lol_wp_demonicembracehat_nomask ~= nil and data.lol_wp_demonicembracehat_nomask or false
    inst.lol_wp_demonicembracehat_nomask = not inst.lol_wp_demonicembracehat_nomask
    transfer(inst)
end

local function fn()
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

    inst:AddTag("shadow_item")

	--shadowlevel (from shadowlevel component) added to pristine state for optimization
	inst:AddTag("shadowlevel")

    inst.Light:SetFalloff(.2)
    inst.Light:SetIntensity(.9)
    inst.Light:SetRadius(TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.LIGHT_RADIUS)
    inst.Light:SetColour(239/255,69/255,255/255)
    inst.Light:Enable(false)

    inst:AddTag("waterproofer")

    inst:AddTag("lol_wp_demonicembracehat")

    -- inst:AddTag("shadowdominance")
    inst:AddTag("goggles")

    inst:AddOrRemoveTag('nightvision',true)

    if not TheWorld.ismastersim then
        return inst
    end

    -- flag
    inst.lol_wp_demonicembracehat_nomask = false

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..prefab_id..".xml"

    -- inst:AddComponent("fuel")
    -- inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.DURABILITY, TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.ABSORB)
    inst.components.armor:SetKeepOnFinished(true) -- 耐久用完保留
    inst.components.armor:SetOnFinished(onfinished)

    inst:AddComponent("planardefense")
    inst.components.planardefense:SetBaseDefense(TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.DEFEND_PLANAR)

    inst:AddComponent("equippable")
    inst.components.equippable.insulated = true
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.is_magic_dapperness = true
    inst.components.equippable.dapperness = (TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.DARPPERNESS+TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.WHEN_MASKED.DARPPERNESS)/54

    inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.SHADOW_LEVEL)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetChargeTime(TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.SKILL_STARE.CD)
    -- inst.components.rechargeable:SetOnDischargedFn(function(inst) end)
    -- inst.components.rechargeable:SetOnChargedFn(OnChargedFn)

    -- inst:AddComponent("resistance")
    -- inst.components.resistance:SetShouldResistFn(ShouldResistFn)
    -- inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
    -- for i, v in ipairs(RESISTANCES) do
    --     inst.components.resistance:AddResistance(v)
    -- end

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.MOD_LOL_WP.DEMONICEMBRACEHAT.WATERPROOF)

    inst:ListenForEvent('percentusedchange',onpercentusedchange)

    -- inst:AddComponent('shadowdominance')

    inst.fn_lol_wp_demonicembracehat_tf = transfer

    inst.OnSave = onsave 
    inst.OnLoad = onload
    -- inst.OnPreLoad = onpreload

    --MakeHauntableLaunch(inst)
    -- MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    return inst
end

return Prefab(prefab_id, fn, assets)
