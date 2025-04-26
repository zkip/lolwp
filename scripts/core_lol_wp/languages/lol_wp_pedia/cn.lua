local db = TUNING.MOD_LOL_WP
local keymap = require('core_lol_wp/utils/keymap')

local modid = 'lol_wp'

---@class lang_lol_wp_pedia
local data = {
    lol_wp_pedia_group = { -- 所有的分组
        warrior = '战士装备',
        tank = '坦克装备',
        mage = '法师装备',
        support = '辅助装备',
    },
    lol_wp_pedia_group_label = { -- 所有物品的左边栏label
        lol_wp_s7_cull = '萃取',
        lol_wp_s7_obsidianblade = '黑曜石锋刃',
        lol_wp_s7_doranblade = '多兰之刃',
        lol_wp_s7_doranshield = '多兰之盾',
        lol_wp_s7_doranring = '多兰之戒',
        lol_wp_s7_tearsofgoddess = '女神之泪',
        gallop_breaker = '破舰者',
        gallop_whip = '铁刺鞭',
        gallop_bloodaxe = '渴血战斧',
        lol_heartsteel = '心之钢',
        gallop_tiamat = '提亚马特',
        gallop_hydra = '巨型九头蛇',
        riftmaker_weapon = '峡谷制造者',
        nashor_tooth = '纳什之牙',
        crystal_scepter = '瑞莱的冰晶节杖',
        gallop_blackcutter = '黑色切割者',
        gallop_brokenking = '破败王者之刃',
        gallop_ad_destroyer = '挺进破坏者',
        lol_wp_trinity = '三相之力',
        lol_wp_sheen = '耀光',
        lol_wp_divine = '神圣分离者',
        lol_wp_overlordbloodarmor = '霸王血铠',
        lol_wp_demonicembracehat = '恶魔之拥',
        lol_wp_warmogarmor = '狂徒铠甲',
        lol_wp_s8_deathcap = '灭世者的死亡之帽',
        lol_wp_s8_uselessbat = '无用大棒',
        lol_wp_s8_lichbane = '巫妖之祸',
        lol_wp_s9_guider = '引路者',
        lol_wp_s9_eyestone_low = '戒备眼石',
        lol_wp_s9_eyestone_high = '警觉眼石',
        lol_wp_s10_guinsoo = '鬼索的狂暴之刃',
        lol_wp_s10_blastingwand = '爆裂魔杖',
        lol_wp_s10_sunfireaegis = '日炎圣盾',
        lol_wp_s11_amplifyingtome = '增幅典籍',
        lol_wp_s11_darkseal = '黑暗封印',
        lol_wp_s11_mejaisoulstealer = '梅贾的窃魂卷',
        lol_wp_s12_eclipse = '星蚀',
        lol_wp_s12_malignance = '焚天',
        alchemy_chainsaw = '炼金朋克链锯剑',
        lol_wp_s13_infinity_edge = '无尽之刃',
        lol_wp_s13_statikk_shiv = '斯塔缇克电刃',
        lol_wp_s13_statikk_shiv_charged = '斯塔缇克电刀',
        lol_wp_s13_collector = '收集者',
        lol_wp_s14_bramble_vest = '棘刺背心',
        lol_wp_s14_thornmail = '荆棘之甲',
        lol_wp_s14_hubris = '狂妄',
        lol_wp_s15_crown_of_the_shattered_queen = '破碎王后之冕',
        lol_wp_s15_stopwatch = '秒表',
        lol_wp_s15_zhonya = '中娅沙漏',
        lol_wp_s16_potion_hp = '生命药水',
        lol_wp_s16_potion_compound = '复用型药水',
        lol_wp_s16_potion_corruption = '腐败药水',
        lol_wp_s17_luden = '卢登的回声',
        lol_wp_s17_liandry = '兰德里的折磨',
        lol_wp_s17_lostchapter = '遗失的章节',
        lol_wp_s18_bloodthirster = '饮血剑',
        lol_wp_s18_stormrazor = '岚切',
        lol_wp_s18_krakenslayer = '海妖杀手',
        lol_wp_s19_archangelstaff = '大天使之杖',
        lol_wp_s19_archangelstaff_upgrade = '炽天使之拥',
        lol_wp_s19_muramana = '魔宗',
        lol_wp_s19_muramana_upgrade = '魔切',
        lol_wp_s19_fimbulwinter_armor = '凛冬之临',
        lol_wp_s19_fimbulwinter_armor_upgrade = '末日寒冬',
    },
    pedia_items = { -- 图鉴物品
        lol_wp_s7_cull = {
            name = '萃取',
            info_instead = '- 类型：近战武器/工具/镰刀\n- 攻击力: '..db.CULL.DMG..'\n- 生命回复：'..db.CULL.ATK_REGEN..'\n- 主动：【收割】\n\t右键可以像暗影收割者一样范围收割作物，可以对敌人使用，造成等同于武器数值的范围伤害，每次收割后有'..db.CULL.SKILL_SWEEP.CD..'秒冷却。\n- 被动：【掠夺】\n\t每击杀一个单位会掉落'..db.CULL.SKILL_LOOT.GOLD_PERUNIT..'个金块，累计击杀'..db.CULL.SKILL_LOOT.FINISHED..'个生物会爆掉，掉落'..db.CULL.SKILL_LOOT.GOLD_WHEN_FINISHED..'个金块。\n- 耐久：无',
        },
        lol_wp_s7_obsidianblade = {
            name = '黑曜石锋刃',
            info_instead = '- 类型：近战武器/刀\n- 攻击力: '..db.OBSIDIANBLADE.DMG..'\n- 被动：【猎手】\n\t攻击中立生物会造成双倍伤害，并提供'..db.OBSIDIANBLADE.DRAIN..'点生命偷取。\n- 被动：【狩猎人】\n\t击杀生物后，会使掉落物中概率最高的掉落物额外掉落一个，并使所有掉落物概率提高'..(db.OBSIDIANBLADE.SKILL_HUNTER.CHANCE_UP*100)..'%。\n- 耐久：'..db.OBSIDIANBLADE.FINITEUSE..'，耐久耗尽会损坏'
        },
        lol_wp_s7_doranblade = {
            name = '多兰之刃',
            info_instead = '- 类型：近战武器/剑\n- 攻击力：'..db.DORANBLADE.DMG..' \n- 生命偷取：'..db.DORANBLADE.DRAIN..'\n- 耐久：'..db.DORANBLADE.FINITEUSE..'，耐久耗尽会损坏'
        },
        lol_wp_s7_doranshield = {
            name = '多兰之盾',
            info_instead = '- 类型：近战武器/盾牌\n- 攻击力：'..db.DORANSHIELD.DMG..'\n- 防御：'..(db.DORANSHIELD.ABSORB*100)..'%\n- 主动：【格挡】\n\t右键点击并选中方向后即能格挡来自对应方向的攻击，持续1秒，格挡不损失耐久，格挡成功时，会额外回复自身'..db.DORANSHIELD.SKILL_BLOCK.REGEN_WHEN_SUCCESS..'点生命值。\n- 被动：【复原力】\n\t手持时每'..db.DORANSHIELD.SKILL_RESTORE.INTERVAL..'秒回复'..db.DORANSHIELD.SKILL_RESTORE.REGEN..'生命值。\n- 耐久：'..db.DORANSHIELD.FINITEUSE..'，耐久耗尽会损坏'
        },
        lol_wp_s7_doranring = {
            name = '多兰之戒',
            info_instead = '- 类型：护符/戒指\n- 额外位面伤害：'..db.DORANRING.PLANAR_DMG_WHEN_EQUIP..'\n- 被动：【汲取】\n\t佩戴时+'..db.DORANRING.DAPPERNESS..'san/min。\n- 耐久：无'
        },
        lol_wp_s7_tearsofgoddess = {
            name = '女神之泪',
            info_instead = '- 类型：护符/魔法石\n- 理智：+'..db.TEARSOFGODDESS.DAPPERNESS..'\n- 放在物品栏也可以提供回san效果，携带多个可叠加。\n- 被动：【法力流】\n\t佩戴时发动一次攻击可以叠加'..db.TEARSOFGODDESS.SKILL_SPELLFLOW.NUM_PER_HIT..'层被动，每层被动提供'..db.TEARSOFGODDESS.SKILL_SPELLFLOW.SAN_LIMIT_PER_NUM..'点理智上限，最多'..db.TEARSOFGODDESS.SKILL_SPELLFLOW.SAN_LIMIT_MAX..'层，叠加被动有'..db.TEARSOFGODDESS.SKILL_SPELLFLOW.CD..'秒冷却。\n- 耐久：无\n- 物品下方会显示叠加的层数。'
        },
        gallop_breaker = {name = '破舰者', info_instead = '- 类型：近战武器/工具/锤子\n- 攻击力：40\n- 移速+5%\n- 工作效率：斧/镐/锤/铲/锄300%/锤力1000%\n- 可挖掘高级材料。\n- 被动：【船长】\n\t第五次普攻造成140%真实伤害。\n- 被动：【爆破】\n\t砍伐和挖掘时25%概率触发秒杀。\n- 被动：【登舰小队】\n\t手持破舰者时，自身和身边的雇佣单位获得80%护甲，工作效率提升至2倍，但如果半径5码内出现其他玩家时这个功能失效。\n- 在手持破舰者时会播放拆塔的小曲，右键武器可以切换形态，关闭bgm，所有工具功能和以上所有被动效果，获得特殊技能：\n- 主动：【深海冲击】\n\t右键产生一道巨大水柱，造成100大范围伤害，指示器分为两个圈，内圈会破坏岩石和树木，不会破坏植物和建筑，外圈只造成伤害，且伤害只有50，在水上会造成双倍伤害。水柱可以立即熄灭范围内的火焰，并且为附近的田地浇满水，被命中的目标会增加100点潮湿度，每次释放后消耗5san值，冷却时间5秒。\n- 被动：【船长】\n\t第五次普攻造成140%真实伤害。\n- 耐久：无',''},
        gallop_whip = {name = '铁刺鞭', info_instead = '- 类型：近战武器/链锤\n- 攻击力：51\n- 攻击距离：1.5\n- 被动：【新月】\n\t所有攻击都会造成范围伤害。\n- 耐久：150，耐久耗尽会损坏\n- 修复材料：燧石20%',''},
        gallop_bloodaxe = {name = '渴血战斧', info_instead = '- 类型：近战武器/链锤\n- 攻击力：85\n- 攻击距离：2\n- 全能吸血：'..TUNING[string.upper('CONFIG_'..modid..'bloodaxe_health')]..'\n- 每命中一个敌方单位额外回复1点生命值，同时命中多个单位可以叠加，最多叠加至10。\n- 主动：【饥渴斩击】\n\t以自己为中心释放一道圆形剑气，造成80范围伤害，会受攻击倍率影响，每命中一个单位回复5点生命，无上限，冷却时间5秒。\n- 被动：【新月】\n\t所有攻击都会造成范围伤害。\n- 被动：【暗之禁锢】\n\t每次攻击有10%的概率释放半径4圆形区域的暗影囚笼，对范围内的所有生物生效，将其困住12秒无法移动。Boss生物只会被困6秒，冷却10秒\n- 手持时会播放剑魔的小曲，右键武器可以关闭。\n- 属于暗影物品，暗影等级4，对月亮阵营伤害增加10%。\n- 耐久：200，耐久耗尽不会损坏\n- 修复材料：噩梦燃料20%/纯粹恐惧100%',''},
        lol_heartsteel = {name = '心之钢', info_instead = '- 类型：护符/魔法石\n- 佩戴时会缓慢回复生命值，每10秒回复最大生命值1%的血量。 \n- 主动：【庞然吞食】\n\t靠近boss生物5码距离内，可以充能3秒，造成一次强化攻击，充能攻击会造成额外60 (+10%来自自身生命值)额外物理伤害，并为你提供10永久最大生命值。每个单位有120秒冷却，最多叠加'..( TUNING[string.upper('CONFIG_'..modid..'limit_lol_heartsteel_new')] and (TUNING[string.upper('CONFIG_'..modid..'limit_lol_heartsteel_new')]*10) or '无上限' )..'的额外生命值，可以在模组设置里更改为无限，叠满后也可以触发充能攻击，但不会再增加层数。 \n- 被动：【歌利亚巨人】\n\t每获得100额外生命值，人物体型会变大10%，最多变大40%，移速会随着体型变大而减少，在卸下装备时生命值和体型都会恢复正常。\n- 击败狂暴克劳斯100%掉落蓝图。\n- 耐久：无\n- 物品下方会显示叠加的层数。',''},
        gallop_tiamat = {name = '提亚马特', info_instead = '- 类型：近战武器/工具/斧/镐\n- 攻击力：45\n- 工作效率：斧/镐125%\n- 可以挖掘高级材料。\n- 主动：【钢斩】\n\t右键朝指定位置劈砍，消耗5点耐久，造成与武器数值相同的范围伤害，冷却2秒。\n- 耐久：800，耐久耗尽会损坏\n- 修复材料：金块20%',''},
        gallop_hydra = {name = '巨型九头蛇', info_instead = '- 类型：近战武器/戟\n- 攻击力：24\n- 攻击距离：2.0\n- 主动：【钢斩】\n\t右键朝指定位置劈砍，造成与武器数值相同的aoe伤害，冷却0.5秒。\n- 主动：【顺劈】\n\t可以将最大生命上限转化为攻击力，普通攻击附带玩家最大生命值10%的额外物理伤害，玩家血上限越高伤害就越高。\n- 击败蚁狮100%掉落蓝图。\n- 耐久：无',''},
        riftmaker_weapon = {name = '峡谷制造者', info_instead = '- 类型：远程武器/法杖/护符\n- 位面伤害：50\n- 攻击距离：5\n- 全能吸血：7\n- 理智：-5\n- 每次攻击消耗2san值。\n- 会发出半径2的紫色光照。\n- 主动：【虚空裂隙】\n\t使用一次传送魔杖的效果，消耗50san和10%耐久。\n- 被动：【虚空腐蚀】\n\t每次攻击会附带当前造成伤害25%的额外真实伤害，无视敌人的护甲和减伤。\n- 右键物品可以转换成护符物品：\n- 额外位面伤害：20\n- 全能吸血：3\n- 理智：-5\n- 每次攻击消耗2san值。\n- 会发出半径2的紫色光照。\n- 被动：【虚空腐蚀】\n\t每次攻击会附带当前造成伤害10%的额外真实伤害，无视敌人的护甲和减伤。\n- 属于暗影物品，暗影等级4，手持和佩戴时-5san/min，对月亮阵营伤害增加10%。\n- 耐久：200，耐久耗尽不会损坏\n- 装备时会消耗使用者的理智缓慢恢复耐久，-20san/min。\n- 修复材料：噩梦燃料20%/纯粹恐惧100%',''},
        nashor_tooth = {name = '纳什之牙', info_instead = '- 类型：近战武器/刀\n- 攻击力：5\n- 位面伤害：51\n- 理智：-10\n- 移速+10%\n- 主动：【艾卡西亚之咬】\n\t朝指定方向突刺，对路径上的敌人造成70点位面伤害，冷却5秒。\n- 被动：【虚空侵蚀】\n\t每次攻击增加1点位面伤害，最多增加至25点位面伤害，持续10秒，停止攻击10秒后叠加的位面伤害消失。\n- 属于暗影物品，暗影等级2，对月亮阵营伤害增加10%。\n- 击败巨型洞穴蠕虫100%掉落一个成品。\n- 耐久：200，耐久耗尽不会损坏\n- 修复材料：噩梦燃料20%，纯粹恐惧100%',''},
        crystal_scepter = {name = '瑞莱的冰晶节杖', info_instead = '- 类型：远程武器/法杖\n- 位面伤害：40\n- 攻击距离：8\n- 移速+20%\n- 主动：【冰封陵墓】\n\t可以召唤一个克劳斯的冰法阵，冻结范围内所有敌人，消耗20san，冷却20秒。\n- 被动：【凝霜】\n\t每次攻击造成30%减速和0.5层冰冻，持续1秒。\n- 击败独眼巨鹿100%掉落蓝图。\n- 击败晶体独眼巨鹿75%掉落一个成品。\n- 耐久：无',''},
        gallop_blackcutter = {name = '黑色切割者', info_instead = '- 类型：近战武器/工具/斧子\n- 攻击力：68\n- 攻击距离：1.2\n- 移速-10%\n- 工作效率：斧300%\n- 主动：【诺克萨斯断头台】\n\t右键敌人释放跳劈重击，造成136点真实伤害，无视敌人护甲和减伤，每层流血会使当前伤害翻1倍，最高造成136x5=680点真实伤害，会受攻击倍率影响，使用后冷却20秒，用大招击败敌人可以立即刷新冷却时间，并且会使周围的敌人进入恐惧状态，持续4秒。\n- 被动【切割】\n\t每次攻击会附带流血效果，造成每秒5点真实伤害，同时移速+20%，持续5秒，在5秒内再次攻击可使流血效果叠加，一共可以叠加5层，即每秒造成25点真实伤害，会受到攻击倍率影响，停止攻击5秒后消失。\n- 手持时会播放神王的小曲，右键武器可以关闭。\n- 属于暗影物品，暗影等级2，对月亮阵营伤害增加10%。\n- 耐久：250，耐久耗尽不会损坏\n- 手持时会消耗使用者的理智缓慢恢复耐久，-20san/min。\n- 修复材料：噩梦燃料20%/纯粹恐惧100%',''},
        gallop_brokenking = {name = '破败王者之刃', info_instead = '- 类型：近战武器/剑\n- 攻击力：51\n- 攻击距离：1.5\n- 生命偷取：5\n- 移速+10%\n- 主动：【痛贯天灵】\n\t跳跃到空中，在鼠标指定位置造成半径5码的100点位面伤害，并立即刷新雾之锋的冷却时间，消耗10san，冷却20秒。\n- 被动：【雾之锋】\n\t攻击造成敌方最大生命值2%的额外伤害，并且回复自身10点生命值，冷却20秒。\n- 被动：【君命已决】\n\t佩戴启迪之冠时所有伤害增加100%，且雾之锋和痛贯天灵的冷却缩减至5秒。\n- 被动：【茫茫焦土】\n\t手持时免疫黑暗瘴气的负面效果，并且额外增加10%移速。\n- 手持时会播放破败王的小曲，右键武器可以关闭。\n- 属于月亮阵营，对暗影阵营伤害增加10%。\n- 耐久：无\n- 物品下方会显示雾之锋的冷却时间。',''},
        gallop_ad_destroyer = {name = '挺进破坏者', info_instead = '- 类型：近战武器/链锤\n- 攻击力：85\n- 攻击距离：2.0\n- 会发出半径3的白色光照。\n- 移速+25%\n- 主动：【破阵冲击波】\n\t右键以自身为中心释放一道圆形冲击波，造成等同于一次普攻的AOE伤害，击退范围内的敌人并使他们减速50%，持续5秒，每命中一个敌方单位增加自身20%移速，同时命中多个单位可以叠加，最多叠加至100%，持续3秒，冷却时间5秒。\n- 被动：【新月】\n\t所有攻击都会造成范围伤害。\n- 被动：【星体结界】\n\t每次攻击有10%的概率释放催眠效果，催眠半径4圆形范围内的目标，催眠12秒，有10秒冷却。\n- 手持时会播放挖机的小曲，右键武器可以关闭。\n- 属于月亮阵营，对暗影阵营伤害增加10%。\n- 耐久：400，耐久耗尽不会损坏\n- 修复材料：纯粹辉煌50%/亮茄修补套件100%',''},
        lol_wp_trinity = {
            name = '三相之力',
            info_instead = '- 类型：远程武器/飞刃/护符\n- 攻击力：'..db.TRINITY.DMG..'\n- 攻击距离：'..db.TRINITY.RANGE..'\n- 理智：+'..db.TRINITY.DARPPERNESS..'\n- 会发出半径'..db.TRINITY.LIGHT_RADIUS..'的金色光照。\n- 被动：【三重咒刃】\n\t佩戴后人物身边会出现三把刀刃，在人物做出攻击动作后刀刃会持续自动攻击玩家所攻击的目标，造成3段伤害。\n- 装备后右键可以转换成护符物品，佩戴时会获得特殊被动：\n- 被动：【艾欧尼亚之灵】\n\t移速'..((db.TRINITY.WALKSPEEDMULT - 1) >= 0 and '+' or '')..((db.TRINITY.WALKSPEEDMULT-1)*100)..'%'..'，攻击倍率x'..db.TRINITY.DMGMULT..'，每'..db.TRINITY.HEAL_INTERVAL..'秒回复'..db.TRINITY.HEAL_HP..'点生命值。\n- 被动：【三重咒刃】\n\t刀刃的攻击力降低到'..db.TRINITY.DMG_WHEN_AMULET..'，在人物做出攻击动作后刀刃会自动攻击1次玩家所攻击的目标，造成3段伤害，护符形态下不会持续攻击，人物停止攻击后也会停止。\n- 耐久：'..db.TRINITY.FINITEUSE..'，耐久耗尽不会损坏'
        },
        lol_wp_sheen = {
            name = '耀光',
            info_instead = '- 类型：近战武器/剑\n- 攻击力：'..db.SHEEN.DMG..'\n- 移速'..((db.SHEEN.WALKSPEEDMULT - 1) >= 0 and '+' or '')..((db.SHEEN.WALKSPEEDMULT-1)*100)..'%'..'\n- 会发出半径'..db.SHEEN.LIGHT_RADIUS..'的白色光照。\n- 被动：【咒刃】\n\t攻击会触发一次强化攻击，造成'..(db.SHEEN.DMGMULT*100)..'%的伤害，冷却时间'..db.SHEEN.CD..'秒。\n- 属于月亮阵营，对暗影阵营伤害增加'..((db.SHEEN.DMGMULT_TO_SHADOW-1)*100)..'%。\n- 耐久：'..db.SHEEN.FINITEUSES..'，耐久耗尽会损坏'
        },
        lol_wp_divine = {
            name = '神圣分离者',
            info_instead = '- 类型：近战武器/工具/斧镐\n- 攻击力：'..db.DIVINE.DMG..'\n- 攻击距离：'..db.DIVINE.RANGE..'\n- 工作效率：斧/镐'..(db.DIVINE.EFFICIENCY*100)..'%\n- 可以开采高级材料。\n- 移速'..((db.DIVINE.WALKSPEEDMULT - 1) >= 0 and '+' or '')..((db.DIVINE.WALKSPEEDMULT-1)*100)..'%'..'\n- 会发出半径'..db.DIVINE.LIGHT_RADIUS..'的金色光照。\n- 主动：【神圣打击】\n\t右键跳向目标释放重击，会造成目标最大生命值'..(db.DIVINE.HOLY_DMG*100)..'%的额外物理伤害，并回复自身'..db.DIVINE.HOLY_HEAL..'点生命值，如果攻击暗影阵营生物（除boss，机械生物，墨荒以外）可以造成目标最大生命值100%的额外物理伤害，秒杀影怪，冷却'..db.DIVINE.HOLY_CD..'秒。\n- 被动：【咒刃】\n\t攻击会触发一次强化攻击，造成'..(db.DIVINE.DMGMULT*100)..'%的伤害，并回复自身'..db.DIVINE.ATK_HEAL..'点生命值，冷却时间'..db.DIVINE.CD..'秒。\n- 属于月亮阵营，对暗影阵营伤害增加'..((db.DIVINE.DMGMULT_TO_SHADOW-1)*100)..'%。\n- 耐久：'..db.DIVINE.FINITEUSES..'，耐久耗尽不会损坏'
        },
        lol_wp_overlordbloodarmor = {
            name = '霸王血铠',
            info_instead = '- 类型：护甲\n- 防御力：'..(db.OVERLORDBLOOD.ABSORB*100)..'%\n- 位面防御：'..db.OVERLORDBLOOD.DEFEND_PLANAR..'\n- 防水：'..(db.OVERLORDBLOOD.WATERPROOF*100)..'%\n- 防雷：100%\n- 理智：-5\n- 受击时会触发骨甲的免伤效果，不消耗耐久，冷却时间'..db.OVERLORDBLOOD.CD..'秒。\n- 被动：【专横】\n\t将玩家'..(db.OVERLORDBLOOD.SKILL_MAXHP_TO_ATK*100)..'%最大生命值转化为额外攻击力。\n- 被动：【报复】\n\t将玩家损失生命值'..(db.OVERLORDBLOOD.SKILL_LOSTHP_TO_ATK*100)..'%转化为额外攻击力。\n- 被动：【霸者神威】\n\t与恶魔之拥同时装备时触发套装效果，免疫击飞和受击硬直。\n- 属于暗影物品，暗影等级'..db.OVERLORDBLOOD.SHADOW_LEVEL..'。\n- 击败远古织影者'..(db.OVERLORDBLOOD.BLUEPRINTDROP_CHANCE.STALKER_ATRIUM*100)..'%掉落蓝图。\n- 耐久：'..db.OVERLORDBLOOD.DURABILITY..'，耐久耗尽不会损坏\n- 在耐久低于'..(db.OVERLORDBLOOD.AUTO_REPAIR.START*100)..'%时会吸取玩家生命值恢复耐久，每'..db.OVERLORDBLOOD.AUTO_REPAIR.INTERVAL..'秒-'..db.OVERLORDBLOOD.AUTO_REPAIR.DRAIN..'点生命值，恢复'..db.OVERLORDBLOOD.AUTO_REPAIR.REPAIR..'点耐久。'
        },
        lol_wp_demonicembracehat = {
            name = '恶魔之拥',
            info_instead = '- 类型：头盔/面具\n- 防御力：'..(db.DEMONICEMBRACEHAT.ABSORB*100)..'%\n- 位面防御：'..db.DEMONICEMBRACEHAT.DEFEND_PLANAR..'\n- 防水：'..(db.DEMONICEMBRACEHAT.WATERPROOF*100)..'%\n- 防雷：100%\n- 理智：-20\n- 会发出半径2的紫色光照。\n- 佩戴时右键可以切换头盔和面具形态，面具形态'..db.DEMONICEMBRACEHAT.WHEN_MASKED.DARPPERNESS..'san/min，有骨头头盔效果和护目镜效果，获得和鼹鼠帽相同的夜视能力，头盔形态-5san/min，没有特殊效果。\n- 被动：【黑暗契约】\n\t将玩家'..(db.DEMONICEMBRACEHAT.SKILL_DARKCONVENANT.TRANSFER_MAXHP_PERCENT*100)..'%的最大生命值转化为额外的位面伤害。\n- 被动：【亚扎卡纳的凝视】\n\t对一名敌人造成伤害时，会造成相当于其'..(db.DEMONICEMBRACEHAT.SKILL_STARE.MAXHP_PERCENT*100)..'%最大生命值的额外位面伤害，冷却'..db.DEMONICEMBRACEHAT.SKILL_STARE.CD..'秒。\n- 被动：【霸者神威】\n\t与霸王血铠同时装备时触发套装效果，免疫击飞和受击硬直。\n- 属于暗影物品，暗影等级'..db.DEMONICEMBRACEHAT.SHADOW_LEVEL..'。\n- 击败远古织影者'..(db.DEMONICEMBRACEHAT.BLUEPRINTDROP_CHANCE.STALKER_ATRIUM*100)..'%掉落蓝图。\n- 耐久：'..db.DEMONICEMBRACEHAT.DURABILITY..'，耐久耗尽不会损坏\n- 在耐久不足时会吸取玩家理智值恢复耐久，同绝望石装备。'
        },
        lol_wp_warmogarmor = {
            name = '狂徒铠甲',
            info_instead = '- 类型：护甲\n- 防御力：'..(db.WARMOGARMOR.ABSORB*100)..'%\n- 隔热：'..db.WARMOGARMOR.INSULATION..'\n- 防水：'..(db.WARMOGARMOR.WATERPROOF*100)..'%\n- 精理智：+'..db.WARMOGARMOR.DARPPERNESS..'\n- 饥饿速度-'..((1-db.WARMOGARMOR.HUNGERRATE)*100)..'%\n- 移速'..((db.WARMOGARMOR.WALKSPEEDMULT - 1) >= 0 and '+' or '')..((db.WARMOGARMOR.WALKSPEEDMULT-1)*100)..'%'..'\n- 主动：【真菌毒雾】\n\t在原地召唤一片孢子云，效果和睡袋完全一致，消耗'..db.WARMOGARMOR.SKILL_POISONFOG.CONSUME_FINITEUSE..'点耐久，冷却'..db.WARMOGARMOR.SKILL_POISONFOG.CD..'秒。\n- 被动：【狂徒之心】\n\t穿戴时在'..db.WARMOGARMOR.SKILL_HEART.NO_TAKE_DMG_IN..'秒内没有受到伤害，血量低于'..(db.WARMOGARMOR.SKILL_HEART.HP_PERCENT_BELOW*100)..'%时，则每'..db.WARMOGARMOR.SKILL_HEART.INTERVAL..'秒恢复自身'..(db.WARMOGARMOR.SKILL_HEART.REGEN_PERCENT*100)..'%最大生命值的血量，并额外增加'..(db.WARMOGARMOR.SKILL_HEART.WALKSPEEDMULT*100)..'%移速，受到攻击时不会消耗耐久，在触发狂徒之心时每秒消耗'..db.WARMOGARMOR.SKILL_HEART.RESUME..'点耐久。\n- 被动：【想去哪就去哪】\n\t穿戴时免疫击飞效果。\n- 穿戴时会放出绿色的蘑菇孢子。\n- 击败悲惨的毒菌蟾蜍'..(db.WARMOGARMOR.BLUEPRINTDROP_CHANCE.TOADSTOOL_DARK*100)..'%掉落蓝图，普通毒菌蟾蜍'..(db.WARMOGARMOR.BLUEPRINTDROP_CHANCE.TOADSTOOL*100)..'%掉落蓝图。\n- 耐久：'..db.WARMOGARMOR.DURABILITY..'，耐久耗尽不会损坏'
        },
        lol_wp_s8_deathcap = {
            name = '灭世者的死亡之帽',
            info_instead = '- 类型：帽子\n- 防水：'..(db.DEATHCAP.WATERPROOF*100)..'%\n- 防雷：100%\n- 理智：-10\n- 拥有魔术师高礼帽的功能，并且除麦斯威尔以外的角色也可以使用。\n- 会发出半径'..db.DEATHCAP.LIGHT_RADIUS..'的蓝色光照。\n- 被动：【魔法乐章】\n\t每次攻击附带额外'..db.DEATHCAP.SKILL_MAGIC.WEAR_INCREASE_PLANAR_DMG..'点位面伤害，佩戴时会使当前造成的位面伤害提升'..((db.DEATHCAP.SKILL_MAGIC.WEAR_INCREASE_PLANAR_DMG_MULT-1)*100)..'%。\n- 属于暗影物品，暗影等级'..db.DEATHCAP.SHADOW_LEVEL..'，使用暗影物品会额外增伤'..((db.DEATHCAP.WEAR_INCREASE_SHADOW_WEAPON_DMGMULT-1)*100)..'%。\n- 耐久：无'
        },
        lol_wp_s8_uselessbat = {
            name = '无用大棒',
            info_instead = '- 类型：近战武器/工具/锤子\n- 攻击力：'..db.USELESSBAT.DMG..'\n- 位面伤害：'..db.USELESSBAT.PLANAR_DMG..'\n- 工作效率：锤100%\n- 理智：-5\n- 属于暗影物品，暗影等级'..db.USELESSBAT.SHADOW_LEVEL..'，对月亮阵营伤害增加'..((db.USELESSBAT.DMGMULT_TO_PLANAR-1)*100)..'%。\n- 耐久：'..db.USELESSBAT.FINITEUSE..'，耐久耗尽会损坏'
        },
        lol_wp_s8_lichbane = {
            name = '巫妖之祸',
            info_instead = '- 类型：近战武器/剑\n- 位面伤害：'..db.LICHBANE.PLANAR_DMG..'\n- 会发出半径'..db.LICHBANE.LIGHT_RADIUS..'的金色光照。\n- 理智：-10\n- 移速'..((db.LICHBANE.WALKSPEEDMULT - 1) >= 0 and '+' or '')..((db.LICHBANE.WALKSPEEDMULT-1)*100)..'%'..'\n- 被动：【咒刃】\n\t攻击会触发一次强化攻击，造成'..(db.LICHBANE.SKILL_CURSEBLADE.DMGMULT*100)..'%的伤害，冷却时间'..db.LICHBANE.SKILL_CURSEBLADE.CD..'秒。\n- 被动：【祸源】\n\t攻击的目标获得'..((db.LICHBANE.SKILL_CURSERACE.DMGMULT-1)*100)..'%易伤，持续'..db.LICHBANE.SKILL_CURSERACE.LAST..'秒，攻击会点燃目标，造成每'..db.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_PERIOD..'秒'..db.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_DMG..'点的火焰伤害，持续'..db.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_LAST..'秒。\n- 击败附身座狼'..(db.LICHBANE.DROP_CHANCE.mutatedwarg*100)..'%掉落一个成品\n- 属于暗影物品，暗影等级'..db.LICHBANE.SHADOW_LEVEL..'，对月亮阵营伤害增加'..((db.LICHBANE.DMGMULT_TO_PLANAR-1)*100)..'%。\n- 耐久：耐久'..db.LICHBANE.FUELED..'分钟，耐久不随攻击次数降低，而是随着时间降低，耐久耗尽后不会损坏，但剑刃上的火焰会消失，失去光照。可以装备，但只有'..db.LICHBANE.DMG_WHEN_NO_DURABILITY..'物理伤害，并且不会触发任何特殊效果。'
        },
        lol_wp_s9_guider = {
            name = '引路者',
            info_instead = '- 类型：容器/背包\n- 容量：14\n- 防御：'..(db.GUIDER.ABSORB*100)..'%\n- 保暖：'..db.GUIDER.AVOID_COLD..'\n- 防水：'..(db.GUIDER.WATERPROOF*100)..'%\n- 理智：+'..db.GUIDER.DARPPERNESS..'\n- 会发出半径'..db.GUIDER.LIGHT.RADIUS..'的金色光照。\n- 有冰箱保鲜效果。\n- 防火，不会被点燃。\n- 移速'..((db.GUIDER.WALKSPEEDMULT - 1) >= 0 and '+' or '')..((db.GUIDER.WALKSPEEDMULT-1)*100)..'%'..'\n- 被动：【引路】\n\t会给半径'..db.GUIDER.SKILL_GUIDE.RADIUS..'范围内的玩家提供'..((db.GUIDER.SKILL_GUIDE.WALKSPEEDMULT-1)*100)..'%移速加成，多人同时装备不会叠加，攻击敌人会附带'..(db.GUIDER.SKILL_GUIDE.ATK_SPEEDDOWN*100)..'%减速，持续'..db.GUIDER.SKILL_GUIDE.LAST..'秒，冷却'..db.GUIDER.SKILL_GUIDE.CD..'秒。\n- 耐久：无'
        },
        lol_wp_s9_eyestone_low = {
            name = '戒备眼石',
            info_instead = '- 类型：容器/护符\n- 被动：【奥术窖藏】\n\t佩戴时出现3个额外护符栏，类似融合勋章，可以放入英雄联盟武器的护符物品，不可放入有容器的护符，同种护符不能同时装备2个，装备时会同时生效。\n- 被动：【均衡】\n\t所有放入眼石的护符提供的额外物理/位面伤害减少'..((1-db.ITEM_EFFECT_RATE_IN_EYESTONE)*100)..'%，可以在模组设置调整。\n- 耐久：无'
        },
        lol_wp_s9_eyestone_high = {
            name = '警觉眼石',
            info_instead = '- 类型：容器/护符\n- 被动：【奥术窖藏】\n\t佩戴时出现6个额外护符栏，类似融合勋章，可以放入英雄联盟武器的护符物品，不可放入有容器的护符，同种护符不能同时装备2个，装备时会同时生效。\n- 被动：【均衡】\n\t所有放入眼石的护符提供的额外物理/位面伤害减少'..((1-db.ITEM_EFFECT_RATE_IN_EYESTONE)*100)..'%，可以在模组设置调整。\n- 耐久：无'
        },
        lol_wp_s10_guinsoo = {
            name = '鬼索的狂暴之刃',
            info_instead = '- 类型：近战武器/刀\n- 攻击力：'..db.GUINSOO.DMG..'\n- 位面伤害：'..db.GUINSOO.PLANAR_DMG..'\n- 主动：【旋风斩】\n\t朝指定方向突刺，对路径上的敌人造成'..db.GUINSOO.SKILL_ALPHA.DMG..'伤害和'..db.GUINSOO.SKILL_ALPHA.PLANAR_DMG..'点位面伤害，冷却'..db.GUINSOO.SKILL_ALPHA.CD..'秒。\n- 被动：【沸腾打击】\n\t每次攻击会提供'..(db.GUINSOO.SKILL_BOILSTRIKE.SPEED_PER*100)..'%攻击速度，至多可叠加'..db.GUINSOO.SKILL_BOILSTRIKE.MAXSTACK..'次并至多提供'..(db.GUINSOO.SKILL_BOILSTRIKE.SPEED_PER*db.GUINSOO.SKILL_BOILSTRIKE.MAXSTACK*100)..'%攻击速度，持续'..db.GUINSOO.SKILL_BOILSTRIKE.COMBO_KEEPTIME..'秒。\n- 叠满后会持续升温，温度相当于龙鳞火炉，发出半径'..db.GUINSOO.LIGHT.RADIUS..'的金色光照，攻击会点燃目标，造成每'..db.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_PERIOD..'秒'..db.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_DMG..'点的火焰伤害，持续'..db.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_LAST..'秒。\n- 击败龙蝇'..(db.GUINSOO.BLUEPRINTDROP_CHANCE.dragonfly*100)..'%掉落蓝图。\n- 手持时会播放羊刀的小曲，右键武器可以关闭。\n- 击败装甲熊獾'..(db.GUINSOO.DROP_CHANCE.mutatedbearger*100)..'%掉落一个成品\n- 耐久：'..db.GUINSOO.FINITEUSE..'，耐久耗尽不会损坏'
        },
        lol_wp_s10_blastingwand = {
            name = '爆裂魔杖',
            info_instead = '- 类型：远程武器/法杖\n- 位面伤害：'..db.BLASTINGWAND.PLANAR_DMG..'\n- 攻击距离：'..db.BLASTINGWAND.RANGE..'\n- 理智：-5\n- 攻击会点燃目标，造成每'..db.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_PERIOD..'秒'..db.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_DMG..'点的火焰伤害，持续'..db.GUINSOO.SKILL_BOILSTRIKE.WHEN_MAXSTACK_BURN_LAST..'秒。\n- 属于暗影物品，暗影等级'..db.BLASTINGWAND.SHADOW_LEVEL..'，对月亮阵营伤害增加'..((db.BLASTINGWAND.DMGMULT_TO_PLANAR-1)*100)..'%。\n- 耐久：'..db.BLASTINGWAND.FINITEUSE..'，耐久耗尽会损坏'
        },
        lol_wp_s10_sunfireaegis = {
            name = '日炎圣盾',
            info_instead = '- 类型：近战武器/盾牌/护甲\n- 攻击力：'..db.SUNFIREAEGIS.DMG..'\n- 防御力：'..(db.SUNFIREAEGIS.ABSORB*100)..'%\n- 保暖：'..db.SUNFIREAEGIS.AVOID_COLD..'\n- 免疫火焰伤害。\n- 移速'..((db.SUNFIREAEGIS.WALKSPEEDMULT - 1) >= 0 and '+' or '')..((db.SUNFIREAEGIS.WALKSPEEDMULT-1)*100)..'%'..'\n- 主动：【烈阳庇护】\n\t右键点击并选中方向后即能格挡来自对应方向的攻击，持续3秒钟，格挡不损失耐久，在格挡成功时对周围半径'..db.SUNFIREAEGIS.SKILL_SUNSHELTER.SUCCESS_BLOCK.RANGE..'码范围造成'..db.SUNFIREAEGIS.SKILL_SUNSHELTER.SUCCESS_BLOCK.PLANAR_DMG..'点位面伤害和自身生命值'..(db.SUNFIREAEGIS.SKILL_SUNSHELTER.SUCCESS_BLOCK.EXTRA_DMG_OF_MAXHEALTH*100)..'%的额外位面伤害。\n- 被动：【献祭】\n\t装备时，人物脚下会出现一个红色的圈，在人物半径'..db.SUNFIREAEGIS.SKILL_SACRIFICE.RANGE..'码范围内的敌人会受到每'..db.SUNFIREAEGIS.SKILL_SACRIFICE.INTERVAL..'秒'..db.SUNFIREAEGIS.SKILL_SACRIFICE.PER_PLANARDMG..'点的位面伤害和自身最大生命值5%的额外位面伤害。\n- 被动：【烈焰之触】\n\t攻击会点燃敌人，造成每'..db.SUNFIREAEGIS.SKILL_FIRETOUCH.BURN_PERIOD..'秒'..db.SUNFIREAEGIS.SKILL_FIRETOUCH.BURN_DMG..'点的火焰伤害，持续'..db.SUNFIREAEGIS.SKILL_FIRETOUCH.BURN_LAST..'秒。\n- 在装备时右键可以改变形态，名称变为【日炎斗篷】能够作为护甲装备，数值不变，同时会触发【献祭】的效果，但同时装备日炎圣盾和日炎斗篷只会触发一次【献祭】，而【烈焰之触】变为受到攻击才会点燃目标，类似于鳞甲。\n- 击败龙蝇'..(db.GUINSOO.BLUEPRINTDROP_CHANCE.dragonfly*100)..'%掉落蓝图。\n- 耐久：'..db.SUNFIREAEGIS.FINITEUSE..'，耐久耗尽不会损坏'
        },
        lol_wp_s11_amplifyingtome = {
            name = '增幅典籍',
            info_instead = '- 类型：护符/魔法书\n- 额外位面伤害：'..db.AMPLIFYINGTOME.PLANAR_DMG..'\n- 可以放入书架回复耐久。\n- 主动：【末日将至】\n\t佩戴时，拥有读书能力的人物可以阅读，会在角色周围召唤16道闪电，与“末日将至！”的效果相同，使用后扣除'..(db.AMPLIFYINGTOME.CONSUME_WHEN_READ*100)..'%的耐久。\n- 属于暗影物品，暗影等级2。\n- 耐久：'..db.AMPLIFYINGTOME.FINITEUSES..'，耐久耗尽会损坏'
        },
        lol_wp_s11_darkseal = {
            name = '黑暗封印',
            info_instead = '- 类型：护符/戒指\n- 额外位面伤害：'..db.DARKSEAL.PLANAR_DMG..'\n- 理智：-10\n- 不可与梅贾的窃魂卷同时装备。\n- 被动：【荣耀】\n\t每参与击杀一个boss生物获得'..db.DARKSEAL.SKILL_HONOR.STACK_PER_BOSSSKILL..'层被动，每层被动提供'..db.DARKSEAL.SKILL_HONOR.EXTRA_PLANAR_DMG_PER_STACK..'点额外位面伤害，最多叠加'..db.DARKSEAL.SKILL_HONOR.MAXSTACK..'层，共25点额外位面伤害，在佩戴时死亡会清除'..db.DARKSEAL.SKILL_HONOR.PLAYER_DEATH_CONSUME_STACK..'层被动\n- 属于暗影物品，暗影等级'..db.DARKSEAL.SHADOW_LEVEL..'。\n- 耐久：无\n- 物品下方会显示叠加的层数。'
        },
        lol_wp_s11_mejaisoulstealer = {
            name = '梅贾的窃魂卷',
            info_instead = '- 类型：护符/魔法书\n- 额外位面伤害：'..db.MEJAISOULSTEALER.PLANAR_DMG..'\n- 理智：-20\n- 制作时可以继承黑暗封印叠加的被动，不可与黑暗封印同时装备。\n- 被动：【荣耀】\n\t亲手击杀一个boss生物获得'..db.MEJAISOULSTEALER.SKILL_HONOR.BOSSKILL_BY_SELF_STACK..'层被动，参与击杀获得'..db.MEJAISOULSTEALER.SKILL_HONOR.STACK_PER_BOSSSKILL..'层被动，每层被动提供'..db.MEJAISOULSTEALER.SKILL_HONOR.EXTRA_PLANAR_DMG_PER_STACK..'点额外位面伤害，最多可叠加'..db.MEJAISOULSTEALER.SKILL_HONOR.MAXSTACK..'层，共50点额外位面伤害，在佩戴时死亡会清除'..db.MEJAISOULSTEALER.SKILL_HONOR.PLAYER_DEATH_CONSUME_STACK..'层被动。\n- 属于暗影物品，暗影等级'..db.MEJAISOULSTEALER.SHADOW_LEVEL..'。\n- 耐久：无\n- 物品下方会显示叠加的层数。'
        },
        lol_wp_s12_eclipse = {
            name = '星蚀',
            info_instead = '- 类型：近战武器/刀\n- 攻击力：'..db.ECLIPSE.DMG..'\n- 攻击距离：'..db.ECLIPSE.RANGE..'\n- 理智：+'..db.ECLIPSE.DARPPERNESS..'\n- 会发出半径'..db.ECLIPSE.LIGHT.RADIUS..'码的蓝色光照\n- 移速'..((db.ECLIPSE.WALKSPEEDMULT - 1) >= 0 and '+' or '')..((db.ECLIPSE.WALKSPEEDMULT-1)*100)..'%'..'\n- 主动：【新月打击】\n\t右键原地跳劈释放'..db.ECLIPSE.SKILL_NEWMOON_STRIKE.LASER_NUM..'道激光，消耗'..db.ECLIPSE.SKILL_NEWMOON_STRIKE.CONSUME_SAN..'理智，每道激光造成'..db.ECLIPSE.SKILL_NEWMOON_STRIKE.LASER_PLANAR_DMG..'点位面伤害，会破坏路径上的矿石和树木，不会破坏建筑，冷却时间'..db.ECLIPSE.SKILL_NEWMOON_STRIKE.CD..'秒。\n- 被动：【永升之月】\n\t每第'..db.ECLIPSE.SKILL_EVERMOON.ATK_COUNT_DO_EXTRA..'次攻击会造成敌方最大生命值'..(db.ECLIPSE.SKILL_EVERMOON.ENEMY_MAXHP_RATE_PLANAR_DMG*100)..'%的额外位面伤害，并为你提供持续'..db.ECLIPSE.SKILL_EVERMOON.SHIELD_DURATION..'秒的无敌护盾，冷却时间'..db.ECLIPSE.SKILL_EVERMOON.CD..'秒。\n- 属于月亮阵营，对暗影阵营伤害增加'..((db.ECLIPSE.DMGMULT_TO_SHADOW-1)*100)..'%。\n- 被动：【月蚀骑士】\n\t和亮茄头盔，亮茄盔甲同时装备时获得套装效果，增加20点位面伤害\n- 被动：【狂雷渐起】\n\t和兰德里的折磨，末日寒冬同时装备时获得套装效果，武器带电。\n- 击败天体英雄'..(db.ECLIPSE.BLUEPRINTDROP_CHANCE.alterguardian_phase3*100)..'%掉落蓝图。\n- 耐久：无\n- 物品下方会显示永升之月的冷却时间。'
        },
        lol_wp_s12_malignance = {
            name = '焚天',
            info_instead = '- 类型：近战武器/骑枪\n- 攻击力：'..db.MALIGNANCE.DMG..'\n- 攻击距离：'..db.MALIGNANCE.RANGE..'\n- 移速'..((db.MALIGNANCE.WALKSPEEDMULT - 1) >= 0 and '+' or '')..((db.MALIGNANCE.WALKSPEEDMULT-1)*100)..'%'..'\n- 主动：【堕天一击】\n\t跳跃到空中，在鼠标指定位置造成半径'..db.MALIGNANCE.SKILL_FALLEN_BLOW.RADIUS..'码的'..db.MALIGNANCE.SKILL_FALLEN_BLOW.DAMAGE..'点物理伤害，但不会触发【光盾打击】，破坏范围内的矿石和树木，不会破坏建筑，冷却'..db.MALIGNANCE.SKILL_FALLEN_BLOW.CD..'秒。被动：【光盾打击】\n\t对目标的第一次攻击会造成三连击，如果是boss单位，还会治疗自身'..db.MALIGNANCE.SKILL_GLOWSHIELD_STRIKE.HEAL_HP..'点生命值和损失血量'..(db.MALIGNANCE.SKILL_GLOWSHIELD_STRIKE.HEAL_LOST_RATE_HP*100)..'%的生命值，每个目标单独冷却'..db.MALIGNANCE.SKILL_GLOWSHIELD_STRIKE.CD_PER_TARGET..'秒。\n- 属于月亮阵营，对暗影阵营伤害增加'..((db.MALIGNANCE.DMGMULT_TO_SHADOW-1)*100)..'%。\n- 耐久：'..db.MALIGNANCE.FINITEUSES..'，耐久耗尽不会损坏'
        },
        alchemy_chainsaw = {name = '炼金朋克链锯剑', info_instead = '- 类型：近战武器/工具/链锯\n- 攻击力：51\n- 移速+10%\n- 主动：【链锯启动】\n\t右键装备可以让链锯旋转，攻击力变为68，每2s消耗1耐久，可以触发【怜悯】和【劈削】,可以快速砍树，再次右键装备可以关闭。\n- 工作效率：斧：1000%\n- 主动：【怜悯】\n\t启动链锯后解锁右键技能，消耗10点生命值，右键目标可以跳跃斩击造成武器当前攻击力的2倍伤害，并提前结算流血伤害，造成（流血伤害x流血层数x剩余时间）的额外伤害，同时清空目标身上的流血层数。如果使目标血量被降低到25%/8%（普通生物/BOSS）以下会直接斩杀并回复自身15点san值和15点血量，冷却时间20秒。\n- 被动：【劈削】\n\t每次攻击会附带流血效果和60%重伤效果（减少目标60%的回复），每秒造成2点伤害，持续20秒，在20秒内再次攻击可使流血效果叠加，一共可以叠加10层，即每秒最大造成20点伤害，会受到攻击倍率影响。\n- 击败拾荒疯猪100%掉落蓝图。\n- 耐久：400，耐久耗尽不会损坏，可以装备，但攻击力转变为34。\n- 修复材料：齿轮20%/自动修理机100%'},
        lol_wp_s13_infinity_edge = {
            name = '无尽之刃',
            info_instead = '- 类型：近战武器/剑/护符\n- 攻击力：'..db.INFINITY_EDGE.DMG..'\n- 攻击距离：'..db.INFINITY_EDGE.RANGE..'\n- 暴击：'..(db.INFINITY_EDGE.CRITICAL_CHANCE*100)..'%的概率造成'..db.INFINITY_EDGE.CRITICAL_DMGMULT..'倍伤害\n- 被动：【无尽之力】\n\t装备时增加'..((db.INFINITY_EDGE.SKILL_INFINITY_EDGE.OWNER_DMGMULT_WHEN_EQUIP-1)*100)..'%攻击倍率。\n- 装备后右键可以转换成护符物品，佩戴时会获得特殊被动：\n- 被动：【无尽之力】\n\t装备时增加'..((db.INFINITY_EDGE.AS_AMULET.OWNER_DMGMULT_WHEN_EQUIP-1)*100)..'%攻击倍率，'..db.INFINITY_EDGE.AS_AMULET.DARPPERNESS..'san/min，增加所有武器'..(db.INFINITY_EDGE.AS_AMULET.CRITICAL_CHANCE*100)..'%暴击率和'..((db.INFINITY_EDGE.AS_AMULET.CRITICAL_DMGMULT-1)*100)..'%暴击伤害，可以让所有武器触发暴击，但暴击伤害只有1.5倍。\n- 位面伤害不会触发暴击。\n- 耐久：'..db.INFINITY_EDGE.FINITEUSES..'，耐久耗尽不会损坏'
        },
        lol_wp_s13_statikk_shiv = {
            name = '斯塔缇克电刃',
            info_instead = '- 类型：近战武器/剑\n- 攻击力：'..db.STATIKK_SHIV.DMG..'\n- 攻击带电，对目标造成1.5倍伤害，对潮湿目标造成2.5倍伤害。\n- 暴击：'..(db.STATIKK_SHIV.CRITICAL_CHANCE*100)..'%的概率造成'..db.STATIKK_SHIV.CRITICAL_DMGMULT..'倍伤害。\n- 移速'..((db.STATIKK_SHIV.WALKSPEEDMULT - 1) >= 0 and '+' or '')..((db.STATIKK_SHIV.WALKSPEEDMULT-1)*100)..'%'..'\n- 被动：【电火花】\n\t使前'..db.STATIKK_SHIV.SKILL_ELECTRIC_SPARK.HIT_TIMES..'次攻击在命中时发射连锁闪电，会连锁攻击目标'..db.STATIKK_SHIV.SKILL_ELECTRIC_SPARK.CHAIN_RANGE..'码内最近的单位造成'..db.STATIKK_SHIV.SKILL_ELECTRIC_SPARK.PLANAR_DMG_WHEN_CHAIN..'点位面伤害，最多连锁'..db.STATIKK_SHIV.SKILL_ELECTRIC_SPARK.CHAIN_MAX_TARGET..'个目标，每个目标只会被连锁一次，冷却时间'..db.STATIKK_SHIV.SKILL_ELECTRIC_SPARK.CD..'秒。\n- 被动：【盈能】\n\t每次攻击会减少'..db.STATIKK_SHIV.SKILL_CHARGE.REDUCE_SKILL_ELECTRIC_SPARK_PER_HIT..'秒被动技能冷却时间。\n- 放在地上有避雷针功能，会优先引雷，在被闪电劈中后变成【斯塔缇克电刀】\n- 耐久：'..db.STATIKK_SHIV.FINITEUSES..'，耐久耗尽不会损坏\n- 使用武器左键点击避雷针和发电机可以修复100%耐久，并消耗其1格充能/电量。'
        },
        lol_wp_s13_statikk_shiv_charged = {
            name = '斯塔缇克电刀',
            info_instead = '- 类型：近战武器/刀\n- 攻击力：'..db.STATIKK_SHIV_CHARGED.DMG..'\n- 攻击带电，对目标造成1.5倍伤害，对潮湿目标造成2.5倍伤害。\n- 暴击：'..(db.STATIKK_SHIV_CHARGED.CRITICAL_CHANCE*100)..'%的概率造成'..db.STATIKK_SHIV_CHARGED.CRITICAL_DMGMULT..'倍伤害。\n- 会发出半径'..db.STATIKK_SHIV_CHARGED.LIGHT.RADIUS..'的白色光照。\n- 移速'..((db.STATIKK_SHIV_CHARGED.WALKSPEEDMULT - 1) >= 0 and '+' or '')..((db.STATIKK_SHIV_CHARGED.WALKSPEEDMULT-1)*100)..'%'..'\n- 被动：【电火花】\n\t每次攻击都会发射连锁闪电，会连锁攻击目标'..db.STATIKK_SHIV_CHARGED.SKILL_ELECTRIC_SPARK.CHAIN_RANGE..'码内最近的单位造成'..db.STATIKK_SHIV_CHARGED.SKILL_ELECTRIC_SPARK.PLANAR_DMG_WHEN_CHAIN..'点位面伤害，最多连锁'..db.STATIKK_SHIV_CHARGED.SKILL_ELECTRIC_SPARK.CHAIN_MAX_TARGET..'个目标，每个目标只会被连锁一次，无冷却。\n- 放在地上有避雷针功能，会优先引雷，在被闪电劈中后会回满耐久。\n- 耐久：'..db.STATIKK_SHIV_CHARGED.FINITEUSES..'，耐久耗尽会变回【斯塔缇克电刃】\n- 使用武器左键点击避雷针和发电机可以修复100%耐久，并消耗其1格充能/电量。',
        },
        lol_wp_s13_collector = {
            name = '收集者',
            info_instead = '- 类型：远程武器/火枪\n- 攻击力：'..db.COLLECTOR.DMG..'\n- 攻击速度：0.5\n- 攻击距离：'..db.COLLECTOR.RANGE..'\n- 暴击：'..(db.COLLECTOR.CRITICAL_CHANCE*100)..'%的概率造成'..db.COLLECTOR.CRITICAL_DMGMULT..'倍伤害。\n- 有一个弹药格子，需要使用金块作为弹药，每次攻击消耗1个，没有弹药时无法攻击。\n- 被动：【死与税】\n\t如果你造成的伤害使敌方的生命值跌到'..(db.COLLECTOR.SKILL_DEATH_AND_TAX.SEC_KILL_HP_LINE*100)..'%以下，那么会直接将其处决，并造成'..db.COLLECTOR.SKILL_DEATH_AND_TAX.PLANAR_DMG_WHEN_SEC_KILL..'的位面伤害。击杀boss生物时会为你提供额外的'..db.COLLECTOR.SKILL_DEATH_AND_TAX.GOLDNUGGET_WHEN_KILL_BOSS..'金块，击杀普通生物会掉落'..db.COLLECTOR.SKILL_DEATH_AND_TAX.GOLDNUGGET_WHEN_KILL_NORMAL..'个金块。\n- 有概率在沉底宝箱开出，概率会随着世界天数的增加而上升，第 1 天的概率是'..(db.COLLECTOR.DROP_FROM_OCEANCHEST.START_CHANCE*100)..'%，在第 '..db.COLLECTOR.DROP_FROM_OCEANCHEST.MAX_DAY..' 天到达上限 '..(db.COLLECTOR.DROP_FROM_OCEANCHEST.MAX_CHANCE*100)..'%。\n- 耐久：无'
        },
        lol_wp_s14_bramble_vest = {
            name = '棘刺背心',
            info_instead = '- 类型：护甲\n- 防御力：'..(db.BRAMBLE_VEST.ABSORB*100)..'%\n- 防水：'..(db.BRAMBLE_VEST.WATERPROOF*100)..'%\n- 被动：【荆棘】\n\t装备时会将敌方伤害的'..(db.BRAMBLE_VEST.SKILL_BRAMBLE.REFLECT_DMG_PERCENT*100)..'%转化为位面伤害直接反弹给攻击者，功能与荆棘外壳相似。被反伤的敌人会受到'..(db.BRAMBLE_VEST.SKILL_BRAMBLE.REFLECTED_TARGET_DMGTAKEN*100)..'%易伤，持续'..(db.BRAMBLE_VEST.SKILL_BRAMBLE.DMGTAKEN_LAST)..'秒。\n- 耐久：'..db.BRAMBLE_VEST.FINITEUSES..'，耐久耗尽会损坏',
        },
        lol_wp_s14_thornmail = {
            name = '荆棘之甲',
            info_instead = '- 类型：护甲\n- 防御力：'..(db.THORNMAIL.ABSORB*100)..'%\n- 防水：'..(db.THORNMAIL.WATERPROOF*100)..'%\n- 理智：-5\n- 移速'..((db.THORNMAIL.WALKSPEEDMULT - 1) >= 0 and '+' or '')..((db.THORNMAIL.WALKSPEEDMULT-1)*100)..'%'..'\n- 被动：【荆棘】\n\t装备时会将敌方伤害的'..(db.THORNMAIL.SKILL_BRAMBLE.REFLECT_DMG_PERCENT*100)..'%转化为位面伤害直接反弹给攻击者，功能与荆棘外壳相似。被反伤的敌人会受到'..(db.THORNMAIL.SKILL_BRAMBLE.REFLECTED_TARGET_DMGTAKEN*100)..'%易伤，持续'..db.THORNMAIL.SKILL_BRAMBLE.DMGTAKEN_LAST..'秒。\n- 属于暗影物品，暗影等级'..db.THORNMAIL.SHADOW_LEVEL..'。\n- 击败梦魇疯猪'..(db.THORNMAIL.BLUEPRINTDROP_CHANCE.daywalker*100)..'%掉落蓝图。\n- 耐久：'..db.THORNMAIL.FINITEUSES..'，耐久耗尽不会损坏\n- 在耐久不足时会吸取玩家理智值恢复耐久，同绝望石装备。',
        },
        lol_wp_s14_hubris = {
            name = '狂妄',
            info_instead = '- 类型：头盔/王冠\n- 防御力：'..(db.HUBRIS.ABSORB*100)..'%\n- 额外攻击力：'..db.HUBRIS.DMG_WHEN_EQUIP..'\n- 理智：-10\n- 移速'..((db.HUBRIS.WALKSPEEDMULT - 1) >= 0 and '+' or '')..((db.HUBRIS.WALKSPEEDMULT-1)*100)..'%'..'\n- 被动：【盛名】\n\t每参与击杀一个boss生物会叠加'..db.HUBRIS.SKILL_REPUTATION.BOSSKILL_BY_SELF_STACK..'层被动，每层被动提供'..db.HUBRIS.SKILL_REPUTATION.DMG_PER_STACK..'点攻击力，上限'..(not db.HUBRIS.SKILL_REPUTATION.MAXSTACK and '无限' or db.HUBRIS.SKILL_REPUTATION.MAXSTACK)..'层，可以在模组设置里更改为无限。\n- 属于暗影物品，暗影等级'..db.HUBRIS.SHADOW_LEVEL..'。\n- 击败蜂王'..(db.HUBRIS.BLUEPRINTDROP_CHANCE.beequeen*100)..'%掉落蓝图。\n- 耐久：无\n- 物品下方会显示叠加的层数。',
        },
        lol_wp_s15_crown_of_the_shattered_queen = {
            name = '破碎王后之冕',
            info_instead = '- 类型：头盔/王冠\n- 防御力：'..(db.CROWN_OF_THE_SHATTERED_QUEEN.ABSORB*100)..'%\n- 位面防御：'..db.CROWN_OF_THE_SHATTERED_QUEEN.DEFEND_PLANAR..'\n- 额外位面伤害：'..db.CROWN_OF_THE_SHATTERED_QUEEN.PLANAR_DMG_WHEN_EQUIP ..'\n- 理智：+'..db.CROWN_OF_THE_SHATTERED_QUEEN.DARPPERNESS..'\n- 被动：【护卫】\n\t佩戴时生成一个铥矿皇冠同样的护盾，免疫所有伤害，持续时间无限，护盾持续期间回san速度翻倍，受到攻击'..db.CROWN_OF_THE_SHATTERED_QUEEN.SKILL_GUARD.FADE_WHEN_ATTACKED..'秒后消失，冷却时间'..db.CROWN_OF_THE_SHATTERED_QUEEN.SKILL_GUARD.CD..'秒。\n- 被动：【哀悼】\n\t与破败王者之刃同时装备时，其伤害提升'..((db.CROWN_OF_THE_SHATTERED_QUEEN.SKILL_MOURN.DMGMULT-1)*100)..'%。\n- 属于月亮阵营。\n- 耐久：无',
        },
        lol_wp_s15_stopwatch = {
            name = '秒表',
            info_instead = '- 类型：特殊道具\n- 用于进行短距离内的瞬间移动。当玩家的物品栏中有秒表时，在玩家走过的路径上会不断生成时间节点\n- 主动：【回溯】\n\t右键物品会把玩家瞬间传送到时间节点的位置。冷却时间'..db.STOPWATCH.SKILL_TRACEBACK.CD..'秒。功能与旺达的倒走表完全一致，但其他人物也可以使用。\n- 主动：【时空断裂】\n\t旺达使用时，右键物品会瞬移到时间节点的位置，同时会造成'..db.STOPWATCH.SKILL_JIKU.PLANAR_DMG..'大范围位面伤害，并触发一次不老表的效果，回复时间值，冷却时间'..db.STOPWATCH.SKILL_JIKU.CD..'秒\n- 耐久：无',
        },
        lol_wp_s15_zhonya = {
            name = '中娅沙漏',
            info_instead = '- 类型：护符/特殊道具\n- 额外位面伤害：'..db.ZHONYA.PLANAR_DMG_WHEN_EQUIP..'\n- 防御：'..(db.ZHONYA.ABSORB*100)..'%\n- 理智：+'..db.ZHONYA.DARPPERNESS..'\n- 主动：【凝滞】\n\t装备后右键物品，在'..db.ZHONYA.SKILL_FREEZE.DURATION..'秒内免疫所有伤害，包括燃烧，饥饿，过冷过热，在触发无敌时人物会变成金色，可以正常移动和攻击。按'..keymap[TUNING[string.upper('CONFIG_'..modid..'key_lol_wp_s15_zhonya_freeze')]]..'键快捷触发，可以在模组设置里调整按键。使用后冷却'..db.ZHONYA.SKILL_FREEZE.CD..'秒。\n- 被动：【永驻】\n\t旺达或拥有时间值的人物装备后，时间值将不会自动流逝，但受到伤害还是会损失时间值。\n- 属于月亮阵营。\n- 耐久：无',
        },
        lol_wp_s16_potion_hp = {
            name = '生命药水',
            info_instead = '- 类型：特殊道具/药水\n- 可食用，可堆叠20个。\n- 食用后：\n\t生命'..(db.POTION_HP.DRINK_HP > 0 and '+' or '-')..(math.abs(db.POTION_HP.DRINK_HP))..'，理智'..(db.POTION_HP.DRINK_SAN > 0 and '+' or '-')..(math.abs(db.POTION_HP.DRINK_SAN))..'，提供每2秒'..db.POTION_HP.DRINK_PERSEC_HP..'点的生命回复，持续'..db.POTION_HP.DURATION..'秒，重复食用只会增加持续时间，不会增加回复速度，最多叠加'..(db.POTION_HP.MAX/db.POTION_HP.DURATION)..'层（'..db.POTION_HP.MAX..'秒）叠满后再次食用不会增加时间。\n- 无法与腐败药水，复用型药水同时使用。\n- 消耗品。',
        },
        lol_wp_s16_potion_compound = {
            name = '复用型药水',
            info_instead = '- 类型：特殊道具/药水\n- 可食用，不可堆叠。\n- 食用后：\n\t生命'..(db.POTION_COMPOUND.DRINK_HP > 0 and '+' or '-')..(math.abs(db.POTION_COMPOUND.DRINK_HP))..'，理智'..(db.POTION_COMPOUND.DRINK_SAN > 0 and '+' or '-')..(math.abs(db.POTION_COMPOUND.DRINK_SAN))..'，消耗'..(db.POTION_COMPOUND.DRINK_CONSUME_PERCENT*100)..'%耐久，提供每2秒'..db.POTION_COMPOUND.DRINK_PERSEC_HP..'点的生命回复，持续'..db.POTION_COMPOUND.DURATION..'秒，重复食用只会增加持续时间，不会增加回复速度，最多叠加'..(db.POTION_COMPOUND.MAX/db.POTION_COMPOUND.DURATION)..'层（'..db.POTION_COMPOUND.MAX..'秒）叠满后再次食用不会增加时间。\n- 耐久：'..(math.floor(1/db.POTION_COMPOUND.DRINK_CONSUME_PERCENT))..'次，耐久处于'..(db.POTION_COMPOUND.DRINK_CONSUME_PERCENT*100)..'%以下不可食用，耐久耗尽不会损坏。',
        },
        lol_wp_s16_potion_corruption = {
            name = '腐败药水',
            info_instead = '- 类型：特殊道具/药水\n- 可食用，不可堆叠。\n- 食用后：\n\t生命'..(db.POTION_CORRUPTION.DRINK_HP > 0 and '+' or '-')..(math.abs(db.POTION_CORRUPTION.DRINK_HP))..'，理智'..(db.POTION_CORRUPTION.DRINK_SAN > 0 and '+' or '-')..(math.abs(db.POTION_CORRUPTION.DRINK_SAN))..'，消耗'..(db.POTION_CORRUPTION.DRINK_CONSUME_PERCENT*100)..'%耐久，提供每2秒'..db.POTION_CORRUPTION.DRINK_PERSEC_HP..'点的生命和每2秒'..db.POTION_CORRUPTION.DRINK_PERSEC_SAN..'点的理智回复，持续'..db.POTION_CORRUPTION.DURATION..'秒，重复食用只会增加持续时间，不会增加回复速度，最多叠加'..(db.POTION_CORRUPTION.MAX/db.POTION_CORRUPTION.DURATION)..'层（'..db.POTION_CORRUPTION.MAX..'秒）叠满后再次食用不会增加时间。\n- 被动：【腐败之触】\n\t持续期间提供额外'..db.POTION_CORRUPTION.PLANAR_DMG_WHEN_DRINK..'点额外位面伤害，该效果不可叠加。\n- 被动：【腐化】\n\t效果结束后人物会变为昏昏沉沉状态20秒，移速-20%\n- 耐久：'..(math.floor(1/db.POTION_CORRUPTION.DRINK_CONSUME_PERCENT))..'次，耐久处于'..(db.POTION_CORRUPTION.DRINK_CONSUME_PERCENT*100)..'%以下不可食用，耐久耗尽不会损坏。',
        },
        lol_wp_s17_luden = {
            name = '卢登的回声',
            info_instead = '- 类型：远程武器/法杖\n- 位面伤害：'..TUNING.MOD_LOL_WP.LUDEN.PLANAR_DMG..'\n- 攻击距离：'..TUNING.MOD_LOL_WP.LUDEN.RANGE..'\n- 理智：'..(TUNING.MOD_LOL_WP.LUDEN.DARPPERNESS>0 and '+' or '-')..math.abs(TUNING.MOD_LOL_WP.LUDEN.DARPPERNESS)..'\n- 移速+'..((TUNING.MOD_LOL_WP.LUDEN.WALKSPEEDMULT-1)*100)..'%\n- 主动：【奥术跃迁】\n\t右键可以瞬移到鼠标指定位置，消耗'..math.abs(TUNING.MOD_LOL_WP.LUDEN.SKILL_ARCANE_TELE.CONSUME_SAN)..'点san值和'..TUNING.MOD_LOL_WP.LUDEN.SKILL_ARCANE_TELE.CONSUME..'耐久。\n- 被动：【回声】\n\t攻击会弹出'..TUNING.MOD_LOL_WP.LUDEN.SKILL_ECHO.MISSILE..'个法球，弹射到附近的敌方生物上1次，造成'..TUNING.MOD_LOL_WP.LUDEN.SKILL_ECHO.PLANAR_DMG..'位面伤害，和亮茄魔杖类似，冷却时间'..TUNING.MOD_LOL_WP.LUDEN.SKILL_ECHO.CD..'秒。\n- 属于暗影物品，暗影等级'..TUNING.MOD_LOL_WP.LUDEN.SHADOW_LEVEL..'，对月亮阵营伤害增加'..((TUNING.MOD_LOL_WP.LUDEN.DMGMULT_TO_PLANAR-1)*100)..'%。\n- 耐久：'..TUNING.MOD_LOL_WP.LUDEN.FINITEUSES..'，耐久耗尽不会损坏'
        },
        lol_wp_s17_liandry = {
            name = '兰德里的折磨',
            info_instead = '- 类型：头盔/面具\n- 防御：'..(TUNING.MOD_LOL_WP.LIANDRY.ABSORB*100)..'%\n- 位面防御：'..TUNING.MOD_LOL_WP.LIANDRY.DEFEND_PLANAR..'\n- 防雷：100%\n- 理智：'..(TUNING.MOD_LOL_WP.LIANDRY.DARPPERNESS>0 and '+' or '-')..math.abs(TUNING.MOD_LOL_WP.LIANDRY.DARPPERNESS)..'\n- 会发出半径2的白色光照。\n- 佩戴时右键可以切换头盔和面具形态，面具形态-20san/min，有免疫催眠效果和护目镜效果，获得和夜梅相同的夜视能力，头盔形态-5san/min，没有特殊效果。\n- 被动：【折磨】\n\t你的攻击会使敌人灼烧，每'..TUNING.MOD_LOL_WP.LIANDRY.SKILL_TORMENT.INTERVAL..'秒造成目标'..(TUNING.MOD_LOL_WP.LIANDRY.SKILL_TORMENT.MAXHP_PERCENT_PLANAR_DMG*100)..'%最大生命值的位面伤害，持续'..TUNING.MOD_LOL_WP.LIANDRY.SKILL_TORMENT.DURATION..'秒，冷却'..TUNING.MOD_LOL_WP.LIANDRY.SKILL_TORMENT.CD..'秒。\n- 被动：【受苦】\n\t你的攻击附带当前造成伤害'..(TUNING.MOD_LOL_WP.LIANDRY.SKILL_SUFFER.PLANAR_DMG*100)..'%的额外位面伤害。\n- 被动：【冰川增幅】\n\t与末日寒冬同时装备时获得套装效果，每次攻击造成额外40%减速，并使该目标伤害降低40%，持续1.5秒，无冷却。\n- 属于月亮阵营，使用月亮武器会额外增伤'..((TUNING.MOD_LOL_WP.LIANDRY.DMGMULT_TO_SHADOW-1)*100)..'%。\n- 耐久：无',
        },
        lol_wp_s17_lostchapter = {
            name = '遗失的章节',
            info_instead = '- 类型：护符/魔法书\n- 额外位面伤害：'..TUNING.MOD_LOL_WP.LOSTCHAPTER.PLANAR_DMG_WHEN_EQUIP..'\n- 理智：'..(TUNING.MOD_LOL_WP.LOSTCHAPTER.DARPPERNESS>0 and '+' or '-')..math.abs(TUNING.MOD_LOL_WP.LOSTCHAPTER.DARPPERNESS)..'\n- 被动：【启蒙】\n\t每天早上回复自身'..(TUNING.MOD_LOL_WP.LOSTCHAPTER.SKILL_ENLIGHTENMENT.RECOVER_SAN_PERCENT*100)..'%的理智值。\n- 属于月亮阵营。\n- 耐久：无',
        },
        lol_wp_s18_bloodthirster = {
            name = '饮血剑',
            info_instead = '- 类型：近战武器/骨剑\n- 攻击力：'..TUNING.MOD_LOL_WP.BLOODTHIRSTER.DMG..'\n- 攻击距离：1.2\n- 生命偷取：'..TUNING.MOD_LOL_WP.BLOODTHIRSTER.DRAIN..'\n- 暴击：'..(TUNING.MOD_LOL_WP.BLOODTHIRSTER.CRITICAL_CHANCE*100)..'%的概率造成'..TUNING.MOD_LOL_WP.BLOODTHIRSTER.CRITICAL_DMGMULT..'倍伤害\n- 理智：'..((TUNING.MOD_LOL_WP.BLOODTHIRSTER.DARPPERNESS > 0 and '+' or '-')..math.abs(TUNING.MOD_LOL_WP.BLOODTHIRSTER.DARPPERNESS))..'\n- 每次攻击消耗'..math.abs(TUNING.MOD_LOL_WP.BLOODTHIRSTER.ATK_DELTA_SAN)..'点理智。\n- 被动：【灵液护盾】\n\t每次攻击生成一个铥矿皇冠的护盾，持续'..TUNING.MOD_LOL_WP.BLOODTHIRSTER.SKILL_SPIRITUAL_LIQUID_SHIELD.SHIELD_DURATION..'秒，冷却'..TUNING.MOD_LOL_WP.BLOODTHIRSTER.SKILL_SPIRITUAL_LIQUID_SHIELD.CD..'秒。\n- 被动：【鲜血魔井】\n\t在满血时攻击，溢出的吸血将会等量修复武器的耐久。\n- 被动：【暗裔化身】\n\t和虚空风帽，虚空长袍同时装备时获得套装效果，增加'..TUNING.MOD_LOL_WP.BLOODTHIRSTER.SUITE_EFFECT.PLANAR_DMG..'点位面伤害\n- 被动：【大灭】\n\t和霸王血铠，恶魔之拥同时装备时获得套装效果，增加'..TUNING.MOD_LOL_WP.BLOODTHIRSTER.SUITE_EFFECT_2.DRAIN..'点生命偷取和'..TUNING.MOD_LOL_WP.BLOODTHIRSTER.SUITE_EFFECT_2.PLANAR_DMG..'点位面伤害。\n- 属于暗影物品，暗影等级'..TUNING.MOD_LOL_WP.BLOODTHIRSTER.SHADOW_LEVEL..'，对月亮阵营伤害增加'..((TUNING.MOD_LOL_WP.BLOODTHIRSTER.DMGMULT_TO_PLANAR-1)*100)..'%。\n- 耐久：'..TUNING.MOD_LOL_WP.BLOODTHIRSTER.FINITEUSES..'，耐久耗尽不会损坏',
        },
        lol_wp_s18_stormrazor = {
            name = '岚切',
            info_instead = '- 类型：近战武器/武士刀\n- 攻击力：'..TUNING.MOD_LOL_WP.STORMRAZOR.DMG..'\n- 暴击：'..(TUNING.MOD_LOL_WP.STORMRAZOR.CRITICAL_CHANCE*100)..'%的概率造成'..TUNING.MOD_LOL_WP.STORMRAZOR.CRITICAL_DMGMULT..'倍伤害\n- 移速+'..((TUNING.MOD_LOL_WP.STORMRAZOR.WALKSPEEDMULT-1)*100)..'%。\n- 主动：【拔刀】\n\t岚切默认会收入刀鞘，右键物品可以拔刀，在拔刀前无法使用岚切进行攻击，收入刀鞘时移速'..((TUNING.MOD_LOL_WP.STORMRAZOR.WALKSPEEDMULT_WITH_SAYA-1)*100)..'%，会自动修复，每'..TUNING.MOD_LOL_WP.STORMRAZOR.SKILL_SHIV.REPAIR_INTERVAL..'秒修复'..TUNING.MOD_LOL_WP.STORMRAZOR.SKILL_SHIV.REPAIR..'点耐久。\n- 主动：【疾风斩】\n\t右键目标可释放一道天气风向标的旋风，造成每秒'..TUNING.MOD_LOL_WP.STORMRAZOR.SKILL_WIND_SLASH.DMG..'伤害，会受到攻击倍率影响，可以摧毁岩石和树木，不会摧毁建筑，冷却'..TUNING.MOD_LOL_WP.STORMRAZOR.SKILL_WIND_SLASH.CD..'秒。\n- 被动：【电冲】\n\t攻击附带'..TUNING.MOD_LOL_WP.STORMRAZOR.SKILL_ELECTRICSLASH.PLANAR_DMG..'位面伤害并提供持续'..TUNING.MOD_LOL_WP.STORMRAZOR.SKILL_ELECTRICSLASH.WALKSPEEDMULT_DURATION..'秒的'..((TUNING.MOD_LOL_WP.STORMRAZOR.SKILL_ELECTRICSLASH.WALKSPEEDMULT-1)*100)..'%移动速度，冷却时间'..TUNING.MOD_LOL_WP.STORMRAZOR.SKILL_ELECTRICSLASH.CD..'秒。\n- 被动：【盈能】\n\t每次攻击会减少'..TUNING.MOD_LOL_WP.STORMRAZOR.SKILL_CHARGE.REDUCE_SKILL_ELECTRICSLASH_PER_HIT..'秒被动技能冷却时间。\n- 拔刀时会播放亚索的小曲，收入刀鞘可以关闭，可以在模组设置关闭\n- 属于月亮阵营，对暗影阵营伤害增加'..((TUNING.MOD_LOL_WP.STORMRAZOR.DMGMULT_TO_SHADOW-1)*100)..'%。\n- 击败麋鹿鹅'..((TUNING.MOD_LOL_WP.STORMRAZOR.BLUEPRINTDROP_CHANCE.moose*100))..'%掉落蓝图。\n- 耐久：'..TUNING.MOD_LOL_WP.STORMRAZOR.FINITEUSES..'，耐久耗尽不会损坏',
        },
        lol_wp_s18_krakenslayer = {
            name = '海妖杀手',
            info_instead = '- 类型：远程武器/捕鲸炮\n- 攻击力：'..TUNING.MOD_LOL_WP.KRAKENSLAYER.DMG..'\n- 攻击距离：'..TUNING.MOD_LOL_WP.KRAKENSLAYER.RANGE..'\n- 攻击带电，对目标造成1.5倍伤害，对潮湿目标造成2.5倍伤害。\n- 暴击：'..(TUNING.MOD_LOL_WP.KRAKENSLAYER.CRITICAL_CHANCE*100)..'%的概率造成'..TUNING.MOD_LOL_WP.KRAKENSLAYER.CRITICAL_DMGMULT..'倍伤害\n- 移速+'..((TUNING.MOD_LOL_WP.KRAKENSLAYER.WALKSPEEDMULT-1)*100)..'%。\n- 被动：【放倒它】\n\t每第三次攻击附带'..TUNING.MOD_LOL_WP.KRAKENSLAYER.SKILL_TAKEDOWN.TRUEDMG..'真实伤害，会受攻击倍率影响，如果目标损失生命值超过'..((1-TUNING.MOD_LOL_WP.KRAKENSLAYER.SKILL_TAKEDOWN.GP_PERCENT_LESS_THAN)*100)..'%，则伤害提升至'..TUNING.MOD_LOL_WP.KRAKENSLAYER.SKILL_TAKEDOWN.NEW_TRUEDMG..'真实伤害。\n- 被动：【捕鲸手】\n\t对水上生物造成'..TUNING.MOD_LOL_WP.KRAKENSLAYER.SKILL_KUJIRA.DMGMULT_TO_MOB_ON_WATER..'倍伤害。\n- 击败天体英雄后，有'..(TUNING.MOD_LOL_WP.KRAKENSLAYER.CHANCE_TO_GET_IN_CHEST_AFTER_KILL_BOSS*100)..'%概率在沉底宝箱开出。\n- 属于月亮阵营，对暗影阵营伤害增加'..((TUNING.MOD_LOL_WP.KRAKENSLAYER.DMGMULT_TO_SHADOW-1)*100)..'%。\n- 耐久：400，耐久耗尽不会损坏\n- 修复材料：齿轮25%/废铁50%/自动修理机100%',
        },
        lol_wp_s19_archangelstaff = {
            name = '大天使之杖',
            info_instead = '- 类型：远程武器/法杖\n- 位面伤害：'..TUNING.MOD_LOL_WP.ARCHANGELSTAFF.PLANAR_DMG..'\n- 攻击距离：'..TUNING.MOD_LOL_WP.ARCHANGELSTAFF.RANGE..'\n- 移速'..((TUNING.MOD_LOL_WP.ARCHANGELSTAFF.WALKSPEEDMULT-1)>0 and '+' or '-')..(math.abs(TUNING.MOD_LOL_WP.ARCHANGELSTAFF.WALKSPEEDMULT-1)*100)..'%\n- 制作时可以继承女神之泪的被动\n- 被动：【超负荷】\n\t每攻击'..(TUNING.MOD_LOL_WP.ARCHANGELSTAFF.SKILL_OVERLOAD.PER_HIT_TIMES-1)..'次释放一次亮茄魔杖的弹射法球，弹射6次，造成武器面板伤害\n- 被动：【敬畏】\n\t获得'..(TUNING.MOD_LOL_WP.ARCHANGELSTAFF.SKILL_FEAR.PLANAR_DMG_MAXSANPERCENT*100)..'%最大理智值的位面伤害。\n- 被动：【法力积攒】\n\t发动一次攻击可以叠加'..TUNING.MOD_LOL_WP.ARCHANGELSTAFF.SKILL_COUNT.COUNT_PER_HIT..'层被动，如果攻击目标是boss生物则叠加'..TUNING.MOD_LOL_WP.ARCHANGELSTAFF.SKILL_COUNT.COUNT_PER_HIT_BOSS..'层被动，每层被动提供'..TUNING.MOD_LOL_WP.ARCHANGELSTAFF.SKILL_COUNT.DARPPERNESS_PER_COUNT..'理智回复，最多'..TUNING.MOD_LOL_WP.ARCHANGELSTAFF.SKILL_COUNT.MAX_COUNT..'层，共'..(TUNING.MOD_LOL_WP.ARCHANGELSTAFF.SKILL_COUNT.DARPPERNESS_PER_COUNT*TUNING.MOD_LOL_WP.ARCHANGELSTAFF.SKILL_COUNT.MAX_COUNT)..'点理智回复，叠加被动有'..TUNING.MOD_LOL_WP.ARCHANGELSTAFF.SKILL_COUNT.CD..'秒冷却。\n- 在叠加'..TUNING.MOD_LOL_WP.ARCHANGELSTAFF.SKILL_COUNT.MAX_COUNT..'层时，可以给予一个启迪碎片进行升级，这个装备会转变为【炽天使之拥】获得属性提升和特殊被动。\n- 属于月亮阵营，对暗影阵营伤害增加'..((TUNING.MOD_LOL_WP.ARCHANGELSTAFF.DMGMULT_TO_SHADOW-1)*100)..'%。\n- 耐久：无\n- 物品下方会显示叠加的层数。',
        },
        lol_wp_s19_archangelstaff_upgrade = {
            name = '炽天使之拥',
            info_instead = '- 类型：远程武器/法杖\n- 位面伤害：'..TUNING.MOD_LOL_WP.ARCHANGELSTAFF.UPGRADE.PLANAR_DMG..'\n- 攻击距离：'..TUNING.MOD_LOL_WP.ARCHANGELSTAFF.UPGRADE.RANGE..'\n- 理智：+'..TUNING.MOD_LOL_WP.ARCHANGELSTAFF.UPGRADE.DARPPERNESS..'\n- 移速'..((TUNING.MOD_LOL_WP.ARCHANGELSTAFF.WALKSPEEDMULT-1)>0 and '+' or '-')..(math.abs(TUNING.MOD_LOL_WP.ARCHANGELSTAFF.WALKSPEEDMULT-1)*100)..'%\n- 会发出半径'..TUNING.MOD_LOL_WP.ARCHANGELSTAFF.UPGRADE.LIGHT.RADIUS..'的白色光照。\n- 被动：【超负荷】\n\t每攻击'..(TUNING.MOD_LOL_WP.ARCHANGELSTAFF.SKILL_OVERLOAD.PER_HIT_TIMES-1)..'次释放亮茄魔杖的弹射法球，弹射6次，造成武器面板伤害。\n- 被动：【敬畏】\n\t获得'..((TUNING.MOD_LOL_WP.ARCHANGELSTAFF.UPGRADE.SKILL_FEAR.PLANAR_DMG_MAXSANPERCENT*100))..'%最大理智值的位面伤害。\n- 被动：【救主灵刃】\n\t在受到将使你的生命值跌到'..(TUNING.MOD_LOL_WP.ARCHANGELSTAFF.UPGRADE.SKILL_SHIELD.HP_PERCENT_BELOW*100)..'%以下的伤害时，提供持续'..TUNING.MOD_LOL_WP.ARCHANGELSTAFF.UPGRADE.SKILL_SHIELD.SHIELD_DURATION..'秒的无敌护盾，冷却时间'..TUNING.MOD_LOL_WP.ARCHANGELSTAFF.UPGRADE.SKILL_SHIELD.CD..'秒。\n- 属于月亮阵营，对暗影阵营伤害增加'..((TUNING.MOD_LOL_WP.ARCHANGELSTAFF.UPGRADE.DMGMULT_TO_SHADOW-1)*100) ..'%。\n- 耐久：无',
        },
        lol_wp_s19_muramana = {
            name = '魔宗',
            info_instead = '- 类型：近战武器/长枪\n- 攻击力：'..TUNING.MOD_LOL_WP.MURAMANA.DMG..'\n- 攻击距离：'..TUNING.MOD_LOL_WP.MURAMANA.RANGE..'\n- 移速'..((TUNING.MOD_LOL_WP.MURAMANA.WALKSPEEDMULT-1)>0 and '+' or '-')..(math.abs(TUNING.MOD_LOL_WP.MURAMANA.WALKSPEEDMULT-1)*100)..'%\n- 制作时可以继承女神之泪的被动\n- 被动：【风斩电刺】\n\t每攻击'..(TUNING.MOD_LOL_WP.MURAMANA.SKILL_WINDSLASH.PER_HIT_TIMES-1)..'次后释放三连击，造成3段武器面板伤害。\n- 被动：【敬畏】\n\t获得'..(TUNING.MOD_LOL_WP.MURAMANA.SKILL_FEAR.SAN_PERCENT*100)..'%最大理智值的物理伤害。\n- 被动：【法力积攒】\n\t发动一次攻击可以叠加'..TUNING.MOD_LOL_WP.MURAMANA.SKILL_COUNT.COUNT_PER_HIT..'层被动，如果攻击目标是boss生物则叠加'..TUNING.MOD_LOL_WP.MURAMANA.SKILL_COUNT.COUNT_PER_HIT_BOSS..'层被动，每层被动提供'..TUNING.MOD_LOL_WP.MURAMANA.SKILL_COUNT.DARPPERNESS_PER_COUNT..'理智回复，最多'..TUNING.MOD_LOL_WP.MURAMANA.SKILL_COUNT.MAX_COUNT..'层，共'..(TUNING.MOD_LOL_WP.MURAMANA.SKILL_COUNT.DARPPERNESS_PER_COUNT*TUNING.MOD_LOL_WP.MURAMANA.SKILL_COUNT.MAX_COUNT)..'点理智回复，叠加被动有'..TUNING.MOD_LOL_WP.MURAMANA.SKILL_COUNT.CD..'秒冷却。\n- 在叠加'..TUNING.MOD_LOL_WP.MURAMANA.SKILL_COUNT.MAX_COUNT..'层时，可以给予一个启迪碎片进行升级，这个装备会转变为【魔切】获得属性提升和特殊被动\n- 属于月亮阵营，对暗影阵营伤害增加'..((TUNING.MOD_LOL_WP.MURAMANA.DMGMULT_TO_SHADOW-1)*100)..'%。\n- 耐久：无\n- 物品下方会显示叠加的层数。',
        },
        lol_wp_s19_muramana_upgrade = {
            name = '魔切',
            info_instead = '- 类型：近战武器/长枪\n- 攻击力：'..TUNING.MOD_LOL_WP.MURAMANA.UPGRADE.DMG..'\n- 攻击距离：'..TUNING.MOD_LOL_WP.MURAMANA.UPGRADE.RANGE..'\n- 理智：+'..TUNING.MOD_LOL_WP.MURAMANA.UPGRADE.DARPPERNESS..'\n- 移速'..((TUNING.MOD_LOL_WP.MURAMANA.WALKSPEEDMULT-1)>0 and '+' or '-')..(math.abs(TUNING.MOD_LOL_WP.MURAMANA.WALKSPEEDMULT-1)*100)..'%\n- 会发出半径'..TUNING.MOD_LOL_WP.MURAMANA.UPGRADE.LIGHT.RADIUS..'的白色光照。\n- 被动：【风斩电刺】\n\t每攻击'..(TUNING.MOD_LOL_WP.MURAMANA.SKILL_WINDSLASH.PER_HIT_TIMES-1)..'次后释放三连击，造成3段武器面板伤害。\n- 被动：【敬畏】\n\t获得'..(TUNING.MOD_LOL_WP.MURAMANA.UPGRADE.SKILL_FEAR.SAN_PERCENT*100)..'%最大理智值的物理伤害。\n- 被动：【冲击】\n\t获得'..(TUNING.MOD_LOL_WP.MURAMANA.UPGRADE.SKILL_SLASH.SAN_PERCENT*100)..'%最大理智值的位面伤害。\n- 属于月亮阵营，对暗影阵营伤害增加'..((TUNING.MOD_LOL_WP.MURAMANA.UPGRADE.DMGMULT_TO_SHADOW-1)*100)..'%。\n- 耐久：无',
        },
        lol_wp_s19_fimbulwinter_armor = {
            name = '凛冬之临',
            info_instead = '- 类型：护甲装备/盔甲\n- 防御：'..(TUNING.MOD_LOL_WP.FIMBULWINTER.ABSORB*100)..'%\n- 保暖：'..TUNING.MOD_LOL_WP.FIMBULWINTER.AVOID_COLD..'\n- 防水：'..(TUNING.MOD_LOL_WP.FIMBULWINTER.WATERPROOF*100)..'%\n- 免疫击飞效果。\n- 移速'..((TUNING.MOD_LOL_WP.FIMBULWINTER.WALKSPEEDMULT-1)>0 and '+' or '-')..(math.abs(TUNING.MOD_LOL_WP.FIMBULWINTER.WALKSPEEDMULT-1)*100)..'%\n- 制作时可以继承女神之泪的被动\n- 被动：【敬畏】\n\t获得'..(TUNING.MOD_LOL_WP.FIMBULWINTER.SKILL_FEAR.SAN_PERCENT*100)..'%最大理智值的位面防御。\n- 被动：【法力积攒】\n\t发动一次攻击可以叠加'..TUNING.MOD_LOL_WP.FIMBULWINTER.SKILL_COUNT.COUNT_PER_HIT..'层被动，如果攻击目标是boss生物则叠加'..TUNING.MOD_LOL_WP.FIMBULWINTER.SKILL_COUNT.COUNT_PER_HIT_BOSS..'层被动，每层被动提供'..TUNING.MOD_LOL_WP.FIMBULWINTER.SKILL_COUNT.DARPPERNESS_PER_COUNT..'精神回复，最多'..TUNING.MOD_LOL_WP.FIMBULWINTER.SKILL_COUNT.MAX_COUNT..'层，共'..(TUNING.MOD_LOL_WP.FIMBULWINTER.SKILL_COUNT.MAX_COUNT*TUNING.MOD_LOL_WP.FIMBULWINTER.SKILL_COUNT.DARPPERNESS_PER_COUNT)..'点理智回复，叠加被动有'..TUNING.MOD_LOL_WP.FIMBULWINTER.SKILL_COUNT.CD..'秒冷却。\n- 在叠加'..TUNING.MOD_LOL_WP.FIMBULWINTER.SKILL_COUNT.MAX_COUNT..'层时，可以给予一个启迪碎片进行升级，这个装备会转变为【末日寒冬】获得属性提升和特殊被动。\n- 属于月亮阵营。\n- 耐久：无\n- 物品下方会显示叠加的层数。',
        },
        lol_wp_s19_fimbulwinter_armor_upgrade = {
            name = '末日寒冬',
            info_instead = '- 类型：护甲装备/盔甲\n- 防御：'..(TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.ABSORB*100)..'%\n- 保暖：'..TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.AVOID_COLD..'\n- 防水：'..(TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.WATERPROOF*100)..'%\n- 理智：+'..TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.DARPPERNESS..'\n- 免疫击飞效果。\n- 免疫冰冻效果。\n- 饥饿速度'..((TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.HUNGER_BURN_RATE-1)>0 and '+' or '-')..(math.abs(TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.HUNGER_BURN_RATE-1)*100)..'%\n- 防雷：100%\n- 移速'..((TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.WALKSPEEDMULT-1)>0 and '+' or '-')..(math.abs(TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.WALKSPEEDMULT-1)*100)..'%\n- 会发出半径'..TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.LIGHT.RADIUS..'的白色光照。\n- 被动：【敬畏】\n\t获得'..(TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.SKILL_FEAR.SAN_PERCENT*100)..'%最大理智值的位面防御。\n- 被动：【永续】\n\t攻击boss生物时会提供一个持续'..TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.SKILL_ENTERNAL.DURANTION..'秒的无敌护盾，冷却时间'..TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.SKILL_ENTERNAL.CD..'秒。\n- 被动：【冰川增幅】\n\t与兰德里的折磨同时装备时获得套装效果，每次攻击造成额外'..(100*(1-TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.SKILL_ICERAISE.SPEEDDOWN))..'%减速，并使该目标伤害降低'..(100*(1-TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.SKILL_ICERAISE.DOWN_TARGET_ATK))..'%，持续'..TUNING.MOD_LOL_WP.FIMBULWINTER.UPGRADE.SKILL_ICERAISE.DURATION..'秒，无冷却。\n- 属于月亮阵营。\n- 耐久：无',
        },
    },
    ---@type lol_wp_pedia_iteminfo
    pedia_items_info_key = { -- 图鉴物品所有的条目
        name = '名称: ',
        damage = '伤害: ',
        walkspeedmult = '移动速度: ',
        dapperness = 'san值影响: ',
        hit_add_hp = '攻击回血: ',
    }
}

local all_repair_tbl_key = { 'REPAIR','REPAIR_ARMOR','REPAIR_FUELED'}
for id, tbl in pairs(data.pedia_items) do
    for _,v in ipairs(all_repair_tbl_key) do
        local repair = db[v][string.upper(id)]
        if repair then
            local res = ''

            -- 创建一个数组来存储键值对
            local sortedArray = {}
            ---@diagnostic disable-next-line: param-type-mismatch
            for key, value in pairs(repair) do
                table.insert(sortedArray, {key = key, value = value})
            end
            -- 按照值从小到大排序
            table.sort(sortedArray, function(a, b)
                return a.value < b.value
            end)
            for _, entry in ipairs(sortedArray) do
                res = res..STRINGS.NAMES[entry.key]..(entry.value*100)..'%/'
            end

            -- ---@diagnostic disable-next-line: empty-block, param-type-mismatch
            -- for prefab,value in pairs(repair) do
            --     res = res..STRINGS.NAMES[prefab]..(value*100)..'%/'
            -- end
            tbl.info_instead = (tbl.info_instead or '') .. '\n- 修复材料：'..res
            tbl.info_instead = string.sub(tbl.info_instead,1,-2)
            break
        end
    end
end

return data