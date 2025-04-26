local modid = 'lol_wp'
---@type lang_lol_wp_pedia
local lang = require('core_lol_wp/languages/lol_wp_pedia/'..TUNING['CONFIG_'..string.upper(modid)..'_LANG'])

local data = {
    ---@type table<string,data_lol_wp_pedia>
    pedia_items = { -- 所有图鉴物品
        -- 萃取
        lol_wp_s7_cull = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s7_cull,
            group = 'warrior',
            info = {},
        },
        -- 黑曜石锋刃
        lol_wp_s7_obsidianblade = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s7_obsidianblade,
            group = 'warrior',
            info = {},

        },
        -- 多兰之刃
        lol_wp_s7_doranblade = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s7_doranblade,
            group = 'warrior',
            info = {},

        },
        -- 多兰之盾
        lol_wp_s7_doranshield = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s7_doranshield,
            group = 'tank',
            info = {},

        },
        -- 多兰之戒
        lol_wp_s7_doranring = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s7_doranring,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'mage',
            info = {},

        },
        -- 女神之泪
        lol_wp_s7_tearsofgoddess = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s7_tearsofgoddess,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'mage',
            info = {},

        },
        -- 破舰者
        gallop_breaker = {
            name = lang.lol_wp_pedia_group_label.gallop_breaker,
            group = 'tank',
            info = {},

        },
        -- 铁刺鞭
        gallop_whip = {
            name = lang.lol_wp_pedia_group_label.gallop_whip,
            group = 'warrior',
            info = {},

        },
        -- 渴血战斧
        gallop_bloodaxe = {
            name = lang.lol_wp_pedia_group_label.gallop_bloodaxe,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'warrior',
            info = {},

        },
        -- 心之钢
        lol_heartsteel = {
            name = lang.lol_wp_pedia_group_label.lol_heartsteel,
            group = 'tank',
            info = {},

        },
        -- 提亚马特
        gallop_tiamat = {
            name = lang.lol_wp_pedia_group_label.gallop_tiamat,
            group = 'warrior',
            xml = 'images/gallop_inventoryimages_h_t.xml',
            tex = 'gallop_tiamat.tex',
            info = {},

        },
        -- 巨型九头蛇
        gallop_hydra = {
            name = lang.lol_wp_pedia_group_label.gallop_hydra,
            group = 'tank',
            xml = 'images/gallop_inventoryimages_h_t.xml',
            tex = 'gallop_hydra.tex',
            info = {},
        },
        -- 峡谷制造者
        riftmaker_weapon = {
            name = lang.lol_wp_pedia_group_label.riftmaker_weapon,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'mage',
            info = {},
        },
        -- 纳什之牙
        nashor_tooth = {
            name = lang.lol_wp_pedia_group_label.nashor_tooth,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'mage',
            info = {},

        },
        -- 瑞莱的冰晶节杖
        crystal_scepter = {
            name = lang.lol_wp_pedia_group_label.crystal_scepter,
            group = 'mage',
            info = {},

        },
        -- 黑色切割者
        gallop_blackcutter = {
            name = lang.lol_wp_pedia_group_label.gallop_blackcutter,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'warrior',
            xml = 'images/gallop_inventoryimages_h_t.xml',
            tex = 'gallop_blackcutter.tex',
            info = {},

        },
        -- 破败王者之刃
        gallop_brokenking = {
            name = lang.lol_wp_pedia_group_label.gallop_brokenking,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'warrior',
            xml = 'images/gallop_inventoryimages_h_t.xml',
            tex = 'gallop_brokenking.tex',
            info = {},

        },
        -- 挺进破坏者
        gallop_ad_destroyer = {
            name = lang.lol_wp_pedia_group_label.gallop_ad_destroyer,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'warrior',
            xml = 'images/gallop_inventoryimages_h_t.xml',
            tex = 'gallop_ad_destroyer.tex',
            info = {},

        },
        -- 三相之力
        lol_wp_trinity = {
            name = lang.lol_wp_pedia_group_label.lol_wp_trinity,
            group = 'warrior',
            info = {},

        },
        -- 耀光
        lol_wp_sheen = {
            name = lang.lol_wp_pedia_group_label.lol_wp_sheen,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'warrior',
            info = {},

        },
        -- 神圣分离者
        lol_wp_divine = {
            name = lang.lol_wp_pedia_group_label.lol_wp_divine,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'warrior',
            info = {},

        },
        -- 霸王血铠
        lol_wp_overlordbloodarmor = {
            name = lang.lol_wp_pedia_group_label.lol_wp_overlordbloodarmor,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'tank',
            info = {},

        },
        -- 恶魔之拥
        lol_wp_demonicembracehat = {
            name = lang.lol_wp_pedia_group_label.lol_wp_demonicembracehat,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'mage',
            info = {},

        },
        -- 狂徒铠甲
        lol_wp_warmogarmor = {
            name = lang.lol_wp_pedia_group_label.lol_wp_warmogarmor,
            group = 'tank',
            info = {},

        },
        -- 灭世者的死亡之帽
        lol_wp_s8_deathcap = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s8_deathcap,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'mage',
            info = {},

        },
        -- 无用大棒
        lol_wp_s8_uselessbat = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s8_uselessbat,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'mage',
            info = {},

        },
        -- 巫妖之祸
        lol_wp_s8_lichbane = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s8_lichbane,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'mage',
            info = {},

        },
        -- 引路者
        lol_wp_s9_guider = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s9_guider,
            group = 'support',
            info = {},

        },
        -- 戒备眼石
        lol_wp_s9_eyestone_low = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s9_eyestone_low,
            group = 'support',
            info = {},

        },
        -- 警觉眼石
        lol_wp_s9_eyestone_high = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s9_eyestone_high,
            group = 'support',
            info = {},

        },
        -- 鬼索的狂暴之刃
        lol_wp_s10_guinsoo = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s10_guinsoo,
            group = 'warrior',
            info = {},

        },
        -- 爆裂魔杖
        lol_wp_s10_blastingwand = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s10_blastingwand,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'mage',
            info = {},

        },
        -- 日炎圣盾
        lol_wp_s10_sunfireaegis = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s10_sunfireaegis,
            group = 'tank',
            info = {},

        },
        -- 增幅典籍
        lol_wp_s11_amplifyingtome = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s11_amplifyingtome,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'mage',
            info = {},

        },
        -- 黑暗封印
        lol_wp_s11_darkseal = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s11_darkseal,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'mage',
            info = {},

        },
        -- 梅贾的窃魂卷
        lol_wp_s11_mejaisoulstealer = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s11_mejaisoulstealer,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'mage',
            info = {},

        },
        -- 星蚀
        lol_wp_s12_eclipse = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s12_eclipse,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'warrior',
            info = {},

        },
        -- 焚天
        lol_wp_s12_malignance = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s12_malignance,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'warrior',
            info = {},

        },
        -- 炼金朋克链锯剑
        alchemy_chainsaw = {
            name = lang.lol_wp_pedia_group_label.alchemy_chainsaw,
            group = 'warrior',
            xml = 'images/alchemy_chainsaw.xml',
            tex = 'alchemy_chainsaw.tex',
            info = {},
        },
        -- 无尽之刃
        lol_wp_s13_infinity_edge = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s13_infinity_edge,
            group = 'warrior',
            info = {},

        },
        -- 斯塔缇克电刃
        lol_wp_s13_statikk_shiv = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s13_statikk_shiv,
            group = 'warrior',
            info = {},

        },
        -- 斯塔缇克电刀
        lol_wp_s13_statikk_shiv_charged = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s13_statikk_shiv_charged,
            group = 'warrior',
            info = {},

        },
        -- 收集者
        lol_wp_s13_collector = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s13_collector,
            group = 'warrior',
            info = {},

        },
        -- 棘刺背心
        lol_wp_s14_bramble_vest = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s14_bramble_vest,
            group = 'tank',
            info = {},
        },
        -- 荆棘之甲
        lol_wp_s14_thornmail = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s14_thornmail,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'tank',
            info = {},
        },
        -- 狂妄
        lol_wp_s14_hubris = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s14_hubris,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'warrior',
            info = {},
        },
        -- 破碎王后之冕
        lol_wp_s15_crown_of_the_shattered_queen = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s15_crown_of_the_shattered_queen,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'mage',
            info = {},
        },
        -- 秒表
        lol_wp_s15_stopwatch = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s15_stopwatch,
            group = 'support',
            info = {},
        },
        -- 中娅沙漏
        lol_wp_s15_zhonya = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s15_zhonya,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'mage',
            info = {},
        },
        -- 生命药水
        lol_wp_s16_potion_hp = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s16_potion_hp,
            group = 'support',
            info = {},
        },
        -- 复用型药水
        lol_wp_s16_potion_compound = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s16_potion_compound,
            group = 'support',
            info = {},
        },
        -- 腐败药水
        lol_wp_s16_potion_corruption = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s16_potion_corruption,
            group = 'support',
            info = {},
        },
        -- 卢登的回声
        lol_wp_s17_luden = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s17_luden,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'mage',
            info = {},
        },
        -- 兰德里的折磨
        lol_wp_s17_liandry = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s17_liandry,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'mage',
            info = {},
        },
        -- 遗失的章节
        lol_wp_s17_lostchapter = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s17_lostchapter,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'mage',
            info = {},
        },
        -- 饮血剑
        lol_wp_s18_bloodthirster = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s18_bloodthirster,
            name_rgba = {223/255,94/255,99/255,1},
            group = 'warrior',
            info = {},
        },
        -- 岚切
        lol_wp_s18_stormrazor = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s18_stormrazor,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'warrior',
            info = {},
        },
        -- 海妖杀手
        lol_wp_s18_krakenslayer = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s18_krakenslayer,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'warrior',
            info = {},
        },
        -- 大天使之杖
        lol_wp_s19_archangelstaff = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s19_archangelstaff,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'mage',
            info = {},
        },
        -- 炽天使之拥
        lol_wp_s19_archangelstaff_upgrade = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s19_archangelstaff_upgrade,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'mage',
            info = {},
        },
        -- 魔宗
        lol_wp_s19_muramana = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s19_muramana,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'warrior',
            info = {},
        },
        -- 魔切
        lol_wp_s19_muramana_upgrade = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s19_muramana_upgrade,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'warrior',
            info = {},
        },
        -- 凛冬之临
        lol_wp_s19_fimbulwinter_armor = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s19_fimbulwinter_armor,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'tank',
            info = {},
        },
        -- 末日寒冬
        lol_wp_s19_fimbulwinter_armor_upgrade = {
            name = lang.lol_wp_pedia_group_label.lol_wp_s19_fimbulwinter_armor_upgrade,
            name_rgba = {38/255,221/255,223/255,1},
            group = 'tank',
            info = {},
        },
    },
    -- 图鉴物品排序
    pedia_items_order = {
        -- warrior
        'lol_wp_s7_doranblade',
        'lol_wp_s7_cull',
        'lol_wp_s7_obsidianblade',
        'gallop_whip',
        'gallop_tiamat',
        'lol_wp_sheen',
        'lol_wp_s13_statikk_shiv',
        'lol_wp_s13_statikk_shiv_charged',
        'lol_wp_s10_guinsoo',
        'gallop_blackcutter',
        'gallop_brokenking',
        'lol_wp_s19_muramana',
        'lol_wp_s18_stormrazor',
        'lol_wp_trinity',
        'lol_wp_divine',
        'lol_wp_s12_malignance',
        'lol_wp_s13_infinity_edge',
        'lol_wp_s14_hubris',
        'alchemy_chainsaw',
        'lol_wp_s13_collector',
        'gallop_bloodaxe',
        'lol_wp_s18_bloodthirster',
        'gallop_ad_destroyer',
        'lol_wp_s19_muramana_upgrade',
        'lol_wp_s12_eclipse',
        'lol_wp_s18_krakenslayer',
        -- tank
        'lol_wp_s7_doranshield',
        'lol_wp_s14_bramble_vest',
        'lol_wp_s14_thornmail',
        'lol_wp_s19_fimbulwinter_armor',
        'lol_wp_s10_sunfireaegis',
        'lol_heartsteel',
        'gallop_hydra',
        'gallop_breaker',
        'lol_wp_warmogarmor',
        'lol_wp_overlordbloodarmor',
        'lol_wp_s19_fimbulwinter_armor_upgrade',
        -- mage
        'lol_wp_s7_doranring',
        'lol_wp_s11_amplifyingtome',
        'lol_wp_s11_darkseal',
        'lol_wp_s7_tearsofgoddess',
        'lol_wp_s17_lostchapter',
        'lol_wp_s10_blastingwand',
        'lol_wp_s8_uselessbat',
        'nashor_tooth',
        'lol_wp_s15_crown_of_the_shattered_queen',
        'crystal_scepter',
        'lol_wp_s19_archangelstaff',
        'lol_wp_s15_zhonya',
        'lol_wp_s17_luden',
        'lol_wp_s8_lichbane',
        'riftmaker_weapon',
        'lol_wp_demonicembracehat',
        'lol_wp_s8_deathcap',
        'lol_wp_s11_mejaisoulstealer',
        'lol_wp_s19_archangelstaff_upgrade',
        'lol_wp_s17_liandry',
        -- support
        'lol_wp_s16_potion_hp',
        'lol_wp_s16_potion_compound',
        'lol_wp_s15_stopwatch',
        'lol_wp_s16_potion_corruption',
        'lol_wp_s9_eyestone_low',
        'lol_wp_s9_eyestone_high',
        'lol_wp_s9_guider',
    },
    ---@type lol_wp_pedia_group[]
    groups_order = { -- 组别顺序
        'warrior','tank','mage','support'
    },
    ---@type table<lol_wp_pedia_group,lol_wp_pedia_group_spec>
    group_spec = { -- 组别参数表
        warrior = {
            btn_color = {180/255,103/255,92/255,1},
        },
        tank = {
            btn_color = {180/255,130/255,92/255,1},
        },
        mage = {
            btn_color = {166/255,92/255,180/255,1},
        },
        support = {
            btn_color = {92/255,171/255,180/255,1},
        }
    },
}

-- 注入 info_instead
for id,v in pairs(data.pedia_items) do
    v.info_instead = lang.pedia_items[id].info_instead or ''
end

return data