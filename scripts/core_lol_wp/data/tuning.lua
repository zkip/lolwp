---@diagnostic disable: undefined-global, trailing-space

local modid = 'lol_wp'

TUNING.MOD_LOL_WP = {
    little_items = {
        lol_wp_s7_obsidianblade = true,
        lol_wp_s7_cull = true,
        lol_wp_s7_doranblade = true,
        gallop_whip = true,
        gallop_tiamat = true,
        lol_wp_sheen = true,
        lol_wp_s8_uselessbat = true,
        lol_wp_s10_blastingwand = true,
        lol_wp_s7_doranshield = true,
        lol_wp_s14_bramble_vest = true,
        lol_wp_s11_amplifyingtome = true,
        lol_wp_s16_potion_hp = true,
        lol_wp_s16_potion_compound = true,
        lol_wp_s15_stopwatch = true,
        lol_wp_s16_potion_corruption = true,
        lol_wp_s9_eyestone_low = true,
        lol_wp_s9_eyestone_high = true,
        lol_wp_s7_doranring = true,
        lol_wp_s11_darkseal = true,
        lol_wp_s7_tearsofgoddess = true,
        lol_wp_s17_lostchapter = true,

        lol_wp_s13_statikk_shiv = false,
        lol_wp_s13_statikk_shiv_charged = false,
        lol_wp_s10_guinsoo = false,
        gallop_blackcutter = false,
        gallop_brokenking = false,
        lol_wp_s18_stormrazor = false,
        lol_wp_s18_stormrazor_nosaya = false,
        lol_wp_trinity = false,
        lol_wp_divine = false,
        lol_wp_s12_malignance = false,
        lol_wp_s13_infinity_edge = false,
        lol_wp_s13_infinity_edge_amulet = false,
        lol_wp_s14_hubris = false,
        alchemy_chainsaw = false,
        lol_wp_s13_collector = false,
        gallop_bloodaxe = false,
        lol_wp_s18_bloodthirster = false,
        gallop_ad_destroyer = false,
        lol_wp_s12_eclipse = false,
        lol_wp_s18_krakenslayer = false,
        lol_wp_s14_thornmail = false,
        lol_wp_s10_sunfireaegis = false,
        lol_wp_s10_sunfireaegis_armor = false,
        lol_heartsteel = false,
        gallop_hydra = false,
        gallop_breaker = false,
        lol_wp_warmogarmor = false,
        lol_wp_overlordbloodarmor = false,
        lol_wp_demonicembracehat = false,
        nashor_tooth = false,
        lol_wp_s15_crown_of_the_shattered_queen = false,
        crystal_scepter = false,
        lol_wp_s15_zhonya = false,
        lol_wp_s17_luden = false,
        lol_wp_s8_lichbane = false,
        riftmaker_weapon = false,
        riftmaker_amulet = false,
        lol_wp_s8_deathcap = false,
        lol_wp_s11_mejaisoulstealer = false,
        lol_wp_s17_liandry = false,
        lol_wp_s17_liandry_nomask = false,
        lol_wp_s9_guider = false,
    },
    ---@type number
    ITEM_EFFECT_RATE_IN_EYESTONE = TUNING[string.upper('CONFIG_'..modid..'lol_wp_eyestone_item_effect_half')], -- 物品在眼石中效果倍率
    SKIN_API = {
        elegent = {255/255,39/255,79/255,1},
        top = {91/255,193/255,255/255,1},
        reward = {255/255,255/255,16/255,1},
        cool = {225/255,31/255,248/255,1},
    },
    ATKSPEED = 1,
    REPAIR = { -- 修复耐久(finiteuse)相关
        LOL_WP_SHEEN = {
            MOONGLASS = .2, -- 使用玻璃碎片可以修复20%耐久
            MOONROCKNUGGET = .5, -- 月岩可以修复50%耐久。
        },
        LOL_WP_DIVINE = {
            GOLDNUGGET = .1,
            THULECITE = .5,
        },
        LOL_WP_TRINITY = {
            GOLDNUGGET = .1,
        },
        LOL_WP_S7_DORANBLADE = {
            FLINT = .2,
            GOLDNUGGET = .5,
        },
        LOL_WP_S7_OBSIDIANBLADE = {
            FLINT = .2,
        },
        LOL_WP_S8_USELESSBAT = { -- 无用大棒
            NIGHTMAREFUEL = .25,
            HORRORFUEL = 1,
        },
        LOL_WP_S10_GUINSOO = { -- 鬼索的狂暴之刃
            GOLDNUGGET = .2,
            DRAGON_SCALES = .5,
        },
        LOL_WP_S10_BLASTINGWAND = { -- 爆裂魔杖
            NIGHTMAREFUEL = .2,
            HORRORFUEL = 1,
        },
        LOL_WP_S11_AMPLIFYINGTOME = { -- 增幅典籍
            NIGHTMAREFUEL = .2,
            HORRORFUEL = 1,
        },
        LOL_WP_S12_MALIGNANCE = { -- 焚天
            NIGHTMAREFUEL = .2,
            HORRORFUEL = 1,
        },
        LOL_WP_S13_INFINITY_EDGE = { -- 无尽之刃
            GOLDNUGGET = .1,
        },
        LOL_WP_S13_STATIKK_SHIV = { -- 斯塔缇克电刃
            TRANSISTOR = .5
        },
        LOL_WP_S13_INFINITY_EDGE_AMULET = { -- 无尽之刃  护符
            GOLDNUGGET = .1,
        },
        LOL_WP_S16_POTION_COMPOUND = { -- 复用型药水】（治疗栏）
            GREEN_CAP = .2,
            GREEN_CAP_COOKED = .2,
        },
        LOL_WP_S16_POTION_CORRUPTION = { -- 腐败药水】（治疗栏
            NIGHTMAREFUEL = .1,
            BLUE_CAP = .1,
            BLUE_CAP_COOKED = .1,
        },
        LOL_WP_S17_LUDEN = { -- 卢登的回声】（魔法栏
            NIGHTMAREFUEL = .2,
            HORRORFUEL = 1,
        },
        LOL_WP_S18_BLOODTHIRSTER = { -- 饮血剑】（暗影术基座
            NIGHTMAREFUEL = .1,
            HORRORFUEL = .5,
            VOIDCLOTH_KIT = 1,
        },
        LOL_WP_S18_STORMRAZOR = { -- 岚切】（月岛科技栏）
            GOLDNUGGET = .2,
        },
        LOL_WP_S18_STORMRAZOR_NOSAYA = {
            GOLDNUGGET = .2,
        },
        LOL_WP_S18_KRAKENSLAYER = { -- 海妖杀手】（武器栏
            WAGPUNK_BITS = .5,
            GEARS = .25,
            WAGPUNKBITS_KIT = 1,
        }
    },
    REPAIR_ARMOR = { -- 修理armor组件
        LOL_WP_OVERLORDBLOODARMOR = { -- 霸王血铠
            NIGHTMAREFUEL = .1,
            HORRORFUEL = .5,
            VOIDCLOTH_KIT = 1,
        },
        LOL_WP_WARMOGARMOR = { -- 狂徒铠甲
            SHROOM_SKIN = .5,
            GREENGEM = .5,
            LIVINGLOG = .1,
        },
        LOL_WP_DEMONICEMBRACEHAT = { -- 恶魔之拥
            NIGHTMAREFUEL = .1, -- 噩梦燃料修复10%耐久
            HORRORFUEL = .5, -- 纯粹恐惧修复50%耐久。
            VOIDCLOTH_KIT = 1,
        },
        LOL_WP_S7_DORANSHIELD = { -- 多兰之盾
            FLINT = .2,
            GOLDNUGGET = .5,
        },
        LOL_WP_S10_SUNFIREAEGIS = { -- 日炎圣盾
            GOLDNUGGET = .2,
            DRAGON_SCALES = 1,
        },
        LOL_WP_S10_SUNFIREAEGIS_ARMOR = { -- 日炎圣盾 护甲 日炎斗篷
            GOLDNUGGET = .2,
            DRAGON_SCALES = 1,
        },
        LOL_WP_S14_BRAMBLE_VEST = { -- 棘刺背心
            HOUNDSTOOTH = .2,
            FLINT = .2,
        },
        LOL_WP_S14_THORNMAIL = { -- 荆棘之甲
            HOUNDSTOOTH = .2,
            NIGHTMAREFUEL = .2,
            HORRORFUEL = 1,
        }
    },
    REPAIR_FUELED = { -- 修理FUELED组件
        LOL_WP_S8_LICHBANE = { -- 巫妖之祸
            NIGHTMAREFUEL = .2,
            HORRORFUEL = 1,
        }
    },
    CANTEQUIP_WHENNODURABILITY = { -- 无耐久不能装备
        -- S10 之后统一在此管理
        lol_wp_s10_guinsoo = true,
        lol_wp_s10_sunfireaegis = true,
        lol_wp_s10_sunfireaegis_armor = true,
        lol_wp_s12_malignance = true,
        -- s13
        lol_wp_s13_infinity_edge = true,
        lol_wp_s13_infinity_edge_amulet = true,
        lol_wp_s13_statikk_shiv = true,
        -- s14
        lol_wp_s14_thornmail = true,
        -- s17
        lol_wp_s17_luden = true,
        -- s18
        lol_wp_s18_bloodthirster = true,
        lol_wp_s18_stormrazor = true,
        lol_wp_s18_stormrazor_nosaya = true,
        lol_wp_s18_krakenslayer = true,
    },
    --------------------------------------
    ---------------S5------------------
    --------------------------------------
    SHEEN = { -- 耀光
        DMG = 51, -- 攻击力
        WALKSPEEDMULT = 1.1, -- 移速
        LIGHT_FALLOFF = .2,
        LIGHT_INTENSITY = .9,
        LIGHT_RADIUS = 1, -- 手持时会发出半径1的微弱光照。
        LIGHT_COLOR = {1,1,1}, -- RGB
        FINITEUSES = 300, -- 耐久
        CD = 2, -- [咒刃] 冷却时间2秒。
        DMGMULT_TO_SHADOW = 1.1, -- 对暗影阵营生物造成10%额外伤害。
        DMGMULT = 2, -- [咒刃] 攻击会触发- -次强化攻击，造成200%的伤害
    },
    DIVINE = { -- 神圣分离者
        DMG = 51, -- 攻击力
        WALKSPEEDMULT = 1.1, -- 移速
        LIGHT_FALLOFF = .2,
        LIGHT_INTENSITY = .9,
        LIGHT_RADIUS = 1.5, -- 手持时会发出半径2的微弱光照。
        LIGHT_COLOR = {251/255,232/255,16/255},
        FINITEUSES = 400, -- 耐久400 
        EFFICIENCY = 3, -- 工具效率
        ACTION_CONSUME = { -- 工具消耗耐久
            CHOP = 1,
            MINE = 1,
        },
        CD = 2, -- [咒刃] 冷却时间1.5秒。
        ATK_HEAL = 5, -- [咒刃]  触发时会回复5生命值
        DMGMULT_TO_SHADOW = 1.1, -- 对暗影阵营生物造成10%额外伤害。
        DMGMULT = 2.5, --  [咒刃] 攻击会触发一次强化攻击,造成250%的伤害，
        HOLY_DMG = .04, -- [神圣打击] 右键目标造成-次强化攻击，会造成目标最大生命值2%的额外物理伤害
        HOLY_HEAL = 15, -- [神圣打击] 并回复自身15点生命值
        HOLY_CD = 10, -- [神圣打击] 冷却10秒。
        RANGE = 1.2, -- 距离
    },
    TRINITY = { -- 三项
        DMG = 33,
        RANGE = 5,
        LIGHT_RADIUS = 2,
        DARPPERNESS = 3,
        WALKSPEEDMULT = 1.15,
        DMGMULT = 1.3,
        HEAL_INTERVAL = 10, -- /s
        HEAL_HP = 3, 
        DMG_WHEN_AMULET = 16,
        FINITEUSE = 800, -- 耐久
    },
    OVERLORDBLOOD = { -- 霸王血铠
        DARPPERNESS = -5, -- 穿戴掉san
        SHADOW_LEVEL = 4, -- 暗影等级
        DURABILITY = 2000, -- 耐久
        ABSORB = .9, -- 防御
        DEFEND_PLANAR = 0, -- 位面防御
        CD = 10, -- 骨甲效果cd
        AUTO_REPAIR = { -- 在耐久不足时会吸取玩家生命值恢复耐久
            START = .8,  -- 低于percent开始修复
            END = 1, -- 超过这个percent,停止修复
            INTERVAL = 5, -- 吸血间隔/s
            DRAIN = 10, -- 每次吸血
            INTERVAL_REPAIR = 5, -- 修复耐久间隔/s
            REPAIR = 20, -- 每次修复耐久
        },
        SKILL_MAXHP_TO_ATK = .02, -- 将玩家2%最大生命值转化为额外攻击力。
        SKILL_LOSTHP_TO_ATK = .05, -- 【报复】获得损失生命值5%的攻击力提升。
        WATERPROOF = .2, -- 防水
        BLUEPRINTDROP_CHANCE = { -- 蓝图掉落
            -- STALKER = 1,
            -- STALKER_FOREST = 1,
            STALKER_ATRIUM = 1,
        }
    },
    WARMOGARMOR = { -- 狂徒铠甲
        ABSORB = .7, -- 防御
        WALKSPEEDMULT = 1.05, -- 穿戴移速
        DARPPERNESS = 4, -- 穿戴san
        INSULATION = 120, -- 隔热
        WATERPROOF = .2, -- 防水
        HUNGERRATE = .6, -- 饥饿速率
        SKILL_HEART = { -- 被动：【狂徒之心】
            NO_TAKE_DMG_IN = 6, -- 秒内没收到伤害,
            HP_PERCENT_BELOW = .8, -- 血量低于百分比
            INTERVAL = 1, -- 每隔多少秒
            REGEN_PERCENT = .05, -- 回复自身最大生命的百分之多少
            WALKSPEEDMULT = .1, -- 额外增加10%移速
            RESUME = 1, -- 触发时会消耗多少耐久
        },
        SKILL_POISONFOG = { -- 主动：【真菌毒雾】
            CD = 10,
            CONSUME_FINITEUSE = 1, -- 狂徒主动增加消耗，每次消耗1点耐久
        },
        BLUEPRINTDROP_CHANCE = { -- 蓝图掉落   
            TOADSTOOL = .5, -- 普通毒菌蟾蜍50%掉落蓝图。
            TOADSTOOL_DARK = 1, -- 悲惨的毒菌蟾蜍100%掉落蓝图。
        },
        DURABILITY = 200, -- 耐久
    },
    DEMONICEMBRACEHAT = { -- 恶魔之拥 头盔
        LIGHT_RADIUS = 2, -- 光照半径
        WATERPROOF = .4, -- 防水
        ABSORB = .4, -- 防御
        DEFEND_PLANAR = 20, -- 位面防御，
        WHEN_MASKED = { -- 右键切换为面具时
            DARPPERNESS = -20,
        },
        SKILL_DARKCONVENANT = { -- 被动：【黑暗契约】
            TRANSFER_MAXHP_PERCENT = .02 -- 将玩家2%的最大生命值转化为额外的位面伤害。
        },
        SKILL_STARE = { -- 被动：【亚扎卡纳的凝视】
            CD = 10, -- 冷却
            MAXHP_PERCENT = .01 -- 对一名敌人造成伤害时，会造成相当于其1%最大生命值的额外位面伤害
        },
        SHADOW_LEVEL = 4,
        DARPPERNESS = -5,
        BLUEPRINTDROP_CHANCE = { -- 蓝图掉落
            STALKER_ATRIUM = 1, -- 远古织影者100%掉落蓝图。
        },
        DURABILITY = 2000, --  耐久
    },
    --------------------------------------
    ---------------S7------------------
    --------------------------------------
    -- 萃取
    CULL = {
        DMG = 34, -- 攻击力
        ATK_REGEN = 1, -- 每次攻击回复自身2点生命值
        SKILL_SWEEP = { -- 主动：【收割
            CD = 5, -- 冷却时间
        },
        SKILL_LOOT = { -- 被动：【掠夺】
            GOLD_PERUNIT = 1, -- 每击杀一个单位会掉落1个金块
            FINISHED = 100, -- 累计击杀100个生物会爆掉(萃取 消失)
            GOLD_WHEN_FINISHED = 20, -- 掉落20个金块。
        },
    },
    -- 多兰之刃
    DORANBLADE = {
        DMG = 45, -- 攻击力
        DRAIN = 2, -- 吸血
        FINITEUSE = 200, -- 耐久
    },
    -- 多兰之戒
    DORANRING = {
        PLANAR_DMG_WHEN_EQUIP = 10, -- 佩戴时提供10点额外位面伤害。
        DAPPERNESS = 8, -- 佩戴时+8san/min。
    },
    -- 女神之泪
    TEARSOFGODDESS = {
        DAPPERNESS = 6,
        SKILL_SPELLFLOW = {
            NUM_PER_HIT = 1,
            SAN_LIMIT_PER_NUM = 1,
            SAN_LIMIT_MAX = TUNING[string.upper('CONFIG_'..modid..'tears_limit')],
            CD = 4,
        },
    },
    -- 黑曜石锋刃
    OBSIDIANBLADE = {
        DMG = 45, -- 攻击力
        DMGMULT_TO_NEUTRAL = 2, -- 攻击中立生物会造成双倍伤
        DRAIN = 6, -- 吸血
        SKILL_HUNTER = { -- 被动：【狩猎人】击杀生物后，会使掉落物中概率最高的掉落物额外掉落一个,,并使所有掉落物概率提高10%。
            CHANCE_UP = .1,
        },
        FINITEUSE = 200,
    },
    -- 多兰之盾
    DORANSHIELD = {
        DMG = 34, -- 伤害
        ABSORB = .8, -- 防御
        SKILL_RESTORE = { -- 被动：【复原力】手持时每5秒回复1生命值。
            INTERVAL = 5, -- 间隔
            REGEN = 1, -- 回复
        },
        SKILL_BLOCK = {
            REGEN_WHEN_SUCCESS = 6, -- 格挡成功时，会额外回复自身6点生命值。 
        },
        FINITEUSE = 400,
    },
    --------------------------------------
    ---------------S8------------------
    --------------------------------------
    -- 灭世者的死亡之帽
    DEATHCAP = {
        WATERPROOF = .6, -- 防水
        LIGHTNINGPROOF = 1, -- 防雷
        LIGHT_RADIUS = 2, --光照半径
        SKILL_MAGIC = { -- 被动：【魔法乐章】
            WEAR_INCREASE_PLANAR_DMG = 30,
            WEAR_INCREASE_PLANAR_DMG_MULT = 1.35,
        },
        SHADOW_LEVEL = 4, -- 属于暗影物品，暗影等级4
        WEAR_INCREASE_SHADOW_WEAPON_DMGMULT = 1.1, -- 使用暗影物品会额外增伤20%
        DARPPERNESS = -20,
    },
    -- 无用大棒
    USELESSBAT = {
        DMG = 15, -- 攻击力
        PLANAR_DMG = 50, -- 位面伤害
        CONSUME_WHEN_HAMMER = 1, -- 拥有锤子的功能，消耗1点耐久
        SHADOW_LEVEL = 2, -- 暗影等级2
        DMGMULT_TO_PLANAR = 1.1, -- 对月亮阵营生物伤害增加10%
        DARPPERNESS = -5, -- 手持时-5san/min。
        FINITEUSE = 200, -- 耐久200，
    },
    -- 巫妖之祸
    LICHBANE = {
        DMG = 0,
        PLANAR_DMG = 68, -- 位面伤害68，
        WALKSPEEDMULT = 1.1, -- 移速

        LIGHT_RADIUS = 1.5, -- 手持时会发出半径2的金色光照。
        LIGHT_FALLOFF = .2,
        LIGHT_INTENSITY = .9,
        LIGHT_COLOR = {250/255, 210/255, 28/255},

        SKILL_CURSEBLADE = { -- 被动：【咒刃】
            CD = 2,
            DMGMULT = 1.75,
        },
        SKILL_CURSERACE = { -- 被动：【祸源】 攻击的目标获得20%易伤，持续5秒。
            DMGMULT = 1.2,
            LAST = 5,
        },
        SHADOW_LEVEL = 3,
        DMGMULT_TO_PLANAR = 1.1,
        DARPPERNESS = -10,
        FUELED = 12, -- 耐久12分钟
        DMG_WHEN_NO_DURABILITY = 34,
        DROP_CHANCE = {
            mutatedwarg = .75
        },
    },
    --------------------------------------
    ---------------S9------------------
    --------------------------------------
    -- 引路者
    GUIDER = {
        ABSORB = .4, -- 护甲
        AVOID_COLD = 120, -- 保暖
        WATERPROOF = .2, -- 防水
        WALKSPEEDMULT = 1.1, -- 移速
        DARPPERNESS = 6, -- +6san/min
        LIGHT = { -- 光照
            FALLOFF = .2,
            INTENSITY = .9,
            RADIUS = 1.1,
            COLOR = {250/255, 210/255, 28/255},
        },
        PRESERVER = .5, -- 食物腐烂速度-50%
        SKILL_GUIDE = { -- 被动：【引路】
            RADIUS = 5, -- 会给半径5范围内的玩家提供10%移速加成，
            WALKSPEEDMULT = 1.1, -- 移速加成

            ATK_SPEEDDOWN = .5, -- 攻击会造成50%减速，持续2秒
            LAST = 2, -- 持续时间
            CD = 10, -- 冷却10秒。
        },
    },
    -- 戒备眼石
    EYESTONE_LOW = {

    },
    -- 警觉眼石
    EYESTONE_HIGH = {

    },
    --------------------------------------
    ---------------S10--------------------
    --------------------------------------
    -- 鬼索的狂暴之刃
    GUINSOO = {
        DMG = 30, -- 攻击力
        PLANAR_DMG = 30, -- 位面伤害
        WALKSPEEDMULT = 1.0, -- 移速
        LIGHT = { -- 光照
            FALLOFF = .2,
            INTENSITY = .9,
            RADIUS = 2,
            COLOR = {250/255, 70/255, 28/255},
        },
        ATK_FX = 'winters_feast_depletefood',
        SKILL_BOILSTRIKE = { -- 被动：【沸腾打击】
            SPEED_PER = .08, -- 每次攻击会提供8%攻击速度
            MAXSTACK = 4, -- 至多可叠加4次
            COMBO_KEEPTIME = 5, -- 连击维持时间
            COMBO_DECREASE_OVERTIME = 4, -- 超时扣除连击

            WHEN_MAXSTACK_TEMPERATURE = 100, -- 最大叠加时，温度
            WHEN_MAXSTACK_ATK_FX = 'tauntfire_fx', -- 被动叠满后攻击附带特效

            WHEN_MAXSTACK_BURN_CHANCE = 1, -- 概率点燃敌人
            WHEN_MAXSTACK_BURN_PERIOD = .5, -- 燃烧间隔
            WHEN_MAXSTACK_BURN_DMG = 8, -- 燃烧伤害
            WHEN_MAXSTACK_BURN_LAST = 10, -- 燃烧持续时间
            WHEN_MAXSTACK_BURN_FX = 'firesplash_fx', -- 触发点燃时的特效
        },
        SKILL_ALPHA = { -- 主动：【旋风斩】
            CD = 2,
            DMG = 60,
            PLANAR_DMG = 60,
        },
        FINITEUSE = 200, -- 耐久
        DROP_CHANCE = {
            mutatedbearger = 1,
        },
        BLUEPRINTDROP_CHANCE = {
            dragonfly = 1,
        },
    },
    -- 爆裂魔杖
    BLASTINGWAND = {
        RANGE = 8, -- 攻击距离
        PLANAR_DMG = 40, -- 位面伤害
        SHADOW_LEVEL = 2, -- 暗影等级
        DARPPERNESS = -5, -- 手持时会-10san/min
        DMGMULT_TO_PLANAR = 1.1, -- 对月亮阵营伤害增加10%。
        FINITEUSE = 200, -- 耐久
    },
    -- 日炎圣盾
    SUNFIREAEGIS = {
        DMG = 51, -- 攻击力
        ABSORB = .85, -- 手持时提供80%防御，
        AVOID_COLD = 120, -- 保暖
        WALKSPEEDMULT = .9, -- 移速
        SKILL_SUNSHELTER = { -- 主动：【烈阳庇护】
            SUCCESS_BLOCK = { -- 在格挡成功时对周围半径5码范围造成40点位面伤害和自身生命值10%的额外物理伤害。
                RANGE = 5, -- 对周围半径5码范围
                PLANAR_DMG = 60, -- 造成40点位面伤害
                EXTRA_DMG_OF_MAXHEALTH = .05, -- 自身生命值10%的额外物理伤害
                FX = 'firesplash_fx', -- 格挡成功触发特效
            },
        },
        SKILL_SACRIFICE = { -- 被动：【献祭】
            RANGE = 2, -- 在人物半径2码范围内的敌人
            INTERVAL = 1, -- 伤害间隔
            PER_PLANARDMG = 5, -- 位面伤害

            ALPHA = .7, -- 圈的透明度
        },
        SKILL_FIRETOUCH = { -- 【烈焰之触】
            BURN_PERIOD = .5, -- 燃烧间隔
            BURN_DMG = 8, -- 燃烧伤害
            BURN_LAST = 10, -- 燃烧持续时间
        },
        FINITEUSE = 1400, -- 注意耐久是共用的
        BLUEPRINTDROP_CHANCE = {
            dragonfly = 1,
        },
    },
    --------------------------------------
    ---------------S11--------------------
    --------------------------------------
    -- 增幅典籍（魔法栏）
    AMPLIFYINGTOME = { -- 增幅典籍（魔法栏）
        PLANAR_DMG = 15, -- 佩戴时提供15点额外位面伤害。
        CONSUME_WHEN_READ = .33, -- 使用后扣除33%的耐久
        FINITEUSES = 200, -- 耐久
        CONSUME_PER_HIT = 1, -- 每次攻击消耗1点
        SHADOW_LEVEL = 2,
    },
    -- 黑暗封印
    DARKSEAL = { -- 黑暗封印
        PLANAR_DMG = 5,
        SKILL_HONOR = { -- 被动：【荣耀】
            STACK_PER_BOSSSKILL = 2, -- 每参与击杀一个boss生物获得2层被动
            EXTRA_PLANAR_DMG_PER_STACK = 1, -- 每层被动提供2点额外位面伤害
            MAXSTACK = TUNING[string.upper('CONFIG_'..modid..'darkseel_limit')], -- 最多叠加10层，
            PLAYER_DEATH_CONSUME_STACK = 5, -- 在佩戴时死亡会清除2层被动
            FX_WHEN_STACK = 'cavehole_flick', -- （每次被动增加时触发特效：cavehole_flick）
        },
        SHADOW_LEVEL = 2, -- 暗影等级2
        DARPPERNESS = -10, -- 佩戴时-10san/min。
    },
    -- 梅贾的窃魂卷
    MEJAISOULSTEALER = { -- 梅贾的窃魂卷
        PLANAR_DMG = 10, -- 佩戴时提供10点额外位面伤害
        SKILL_HONOR = { -- 被动：【荣耀】
            BOSSKILL_BY_SELF_STACK = 4, -- 亲手击杀一个boss生物获得2层被动，
            STACK_PER_BOSSSKILL = 2, -- 每参与击杀一个boss生物获得1层被动
            EXTRA_PLANAR_DMG_PER_STACK = 1, -- 每层被动提供2点额外位面伤害
            MAXSTACK = TUNING[string.upper('CONFIG_'..modid..'mejai_limit')], -- 最多叠加20层，
            PLAYER_DEATH_CONSUME_STACK = 10, -- 在佩戴时死亡会清除5层被动
        },
        SHADOW_LEVEL = 4, -- 暗影等级
        DARPPERNESS = -20, -- 佩戴时-20san/min。
    },
    --------------------------------------
    ---------------S12--------------------
    --------------------------------------
    -- 星蚀
    ECLIPSE = {
        DMG = 85, -- 攻击力
        PLANAR_DMG = 0, -- 位面伤害
        RANGE = 1.2,
        LIGHT = { -- 光照
            FALLOFF = .3,
            INTENSITY = .9,
            RADIUS = 5,
            COLOR = {1, 1, 1},
        },
        WALKSPEEDMULT = 1.15,
        DARPPERNESS = 10,
        SKILL_NEWMOON_STRIKE = { -- 主动：【新月打击】
            SECTOR_ANGLE = 60, -- 扇形角度
            LASER_NUM = 3, -- 激光数量
            LASER_PLANAR_DMG = 100, -- 激光位面伤害
            CD = 2,
            CONSUME_SAN = 2, -- 星蚀主动增加消耗，消耗2san
        },
        SKILL_EVERMOON = { -- 被动：【永升之月】
            ATK_COUNT_DO_EXTRA = 2, -- 每第2次攻击会
            ENEMY_MAXHP_RATE_PLANAR_DMG = .06, -- 造成敌方最大生命值6%的额外位面伤害，
            SHIELD_DURATION = 2, -- 并为你提供持续2秒的无敌护盾，
            CD = 6,
            FX_WHEN = 'crab_king_shine',
        },
        DMGMULT_TO_SHADOW = 1.2, -- 对暗影阵营伤害增加20%。
        BLUEPRINTDROP_CHANCE = {
            alterguardian_phase3 = 1,
        },
        SUIT_PLANAR_DMG = 20, -- 星蚀 亮茄头盔 亮茄盔甲 同时装备 +20位面伤害
    },
    -- 焚天
    MALIGNANCE = {
        DMG = 51,
        RANGE = 2,
        WALKSPEEDMULT = 1.1,
        HIT_FX = 'fire_fail_fx',
        SKILL_FALLEN_BLOW = { -- 主动：【堕天一击】
            DISTANCE = 20,
            RADIUS = 5,
            DAMAGE = 100,
            CD = 5,
        },
        SKILL_GLOWSHIELD_STRIKE = { -- 被动：【光盾打击】
            HEAL_HP = 9, -- 治疗自身9点生命值
            HEAL_LOST_RATE_HP = .06, -- 损失血量6%的生命值，
            CD_PER_TARGET = 10,
        },
        DMGMULT_TO_SHADOW = 1.1,
        FINITEUSES = 400,
    },
    --------------------------------------
    ---------------S13--------------------
    --------------------------------------
    -- 无尽之刃
    INFINITY_EDGE = {
        DMG = 68,
        RANGE = 1.2,
        WALKSPEEDMULT = 1.0,
        CRITICAL_CHANCE = .25, -- 暴击率
        CRITICAL_DMGMULT = 2.5, -- 爆伤倍率
        HIF_FX = 'shadowstrike_slash_fx', -- 攻击附带特效
        FX_WHEN_CC = 'fx_dock_pop', -- 暴击时触发攻击特
        SKILL_INFINITY_EDGE = { -- 被动：【无尽之力】
            OWNER_DMGMULT_WHEN_EQUIP = 1.2, -- 角色手持时增加20%攻击倍率
        },
        FINITEUSES = 400,
        AS_AMULET = { -- 作为护符时
            DARPPERNESS = 6, -- san
            OWNER_DMGMULT_WHEN_EQUIP = 1.2, -- 装备时角色攻击倍率
            CRITICAL_CHANCE = .25, -- 暴击率
            CRITICAL_DMGMULT = 1.25, -- 爆伤倍率
        }
    },
    -- 斯塔缇克电刃
    STATIKK_SHIV = { -- 斯塔缇克电刃
        DMG = 34,
        WALKSPEEDMULT = 1.1,
        CRITICAL_CHANCE = .25, -- 暴击率
        CRITICAL_DMGMULT = 2, -- 爆伤倍率
        FX_WHEN_CC = 'fx_dock_pop', -- 暴击时触发攻击特
        SKILL_ELECTRIC_SPARK = { -- 被动：【电火花】
            HIT_TIMES = 3, -- 使前三次攻击在命中时发射连锁闪电
            CHAIN_RANGE = 20, -- 会连锁攻击目标20码内最近的单位
            PLANAR_DMG_WHEN_CHAIN = 35, -- 连锁闪电造成35点位面伤害
            CHAIN_MAX_TARGET = 5, -- 最多连锁5个目标
            CD = 10,
        },
        SKILL_CHARGE = { -- 被动：【盈能】
            REDUCE_SKILL_ELECTRIC_SPARK_PER_HIT = 1, -- 每次攻击会减少1秒被动技能冷却时间
        },
        FINITEUSES = 200,
    },
    -- 斯塔缇克电刀 (充能)
    STATIKK_SHIV_CHARGED = { -- 斯塔缇克电刀 (充能)
        DMG = 27,
        WALKSPEEDMULT = 1.2,
        CRITICAL_CHANCE = .25, -- 暴击率
        CRITICAL_DMGMULT = 2, -- 爆伤倍率
        FX_WHEN_CC = 'fx_dock_pop', -- 暴击时触发攻击特
        LIGHT = { -- 光照
            FALLOFF = .4,
            INTENSITY = .9,
            RADIUS = 2,
            COLOR = {1, 1, 1},
        },
        SKILL_ELECTRIC_SPARK = { -- 被动：【电火花】
            CHAIN_RANGE = 20, -- 会连锁攻击目标20码内最近的单位
            PLANAR_DMG_WHEN_CHAIN = 55, -- 连锁闪电造成55点位面伤害
            CHAIN_MAX_TARGET = 7, -- 最多连锁5个目标
        },
        FINITEUSES = 100, 
    },
    -- 收集者
    COLLECTOR = {
        DMG = 100,
        PLANAR_DMG = 0,
        ATK_PERIOD = 3,
        RANGE = 8,
        CRITICAL_CHANCE = .25, -- 暴击率
        CRITICAL_DMGMULT = 2, -- 爆伤倍率
        FX_WHEN_CC = 'fx_dock_pop', -- 暴击时触发攻击特
        SKILL_DEATH_AND_TAX = { -- 被动：【死与税】
            SEC_KILL_HP_LINE = .05, -- 如果你造成的伤害使敌方的生命值跌到5%以下，那么会直接将其处决
            PLANAR_DMG_WHEN_SEC_KILL = 9999, -- 处决前固定造成伤害
            GOLDNUGGET_WHEN_KILL_BOSS = 25, -- 当你击杀一个boss时，会获得25个金币
            GOLDNUGGET_WHEN_KILL_NORMAL = 3, -- 当你击杀一个普通单位时，会获得3个金币
        },
        DMGMULT_TO_SHADOW = 1.1,
        -- 有概率在沉底宝箱开出，概率会随着世界天数的增加而上升，第 1 天的概率是 0.2%，在第 400 天到达上限 20%
        DROP_FROM_OCEANCHEST = {
            START_CHANCE = .002,
            MAX_CHANCE = .2,
            MAX_DAY = 400,
        }
    },
    --------------------------------------
    ---------------S14--------------------
    --------------------------------------
    -- 棘刺背心
    BRAMBLE_VEST = {
        ABSORB = .8, -- 防御
        WATERPROOF = .1, -- 防水
        SKILL_BRAMBLE = { -- 被动：【荆棘】
            REFLECT_DMG_PERCENT = .25, -- 50%的伤害会反弹给攻击者
            REFLECT_DMG = 10, -- 固定伤害

            REFLECTED_TARGET_DMGTAKEN = .1, -- 被反伤的敌人会受到10%易伤 加算型的
            DMGTAKEN_LAST = 4, -- 持续4秒
        },
        FINITEUSES = 800,
    },
    -- 荆棘之甲
    THORNMAIL = { -- 荆棘之甲
        ABSORB = .95, -- 防御
        WATERPROOF = .2, -- 防水
        WALKSPEEDMULT = .9, -- 移动速度
        SKILL_BRAMBLE = { -- 被动：【荆棘】
            REFLECT_DMG_PERCENT = .5, -- 100%的伤害会反弹给攻击者
            REFLECT_DMG = 20, -- 固定伤害

            REFLECTED_TARGET_DMGTAKEN = .2, -- 被反伤的敌人会受到20%易伤 加算型的
            DMGTAKEN_LAST = 4, -- 持续4秒
        },
        FINITEUSES = 1600,
        SHADOW_LEVEL = 3, -- 暗影等级
        DARPPERNESS = -5,
        BLUEPRINTDROP_CHANCE = {
            daywalker = 1,
        }
    },
    -- 狂妄
    HUBRIS = {
        ABSORB = .6, -- 防御
        DMG_WHEN_EQUIP = 10, -- 佩戴时提供10点额外攻击力
        WALKSPEEDMULT = 1.1, -- 移速
        DARPPERNESS = -10, -- san
        SHADOW_LEVEL = 3, -- 暗影等级
        SKILL_REPUTATION = { -- 被动：【盛名
            BOSSKILL_BY_SELF_STACK = 1, -- 当你击杀一个boss时，会增加1层盛名
            DMG_PER_STACK = 1, -- 每层盛名增加2点攻击力
            ---@type integer|false
            MAXSTACK = TUNING[string.upper('CONFIG_'..modid..'lol_wp_s14_hubris_skill_reputation_limit')], -- 最大层数设置
        },
        BLUEPRINTDROP_CHANCE = {
            beequeen = 1,
        }
    },
    --------------------------------------
    ---------------S15--------------------
    --------------------------------------
    -- 破碎王后之冕
    CROWN_OF_THE_SHATTERED_QUEEN = {
        ABSORB = .4,
        DEFEND_PLANAR = 15, -- 位面防御
        PLANAR_DMG_WHEN_EQUIP = 10, -- 额外位面伤害
        DARPPERNESS = 4, -- 精神回复
        SKILL_GUARD = { -- 被动：【护卫
            FADE_WHEN_ATTACKED = 2, -- 受到攻击2秒后消失
            CD = 20,
        },
        SKILL_MOURN = { -- 被动：【哀悼】
            DMGMULT = 1.2,  -- 与破败王者之刃同时装备时，其伤害提升20%
        }
    },
    -- 秒表
    STOPWATCH = {
        FP_INTERVAL_DIST = 5, -- 足迹最大消逝距离
        SKILL_TRACEBACK = { -- 主动：【回溯
            CD = 2
        },
        SKILL_JIKU = {
            RADIUS = 10,
            PLANAR_DMG = 120,
            CD = 40,
        }
    },
    -- 中娅沙漏
    ZHONYA = {
        ABSORB = .4,
        PLANAR_DMG_WHEN_EQUIP = 10, -- 额外位面伤害
        DARPPERNESS = 6, -- 精神回复
        SKILL_FREEZE = { -- 主动：【凝滞】
            DURATION = 3,
            CD = 40,
        }
    },
    --------------------------------------
    ---------------S16--------------------
    --------------------------------------
    -- 生命药水
    POTION_HP = {
        STACKSIZE = 5,
        DRINK_HP = 5,
        DRINK_SAN = -5,
        DRINK_PERSEC_HP = 3,
        DURATION = 20, -- 持续15秒
        MAX = 100, -- 最多叠加时间
    },
    -- 复用型药水
    POTION_COMPOUND = {
        DRINK_HP = 10,
        DRINK_SAN = 5,
        DRINK_PERSEC_HP = 4, -- 提供每秒4点的生命回复
        FINITEUSES = 100, 
        DURATION = 20, -- 持续15秒
        MAX = 40, -- 最多叠加时间
        DRINK_CONSUME_PERCENT = .5 -- 消耗50%耐久
    },
    -- 腐败药水
    POTION_CORRUPTION = {
        DRINK_HP = 15,
        DRINK_SAN = 10,
        DRINK_PERSEC_HP = 4, -- 提供每秒4点的生命和每秒2点的理智回复
        DRINK_PERSEC_SAN = 2, -- 提供每秒4点的生命和每秒2点的理智回复
        DRINK_CONSUME_PERCENT = .33, -- 消耗33%耐久
        PLANAR_DMG_WHEN_DRINK = 15, -- 持续期间提供额外15点额外位面伤害
        DURATION = 20, -- 持续15秒
        MAX = 60, -- 最多叠加时间
        FINITEUSES = 100,
        DONE_DEBUFF_DURATION = 10, -- buff结束后提供额外20秒的debuff
        DONE_DEBUFF_WALKSPEEDMULT = .8, -- buff结束后移动速度*.5
    },
    --------------------------------------
    ---------------S17--------------------
    --------------------------------------
    -- 卢登的回声
    LUDEN = {
        PLANAR_DMG = 50, -- 位面伤害
        RANGE = 6, -- 攻击距离
        WALKSPEEDMULT = 1.15, -- 移速\
        SKILL_ECHO = { -- 被动：【回声】
            CD = 2,
            PLANAR_DMG = 25,
            MISSILE = 3,
            MISSILE_SPEED = 26, -- 弹道速度
        },
        SKILL_ARCANE_TELE = { -- -主动 奥术跃迁
            CONSUME = 10, -- 消耗耐久
            CONSUME_SAN = -10, --  消耗10点san值，
            DISTANCE = 20,
        },
        SHADOW_LEVEL = 3, -- 暗影等级
        DMGMULT_TO_PLANAR = 1.1, -- 对月亮阵营伤害
        DARPPERNESS = -10, -- 手持时-10san/min。
        FINITEUSES = 200, -- 耐久
    },
    -- 兰德里的折磨
    LIANDRY = {
        ABSORB = .4, -- 防御
        DEFEND_PLANAR = 20, -- 位面防御
        SKILL_TORMENT = { -- 被动【折磨】
            INTERVAL = 1, -- 燃烧间隔
            DURATION = 3, -- 燃烧持续时间
            CD = 5, -- 技能冷却时间
            MAXHP_PERCENT_PLANAR_DMG = .01, -- 造成1%最大生命值的位面伤害，
        },
        SKILL_SUFFER = { -- 被动【受苦】
            PLANAR_DMG = .4, -- 你的攻击附带当前造成伤害20%的额外位面伤害
            INTERVAL = 10, -- 但是佩戴时会每10秒受到5点真实伤害
            TRUE_DMG = 5, -- 真实伤害
        },
        DMGMULT_TO_SHADOW = 1.1, -- 对暗影阵营伤害
        DARPPERNESS = -20, -- 手持时-20san/min。
        WHEN_NOMASK = {
            DARPPERNESS = -5,
        }
    },
    -- 遗失的章节
    LOSTCHAPTER = {
        PLANAR_DMG_WHEN_EQUIP = 10, -- 额外位面伤害
        DARPPERNESS = 6, -- 精神回复
        SKILL_ENLIGHTENMENT = { -- 被动：【启蒙】
            RECOVER_SAN_PERCENT = .2, --  每天早上回复自身20%的理智值
        },
    },
    --------------------------------------
    ---------------S18--------------------
    --------------------------------------
    -- 饮血剑
    BLOODTHIRSTER = { -- 饮血剑
        DMG = 68,
        RANGE = 1.2,
        CRITICAL_CHANCE = .25,
        CRITICAL_DMGMULT = 2,
        DRAIN = 8, -- 生命偷取：
        DARPPERNESS = -10, -- 理智
        ATK_DELTA_SAN = -3, -- 每次攻击消耗5点理智。
        SKILL_SPIRITUAL_LIQUID_SHIELD = { -- 被动：【灵液护盾
            CD = 10,
            SHIELD_CHANCE = .3, -- 每次攻击30%生成一个铥矿皇冠的护盾，
            SHIELD_DURATION = 2, -- 持续2秒
        },
        SKILL_BLOOD_SORCERY_WELL = { -- -被动：【鲜血魔井

        },
        SHADOW_LEVEL = 4,
        DMGMULT_TO_PLANAR = 1.1, -- 对月亮阵营伤害
        FINITEUSES = 200,
        SUITE_EFFECT = { -- 套装效果：和虚空风帽，虚空长袍同时装备时，获得额外5点吸血和10点位面伤害
            DRAIN = 0,
            PLANAR_DMG = 20,
        },
        SUITE_EFFECT_2 = { -- 增加和霸王血铠，恶魔之拥同时装备时的套装效果，增加4点吸血和10位面伤害
            DRAIN = 4,
            PLANAR_DMG = 10,
        }
    },
    -- 岚切】（月岛科技栏）
    STORMRAZOR = { -- 岚切】（月岛科技栏）
        DMG = 68, -- 攻击力
        CRITICAL_CHANCE = .25, -- 暴击：25%的概率
        CRITICAL_DMGMULT = 2, -- 造成双倍伤害
        WALKSPEEDMULT = 1.1, -- 移速
        SKILL_SHIV = { -- 主动：【拔刀】
            REPAIR_INTERVAL = 10, -- 收入刀鞘时会自动修复 每10秒修
            REPAIR = 5, -- 修复5点耐久。
        },
        SKILL_WIND_SLASH = { -- 主动：【疾风斩】
            INTERVAL = FRAMES*10,
            DMG = 20,
            CD = 5,
            LIFETIME = 5,
        },
        SKILL_ELECTRICSLASH = { -- 被动：【电冲】
            PLANAR_DMG = 30, -- 攻击时附加10点位面伤害 直接用物品的组件即可
            WALKSPEEDMULT = 1.45, -- 移动速度
            WALKSPEEDMULT_DURATION = 1, -- 提供持续1秒的45%移动速度，
            CD = 10,
        },
        SKILL_CHARGE = { -- 被动：【盈能】
            REDUCE_SKILL_ELECTRICSLASH_PER_HIT = 1, -- 每次攻击会减少1秒被动技能冷却时间
        },
        DMGMULT_TO_SHADOW = 1.1,
        FINITEUSES = 250,
        BLUEPRINTDROP_CHANCE = {
            moose = 1,
        },
        WALKSPEEDMULT_WITH_SAYA = 1.25,

    },
    -- 海妖杀手】（武器栏）
    KRAKENSLAYER = {
        DMG = 68,
        RANGE = 10,
        CRITICAL_CHANCE = .25, -- 暴击：25%的概率
        CRITICAL_DMGMULT = 2, -- 造成双倍伤害
        WALKSPEEDMULT = 1.15, -- 移速
        SKILL_TAKEDOWN = {
            TRUEDMG = 120,
            GP_PERCENT_LESS_THAN = .5,
            NEW_TRUEDMG = 180,
        },
        SKILL_KUJIRA = {
            DMGMULT_TO_MOB_ON_WATER = 2, -- 对水上生物造成双倍伤害
        },
        CHANCE_TO_GET_IN_CHEST_AFTER_KILL_BOSS = .05, -- 击败天体英雄后，有10%概率在沉底宝箱开出
        DMGMULT_TO_SHADOW = 1.1, -- 对暗影阵营伤害
        FINITEUSES = 400,
    },
    --------------------------------------
    ---------------S19--------------------
    --------------------------------------
    -- 大天使之杖】（月岛科技栏）
    ARCHANGELSTAFF = {
        PLANAR_DMG = 30,
        RANGE = 6,
        WALKSPEEDMULT = 1.1, -- 移速
        SKILL_OVERLOAD = { -- 主动：【超负荷】
            PER_HIT_TIMES = 4, -- 每第4次攻击
        },
        SKILL_FEAR = { -- 被动：【敬畏】
            PLANAR_DMG_MAXSANPERCENT = .02, -- 获得2%最大理智值的额外位面伤害。
        },
        SKILL_COUNT = { -- 被动：【法力积攒】
            COUNT_PER_HIT = 1, -- 发动一次攻击可以叠加1层被动
            COUNT_PER_HIT_BOSS = 2, -- boss生物则叠加2层被动
            DARPPERNESS_PER_COUNT = .03, -- 每层被动提供0.03理智回复
            MAX_COUNT = 300,
            CD = 4,
        },
        DMGMULT_TO_SHADOW = 1.1, -- 对暗影阵营伤害增加10%。
        UPGRADE = { -- 升级
            PLANAR_DMG = 60,
            RANGE = 8,
            DARPPERNESS = 12,
            LIGHT = { -- 光照
                FALLOFF = .3,
                INTENSITY = .9,
                RADIUS = 2,
                COLOR = {1, 1, 1},
            },
            SKILL_FEAR = { -- 被动：【敬畏】
                PLANAR_DMG_MAXSANPERCENT = .05, -- 获得2%最大理智值的额外位面伤害。
            },
            SKILL_SHIELD = { -- 被动：【救主灵刃】
                HP_PERCENT_BELOW = .3, -- 在受到将使你的生命值跌到30%以下的伤害时，
                SHIELD_DURATION = 3, -- 提供持续3秒的无敌护盾
                CD = 40, -- 冷却时间40秒。
            },
            DMGMULT_TO_SHADOW = 1.2, -- 对暗影阵营伤害增加10%。
        }
    },
    -- 魔宗】（月岛科技栏
    MURAMANA = {
        DMG = 45,
        RANGE = 1.5,
        WALKSPEEDMULT = 1.1,
        SKILL_WINDSLASH = { -- 被动：【风斩电刺
            PER_HIT_TIMES = 4, -- 每第4次攻击
        },
        SKILL_FEAR = { -- 被动：【敬畏】
            SAN_PERCENT = .02, -- 获得2%最大理智值的额外物理伤害。
        },
        SKILL_COUNT = { -- 被动：【法力积攒】
            COUNT_PER_HIT = 1, -- 发动一次攻击可以叠加1层被动
            COUNT_PER_HIT_BOSS = 2, -- boss生物则叠加2层被动
            DARPPERNESS_PER_COUNT = .03, -- 每层被动提供0.03理智回复
            MAX_COUNT = 300,
            CD = 4,
        },
        DMGMULT_TO_SHADOW = 1.1, -- 对暗影阵营伤害增加10%。
        UPGRADE = {
            DMG = 51,
            RANGE = 2,
            DARPPERNESS = 12,
            LIGHT = { -- 光照
                FALLOFF = .3,
                INTENSITY = .9,
                RADIUS = 2,
                COLOR = {1, 1, 1},
            },
            SKILL_FEAR = { -- 被动：【敬畏】
                SAN_PERCENT = .05, -- 获得2%最大理智值的额外物理伤害。
            },
            SKILL_SLASH = { -- 被动：【冲击】获得5%最大理智值的额外位面伤害。
                SAN_PERCENT = .05,
            },
            DMGMULT_TO_SHADOW = 1.2,
        }
    },
    -- 凛冬之临】（月岛科技栏）
    FIMBULWINTER = {
        ABSORB = .7,
        AVOID_COLD = 120, -- 保暖
        WATERPROOF = .2, -- 防水
        WALKSPEEDMULT = .9, -- 移速
        SKILL_FEAR = { -- 被动：【敬畏】获得2%最大理智值的位面防御。
            SAN_PERCENT = .02,
        },
        SKILL_COUNT = { -- 被动：【法力积攒】
            COUNT_PER_HIT = 1, -- 发动一次攻击可以叠加1层被动
            COUNT_PER_HIT_BOSS = 2, -- boss生物则叠加2层被动
            DARPPERNESS_PER_COUNT = .03, -- 每层被动提供0.03理智回复
            MAX_COUNT = 300,
            CD = 4,
        },
        UPGRADE = {
            WATERPROOF = .4,
            ABSORB = .9,
            AVOID_COLD = 240,
            HUNGER_BURN_RATE = .8, -- 饥饿速度
            DARPPERNESS = 12,
            WALKSPEEDMULT = .8,
            LIGHT = { -- 光照
                FALLOFF = .3,
                INTENSITY = .9,
                RADIUS = 2,
                COLOR = {1, 1, 1},
            },
            SKILL_FEAR = { -- 被动：【敬畏】获得2%最大理智值的位面防御。
                SAN_PERCENT = .05,
            },
            SKILL_ENTERNAL = { -- 被动：【永续】对一名boss生物造成减速效果时会提供一个持续2秒的无敌护盾，冷却时间10秒。
                DURANTION = 2,
                CD = 10,
            },
            SKILL_ICERAISE = { -- -被动：【冰川增幅】与兰德里的折磨同时装备时获得套装效果，每次攻击造成额外20%减速，并使该目标伤害降低20%，持续1.5秒，无冷却。
                SPEEDDOWN = .6,
                DOWN_TARGET_ATK = .6,
                DURATION = 1.5,
            }
        }
    }
}
