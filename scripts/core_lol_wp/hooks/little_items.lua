local modid = 'lol_wp'
local big_items = TUNING[string.upper('CONFIG_'..modid..'not_little_items_durability')]
local little_items = TUNING[string.upper('CONFIG_'..modid..'little_items_durability')]
local could_repair = TUNING[string.upper('CONFIG_'..modid..'could_repair')]
-- 
for k,v in pairs(TUNING.MOD_LOL_WP.little_items) do
    -- 如果是小件
    if v then
        AddPrefabPostInit(k,function (inst)


            inst:AddOrRemoveTag('nosteal',false)
            if not TheWorld.ismastersim then
                return inst
            end

            if inst.components.finiteuses ~= nil then
                local total = inst.components.finiteuses.total
                local new = total * little_items
                inst.components.finiteuses:SetMaxUses(new)
                inst.components.finiteuses:SetUses(new)
            elseif inst.components.fueled ~= nil then
                local maxfuel = inst.components.fueled.maxfuel
                local new = maxfuel * little_items
                inst.components.fueled:InitializeFuelLevel(new)
            elseif inst.components.armor ~= nil then
                local maxcondition = inst.components.armor.maxcondition
                local new = maxcondition * little_items
                inst.components.armor.condition = new
                inst.components.armor.maxcondition = new
            end

            if inst.components.finiteuses ~= nil then
                if could_repair == 4 then
                    function inst.components.finiteuses:Repair(...)
                        return false
                    end
                elseif could_repair == 3 then
                    function inst.components.finiteuses:Repair(...)
                        return false
                    end
                end
            end
            if inst.components.trader ~= nil then
                
            end
        end)
    else
        AddPrefabPostInit(k,function (inst)
            if big_items == 3 then
                inst:AddOrRemoveTag('hide_percentage',true)
            end

            inst:AddOrRemoveTag('nosteal',true)
            if not TheWorld.ismastersim then
                return inst
            end

            if big_items ~= 3 then
                if inst.components.finiteuses ~= nil then
                    local total = inst.components.finiteuses.total
                    local new = total * big_items
                    inst.components.finiteuses:SetMaxUses(new)
                    inst.components.finiteuses:SetUses(new)
                elseif inst.components.fueled ~= nil then
                    local maxfuel = inst.components.fueled.maxfuel
                    local new = maxfuel * big_items
                    inst.components.fueled:InitializeFuelLevel(new)
                elseif inst.components.armor ~= nil then
                    local maxcondition = inst.components.armor.maxcondition
                    local new = maxcondition * little_items
                    inst.components.armor.condition = new
                    inst.components.armor.maxcondition = new
                end
            else
                -- 如果无限耐久
                if inst.components.finiteuses ~= nil then
                    local old_SetUses = inst.components.finiteuses.SetUses
                    function inst.components.finiteuses:SetUses(val,...)
                        val = inst.components.finiteuses.total
                        return old_SetUses ~= nil and old_SetUses(self,val,...) or nil
                    end
                elseif inst.components.fueled ~= nil then
                    local old_DoDelta = inst.components.fueled.DoDelta
                    function inst.components.fueled:DoDelta(amount,...)
                        amount = 0
                        return old_DoDelta ~= nil and old_DoDelta(self,amount,...) or nil
                    end
                elseif inst.components.armor ~= nil then
                    local old_SetCondition = inst.components.armor.SetCondition
                    function inst.components.armor:SetCondition(amount,...)
                        amount = inst.components.armor.maxcondition
                        return old_SetCondition ~= nil and old_SetCondition(self,amount,...) or nil
                    end
                end
            end

            if inst.components.finiteuses ~= nil then
                if could_repair == 4 then
                    function inst.components.finiteuses:Repair(...)
                        return false
                    end
                elseif could_repair == 2 then
                    function inst.components.finiteuses:Repair(...)
                        return false
                    end
                end
            end

        end)
    end

end

-- 铁刺鞭，提亚马特，黑切，渴血，纳什，峡谷，挺进，
-- 添加设置：武器是否可修复：可修复/仅小件/仅大件/不可修复，默认可修复
-- 峡谷
---@source ../../lol_weapon_actions.lua:140
local _______see
-- 铁刺鞭
---@source ../../prefabs/gallop_whip.lua:338
local _______see
-- 提亚马特
---@source ../../prefabs/gallop_tiamat.lua:50
local _______see
-- 黑切 修复材料：噩梦燃料20%/纯粹恐惧100%
---@source ../../prefabs/gallop_blackcutter.lua:76
local _______see
-- 渴血 修复材料：噩梦燃料20%/纯粹恐惧100%' 和 铁刺鞭 在一块儿, 多看一眼都要爆炸
---@source ../../prefabs/gallop_whip.lua:338
local _______see
-- 纳什 修复材料：噩梦燃料20%，纯粹恐惧100%',
---@source ../../prefabs/nashor_tooth.lua:263
local _______see
-- 挺进
---@source ../../prefabs/gallop_ad_destroyer.lua:59
local _______see