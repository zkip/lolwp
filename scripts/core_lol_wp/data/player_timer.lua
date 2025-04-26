---@alias player_timer_rechargeable_prefab # 玩家cd: `rechargeable` 组别 有哪些prefab
---| 'alchemy_chainsaw'
---| 'crystal_scepter'
---| 'gallop_ad_destroyer'
---| 'gallop_blackcutter'
---| 'gallop_breaker'
---| 'gallop_brokenking'
---| 'gallop_hydra'
---| 'gallop_tiamat'
---| 'gallop_bloodaxe'
---| 'lol_wp_demonicembracehat'
---| 'lol_wp_divine'
---| 'lol_wp_overlordbloodarmor'
---| 'lol_wp_s7_cull'
---| 'lol_wp_s7_doranshield'
---| 'lol_wp_s7_tearsofgoddess'
---| 'lol_wp_s8_lichbane'
---| 'lol_wp_s9_guider'
---| 'lol_wp_s10_guinsoo'
---| 'lol_wp_s10_sunfireaegis'
---| 'lol_wp_s12_malignance'
---| 'lol_wp_s13_statikk_shiv'
---| 'lol_wp_s15_crown_of_the_shattered_queen'
---| 'lol_wp_sheen'
---| 'lol_wp_warmogarmor'
---| 'nashor_tooth'
---| 'lol_wp_s15_zhonya'

----------

---@alias player_timer_gallop_brokenking_frogblade_cd_prefab # 玩家cd: `gallop_brokenking_frogblade_cd` 组别 有哪些prefab
---| 'gallop_brokenking'

----------

---@alias player_timer_lol_wp_cd_itemtile_prefab # 玩家cd: `lol_wp_cd_itemtile` 组别 有哪些prefab
---| 'lol_wp_s12_eclipse'

----------
----------

---@alias player_timer_group # 玩家cd:组别(按组件分)
---| 'rechargeable'
---| 'lol_wp_cd_itemtile'
---| 'gallop_brokenking_frogblade_cd'


---@class player_timer_group_data
---@field members table<player_timer_rechargeable_prefab,player_timer_member> # 组别成员
---@field fn fun(group:player_timer_group,prefab:string,seconds:integer,item:ent,player:ent,should_cd:integer) # 需要开始cd,以及同步cd时调用
---@field fn_resetcd fun(group:player_timer_group,prefab:string,item:ent,player:ent) # 需要重置cd时调用

---@class player_timer_member
---@field only_allow_avatars table<PrefabID,boolean>|nil # 仅允许这些人物共享cd,不填则允许所有

---@type table<player_timer_group,player_timer_group_data>
local data = {

    rechargeable = {
        members = {
            alchemy_chainsaw = {},
            crystal_scepter = {},
            gallop_ad_destroyer = {},
            gallop_blackcutter = {},
            gallop_breaker = {},
            gallop_brokenking = {},
            gallop_hydra = {},
            gallop_tiamat = {},
            gallop_bloodaxe = {},
            lol_wp_demonicembracehat = {},
            lol_wp_divine = {},
            lol_wp_overlordbloodarmor = {},
            lol_wp_s7_cull = {},
            lol_wp_s7_doranshield = {},
            lol_wp_s7_tearsofgoddess = {},
            lol_wp_s8_lichbane = {},
            lol_wp_s9_guider = {},
            lol_wp_s10_guinsoo = {},
            lol_wp_s10_sunfireaegis = {},
            lol_wp_s12_eclipse = {},
            lol_wp_s12_malignance = {},
            lol_wp_s13_statikk_shiv = {},
            lol_wp_s15_crown_of_the_shattered_queen = {},
            lol_wp_sheen = {},
            lol_wp_warmogarmor = {},
            nashor_tooth = {},
            lol_wp_s15_zhonya = {},
            lol_wp_s15_stopwatch = {
                only_allow_avatars = {
                    wanda = true,
                },
            },
            lol_wp_s17_luden = {},
            lol_wp_s17_liandry = {},
        },
        fn = function (group,prefab,seconds,item,player,should_cd)
            if item.components.rechargeable then
                item.player_timer_rechargeable_do_orig_thing = true
                local total = item.components.rechargeable.total
                local chargetime = seconds
                local rest_percent = math.min(1,should_cd/chargetime)
                item.components.rechargeable:Discharge(seconds)
                -- 然后让所有物品重新设置为和玩家一致的cd
                item.components.rechargeable:SetCharge(total*(1-rest_percent),true)
                item.player_timer_rechargeable_do_orig_thing = nil
            end
        end,
        fn_resetcd = function (group,prefab,item,player)
            if item.components.rechargeable then
                item.player_timer_rechargeable_do_orig_thing = true
                item.components.rechargeable:Discharge(item.components.rechargeable:GetChargeTime())
                item.components.rechargeable:SetCharge(item.components.rechargeable.total,true)
                item.player_timer_rechargeable_do_orig_thing = nil
            end
        end,
    },

    lol_wp_cd_itemtile = {
        members = {
            lol_wp_s12_eclipse = true,
        },
        fn = function (group, prefab, seconds, item, player, should_cd)
            if item.components.lol_wp_cd_itemtile then
                item.player_timer_lol_wp_cd_itemtile_do_orig_thing = true
                item.components.lol_wp_cd_itemtile:ForceStartCD(seconds)
                item.components.lol_wp_cd_itemtile:SetCurCD(should_cd)
                item.player_timer_lol_wp_cd_itemtile_do_orig_thing = nil
            end
        end,
        fn_resetcd = function (group, prefab, item, player)
            if item.components.lol_wp_cd_itemtile then
                item.player_timer_lol_wp_cd_itemtile_do_orig_thing = true
                item.components.lol_wp_cd_itemtile:ForceStartCD()
                item.components.lol_wp_cd_itemtile:SetCurCD(0)
                item.player_timer_lol_wp_cd_itemtile_do_orig_thing = nil
            end
        end
    },

    gallop_brokenking_frogblade_cd = {
        members = {
            gallop_brokenking = true,
        },
        fn = function (group, prefab, seconds, item, player, should_cd)
            if item.components.gallop_brokenking_frogblade_cd then
                item.player_timer_gallop_brokenking_frogblade_cd_do_orig_thing = true
                item.components.gallop_brokenking_frogblade_cd:StartCD(seconds)
                item.components.gallop_brokenking_frogblade_cd:ReduceToCD(should_cd)
                item.player_timer_gallop_brokenking_frogblade_cd_do_orig_thing = nil
            end
        end,
        fn_resetcd = function (group, prefab, item, player)
            if item.components.gallop_brokenking_frogblade_cd then
                item.player_timer_gallop_brokenking_frogblade_cd_do_orig_thing = true
                item.components.gallop_brokenking_frogblade_cd:ResetCD()
                item.player_timer_gallop_brokenking_frogblade_cd_do_orig_thing = nil
            end
        end
    }
}

return data