---@diagnostic disable: lowercase-global, undefined-global, trailing-space

local modid = 'lol_wp' -- 定义唯一modid

---@type table<string,_equip_bgm_data>
local TBL_BGM = require('core_'..modid..'/data/bgm')

---@type table<string, string[]>
local eyestone_item_could_exist = require('core_'..modid..'/data/eyestone_item_could_exist')

local function removeItem(obj)
    if obj.components.stackable then
        obj.components.stackable:Get():Remove()
    else
        obj:Remove()
    end
end

---comment
---@param itm ent
---@param doer ent
local function unequipItemInEyeStone(itm,doer)
    local eyestone = itm.components.inventoryitem and itm.components.inventoryitem.owner
    if eyestone and eyestone.components.container then
        local slot = eyestone.components.container:GetItemSlot(itm)
        -- local unequipped_itm = eyestone.components.container:RemoveItemBySlot(slot)
        eyestone.components.container:DropItem(itm)

        if doer.components.inventory then
            doer.components.inventory:GiveItem(itm, nil, doer:GetPosition())
        end
    end
end

local function upequipItem(inst)
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

local function TouchFn(item)
	if item.components and item.components.lol_heartsteel_num then
		item.components.lol_heartsteel_num:TouchSound()
	end
end

---comment
---@param item ent
---@param doer ent
local function repairSound(item,doer)
    if doer and doer.SoundEmitter then
        local sound
        local prefab = item and item.prefab
        if prefab then
            if prefab == 'nightmarefuel' or prefab == 'horrorfuel' then
                sound = 'dontstarve/common/nightmareAddFuel'
            else
                sound = 'aqol/new_test/metal'
            end
        end
        if sound and doer.SoundEmitter then
            doer.SoundEmitter:PlaySound(sound)
        end
    end
end

