---@diagnostic disable: lowercase-global, undefined-global, trailing-space


---@type data_recipe[]
local data = {
	-- 
	{
		recipe_name = 'gallop_whip',
		ingredients = {
			Ingredient("pickaxe",1),
			Ingredient("marble",2),
			Ingredient("goldnugget",4),
			Ingredient("flint",6),
		},
		tech = TECH.SCIENCE_TWO,
		config = {
		},
      	filters = {"WEAPONS",'TAB_LOL_WP'}
	},
	{
		recipe_name = 'gallop_bloodaxe',
		ingredients = {
			Ingredient("gallop_whip",1,'images/inventoryimages/gallop_whip.xml'),
			Ingredient("redgem",10),
			Ingredient("dreadstone",8),
			Ingredient("horrorfuel",4),
			Ingredient("voidcloth",2),
		},
		tech = TECH.SHADOWFORGING_TWO,
		config = {
			nounlock = true, station_tag = "shadow_forge"
		},
      	filters = {"WEAPONS",'TAB_LOL_WP'}
	},
	{
		recipe_name = 'gallop_breaker',
		ingredients = {
			Ingredient("multitool_axe_pickaxe",1),
			Ingredient("gnarwail_horn",2),
			Ingredient("minotaurhorn",1),
			Ingredient("cookiecuttershell",8),
			Ingredient("thulecite",6),
		},
		tech = TECH.ANCIENT_THREE,
		config = {
			station_tag = "altar", nounlock = true
		},
      	filters = {"CRAFTING_STATION", "WEAPONS",'TAB_LOL_WP'}
	},

	-- 1玻璃刀, 4月岩，6玻璃碎片，2蓝宝石
	{
		recipe_name = 'lol_wp_sheen',
		ingredients = {
			Ingredient("glasscutter",1),
			Ingredient("moonrocknugget",4),
			Ingredient("moonglass",6),
			Ingredient("bluegem",2),
		},
		tech = TECH.CELESTIAL_THREE,
		config = {
			station_tag="moon_altar",
			nounlock = true,
		},
		filters = {'WEAPONS','TAB_LOL_WP'},
	},
	-- 1多用斧镐，1耀光，12铥矿，2海象牙，4黄宝石
	-- 1多用斧镐，1耀光，8铥矿，40金块，4绿宝石
	{
		recipe_name = 'lol_wp_divine',
		ingredients = {
			Ingredient("multitool_axe_pickaxe",1),
			Ingredient("lol_wp_sheen",1,'images/inventoryimages/lol_wp_sheen.xml'),
			Ingredient("goldnugget",40),
			Ingredient("thulecite",12),
			Ingredient("greengem",4),
		},
		tech = TECH.ANCIENT_THREE,
		config = {
			station_tag = "altar",
			nounlock = true,
		},
		filters = {'CRAFTING_STATION','WEAPONS','TAB_LOL_WP'},
	},
	-- 1 铥矿棒，1 暗夜剑，1 耀光, 6 铥矿，3 彩虹宝石
	-- 1 铥矿棒，1 暗夜剑，1 耀光, 33 金矿，3 彩虹宝石
	{
		recipe_name = 'lol_wp_trinity',
		ingredients = {
			Ingredient("ruins_bat",1),
			Ingredient("nightsword",1),
			Ingredient("lol_wp_sheen",1,'images/inventoryimages/lol_wp_sheen.xml'),
			Ingredient("goldnugget",33),
			Ingredient("opalpreciousgem",3),
		},
		tech = TECH.ANCIENT_THREE,
		config = {
			station_tag = "altar",
			nounlock = true,
		},
		filters = {'CRAFTING_STATION','WEAPONS','TAB_LOL_WP'},
	},
	-- 霸王血铠 1骨头盔甲，1绝望石盔甲，5红宝石，10铥矿，6纯粹恐惧
	{
		recipe_name = 'lol_wp_overlordbloodarmor',
		ingredients = {
			Ingredient("armorskeleton",1),
			Ingredient("armor_voidcloth",1),
			Ingredient("redgem",5),
			Ingredient("thulecite",10),
			Ingredient("horrorfuel",6),
		},
		tech = TECH.LOST,
		config = {
			-- nounlock = true,
		},
		filters = {'ARMOUR','TAB_LOL_WP'},
	},
	-- -- 恶魔之拥 1骨头头盔，1绝望石头盔，5紫宝石，10铥矿，6纯粹恐惧
	{
		recipe_name = 'lol_wp_demonicembracehat',
		ingredients = {
			Ingredient("skeletonhat",1),
			Ingredient("voidclothhat",1),
			Ingredient("purplegem",5),
			Ingredient("thulecite",10),
			Ingredient("horrorfuel",6),
		},
		tech = TECH.LOST,
		config = {},
		filters = {'ARMOUR','TAB_LOL_WP'},
	},
	-- -- 狂徒铠甲 1木甲，1荆棘外壳，4蘑菇皮，16活木，4绿宝石
	{
		recipe_name = 'lol_wp_warmogarmor',
		ingredients = {
			Ingredient("armorwood",1),
			Ingredient("hawaiianshirt",1),
			Ingredient("shroom_skin",4),
			Ingredient("livinglog",16),
			Ingredient("greengem",4),
		},
		tech = TECH.LOST,
		config = {},
		filters = {'ARMOUR','TAB_LOL_WP'},
	},
	-- S7
	-- 萃取（武器栏）制作配方：1长矛，20金块，5燧石
	{
		recipe_name = 'lol_wp_s7_cull',
		ingredients = {
			Ingredient("spear",1),
			Ingredient("goldnugget",20),
			Ingredient("flint",5),
		},
		tech = TECH.SCIENCE_TWO,
		config = {},
		filters = {'WEAPONS','TAB_LOL_WP'},
	}, 
	-- 多兰之刃（武器栏 1长矛，4金块，2燧石
	{
		recipe_name = 'lol_wp_s7_doranblade',
		ingredients = {
			Ingredient("spear",1),
			Ingredient("goldnugget",4),
			Ingredient("flint",2),
		},
		tech = TECH.SCIENCE_ONE,
		config = {},
		filters = {'WEAPONS','TAB_LOL_WP'},
	},
	-- 多兰之盾（护甲栏
	{
		recipe_name = 'lol_wp_s7_doranshield',
		ingredients = {
			Ingredient("boards",2),
			Ingredient("goldnugget",4),
			Ingredient("flint",2),
		},
		tech = TECH.SCIENCE_ONE,
		config = {},
		filters = {'ARMOUR','TAB_LOL_WP'},
	},
	-- 多兰之戒（魔法栏
	{
		recipe_name = 'lol_wp_s7_doranring',
		ingredients = {
			Ingredient("moonrocknugget",4),
			Ingredient("goldnugget",4),
			Ingredient("nightmarefuel",2),
		},
		tech = TECH.MAGIC_TWO,
		config = {},
		filters = {'MAGIC','TAB_LOL_WP'},
	},
	-- 女神之泪（月岛科技栏
	{
		recipe_name = 'lol_wp_s7_tearsofgoddess',
		ingredients = {
			Ingredient("bluegem",5),
			Ingredient("moonglass",10),
			Ingredient("nightmarefuel",5),
		},
		tech = TECH.CELESTIAL_THREE,
		config = {
			station_tag="moon_altar",
			nounlock = true,
		},
		filters = {'TAB_LOL_WP'},
	},
	-- 黑曜石锋刃（武器栏 5月岩，8蜂刺，5燧石
	{
		recipe_name = 'lol_wp_s7_obsidianblade',
		ingredients = {
			Ingredient("moonrocknugget",4),
			Ingredient("stinger",8),
			Ingredient("flint",5),
		},
		tech = TECH.SCIENCE_TWO,
		config = {},
		filters = {'WEAPONS','TAB_LOL_WP'},
	},
	-- S8
	-- 灭世者的死亡之帽
	{
		recipe_name = 'lol_wp_s8_deathcap',
		ingredients = {
			Ingredient("tophat",1),
			Ingredient("lol_wp_s8_uselessbat",2,'images/inventoryimages/lol_wp_s8_uselessbat.xml'),
			Ingredient("shadowheart_infused",1),
			Ingredient("horrorfuel",8),
			Ingredient("voidcloth",6),
		},
		tech = TECH.SHADOWFORGING_TWO,
		config = {
			station_tag = "shadow_forge",
			nounlock = true, 
		},
		filters = {'CLOTHING','TAB_LOL_WP'},
	},
	-- 无用大棒
	{
		recipe_name = 'lol_wp_s8_uselessbat',
		ingredients = {
			Ingredient("purplegem",1),
			Ingredient("boneshard",6),
			Ingredient("livinglog",2),
			Ingredient("nightmarefuel",4),
		},
		tech = TECH.MAGIC_THREE,
		config = {},
		filters = {'MAGIC','TAB_LOL_WP'}
	},
	-- 巫妖之祸
	{
		recipe_name = 'lol_wp_s8_lichbane',
		ingredients = {
			Ingredient("lol_wp_s8_uselessbat",1,'images/inventoryimages/lol_wp_s8_uselessbat.xml'),
			Ingredient("lol_wp_sheen",1,'images/inventoryimages/lol_wp_sheen.xml'),
			Ingredient("marble",20),
			Ingredient("thulecite",12),
			Ingredient("yellowgem",4),
		},
		tech = TECH.ANCIENT_THREE,
		config = {
			station_tag = "altar",
			nounlock = true,
		},
		filters = {'CRAFTING_STATION','TAB_LOL_WP','WEAPONS'},
	},
	-- s9
	-- 引路者（储物栏
	{
		recipe_name = 'lol_wp_s9_guider',
		ingredients = {
			Ingredient("armorruins",1),
			Ingredient("yellowamulet",1),
			Ingredient("bedroll_straw",1),
			Ingredient("bundlewrap",6),
			Ingredient("bearger_fur",1),
		},
		tech = TECH.SCIENCE_TWO,
		config = {},
		filters = {'CONTAINERS','TAB_LOL_WP'}
	},
	-- 戒备眼石
	{
		recipe_name = 'lol_wp_s9_eyestone_low',
		ingredients = {
			Ingredient("nightmare_timepiece",1),
			Ingredient("greenamulet",1),
			Ingredient('orangeamulet',1),
			Ingredient("yellowamulet",1),
			Ingredient("thulecite",20),
		},
		tech = TECH.ANCIENT_THREE,
		config = {
			station_tag = "altar",
			nounlock = true,
		},
		filters = {'CRAFTING_STATION','TAB_LOL_WP'}
	},
	-- 警觉眼石
	{
		recipe_name = 'lol_wp_s9_eyestone_high',
		ingredients = {
			Ingredient("lol_wp_s9_eyestone_low",1,'images/inventoryimages/lol_wp_s9_eyestone_low.xml'),
			Ingredient("greenmooneye",1),
			Ingredient("orangemooneye",1),
			Ingredient("yellowmooneye",1),
			Ingredient("townportaltalisman",20),
		},
		tech = TECH.ANCIENT_THREE,
		config = {
			station_tag = "altar",
			nounlock = true,
		},
		filters = {'CRAFTING_STATION','TAB_LOL_WP'},
	},
	----------------------------------------------
	----------------s10---------------------------
	----------------------------------------------
	-- 鬼索的狂暴之刃
	{
		recipe_name = 'lol_wp_s10_guinsoo',
		ingredients = {
			Ingredient("ruins_bat",1),
			Ingredient("lol_wp_s8_uselessbat",1,'images/inventoryimages/lol_wp_s8_uselessbat.xml'),
			Ingredient("dragon_scales",2),
			Ingredient("redgem",5),
			Ingredient("goldnugget",40),
		},
		tech = TECH.LOST,
		config = {},
		filters = {'WEAPONS','TAB_LOL_WP'},
	},
	-- 爆裂魔杖
	{
		recipe_name = 'lol_wp_s10_blastingwand',
		ingredients = {
			Ingredient("firestaff",1),
			Ingredient("lightninggoathorn",1),
			Ingredient("goldnugget",20),
			Ingredient("livinglog",4),
		},
		tech = TECH.MAGIC_THREE,
		config = {},
		filters = {'MAGIC','TAB_LOL_WP'}
	},
	-- 日炎圣盾
	{
		recipe_name = 'lol_wp_s10_sunfireaegis',
		ingredients = {
			Ingredient("nightmare_timepiece",1),
			Ingredient("armorruins",1),
			Ingredient("dragon_scales",4),
			Ingredient("goldnugget",40),
			Ingredient("redgem",5),
		},
		tech = TECH.LOST,
		config = {},
		filters = {'ARMOUR','TAB_LOL_WP'}
	},
	----------------------------------------------
	----------------s11---------------------------
	----------------------------------------------
	-- 增幅典籍
	{
		recipe_name = 'lol_wp_s11_amplifyingtome',
		ingredients = {
			Ingredient('redgem',1),
			Ingredient('papyrus',4),
			Ingredient('goldnugget',10),
			Ingredient('nightmarefuel',5),
		},
		tech = TECH.MAGIC_TWO,
		config = {},
		filters = {'MAGIC','TAB_LOL_WP'}
	},
	-- 黑暗封印
	{
		recipe_name = 'lol_wp_s11_darkseal',
		ingredients = {
			Ingredient('redgem',2),
			Ingredient('goldnugget',20),
			Ingredient('marble',4),
			Ingredient('nightmarefuel',8),
		},
		tech = TECH.MAGIC_THREE,
		config = {},
		filters = {'MAGIC','TAB_LOL_WP'}
	},
	-- 梅贾的窃魂卷 暗影术基座
	{
		recipe_name = 'lol_wp_s11_mejaisoulstealer',
		ingredients = {
			Ingredient('lol_wp_s11_darkseal',1,'images/inventoryimages/lol_wp_s11_darkseal.xml'),
			Ingredient('lol_wp_s11_amplifyingtome',2,'images/inventoryimages/lol_wp_s11_amplifyingtome.xml'),
			Ingredient("shadowheart_infused",1),
			Ingredient('horrorfuel',10),
			Ingredient('voidcloth',8),
		},
		tech = TECH.SHADOWFORGING_TWO,
		config = {
			station_tag = "shadow_forge",
			nounlock = true, 
		},
		filters = {'TAB_LOL_WP'},
	},
	----------------------------------------------
	----------------s12---------------------------
	----------------------------------------------
	-- 星蚀】（武器栏
	{
		recipe_name = 'lol_wp_s12_eclipse',
		ingredients = {
			Ingredient("sword_lunarplant",1),
			Ingredient("alterguardianhatshard",3),
			Ingredient("opalpreciousgem",5),
			Ingredient('purebrilliance',12),
			Ingredient("moonrocknugget",20),
		},
		tech = TECH.LOST,
		config = {
		},
		filters = {'WEAPONS','TAB_LOL_WP'},
	},
	-- 焚天】（远古栏
	{
		recipe_name = 'lol_wp_s12_malignance',
		ingredients = {
			Ingredient("fence_rotator",1),
			Ingredient("ruins_bat",1),
			Ingredient('moonrocknugget',18),
			Ingredient('thulecite',12),
			Ingredient("bluegem",5),
		},
		tech = TECH.ANCIENT_THREE,
		config = {
			station_tag = "altar",
			nounlock = true,
		},
		filters = {'CRAFTING_STATION','WEAPONS','TAB_LOL_WP'},
	},
	----------------------------------------------
	----------------s13---------------------------
	----------------------------------------------
	-- 无尽之刃】（远古栏）
	{
		recipe_name = 'lol_wp_s13_infinity_edge',
		ingredients = {
			Ingredient("ruins_bat",1),
			Ingredient("minotaurhorn",1),
			Ingredient("thulecite",12),
			Ingredient("goldnugget",80),
			Ingredient("yellowgem",4),
		},
		tech = TECH.ANCIENT_THREE,
		config = {
			station_tag = "altar",
			nounlock = true,
		},
		filters = {'CRAFTING_STATION','WEAPONS','TAB_LOL_WP'},
	},
	-- 斯塔缇克电刃】（武器栏
	{
		recipe_name = 'lol_wp_s13_statikk_shiv',
		ingredients = {
			Ingredient("nightstick",1),
			Ingredient("mastupgrade_lightningrod_item",1),
			Ingredient("transistor",6),
			Ingredient("goldnugget",40),
			Ingredient("gears",4),
		},
		tech = TECH.SCIENCE_TWO,
		config = {
		},
		filters = {'WEAPONS','TAB_LOL_WP'},
	},
	-- 收集者】（辉煌铁匠铺栏 => 改成炼金引擎
	{
		recipe_name = 'lol_wp_s13_collector',
		ingredients = {
			Ingredient("boat_cannon_kit",1),
			Ingredient("boat_bumper_crabking_kit",4),
			Ingredient("gunpowder",8),
			Ingredient("gears",10),
			Ingredient('thulecite',12),
		},
		-- tech = TECH.LUNARFORGING_TWO,
		tech = TECH.SCIENCE_TWO,
		config = {
			-- station_tag = "lunar_forge",
			-- nounlock = true,
		},
		filters = {'WEAPONS','TAB_LOL_WP'}
	},
	----------------------------------------------
	----------------s14---------------------------
	----------------------------------------------
	-- 棘刺背心】（护甲栏）
	{
		recipe_name = 'lol_wp_s14_bramble_vest',
		ingredients = {
			Ingredient("armorwood",1),
			Ingredient("pigskin",2),
			Ingredient("houndstooth",4),
			Ingredient("flint",6),
		},
		tech = TECH.SCIENCE_TWO,
		config = {
		},
		filters = {'ARMOUR','TAB_LOL_WP'},
	},
	-- 荆棘之甲】（护甲栏
	{
		recipe_name = 'lol_wp_s14_thornmail',
		ingredients = {
			Ingredient('lol_wp_s14_bramble_vest',1,'images/inventoryimages/lol_wp_s14_bramble_vest.xml'),
			Ingredient("armordreadstone",1),
			Ingredient("marble",8),
			Ingredient("houndstooth",10),
			Ingredient("cookiecuttershell",8),
		},
		tech = TECH.LOST,
		config = {
		},
		filters = {'ARMOUR','TAB_LOL_WP'},
	},
	-- 狂妄】（远古栏
	{
		recipe_name = 'lol_wp_s14_hubris',
		ingredients = {
			Ingredient("hivehat",1),
			Ingredient("dreadstonehat",1),
			Ingredient("goldnugget",40),
			Ingredient("thulecite",8),
			Ingredient("feather_canary",6),
		},
		tech = TECH.LOST,
		config = {
		},
		filters = {'ARMOUR','TAB_LOL_WP'},
	},
	----------------------------------------------
	----------------s15---------------------------
	----------------------------------------------
	-- 破碎王后之冕】（月岛科技栏
	{
		recipe_name = 'lol_wp_s15_crown_of_the_shattered_queen',
		ingredients = {
			Ingredient("ruinshat",1),
			Ingredient("greengem",1),
			Ingredient("goldnugget",40),
			Ingredient("moonrocknugget",4),
			Ingredient("moonglass",6),
		},
		tech = TECH.CELESTIAL_THREE,
		config = {
			station_tag = "moon_altar",
			nounlock = true,
		},
		filters = {'TAB_LOL_WP'},
	},
	-- 秒表】（工具栏）
	{
		recipe_name = 'lol_wp_s15_stopwatch',
		ingredients = {
			Ingredient("bluegem",1),
			Ingredient("goldnugget",20),
			Ingredient("gears",4),
			Ingredient("moonglass",6),
		},
		tech = TECH.SCIENCE_TWO,
		config = {
		},
		filters = {'TOOLS','TAB_LOL_WP'},
	},
	-- 中娅沙漏】（月岛科技栏
	{
		recipe_name = 'lol_wp_s15_zhonya',
		ingredients = {
			Ingredient("lol_wp_s15_stopwatch",1,'images/inventoryimages/lol_wp_s15_stopwatch.xml'),
			Ingredient("lol_wp_s8_uselessbat",1,'images/inventoryimages/lol_wp_s8_uselessbat.xml'),
			Ingredient("thulecite",8),
			Ingredient("moonglass",12),
			Ingredient("yellowgem",2),
		},
		tech = TECH.CELESTIAL_THREE,
		config = {
			station_tag = "moon_altar",
			nounlock = true,
		},
		filters = {'TAB_LOL_WP'},
	},
	----------------------------------------------
	----------------s16---------------------------
	----------------------------------------------
	-- 生命药水】（治疗栏
	{
		recipe_name = 'lol_wp_s16_potion_hp',
		ingredients = {
			Ingredient("red_cap",1),
			Ingredient("petals",1),
			Ingredient("ash",1),
		},
		tech = TECH.NONE,
		config = {},
		filters = {'RESTORATION','TAB_LOL_WP'}
	},
	-- 复用型药水】（治疗栏
	{
		recipe_name = 'lol_wp_s16_potion_compound',
		ingredients = {
			Ingredient("messagebottleempty",1),
			Ingredient("green_cap",5),
			Ingredient("ash",5),
			Ingredient("nitre",5),
		},
		tech = TECH.SCIENCE_TWO,
		config = {},
		filters = {'RESTORATION','TAB_LOL_WP'}
	},
	-- 腐败药水】（治疗栏
	{
		recipe_name = 'lol_wp_s16_potion_corruption',
		ingredients = {
			Ingredient("lol_wp_s16_potion_compound",1,'images/inventoryimages/lol_wp_s16_potion_compound.xml'),
			Ingredient("blue_cap",10),
			Ingredient("dreadstone",8),
			Ingredient("goldnugget",40),
			Ingredient("nightmarefuel",20),
		},
		tech = TECH.MAGIC_THREE,
		config = {},
		filters = {'RESTORATION','TAB_LOL_WP'}
	},
	----------------------------------------------
	----------------s17---------------------------
	----------------------------------------------
	-- 卢登的回声】（魔法栏）
	{
		recipe_name = 'lol_wp_s17_luden',
		ingredients = {
			Ingredient("nightstick",1),
			Ingredient("lol_wp_s10_blastingwand", 1,'images/inventoryimages/lol_wp_s10_blastingwand.xml'),
			Ingredient("purplegem",10),
			Ingredient("dreadstone",6),
			Ingredient("horrorfuel",4),
		},
		tech = TECH.MAGIC_THREE,
		config = {},
		filters = {'MAGIC','TAB_LOL_WP'}
	},
	-- 兰德里的折磨】（辉煌铁匠铺栏）
	{
		recipe_name = 'lol_wp_s17_liandry',
		ingredients = {
			Ingredient('mask_sagehat',1),
			Ingredient('lunarplanthat',1),
			Ingredient("alterguardianhatshard",1),
			Ingredient("redgem",5),
			Ingredient("purebrilliance",8),
		},
		tech = TECH.LUNARFORGING_TWO,
		config = {
			station_tag = "lunar_forge",
			nounlock = true,
		},
		filters = {'TAB_LOL_WP'}
	},
	-- 遗失的章节】（月岛科技栏
	{
		recipe_name = 'lol_wp_s17_lostchapter',
		ingredients = {
			Ingredient("bluegem",1),
			Ingredient("papyrus",4),
			Ingredient("moonglass",2),
			Ingredient("moon_tree_blossom",6),
		},
		tech = TECH.CELESTIAL_THREE,
		config = {
			station_tag = "moon_altar",
			nounlock = true,
		},
		filters = {'TAB_LOL_WP'},
	},
	----------------------------------------------
	----------------s18---------------------------
	----------------------------------------------
	-- 饮血剑】（暗影术基座栏
	{
		recipe_name = 'lol_wp_s18_bloodthirster',
		ingredients = {
			Ingredient('nightsword',1),
			Ingredient("shadowheart_infused",1),
			Ingredient("fossil_piece",12),
			Ingredient('horrorfuel',8),
			Ingredient("voidcloth",6),
		},
		tech = TECH.SHADOWFORGING_TWO,
		config = {
			station_tag = "shadow_forge",
			nounlock = true, 
		},
		filters = {'TAB_LOL_WP'},
	},
	-- 岚切 月岛科技栏
	{
		recipe_name = 'lol_wp_s18_stormrazor',
		ingredients = {
			Ingredient("glasscutter",1),
			Ingredient("staff_tornado",1),
			Ingredient("goldnugget",40),
			Ingredient("moonrocknugget",12),
			Ingredient("malbatross_feathered_weave",1),
		},
		-- tech = TECH.CELESTIAL_THREE,
		tech = TECH.LOST,
		config = {
			-- station_tag = "moon_altar",
			-- nounlock = true,
		},
		filters = {'TAB_LOL_WP'},
	},
	-- 海妖杀手】（武器栏）
	{
		recipe_name = 'lol_wp_s18_krakenslayer',
		ingredients = {
			Ingredient("houndstooth_blowpipe",1),
			Ingredient("trident",1),
			Ingredient("moonstorm_static_item",1),
			Ingredient("wagpunk_bits",8),
			Ingredient("walrus_tusk",3),
		},
		tech = TECH.LUNARFORGING_TWO,
		config = {
			station_tag = "lunar_forge",
			nounlock = true,
		},
		filters = {'WEAPONS','TAB_LOL_WP'}
	},
	----------------------------------------------
	----------------s19---------------------------
	----------------------------------------------
	-- 大天使之杖】（月岛科技栏
	{
		recipe_name = 'lol_wp_s19_archangelstaff',
		ingredients = {
			Ingredient("opalstaff",1),
			Ingredient("lol_wp_s7_tearsofgoddess",1,'images/inventoryimages/lol_wp_s7_tearsofgoddess.xml'),
			Ingredient("bluegem",5),
			Ingredient("thulecite",8),
			Ingredient("moonglass",12),
		},
		tech = TECH.CELESTIAL_THREE,
		-- tech = TECH.LOST,
		config = {
			station_tag = "moon_altar",
			nounlock = true,
		},
		filters = {'TAB_LOL_WP'},
	},
	-- 魔宗】（月岛科技栏）
	{
		recipe_name = 'lol_wp_s19_muramana',
		ingredients = {
			Ingredient("glasscutter",1),
			Ingredient("lol_wp_s7_tearsofgoddess",1,'images/inventoryimages/lol_wp_s7_tearsofgoddess.xml'),
			Ingredient("bluegem",5),
			Ingredient("moonrocknugget",8),
			Ingredient("moonglass",12),
		},
		tech = TECH.CELESTIAL_THREE,
		config = {
			station_tag = "moon_altar",
			nounlock = true,
		},
		filters = {'TAB_LOL_WP'},
	},
	-- 凛冬之临】（月岛科技栏
	{
		recipe_name = 'lol_wp_s19_fimbulwinter_armor',
		ingredients = {
			Ingredient("armormarble",1),
			Ingredient("beargervest",1),
			Ingredient("lol_wp_s7_tearsofgoddess",1,'images/inventoryimages/lol_wp_s7_tearsofgoddess.xml'),
			Ingredient("bluegem",5),
			Ingredient("moonrocknugget",12),
		},
		tech = TECH.CELESTIAL_THREE,
		config = {
			station_tag = "moon_altar",
			nounlock = true,
		},
		filters = {'TAB_LOL_WP'},
	},
}
---@type data_destruction_recipes[]
local destruction_recipes = {
	{
		name = 'lol_wp_s13_infinity_edge_amulet',
		ingredients = {
			Ingredient("ruins_bat",1),
			Ingredient("minotaurhorn",1),
			Ingredient("thulecite",12),
			Ingredient("goldnugget",80),
			Ingredient("yellowgem",4),
		}
	},
	{
		name = 'riftmaker_amulet',
		ingredients = {
			Ingredient("telestaff", 1), 
			Ingredient("lol_wp_s10_blastingwand", 1,'images/inventoryimages/lol_wp_s10_blastingwand.xml'),
			Ingredient("thulecite", 8), 
			Ingredient("dreadstone", 6),
			Ingredient("horrorfuel", 4)
		}
	},
	{
		name = 'lol_wp_s18_stormrazor_nosaya',
		ingredients = {
			Ingredient("glasscutter",1),
			Ingredient("staff_tornado",1),
			Ingredient("malbatross_feathered_weave",1),
			Ingredient("goldnugget",40),
			Ingredient("moonrocknugget",12),
		}
	},
	{
		name = 'lol_wp_s17_liandry_nomask',
		ingredients = {
			Ingredient('mask_sagehat',1),
			Ingredient("alterguardianhatshard",1),
			Ingredient("redgem",5),
			Ingredient("purebrilliance",8),
			Ingredient('moonrocknugget',10),
		}
	},
	{
		name = 'lol_wp_s19_archangelstaff_upgrade',
		ingredients = {
			Ingredient("opalstaff",1),
			Ingredient("lol_wp_s7_tearsofgoddess",1,'images/inventoryimages/lol_wp_s7_tearsofgoddess.xml'),
			Ingredient("bluegem",5),
			Ingredient("thulecite",8),
			Ingredient("moonglass",12),
		}
	},
	{
		name = 'lol_wp_s19_muramana_upgrade',
		ingredients = {
			Ingredient("glasscutter",1),
			Ingredient("lol_wp_s7_tearsofgoddess",1,'images/inventoryimages/lol_wp_s7_tearsofgoddess.xml'),
			Ingredient("bluegem",5),
			Ingredient("moonrocknugget",8),
			Ingredient("moonglass",12),
		}
	},
	{
		name = 'lol_wp_s19_fimbulwinter_armor_upgrade',
		ingredients = {
			Ingredient("armormarble",1),
			Ingredient("beargervest",1),
			Ingredient("lol_wp_s7_tearsofgoddess",1,'images/inventoryimages/lol_wp_s7_tearsofgoddess.xml'),
			Ingredient("bluegem",5),
			Ingredient("moonrocknugget",12),
		}
	}
}

return data,destruction_recipes