-- 记录 prefab 的被动等属性
local database =  {
    tearsofgoddess = { --女神之泪
        prefab = "lol_wp_s7_tearsofgoddess",
        equipslot = EQUIPSLOTS.LOL_WP,
        passives = { mana_flow = { }, }
    },
    lol_wp_s7_doranring = { --多兰之戒
        equipslot = EQUIPSLOTS.LOL_WP,
    },
    lol_wp_trinity = { --三相之力
        equipslot = EQUIPSLOTS.LOL_WP,
    },
    riftmaker_amulet = { --峡谷制造者(护符)
        equipslot = EQUIPSLOTS.LOL_WP,
    },
    lol_heartsteel = { --心之钢
        equipslot = EQUIPSLOTS.LOL_WP,
    },
    lol_wp_s11_amplifyingtome = { --增幅典籍
        equipslot = EQUIPSLOTS.LOL_WP,
    },
    lol_wp_s11_darkseal = { --黑暗封印
        equipslot = EQUIPSLOTS.LOL_WP,
    },
    lol_wp_s11_mejaisoulstealer = { --梅贾的窃魂卷
        equipslot = EQUIPSLOTS.LOL_WP,
    },
    lol_wp_s13_infinity_edge_amulet = { --无尽之刃(护符)
        equipslot = EQUIPSLOTS.LOL_WP,
    },
    lol_wp_s15_zhonya = { --中娅沙漏
        equipslot = EQUIPSLOTS.LOL_WP,
    },
    lol_wp_s17_lostchapter = { --遗失的章节
        equipslot = EQUIPSLOTS.LOL_WP,
    },
    eyestone_low = { --戒备眼石
        prefab = 'lol_wp_s9_eyestone_low',
        equipslot = EQUIPSLOTS.LOL_WP,
        group = { 'eyestone' },
    },
    eyestone_high = { --警觉眼石
        prefab = 'lol_wp_s9_eyestone_high',
        equipslot = EQUIPSLOTS.LOL_WP,
        group = { 'eyestone' },
    },

    lol_wp_s7_doranshield = { --多兰之盾
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s7_cull = { --萃取
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s7_obsidianblade = { --黑曜石锋刃
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s7_doranblade = { --多兰之刃
        equipslot = EQUIPSLOTS.HANDS,
    },
    gallop_breaker = { --破舰者
        equipslot = EQUIPSLOTS.HANDS,
    },
    gallop_whip = { --铁刺鞭
        equipslot = EQUIPSLOTS.HANDS,
    },
    gallop_bloodaxe = { --渴血战斧
        equipslot = EQUIPSLOTS.HANDS,
    },
    gallop_tiamat = { --提亚马特
        equipslot = EQUIPSLOTS.HANDS,
    },
    gallop_hydra = { --巨型九头蛇
        equipslot = EQUIPSLOTS.HANDS,
    },
    riftmaker_weapon = { --峡谷制造者
        equipslot = EQUIPSLOTS.HANDS,
    },
    nashor_tooth = { --纳什之牙
        equipslot = EQUIPSLOTS.HANDS,
    },
    crystal_scepter = { --瑞莱的冰晶节杖
        equipslot = EQUIPSLOTS.HANDS,
    },
    gallop_blackcutter = { --黑色切割者
        equipslot = EQUIPSLOTS.HANDS,
    },
    gallop_brokenking = { --破败王者之刃
        equipslot = EQUIPSLOTS.HANDS,
    },
    gallop_ad_destroyer = { --挺进破坏者
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_sheen = { --耀光
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_divine = { --神圣分离者
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s12_eclipse = { --星蚀
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s12_malignance = { --焚天
        equipslot = EQUIPSLOTS.HANDS,
    },
    alchemy_chainsaw = { --炼金朋克链锯剑
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s13_infinity_edge = { --无尽之刃
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s13_statikk_shiv = { --斯塔缇克电刃
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s13_statikk_shiv_charged = { --斯塔缇克电刀
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s13_collector = { --收集者
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s8_uselessbat = { --无用大棒
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s10_blastingwand = { --爆裂魔杖
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s17_luden = { --卢登的回声
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s18_stormrazor = { --岚切
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s19_archangelstaff = { --大天使之杖
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s19_archangelstaff_upgrade = { --炽天使之拥
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s18_krakenslayer = { --海妖杀手
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s18_bloodthirster = { --饮血剑
        equipslot = EQUIPSLOTS.HANDS,
    },
    muramana = { --魔宗
        prefab = "lol_wp_s19_muramana",
        equipslot = EQUIPSLOTS.HANDS,
        passives = {
            wind_slash = { charge_desire = TUNING.MOD_LOL_WP.MURAMANA.SKILL_WINDSLASH.PER_HIT_TIMES - 1 },
            awe = { damage_percent = TUNING.MOD_LOL_WP.MURAMANA.SKILL_FEAR.SAN_PERCENT },
            mana_accumulation = {
                delta = TUNING.MOD_LOL_WP.MURAMANA.SKILL_COUNT.COUNT_PER_HIT,
                epic_delta = TUNING.MOD_LOL_WP.MURAMANA.SKILL_COUNT.COUNT_PER_HIT_BOSS,
                max = TUNING.MOD_LOL_WP.MURAMANA.SKILL_COUNT.MAX_COUNT,
                cd = 0.2,
                -- cd = TUNING.MOD_LOL_WP.MURAMANA.SKILL_COUNT.CD,
                sanity_rate_per_mana = 100,
                -- sanity_rate_per_mana = TUNING.MOD_LOL_WP.MURAMANA.SKILL_COUNT.DARPPERNESS_PER_COUNT,
            }
        }
    },
    muramana_upgrade = { --魔切
        prefab = "lol_wp_s19_muramana_upgrade",
        equipslot = EQUIPSLOTS.HANDS,
        passives = { wind_slash = { }, }
    },
    lol_wp_s10_guinsoo = { --鬼索的狂暴之刃
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s8_lichbane = { --巫妖之祸
        equipslot = EQUIPSLOTS.HANDS,
    },
    lol_wp_s10_sunfireaegis = { --日炎圣盾
        equipslot = EQUIPSLOTS.HANDS,
    },

    lol_wp_demonicembracehat = { --恶魔之拥
        equipslot = EQUIPSLOTS.HEAD,
    },
    lol_wp_s14_hubris = { --狂妄
        equipslot = EQUIPSLOTS.HEAD,
    },
    lol_wp_s15_crown_of_the_shattered_queen = { --破碎王后之冕
        equipslot = EQUIPSLOTS.HEAD,
    },
    lol_wp_s8_deathcap = { --灭世者的死亡之帽
        equipslot = EQUIPSLOTS.HEAD,
    },
    lol_wp_s17_liandry = { --兰德里的折磨
        equipslot = EQUIPSLOTS.HEAD,
    },
    lol_wp_s17_liandry_nomask = { --兰德里的折磨（无面具）
        equipslot = EQUIPSLOTS.HEAD,
    },

    lol_wp_overlordbloodarmor = {
        equipslot = EQUIPSLOTS.BODY,
    }, --霸王血铠
    lol_wp_warmogarmor = {
        equipslot = EQUIPSLOTS.BODY,
    }, --狂徒铠甲
    lol_wp_s10_sunfireaegis_armor = {
        equipslot = EQUIPSLOTS.BODY,
    }, --日炎斗篷
    lol_wp_s14_bramble_vest = {
        equipslot = EQUIPSLOTS.BODY,
    }, --棘刺背心
    lol_wp_s14_thornmail = {
        equipslot = EQUIPSLOTS.BODY,
    }, --荆棘之甲
    lol_wp_s19_fimbulwinter_armor = {
        equipslot = EQUIPSLOTS.BODY,
    }, --凛冬之临
    lol_wp_s19_fimbulwinter_armor_upgrade = {
        equipslot = EQUIPSLOTS.BODY,
    }, --末日寒冬

    lol_wp_s9_guider = {
        
    }, --引路者
    lol_wp_s15_stopwatch = {
        
    }, --秒表
    lol_wp_s16_potion_hp = {
        
    }, --生命药水
    lol_wp_s16_potion_compound = {
        
    }, --复用型药水
    lol_wp_s16_potion_corruption = {
        
    }, --腐败药水
}

local passive_map = { }
local passive_total = 0

local prefab_item_data = { }
for name, data in pairs(database) do
    if data.prefab then
        prefab_item_data[data.prefab] = data
    end

    for passive_name, passive_args in pairs(data.passives or { }) do
        local passive_data = passive_map[passive_name]
        if not passive_data then
            passive_data = { }
            passive_total = passive_total + 1
        end
        table.insert(passive_data, data.prefab)
        passive_map[passive_name] = passive_data
    end
end

database.passive_total = passive_total
database.passive_map = passive_map

function database:is_prefab_has_passive(prefab, passive_name)
    return table.contains(passive_map[passive_name] or { }, prefab)
end

function database:get_by_prefab(prefab)
    return prefab_item_data[prefab]
end

return database