---@type data_componentaction[]
local data = {
    -- 心之钢
    {
		id = "ACTION_LOL_HEARTSTEEL_TOUCH_ININV",
		str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_HEARTSTEEL_TOUCH,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil then
                TouchFn(act.invobject)
                return true
            else
				return false
			end
		end,
		state = "give",
		actiondata = {
			priority = 6,
			mount_valid = true,
		},
        type = "INVENTORY",
		component = "inventoryitem",
		testfn = function(inst,doer,actions,right)
            return doer:HasTag("player") and inst.prefab == 'lol_heartsteel' and inst.replica.equippable:IsEquipped()
        end,
	},
    {
		id = "ACTION_LOL_HEARTSTEEL_TOUCH_ONGROUND",
		str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_HEARTSTEEL_TOUCH,
		fn = function(act)
			if act.doer ~= nil and act.target ~= nil then
                TouchFn(act.target)
                return true
            else
				return false
			end
		end,
		state = "give",
		actiondata = {
			priority = 6,
			mount_valid = true,
		},
        type = "SCENE",
		component = "inventoryitem",
		testfn = function(inst,doer,actions,right)
            return right and doer:HasTag("player") and inst.prefab == 'lol_heartsteel'
        end,
	},
    ------------------------------------------
    --------------修理--------------------
    ------------------------------------------
    -- 修理 finiteuse
    {
        id = 'ACTION_LOL_WP_REPAIR',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_REPAIR,
        fn = function (act)
            if act.doer ~= nil and act.invobject ~= nil and act.target ~= nil then
                return (function (obj,tar,doer)
                    if tar.prefab and obj.prefab and tar.components.finiteuses then
                        local delta = TUNING.MOD_LOL_WP.REPAIR[string.upper(tar.prefab)] and TUNING.MOD_LOL_WP.REPAIR[string.upper(tar.prefab)][string.upper(obj.prefab)]
                        if delta then
                            -- 音效
                            repairSound(obj,tar)

                            local cur = tar.components.finiteuses:GetPercent()
                            local new = math.min(1,cur + delta)
                            tar.components.finiteuses:SetPercent(new)
                            removeItem(obj)

                            while obj and obj:IsValid() and (tar.components.finiteuses:GetPercent() + delta) <= 1 do
                                local _cur = tar.components.finiteuses:GetPercent()
                                local _new = math.min(1,_cur + delta)
                                tar.components.finiteuses:SetPercent(_new)
                                removeItem(obj)
                            end

                            -- lol_wp_divine_nofiniteuses
                            if tar:HasTag(tar.prefab..'_nofiniteuses') then
                                tar:RemoveTag(tar.prefab..'_nofiniteuses')
                            end
                            -- 推一个事件以便当物品在眼石中去监听
                            tar:PushEvent('lol_wp_repair')
                            return true
                        end
                    end
                    return false
                end)(act.invobject,act.target,act.doer)
            end
            return false
        end,
        state = 'give',
        actiondata = {
            mount_valid = true,
            priority = 6,
        },
        type = "USEITEM",
        component = 'inventoryitem',
        testfn = function (inst, doer, target, actions, right)
            if right and doer:HasTag("player") and target.prefab and TUNING.MOD_LOL_WP.REPAIR[string.upper(target.prefab)] then
                local res = TUNING[string.upper('CONFIG_'..modid..'could_repair')]
                if res == 4 then
                    return false
                elseif res == 1 then
                    local canrepair = inst and inst.prefab and TUNING.MOD_LOL_WP.REPAIR[string.upper(target.prefab)][string.upper(inst.prefab)]
                    if canrepair then
                        return true
                    end
                elseif res == 2 then
                    if TUNING.MOD_LOL_WP.little_items[target.prefab] then
                        local canrepair = inst and inst.prefab and TUNING.MOD_LOL_WP.REPAIR[string.upper(target.prefab)][string.upper(inst.prefab)]
                        if canrepair then
                            return true
                        end
                    end
                elseif res == 3 then
                    if not TUNING.MOD_LOL_WP.little_items[target.prefab] then
                        local canrepair = inst and inst.prefab and TUNING.MOD_LOL_WP.REPAIR[string.upper(target.prefab)][string.upper(inst.prefab)]
                        if canrepair then
                            return true
                        end
                    end
                end
            end
            return false
        end,
    },
    { -- 修理fuel
        id = 'ACTION_LOL_WP_REPAIR_FUEL',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_REPAIR,
        fn = function (act)
            if act.target and act.invobject then
                return (function (obj,tar,doer)
                    if obj.prefab and tar.prefab and tar.components.fueled then
                        local val = TUNING.MOD_LOL_WP.REPAIR_FUELED[string.upper(tar.prefab)] and TUNING.MOD_LOL_WP.REPAIR_FUELED[string.upper(tar.prefab)][string.upper(obj.prefab)]
                        if val then
                            -- 音效
                            repairSound(obj,tar)

                            local cur = tar.components.fueled:GetPercent()
                            local new = math.min(cur+val,1)
                            tar.components.fueled:SetPercent(new)
                            removeItem(obj)

                            while obj and obj:IsValid() and (tar.components.fueled:GetPercent() + val) <= 1 do
                                local _cur = tar.components.fueled:GetPercent()
                                local _new = math.min(1,_cur + val)
                                tar.components.fueled:SetPercent(_new)
                                removeItem(obj)
                            end

                            if tar:HasTag(tar.prefab..'_nofiniteuses') then
                                tar:RemoveTag(tar.prefab..'_nofiniteuses')
                            end
                            if tar.lol_wp_whentakefuel ~= nil then
                                tar.lol_wp_whentakefuel(tar)
                            end
                            if tar.components.equippable ~= nil and tar.components.equippable:IsEquipped() then
                                tar.components.fueled:StartConsuming()
                            end
                            return true
                        end
                    end
                    return false
                end)(act.invobject,act.target,act.doer)
            end
            return false
        end,
        state = "give",
        actiondata = {
            priority = 6,
            mount_valid = true,
        },
        type = "USEITEM",
        component = 'inventoryitem',
        testfn = function (inst, doer, target, actions, right)
            if right and doer:HasTag("player") and target.prefab and TUNING.MOD_LOL_WP.REPAIR_FUELED[string.upper(target.prefab)] then
                local res = TUNING[string.upper('CONFIG_'..modid..'could_repair')]
                if res == 4 then
                    return false
                elseif res == 1 then
                    local canrepair = inst and inst.prefab and TUNING.MOD_LOL_WP.REPAIR_FUELED[string.upper(target.prefab)][string.upper(inst.prefab)]
                    if canrepair then
                        return true
                    end
                elseif res == 2 then
                    if TUNING.MOD_LOL_WP.little_items[target.prefab] then
                        local canrepair = inst and inst.prefab and TUNING.MOD_LOL_WP.REPAIR_FUELED[string.upper(target.prefab)][string.upper(inst.prefab)]
                        if canrepair then
                            return true
                        end
                    end
                elseif res == 3 then
                    if not TUNING.MOD_LOL_WP.little_items[target.prefab] then
                        local canrepair = inst and inst.prefab and TUNING.MOD_LOL_WP.REPAIR_FUELED[string.upper(target.prefab)][string.upper(inst.prefab)]
                        if canrepair then
                            return true
                        end
                    end
                end
            end
            return false
        end
    },
    -- armor组件 修复
    {
        id = 'ACTION_LOL_WP_REPAIR_ARMOR_COMPO',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_REPAIR_ARMOR_COMPO,
        fn = function (act)
            if act.doer and act.doer:IsValid() and act.invobject and act.invobject:IsValid() and act.target and act.target:IsValid() then
                return (function (obj,tar,doer)
                    local cur_percent = tar.components.armor and tar.components.armor:GetPercent()
                    local repair_percent = obj and obj.prefab and TUNING.MOD_LOL_WP.REPAIR_ARMOR[string.upper(tar.prefab)][string.upper(obj.prefab)]
                    if cur_percent and repair_percent then
                        -- 音效
                        repairSound(obj,tar)
                         
                        local new_percent = math.min(cur_percent + repair_percent,1)
                        tar.components.armor:SetPercent(new_percent)
                        removeItem(obj)

                        while obj and obj:IsValid() and (tar.components.armor:GetPercent() + repair_percent) <= 1 do
                            local _cur = tar.components.armor:GetPercent()
                            local _new = math.min(1,_cur + repair_percent)
                            tar.components.armor:SetPercent(_new)
                            removeItem(obj)
                        end

                        if tar:HasTag(tar.prefab..'_nofiniteuses') then
                            tar:RemoveTag(tar.prefab..'_nofiniteuses')
                        end
                        return true
                    end
                    return false
                end)(act.invobject,act.target,act.doer)
            end
            return false
        end,
        state = 'give',
        actiondata = {
            mount_valid = true,
            priority = 6,
        },
        type = 'USEITEM',
        component = 'inventoryitem',
        testfn = function (inst, doer, target, actions, right)
            if doer:HasTag("player") and target.prefab and TUNING.MOD_LOL_WP.REPAIR_ARMOR[string.upper(target.prefab)] then
                local res = TUNING[string.upper('CONFIG_'..modid..'could_repair')]
                if res == 4 then
                    return false
                elseif res == 1 then
                    local canrepair = inst and inst.prefab and TUNING.MOD_LOL_WP.REPAIR_ARMOR[string.upper(target.prefab)][string.upper(inst.prefab)]
                    if canrepair then
                        return true
                    end
                elseif res == 2 then
                    if TUNING.MOD_LOL_WP.little_items[target.prefab] then
                        local canrepair = inst and inst.prefab and TUNING.MOD_LOL_WP.REPAIR_ARMOR[string.upper(target.prefab)][string.upper(inst.prefab)]
                        if canrepair then
                            return true
                        end
                    end
                elseif res == 3 then
                    if not TUNING.MOD_LOL_WP.little_items[target.prefab] then
                        local canrepair = inst and inst.prefab and TUNING.MOD_LOL_WP.REPAIR_ARMOR[string.upper(target.prefab)][string.upper(inst.prefab)]
                        if canrepair then
                            return true
                        end
                    end
                end
            end
            return false
        end
    },
    ------------------------------------------
    ------------------------------------------
    ------------------------------------------
    -- 神圣分离者 跳劈
    {
        id = 'ACTION_LOL_WP_DIVINE_BLOW',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_DIVINE_BLOW,
        fn = function (act)
            if act.doer and act.doer:IsValid() and act.invobject and act.invobject:IsValid() and act.target and act.target:IsValid() and act.target.components.combat and act.target.components.health and not act.target.components.health:IsDead() then

                return (function (wp,victim,attacker)
                    -- 标记正在放技能
                    wp.lol_wp_divine_isuseingholyskill = true

                    -- sec kill shadow 
                    if victim:HasTag("shadow_aligned") and not victim:HasTag("epic") and not victim:HasTag("chess") and victim.prefab and not string.find(victim.prefab,'shadowthrall_') then
                        victim.components.health:SetPercent(0,nil,attacker)
                    else
                        if attacker.components.combat and not attacker.components.combat:IsAlly(victim) then
                            local victim_maxhealth = victim.components.health.maxhealth
                            local panel_dmg = TUNING.MOD_LOL_WP.DIVINE.DMG
                            local bonus_dmg = victim_maxhealth * TUNING.MOD_LOL_WP.DIVINE.HOLY_DMG
                            local total_dmg = panel_dmg + bonus_dmg

                            victim.components.combat:GetAttacked(attacker,total_dmg,wp)
                        end
                    end
                    local v_x,v_y,v_z = victim:GetPosition():Get()
                    local fx_3 = SpawnPrefab('hammer_mjolnir_cracklebase')
                    -- local fx_2 = SpawnPrefab('cracklehitfx')
                    local fx = SpawnPrefab('fx_dock_pop')
                    fx.Transform:SetPosition(v_x,v_y,v_z)
                    -- fx_2.Transform:SetPosition(v_x,v_y,v_z)
                    fx_3.Transform:SetPosition(v_x,v_y,v_z)

                    -- fx_2:DoTaskInTime(.6,function (inst)
                    --     inst:Remove()
                    -- end)
                    -- 神圣打击回血
                    if not victim:HasTag("structure") and not victim:HasTag("wall") and attacker.components.health and not attacker.components.health:IsDead() then
                        attacker.components.health:DoDelta(TUNING.MOD_LOL_WP.DIVINE.HOLY_HEAL,nil,nil,true)
                    end
                    

                    wp:AddTag('lol_wp_divine_holy_iscd')
                    -- if wp.taskintime_lol_wp_divine_holy_cd == nil then
                    --     wp.taskintime_lol_wp_divine_holy_cd = wp:DoTaskInTime(TUNING.MOD_LOL_WP.DIVINE.HOLY_CD,function()
                    --         wp:RemoveTag('lol_wp_divine_holy_iscd')
                    --         if wp.taskintime_lol_wp_divine_holy_cd then wp.taskintime_lol_wp_divine_holy_cd:Cancel() wp.taskintime_lol_wp_divine_holy_cd = nil end
                    --     end)
                    -- end
                    wp.components.rechargeable:Discharge(TUNING.MOD_LOL_WP.DIVINE.HOLY_CD)

                    -- 标记结束
                    wp.lol_wp_divine_isuseingholyskill = false
                    return true
                end)(act.invobject,act.target,act.doer)
            end
            return false
        end,
        state = 'wisprain_helmsplitter',
        actiondata = {
            mount_valid = false,
            priority = 6,
            distance = 7.5,
        },
        type = 'EQUIPPED',
        component = 'inventoryitem',
        testfn = function (inst, doer, target, actions, right)
            if right and doer:HasTag("player") and inst.prefab == 'lol_wp_divine' and not inst:HasTag('lol_wp_divine_holy_iscd') then
                if not target:HasTag("player") and not target:HasTag("wall") and target.replica.health and not target.replica.health:IsDead() then
                    return true
                end
            end
            return false
        end,
        -- noclient = true,
    },
    -- 三项 转换成护符
    {
        id = 'ACTION_LOL_WP_TRINITY_TF',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_TRINITY_TF,
        fn = function (act)
            if act.doer and act.invobject then
                return (function (obj)
                    if obj.lol_wp_trinity_type == 'weapon' then
                        if obj.components.equippable then
                            upequipItem(obj)
                            obj.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
                            obj.lol_wp_trinity_type = 'amulet'
                            obj:AddTag('amulet')

                            if obj:HasTag('lol_wp_trinity_type_'..'weapon') then
                                obj:RemoveTag('lol_wp_trinity_type_'..'weapon')
                            end
                            obj:AddTag('lol_wp_trinity_type_'..'amulet')

                            obj.components.equippable.walkspeedmult = TUNING.MOD_LOL_WP.TRINITY.WALKSPEEDMULT
                            -- obj.components.equippable.dapperness = TUNING.MOD_LOL_WP.TRINITY.DARPPERNESS/54
                            return true
                        end
                    elseif obj.lol_wp_trinity_type == 'amulet' then
                        if obj.components.equippable then
                            upequipItem(obj)
                            obj.components.equippable.equipslot = EQUIPSLOTS.HANDS
                            obj.lol_wp_trinity_type = 'weapon'
                            obj:RemoveTag('amulet')

                            if obj:HasTag('lol_wp_trinity_type_'..'amulet') then
                                obj:RemoveTag('lol_wp_trinity_type_'..'amulet')
                            end
                            obj:AddTag('lol_wp_trinity_type_'..'weapon')

                            obj.components.equippable.walkspeedmult = 1
                            -- obj.components.equippable.dapperness = 0
                            return true
                        end
                    end
                    return false
                end)(act.invobject)
            end
            return false
        end,
        state = "give",
        actiondata = {
            mount_valid = true,
            priority = 6,
        },
        type = "INVENTORY",
        component = 'inventoryitem',
        testfn = function (inst, doer, actions, right)
            if doer:HasTag('player') and inst.prefab == 'lol_wp_trinity' and inst.replica.equippable and inst.replica.equippable:IsEquipped() then
                return true
            end
            
            return false
        end
    },
    -- 狂徒铠甲 主动：【真菌毒雾】
    {
        id = 'ACTION_LOL_WP_WARMOGARMOR_POISONFOG',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_WARMOGARMOR_POISONFOG,
        fn = function (act)
            if act.doer and act.doer:IsValid() and act.invobject and act.invobject:IsValid() then
                return (function (obj)
                    local x,_,z = obj:GetPosition():Get()
                    SpawnPrefab("sleepbomb_burst").Transform:SetPosition(x, 0, z)
                    SpawnPrefab("sleepcloud").Transform:SetPosition(x, 0, z)

                    obj:AddTag('lol_wp_warmogarmor_iscd')

                    obj.components.rechargeable:Discharge(TUNING.MOD_LOL_WP.WARMOGARMOR.SKILL_POISONFOG.CD)

                    if obj.components.armor then
                        local cur_condition = obj.components.armor.condition
                        local new_condition = math.max(0,cur_condition - TUNING.MOD_LOL_WP.WARMOGARMOR.SKILL_POISONFOG.CONSUME_FINITEUSE)
                        obj.components.armor:SetCondition(new_condition)
                    end
                    return true
                end)(act.invobject)
            end
            return false
        end,
        state = "give",
        actiondata = {
            mount_valid = false,
            priority = 6,
        },
        type = "INVENTORY",
        component = 'inventoryitem',
        testfn = function (inst, doer, actions, right)
            return doer:HasTag("player") and inst.prefab == 'lol_wp_warmogarmor' and not inst:HasTag('lol_wp_warmogarmor_iscd') and inst.replica.equippable and inst.replica.equippable:IsEquipped()
        end
    },
    -- 恶魔之拥  佩戴时右键可以切换头盔和面具形态
    {
        id = 'ACTION_LOL_WP_DEMONICEMBRACEHAT_TF',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_DEMONICEMBRACEHAT_TF,
        fn = function (act)
            if act.doer and act.doer:IsValid() and act.invobject and act.invobject:IsValid() then
                return (function (obj)
                    obj.fn_lol_wp_demonicembracehat_tf(obj)

                    return true
                end)(act.invobject)
            end
            return false
        end,
        state = "give",
        actiondata = {
            mount_valid = true,
            priority = 6,
        },
        type = "INVENTORY",
        component = 'inventoryitem',
        testfn = function (inst, doer, actions, right)
            return doer:HasTag("player") and inst.prefab == 'lol_wp_demonicembracehat' and inst.replica.equippable and inst.replica.equippable:IsEquipped()
        end
    },
    -- 萃取  主动：【收割】
    {
        id = 'ACTION_LOL_WP_S7_CULL_SCRAPE',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_S7_CULL_SCRAPE,
        fn = function (act)
            if act.doer and act.doer:IsValid() and act.invobject and act.invobject:IsValid() and act.target and act.target:IsValid() then
                return (function(obj,tar,doer)
                    if obj.DoScytheAsWp ~= nil then
                        obj:DoScytheAsWp(tar,doer)
                        return true
                    end
                    return false
                end)(act.invobject,act.target,act.doer)
            end
            return false
        end,
        state = 'scythe',
        actiondata = {
            mount_valid = false,
            priority = 6,
            distance = 1.2,
        },
        type = "EQUIPPED",
        component = 'inventoryitem',
        testfn = function (inst, doer, target, actions, right)
            return right and doer:HasTag('player') and inst.prefab == 'lol_wp_s7_cull' and not inst:HasTag('lol_wp_s7_cull_iscd') and target.replica.health ~= nil
        end
    },
    -- 当装备眼石时,眼石中的物品,右键卸下
    {
        id = 'ACTION_UNEQUIP_ITEM_IN_EYESTONE',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_UNEQUIP_ITEM_IN_EYESTONE,
        fn = function (act)
            local obj = act.invobject
            local doer = act.doer
            if obj and obj:IsValid() and doer and doer:IsValid() then
                if doer.components.inventory and not doer.components.inventory:IsFull() then
                    unequipItemInEyeStone(obj,doer)
                    return true
                end
            end
            return false
        end,
        state = "give",
        actiondata = {
            priority = 5,
            mount_valid = true,
        },
        type = 'INVENTORY',
        component = 'cangoineyestone',
        ---comment
        ---@param inst ent
        ---@param doer ent
        ---@param actions any
        ---@param right any
        ---@return unknown
        testfn = function (inst, doer, actions, right)
            -- 通常判断
            if doer:HasTag('player') and inst:HasTag('is_in_lol_wp_eyestone') and doer.replica.inventory and doer.replica.inventory:EquipHasTag('lol_wp_eyestone') and inst.prefab and not inst:HasTag(inst.prefab..'_nofiniteuses') then
                local allow = true
                -- 特殊判断 例如 多形态
                if inst.cangoineyestone and not inst.cangoineyestone(inst) then
                    allow = false
                end
                return allow
            end
            return false
        end
    },
    -- 让可变形态的装备能在眼石里变形态
    {
        id = 'ACTION_TRANSFER_ITEM_IN_EYESTONE',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_TRANSFER_ITEM_IN_EYESTONE,
        fn = function (act)
            local doer = act.doer
            local obj = act.invobject
            if doer and obj and doer:IsValid() and obj:IsValid() then
                if obj.components.lol_wp_amulet_transfer_in_eyestone then
                    return obj.components.lol_wp_amulet_transfer_in_eyestone:AmuletTransfer(obj.prefab,doer)
                end
            end
            return false
        end,
        state = "give",
        actiondata = {
            priority = 6,
            mount_valid = true,
        },
        type = 'INVENTORY',
        component = 'lol_wp_amulet_transfer_in_eyestone', -- 稍后替换成可变形的组件
        ---comment
        ---@param inst ent
        ---@param doer ent
        ---@param actions any
        ---@param right any
        ---@return unknown
        testfn = function (inst, doer, actions, right) -- 稍后添加可变形的判断
            return inst:HasTag('is_in_lol_wp_eyestone_also_equip') and doer.replica.inventory and doer.replica.inventory:EquipHasTag('lol_wp_eyestone')
        end
    },
    -- 当装备眼石时,右键物品栏的物品 装备到眼石
    {
        id = 'ACTION_EQUIP_ITEM_TO_EYESTONE',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_EQUIP_ITEM_TO_EYESTONE,
        fn = function (act)
            local tagprefix = 'lol_wp_s9_eyestone_'
            local success = true
            local obj = act.invobject
            local obj_prefab = obj and obj.prefab
            local doer = act.doer
            if obj and obj:IsValid() and doer and doer:IsValid() and obj_prefab then
                local equips,found = LOLWP_S:findEquipmentsWithKeywords(doer,'lol_wp_s9_eyestone')
                if found then
                    for _,eyestone in ipairs(equips) do
                        -- 眼石容量没满 才能装备
                        if eyestone.components.container and not eyestone.components.container:IsFull() then
                            -- 特殊要求 互斥物品
                            if eyestone_item_could_exist[obj_prefab] then
                                for _,negtive_prefab in ipairs(eyestone_item_could_exist[obj_prefab]) do
                                    if eyestone:HasTag(tagprefix..negtive_prefab) then
                                        success = false
                                        break
                                    end
                                end
                            end
                        end
                        if success then
                            if doer.components.inventory then
                                doer.components.inventory:DropItem(obj)
                            end
                            eyestone.components.container:GiveItem(obj, nil, doer:GetPosition())
                            return true
                        end
                    end
                end
            end
            return false
        end,
        state = "give",
        actiondata = {
            priority = 7,
            mount_valid = true,
        },
        type = "INVENTORY",
        component = 'cangoineyestone',
        ---comment
        ---@param inst ent
        ---@param doer ent
        ---@param actions any
        ---@param right any
        ---@return unknown
        testfn = function (inst, doer, actions, right)
            -- TODO: 请重新考虑是否能放入，仅无效即可？
            -- TODO: 另考虑优化判断没有耐久的逻辑
            local no_finite_uses = inst:HasTag(inst.prefab..'_nofiniteuses')
            -- 仅需要专属槽位的装备才能直接右键放到已装备的眼石中去。如果是需要其它槽位的话，需要优先考虑它所需的槽位，这符合使用习惯
            local is_lolwp_slot = LOLWP_S:isEquipSlot(inst, EQUIPSLOTS.LOL_WP)
            local need_cangoineeyestone =
                doer:HasTag('player') and not inst:HasTag('is_in_lol_wp_eyestone')
                and doer.replica.inventory and doer.replica.inventory:EquipHasTag('lol_wp_eyestone') and inst.prefab
                and not no_finite_uses
                and is_lolwp_slot
                
            -- 通常判断
            if need_cangoineeyestone then
                local allow = true
                -- 特殊判断 例如 多形态
                if inst.cangoineyestone and not inst.cangoineyestone(inst) then
                    allow = false
                end
                return allow
            end
            return false
        end
    },
    -- bgm 通用
    {
        id = 'ACTION_LOL_WP_BGM_MUTE',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_BGM_MUTE,
        fn = function (act)
            local equip = act.invobject
            local prefab = equip and equip.prefab
            if equip and prefab and equip:IsValid() and equip.SoundEmitter then
                if not equip['bgm_'..prefab] then
                    equip['bgm_'..prefab] = true
                    equip.SoundEmitter:SetVolume('bgm_' .. prefab,TBL_BGM[prefab].volume)
                else
                    equip['bgm_'..prefab] = false
                    equip.SoundEmitter:SetVolume('bgm_' .. prefab,0)
                end
                return true
            end 
            return false
        end,
        state = "give",
        actiondata = {
            priority = 6,
            mount_valid = true,
        },
        type = 'INVENTORY',
        component = 'lol_wp_bgm',
        ---comment
        ---@param inst ent  
        ---@param doer ent
        ---@param actions any
        ---@param right any
        testfn = function (inst, doer, actions, right)
            return TUNING[string.upper('CONFIG_'..modid..'lol_wp_bgm_whenequip')] and doer:HasTag('player') and inst.replica.equippable and inst.replica.equippable:IsEquipped()
        end
    },
    -- 读书
    {
        id = 'ACTIONS_LOL_WP_BOOK_READ',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTIONS_LOL_WP_BOOK_READ,
        fn = function (act)
            local book = act.invobject
            local reader = act.doer
            if book and reader and book:IsValid() and reader:IsValid() and book.components.book and reader.components.reader then
                if book.prefab and book.prefab == 'lol_wp_s11_amplifyingtome' then
                    local success, reason = reader.components.reader:Read(book)
                    return success
                end
            end
            return false
        end,
        state = 'book',
        actiondata = {
            mount_valid = false,
            priority = 7,
        },
        type = "INVENTORY",
        component = 'book',
        ---comment
        ---@param inst ent
        ---@param doer ent
        ---@param actions any
        ---@param right any
        testfn = function (inst, doer, actions, right)
            if not doer:HasTag("reader") then
                return false
            end
            if inst.prefab and inst.prefab == 'lol_wp_s11_amplifyingtome' then
                if inst.replica.equippable and inst.replica.equippable:IsEquipped() then
                    return true
                end
                if doer:HasTag('player') then
                    if inst:HasTag('is_in_lol_wp_eyestone_also_equip') then
                        return true
                    end
                end
            end
            return false
        end
    },
    -- 日炎圣盾 切换形态
    {
        id = 'ACTION_SUNFIRE_TRANSFORM',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_SUNFIRE_TRANSFORM,
        fn = function (act)
            local sunfire = act.invobject
            local player = act.doer
            if sunfire and player and sunfire:IsValid() and player:IsValid() and sunfire.components.armor and player.components.inventory then
                local prefab = sunfire.prefab
                local durability = sunfire.components.armor:GetPercent()
                local tf_to = prefab == 'lol_wp_s10_sunfireaegis' and 'lol_wp_s10_sunfireaegis_armor' or 'lol_wp_s10_sunfireaegis'
                local prod = SpawnPrefab(tf_to)
                if prod.components.armor then
                    prod.components.armor:SetPercent(durability)
                end
                LOLWP_S:unequipItem(sunfire)
                sunfire:Remove()
                player.components.inventory:GiveItem(prod)
                return true
            end
            return false
        end,
        state = "give",
        actiondata = {
            priority = 6,
            mount_valid = false,
        },
        type = 'INVENTORY',
        component = 'lol_wp_s10_sunfireaegis',
        ---comment
        ---@param inst ent
        ---@param doer ent
        ---@param actions any
        ---@param right any
        ---@return unknown
        testfn = function (inst, doer, actions, right)
            return doer:HasTag('player') and inst.replica.equippable and inst.replica.equippable:IsEquipped()
        end
    },
    ------------------------------------------
    ----------------S12---------------------
    ------------------------------------------
    -- 星蚀 
    {
        id = 'ACTION_LOL_WP_ECLIPSE_LEAP_LASER',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_ECLIPSE_LEAP_LASER,
        fn = function (act)
            local player = act.doer
            local weapon = act.invobject

            if weapon then
                weapon:AddTag('lol_wp_s12_eclipse'..'_iscd')
            end
            
            if player and weapon and player:IsValid() and weapon:IsValid() then
                if weapon.components.lol_wp_s12_eclipse_leap_laser then
                    local res = weapon.components.lol_wp_s12_eclipse_leap_laser:DoAction(player)
                    return res
                end
            end
            return false
        end,
        state = 'lol_wp_s12_eclipse_leap_laser',
        actiondata = {
            mount_valid = false,
            priority = 7,
            distance = 999,
            invalid_hold_action = true,
        },
        type = 'POINT',
        component = 'lol_wp_s12_eclipse_leap_laser',
        ---comment
        ---@param inst ent
        ---@param doer ent
        ---@param pos any
        ---@param actions any
        ---@param right any
        ---@return false
        testfn = function (inst, doer, pos, actions, right)
            if right then
                if not inst:HasTag('lol_wp_s12_eclipse'..'_iscd') then
                    -- if doer.components.playercontroller then
                    --     doer.components.playercontroller:ClearActionHold()
                    -- end
                    return true
                end
            end
            return false
        end
    },
    -- {
    --     id = 'ACTION_LOL_WP_ECLIPSE_LEAP_LASER',
    --     str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_ECLIPSE_LEAP_LASER,
    --     fn = function (act)
    --         local player = act.doer
    --         local weapon = act.invobject

    --         if weapon then
    --             weapon:AddTag('lol_wp_s12_eclipse'..'_iscd')
    --         end
            
    --         if player and weapon and player:IsValid() and weapon:IsValid() then
    --             if weapon.components.lol_wp_s12_eclipse_leap_laser then
    --                 local res = weapon.components.lol_wp_s12_eclipse_leap_laser:DoAction(player)
    --                 return res
    --             end
    --         end
    --         return false
    --     end,
    --     state = 'lol_wp_s12_eclipse_leap_laser',
    --     actiondata = {
    --         mount_valid = false,
    --         priority = 7,
    --         distance = 999,
    --         invalid_hold_action = true,
    --     },
    --     type = 'EQUIPPED',
    --     component = 'lol_wp_s12_eclipse_leap_laser',
    --     ---comment
    --     ---@param inst ent
    --     ---@param doer ent
    --     ---@param target ent
    --     ---@param actions any
    --     ---@param right any
    --     ---@return boolean
    --     testfn = function (inst, doer, target, actions, right)
    --         if right then
    --             if not inst:HasTag('lol_wp_s12_eclipse'..'_iscd') then
    --                 -- if doer.components.playercontroller then
    --                 --     doer.components.playercontroller:ClearActionHold()
    --                 -- end
    --                 if target:HasTag('structure') then
    --                     return false
    --                 end
    --                 return true
    --             end
    --         end
    --         return false
    --     end
    -- },
    ------------------------------------------
    ----------------S13---------------------
    ------------------------------------------
    -- 斯塔缇克电刃 使用武器左键点击避雷针和发电机可以修复100%耐久，并消耗其1格充能/电量
    {
        id = 'ACTION_LOL_WP_S13_INFINITY_EDGE_ACTIVE_REPAIR',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_S13_INFINITY_EDGE_ACTIVE_REPAIR,
        fn = function (act)
            local target = act.target
            local wp = act.invobject
            if target and target:IsValid() and wp and wp:IsValid() and wp.components.lol_wp_s13_infinity_edge_active_repair then
                return wp.components.lol_wp_s13_infinity_edge_active_repair:Main(target) 
            end
            return false
        end,
        state = "give",
        actiondata = {
            mount_valid = true,
            priority = 7,
        },
        type = "EQUIPPED",
        component = 'lol_wp_s13_infinity_edge_active_repair',
        ---comment
        ---@param inst ent
        ---@param doer ent
        ---@param target ent
        ---@param actions any
        ---@param right any
        ---@return unknown
        testfn = function (inst, doer, target, actions, right)
            return target and target.prefab and (target.prefab == 'lightning_rod' or target.prefab == "winona_battery_low" or target.prefab == 'winona_battery_high')
        end
    },
    -- 无尽之力 装备后右键可以转换成护符物品
    {
        id = 'ACTION_LOL_WP_S13_INFINITY_EDGE_TF',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_S13_INFINITY_EDGE_TF,
        fn = function (act)
            local doer = act.doer
            local obj = act.invobject
            if doer and obj and doer:IsValid() and obj:IsValid() and obj.components.lol_wp_s13_infinity_edge_transform then
                return obj.components.lol_wp_s13_infinity_edge_transform:Transform(doer)
            end
            return false
        end,
        state = "give",
        actiondata = {
            mount_valid = true,
            priority = 6,
        },
        type = "INVENTORY",
        component = 'lol_wp_s13_infinity_edge_transform',
        ---comment
        ---@param inst ent
        ---@param doer ent
        ---@param actions any
        ---@param right any
        ---@return unknown
        testfn = function (inst, doer, actions, right)
            return inst and inst.replica.equippable and inst.replica.equippable:IsEquipped()
        end
    },
    ------------------------------------------
    ----------------S15---------------------
    ------------------------------------------
    -- {
    --     id = 'ACTION_STOPWATCH_FOOTPRINT_TB',
    --     str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_STOPWATCH_FOOTPRINT_TB,
    --     fn = function (act)
    --         local doer = act.doer
    --         local obj = act.invobject
    --         if doer and obj and doer:IsValid() and obj:IsValid() and doer.components.lol_wp_player_footprint_traceback then
    --             local res = doer.components.lol_wp_player_footprint_traceback:TraceBack()
    --             if res then
    --                 if obj.components.rechargeable then
    --                     obj.components.rechargeable:Discharge(TUNING.MOD_LOL_WP.STOPWATCH.SKILL_TRACEBACK.CD)
    --                 end
    --             end
    --             return res
    --         end
    --         return false
    --     end,
    --     state = 'lol_wp_pocketwatch_warpback_pre',
    --     actiondata = {
    --         mount_valid = false,
    --         priority = 7,
    --     },
    --     type = 'INVENTORY',
    --     component = 'lol_wp_allow_footprint_traceback',
    --     ---comment
    --     ---@param inst ent
    --     ---@param doer ent
    --     ---@param actions any
    --     ---@param right any
    --     ---@return unknown
    --     testfn = function (inst, doer, actions, right)
    --         return not inst:HasTag('lol_wp_s15_stopwatch_iscd') and doer and doer.prefab and doer.prefab ~= 'wanda'
    --     end
    -- }
    -- {
    --     id = 'ACTION_STOPWATCH_FOOTPRINT_TB',
    --     str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_STOPWATCH_FOOTPRINT_TB,
    --     fn = function (act)
    --         local caster = act.doer
    --         if act.invobject ~= nil and caster ~= nil and not caster:HasTag("pocketwatchcaster") and act.invobject:HasTag('pocketwatch_lol_wp') then
    --             return act.invobject.components.pocketwatch:CastSpell(caster, act.target, act:GetActionPoint())
    --         end
    --         return false
    --     end,
    --     state = 'pocketwatch_warpback_pre',
    --     actiondata = {
    --         mount_valid = false,
    --         priority = 7,
    --     },
    --     type = 'INVENTORY',
    --     component = 'pocketwatch',
    --     testfn = function (inst, doer, actions, right)
    --         if inst:HasTag("pocketwatch_inactive") and not doer:HasTag("pocketwatchcaster") and inst:HasTag("pocketwatch_castfrominventory") then
	-- 			if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) or inst:HasTag("pocketwatch_mountedcast") then
    --                 if not inst:HasTag('lol_wp_s15_stopwatch_iscd') and inst:HasTag('pocketwatch_lol_wp') then
    --                     return true
    --                 end
	-- 			end
    --         end
    --         return false
    --     end
    -- }
    -- 中娅沙漏 主动：【凝滞】   在3秒内免疫所有伤
    {
        id = 'ACTION_LOL_WP_S15_ZHONYA_FREEZE',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_S15_ZHONYA_FREEZE,
        fn = function (act)
            local obj = act.invobject
            local doer = act.doer
            if obj and doer and obj:IsValid() and doer:IsValid() and obj.components.lol_wp_s15_zhonya then
                return obj.components.lol_wp_s15_zhonya:DoAction(doer)
            end
            return false
        end,
        state = "lol_wp_blank_sg",
        actiondata = {
            mount_valid = false,
            priority = 7,
        },
        type = 'INVENTORY',
        component = 'lol_wp_s15_zhonya',
        ---comment
        ---@param inst ent
        ---@param doer ent
        ---@param actions any
        ---@param right any
        ---@return boolean
        testfn = function (inst, doer, actions, right)
            return not inst:HasTag('lol_wp_s15_zhonya_iscd') and (inst:HasTag('is_in_lol_wp_eyestone_also_equip') or (inst.replica.equippable and inst.replica.equippable:IsEquipped()))
        end
    },
    ------------------------------------------
    ----------------S16---------------------
    ------------------------------------------
    -- 喝药
    {
        id = 'ACTION_LOL_WP_S16_DRINK_POTION',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_S16_DRINK_POTION,
        fn = function (act)
            local drinker = act.doer
            local potion = act.invobject
            if drinker and potion and drinker:IsValid() and potion:IsValid() and drinker.components.lol_wp_potion_drinker then
                return drinker.components.lol_wp_potion_drinker:Drink(potion)
            end
            return false
        end,
        state = 'quickeat',
        actiondata = {
            mount_valid = false,
            priority = 7,
        },
        type = 'INVENTORY',
        component = 'lol_wp_potion_drinkable',
        testfn = function (inst, doer, actions, right)
            return doer.replica.lol_wp_potion_drinker ~= nil and doer.replica.lol_wp_potion_drinker:CanDrink(inst)
        end
    },
    ------------------------------------------
    ----------------S17---------------------
    ------------------------------------------
    -- 卢登的回声 奥术跃迁
    {
        id = 'ACTIONS_LOL_WP_S17_LUDEN_TELE',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTIONS_LOL_WP_S17_LUDEN_TELE,
        fn = function (act)
            local doer = act.doer
            local pt = act:GetActionPoint()
            local staff = act.invobject
            if doer and pt and staff and doer:IsValid() and staff:IsValid() and staff.components.lol_wp_s17_luden_tele then
                return staff.components.lol_wp_s17_luden_tele:Tele(doer,pt)
            end
            return false
        end,
        state = 'quickcastspell',
        actiondata = {
            mount_valid = false,
            priority = 7,
            invalid_hold_action = true,
            distance = TUNING.MOD_LOL_WP.LUDEN.SKILL_ARCANE_TELE.DISTANCE,
        },
        type = "POINT",
        component = "lol_wp_s17_luden_tele",
        testfn = function (inst, doer, pos, actions, right)
            return right and doer:HasTag('player') and not inst:HasTag('lol_wp_s17_luden_nofiniteuses')
        end
    },
    -- 面具 切换
    {
        id = 'ACTION_S17_LIANDRY_TF',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_S17_LIANDRY_TF,
        fn = function (act)
            local doer = act.doer
            local wp = act.invobject
            if doer and wp and doer:IsValid() and wp:IsValid() and wp.components.lol_wp_s17_liandry_tf then
                return wp.components.lol_wp_s17_liandry_tf:TF(doer)
            end
            return false
        end,
        state = "give",
        actiondata = {
            mount_valid = true,
            priority = 6,
        },
        type = "INVENTORY",
        component = 'lol_wp_s17_liandry_tf',
        ---comment
        ---@param inst ent
        ---@param doer ent
        ---@param actions any
        ---@param right any
        testfn = function (inst, doer, actions, right)
            return inst.replica.equippable and inst.replica.equippable:IsEquipped()
        end
    },
    ------------------------------------------
    ----------------S18---------------------
    ------------------------------------------
    {
        id = 'ACTION_LOL_WP_S18_STORMRAZOR_NOSAYA_TF',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_S18_STORMRAZOR_NOSAYA_TF,
        fn = function (act)
            local doer = act.doer
            local wp = act.invobject
            if doer and wp and doer:IsValid() and wp:IsValid() and wp.components.lol_wp_s18_stormrazor_tf then
                return wp.components.lol_wp_s18_stormrazor_tf:DoTF(doer)
            end
            return false
        end,
        state = "give",
        actiondata = {
            mount_valid = true,
            priority = 7,
        },
        type = 'INVENTORY',
        component = 'lol_wp_s18_stormrazor_tf',
        ---comment
        ---@param inst ent
        ---@param doer ent
        ---@param actions any
        ---@param right any
        testfn = function (inst, doer, actions, right)
            return inst.prefab and inst.prefab == 'lol_wp_s18_stormrazor' and inst.replica.equippable and inst.replica.equippable:IsEquipped()
        end
    },
    {
        id = 'ACTION_LOL_WP_S18_STORMRAZOR_TORNADO',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_S18_STORMRAZOR_TORNADO,
        fn = function (act)
            local doer = act.doer
            local wp = act.invobject
            local tar = act.target
            if doer and wp and tar and doer:IsValid() and wp:IsValid() and tar:IsValid() and wp.components.lol_wp_s18_stormrazor_tornado then
                return wp.components.lol_wp_s18_stormrazor_tornado:CastTornado(wp,doer,tar)
            end
            return false
        end,
        state = 'attack',
        actiondata = {
            mount_valid = false,
            priority = 7,
            distance = 10,
        },
        type = "EQUIPPED",
        component = 'lol_wp_s18_stormrazor_tornado',
        ---comment
        ---@param inst ent
        ---@param doer ent
        ---@param target ent
        ---@param actions any
        ---@param right any
        testfn = function (inst, doer, target, actions, right)
            return right and inst.replica.lol_wp_cd_itemtile and not inst.replica.lol_wp_cd_itemtile:IsCD() and not target:HasTag('player')
        end
    },
    ------------------------------------------
    ----------------S19---------------------
    ------------------------------------------
    -- 女神泪升级的武器,满层后,给物品升级
    {
        id = 'ACTION_TEARS_ITEMS_UPGRADE',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_TEARS_ITEMS_UPGRADE,
        fn = function (act)
            local doer = act.doer
            local item = act.invobject
            local wp = act.target
            if doer and item and wp and doer:IsValid() and item:IsValid() and wp:IsValid() then
                local upgrade_to = wp.components.count_from_tearsofgoddness and wp.components.count_from_tearsofgoddness.upgrade_to
                if upgrade_to then
                    local new_wp = SpawnPrefab(upgrade_to)
                    wp:Remove()
                    if doer.components.inventory then
                        doer.components.inventory:GiveItem(new_wp)
                    end
                    LOLWP_S:consumeOneItem(item)
                    return true
                end
            end
            return false
        end,
        state = 'give',
        actiondata = {
            mount_valid = true,
            priority = 6,
        },
        type = "USEITEM",
        component = 'inventoryitem',
        testfn = function (inst, doer, target, actions, right)
            return inst.prefab == "alterguardianhatshard" and target.replica.count_from_tearsofgoddness and target.replica.count_from_tearsofgoddness:IsMax()
        end
    }


   --[[  -- 星蚀 右键开指示器
    {
        id = 'ACTION_LOL_WP_ECLIPSE_LEAP_LASER_CAST',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_ECLIPSE_LEAP_LASER_CAST,
        fn = function (act)
            local weapon = act.invobject
            if weapon and weapon:IsValid() then
                weapon:AddTag('lol_wp_s12_eclipse'..'circle')
                return true
            end
            return false
        end,
        state = 'lol_wp_blank_sg',
        actiondata = {
            mount_valid = false,
            priority = 7,
            distance = 999,
        },
        type = 'POINT',
        component = "lol_wp_s12_eclipse_leap_laser",
        testfn = function (inst, doer, pos, actions, right)
            return right and not inst:HasTag('lol_wp_s12_eclipse'..'_iscd') and not inst:HasTag('lol_wp_s12_eclipse'..'circle')
        end
    },
    -- 星蚀 出指示器并且释放主技能
    {
        id = 'ACTION_LOL_WP_ECLIPSE_LEAP_LASER_CONFIRM',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_ECLIPSE_LEAP_LASER_CONFIRM,
        fn = function (act)
            local player = act.doer
            local weapon = act.invobject
            if player and weapon and player:IsValid() and weapon:IsValid() then
                if weapon.components.lol_wp_s12_eclipse_leap_laser then
                    weapon:RemoveTag('lol_wp_s12_eclipse'..'circle')
                    return weapon.components.lol_wp_s12_eclipse_leap_laser:DoAction(player)
                end
            end
            return false
        end,
        state = 'lol_wp_s12_eclipse_leap_laser',
        actiondata = {
            mount_valid = false,
            priority = 7,
            distance = 999,
        },
        type = "POINT",
        component = 'lol_wp_s12_eclipse_leap_laser',
        ---comment
        ---@param inst ent
        ---@param doer ent
        ---@param pos any
        ---@param actions any
        ---@param right any
        testfn = function (inst, doer, pos, actions, right)
            if not right then
                if inst:HasTag('lol_wp_s12_eclipse'..'circle') then
                    local x,_,z = ConsoleWorldPosition():Get()
                    local px,_,pz = doer:GetPosition():Get()
                    if inst.lol_wp_s12_eclipse_circle == nil or not inst.lol_wp_s12_eclipse_circle:IsValid() then
                        inst.lol_wp_s12_eclipse_circle = SpawnPrefab('reticuleline')
                    end
                    if inst.lol_wp_s12_eclipse_circle and inst.lol_wp_s12_eclipse_circle:IsValid() then
                        inst.lol_wp_s12_eclipse_circle:ForceFacePoint(x,0,z)
                        inst.lol_wp_s12_eclipse_circle.Transform:SetPosition(px,0,pz)
                    end
                    return true
                else
                    if inst.lol_wp_s12_eclipse_circle and inst.lol_wp_s12_eclipse_circle:IsValid() then
                        inst.lol_wp_s12_eclipse_circle:Remove()
                        inst.lol_wp_s12_eclipse_circle = nil
                    end 
                end
            end
            return false
        end
    },
    -- 星蚀 取消
    {
        id = 'ACTION_LOL_WP_ECLIPSE_LEAP_LASER_CANCEL',
        str = STRINGS.MOD_LOL_WP.ACTIONS.ACTION_LOL_WP_ECLIPSE_LEAP_LASER_CANCEL,
        fn = function (act)
            local weapon = act.invobject
            if weapon and weapon:IsValid() then
                weapon:RemoveTag('lol_wp_s12_eclipse'..'circle')
                return true
            end
            return false
        end,
        state = 'lol_wp_blank_sg',
        actiondata = {
            mount_valid = false,
            priority = 7,
            distance = 999,
        },
        type = 'POINT',
        component = 'lol_wp_s12_eclipse_leap_laser',
        testfn = function (inst, doer, pos, actions, right)
            if right then
                if inst:HasTag('lol_wp_s12_eclipse'..'circle') then
                    return true
                end
            end
            return false
        end
    }
  ]]

    -- test
    -- {
    --     id = 'ACTION_LOL_WP_TEST',
    --     str = '沟槽的灵魂跳跃',
    --     fn = function (act)
    --         return (function ()
    --             TheNet:Announce('do action')
    --             return true
    --         end)()
    --     end,
    --     state = "give",
    --     actiondata = {
    --         mount_valid = false,
    --         priority = 10,
    --         distance = 10,
    --     },
    --     type = 'POINT',
    --     component = 'inventoryitem',
    --     testfn = function (inst, doer, pos, actions, right)
    --         return doer:HasTag('player') and inst.prefab == 'lol_wp_s7_doranblade'
    --     end
    -- }

}

---@type data_componentaction_change[]
local change = {
    {
        type = 'INVENTORY',
        component = 'pocketwatch',
        testfn = function (old_testfn, inst, doer, actions, right,...)
            if old_testfn ~= nil then
                old_testfn(inst, doer, actions, right,...)
            end
            if inst:HasTag("pocketwatch_inactive") and not doer:HasTag("pocketwatchcaster") and inst:HasTag("pocketwatch_castfrominventory") and inst.prefab == 'lol_wp_s15_stopwatch' then
				if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) or inst:HasTag("pocketwatch_mountedcast") then
	                table.insert(actions, ACTIONS.CAST_POCKETWATCH)
				end
            end
        end
    }
}

return data,change

