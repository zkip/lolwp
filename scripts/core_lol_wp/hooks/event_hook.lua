

---@class hook_event_sg
---@field fn fun(equips_map: table<string, ent>,player: ent):boolean
---@field client_fn fun(inst: ent)|nil

---@type table<eventID, table<string, hook_event_sg>>
local allevents = {
    ['attacked'] = {
        overlordbloodarmor_and_demonicembracehat = { -- 恶魔之拥和霸王血铠同时装备时触发套装效果：免疫击飞和硬直。
            fn =  function (equips_map,player)
                if equips_map['lol_wp_overlordbloodarmor'] and equips_map['lol_wp_demonicembracehat'] then
                    return true
                end
                return false
            end,
            client_fn = function (inst)
                if inst and inst.HUD and inst.HUD.bloodover then
                    inst.HUD.bloodover:Flash()
                end
            end
        }
    },
    ['knockback'] = {
        lol_wp_warmogarmor = { -- 狂徒加一个免疫击飞和硬直的功能 lol_wp_warmogarmor
            fn = function (equips_map,player)
                if equips_map['lol_wp_warmogarmor'] then
                    return true
                end
                return false
            end,
            client_fn = function (inst)
                if inst and inst.HUD and inst.HUD.bloodover then
                    inst.HUD.bloodover:Flash()
                end
            end
        },
        overlordbloodarmor_and_demonicembracehat = { -- 恶魔之拥和霸王血铠同时装备时触发套装效果：免疫击飞和硬直。
            fn =  function (equips_map,player)
                if equips_map['lol_wp_overlordbloodarmor'] and equips_map['lol_wp_demonicembracehat'] then
                    return true
                end
                return false
            end,
            client_fn = function (inst)
                if inst and inst.HUD and inst.HUD.bloodover then
                    inst.HUD.bloodover:Flash()
                end
            end
        },
        lol_wp_s19_fimbulwinter_armor = { -- 凛冬之临 疫击飞效果
            fn = function (equips_map,player)
                if equips_map['lol_wp_s19_fimbulwinter_armor'] or equips_map['lol_wp_s19_fimbulwinter_armor_upgrade'] then
                    return true
                end
                return false
            end,
            client_fn = function (inst)
                if inst and inst.HUD and inst.HUD.bloodover then
                    inst.HUD.bloodover:Flash()
                end
            end
        },
    },
    ['knockedout'] = {
        lol_wp_s17_liandry = {
            fn = function (equips_map, player)
                if equips_map['lol_wp_s17_liandry'] and player.lol_wp_s17_liandry_no_sleep then
                    return true
                end
                return false
            end
        }
    },
    ['freeze'] = {
        lol_wp_s19_fimbulwinter_armor_upgrade = { -- 凛冬之临 疫击飞效果
            fn = function (equips_map,player)
                if equips_map['lol_wp_s19_fimbulwinter_armor_upgrade'] then
                    return true
                end
                return false
            end,
        },
    },

    -- ['startfiredamage'] = true,
    -- ['firedamage'] = true,
}

AddPlayerPostInit(function (inst)
    inst:ListenForEvent('lol_wp_event_triggered',function ()
        if inst == ThePlayer and inst.replica.lol_wp_event_trigger then
            local event_name = inst.replica.lol_wp_event_trigger:GetEventName() or ''
            if event_name == '' then
                return
            end
            local type = inst.replica.lol_wp_event_trigger:GetType() or ''
            if type == '' then
                return
            end
            local fn = allevents[event_name] and allevents[event_name][type] and allevents[event_name][type].client_fn
            if fn then
                fn(inst)
            end
        end
    end)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent('lol_wp_event_trigger')
end)

local old_PushEvent = EntityScript.PushEvent
function EntityScript:PushEvent(event,data,...)
    -- 筛选事件
    if allevents[event] then
        if self and self.prefab == 'moonstorm_static' then
            return
        end

        -- 筛选player
        if self and self.components.lol_wp_event_trigger then
            local type -- 被哪个type拦了
            -- hook
            local allow = true
            local equips = LOLWP_S:getAllEquipments(self)
            for k,rule in pairs(allevents[event]) do
                if rule.fn and rule.fn(equips,self) then
                    allow = false
                    type = k
                    break
                end
            end
            -- 如果被拦了
            if not allow then
                -- 判断是否有type
                if type then
                    -- 传递数据
                    self.components.lol_wp_event_trigger:Push(event,type)
                end
                return
            end
        end
    end
    return old_PushEvent(self,event,data,...)
end

local old_HandleEvent = State.HandleEvent
function State:HandleEvent(sg,eventame,data,...)
    ---@type ent
    local inst = self.inst
    if allevents[sg] then

        if inst and inst.prefab == 'moonstorm_static' then
            return
        end

        if inst and inst.components.lol_wp_event_trigger then
            local allow = true
            local equips = LOLWP_S:getAllEquipments(inst)
            for k,rule in pairs(allevents[sg]) do
                if rule.fn and rule.fn(equips,inst) then
                    allow = false
                    break
                end
            end
            if not allow then
                return
            end
        end
    end
    return old_HandleEvent(self,sg,eventame,data,...)
end