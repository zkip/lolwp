---@diagnostic disable: undefined-global
---@type string
local modid = 'lol_wp' -- 定义唯一modid

---@diagnostic disable-next-line: inject-field
GLOBAL.LOLWP_SKIN_API = env

---@type LAN_TOOL_COORDS
LOLWP_C = require('core_'..modid..'/utils/coords')
---@type LAN_TOOL_SUGARS
LOLWP_S = require('core_'..modid..'/utils/sugar')
---@type LOL_WP_UNIQUE
LOLWP_U = require('core_'..modid..'/utils/unique')

rawset(GLOBAL,'LOLWP_C',LOLWP_C)
rawset(GLOBAL,'LOLWP_S',LOLWP_S)
rawset(GLOBAL,'LOLWP_U',LOLWP_U)

local moddir = KnownModIndex:GetModsToLoad(true)
local enablemods = {}
for k, dir in pairs(moddir) do
    local info = KnownModIndex:GetModInfo(dir)
    local name = info and info.name or "unknow"
    enablemods[dir] = name
end
function LOL_WP_CHECKMODENABLED(name)
	for k, v in pairs(enablemods) do
        if string.find(v,name) then return true end
    end
    return false
end
rawset(GLOBAL,'LOL_WP_CHECKMODENABLED',LOL_WP_CHECKMODENABLED)


local new_PrefabFiles = {
	'lol_wp_module_buffs',
	-- 'lol_wp_module_dishes',
	-- 'lol_wp_module_particle',
	'lol_wp_sheen',
	'lol_wp_divine',
	'lol_wp_trinity',
	'fx_lol_wp_trinity',
	'lol_wp_terraprisma',
	-- S6
    'lol_wp_overlordbloodarmor',
	'lol_wp_warmogarmor',
	'lol_wp_demonicembracehat',
	-- S7
	'lol_wp_s7_cull',
	'lol_wp_s7_doranblade',
	'lol_wp_s7_doranshield',
	'lol_wp_s7_doranring',
	'lol_wp_s7_tearsofgoddess',
	'lol_wp_s7_obsidianblade',
	-- s8
	'lol_wp_s8_deathcap',
	'lol_wp_s8_uselessbat',
	'lol_wp_s8_lichbane',
	-- s9
	'lol_wp_s9_guider',
	'lol_wp_s9_eyestone_low',
	'lol_wp_s9_eyestone_high',
	-- s10
	'lol_wp_s10_guinsoo',
	'lol_wp_s10_blastingwand',
	'lol_wp_s10_sunfireaegis',
	'lol_wp_s10_sunfireaegis_armor',
	-- s11
	'lol_wp_s11_amplifyingtome',
	'lol_wp_s11_darkseal',
	'lol_wp_s11_mejaisoulstealer',
	-- s12
	'lol_wp_s12_eclipse',
	'lol_wp_s12_malignance',
	-- s13
	'lol_wp_s13_infinity_edge',
	'lol_wp_s13_statikk_shiv',
	'lol_wp_s13_statikk_shiv_charged',
	'lol_wp_s13_collector',
	'lol_wp_s13_infinity_edge_amulet',
	-- s14
    'lol_wp_s14_bramble_vest',
	'lol_wp_s14_thornmail',
	'lol_wp_s14_hubris',
	-- s15
	'lol_wp_s15_crown_of_the_shattered_queen',
	'lol_wp_s15_stopwatch',
	'lol_wp_s15_zhonya',
	-- s16
	'lol_wp_s16_potion_hp',
	'lol_wp_s16_potion_compound',
	'lol_wp_s16_potion_corruption',
	-- s17
	'lol_wp_s17_luden',
	'lol_wp_s17_liandry',
	'lol_wp_s17_lostchapter',
	-- s18
	'lol_wp_s18_bloodthirster',
	'lol_wp_s18_stormrazor',
	'lol_wp_s18_krakenslayer',
	-- s19
	'lol_wp_s19_archangelstaff',
	'lol_wp_s19_muramana',
	'lol_wp_s19_fimbulwinter_armor',
}

local new_Assets = {
    Asset("ATLAS","images/tab_lol_wp.xml"),

	Asset("SOUNDPACKAGE","sound/soundfx_lol_wp_divine.fev"),
	Asset("SOUND","sound/soundfx_lol_wp_divine.fsb"),

	Asset("SOUNDPACKAGE","sound/lol_wp_bgm_pack_a.fev"),
	Asset("SOUND","sound/lol_wp_bgm_pack_a.fsb"),
	Asset("SOUNDPACKAGE","sound/lol_wp_bgm_pack_b.fev"),
	Asset("SOUND","sound/lol_wp_bgm_pack_b.fsb"),
	Asset("SOUNDPACKAGE","sound/lol_wp_bgm_pack_c.fev"),
	Asset("SOUND","sound/lol_wp_bgm_pack_c.fsb"),

	Asset("SOUNDPACKAGE","sound/lol_wp_s15_zhonya.fev"),
	Asset("SOUND","sound/lol_wp_s15_zhonya.fsb"),
	Asset("SOUNDPACKAGE","sound/lol_wp_s18_stormrazor.fev"),
	Asset("SOUND","sound/lol_wp_s18_stormrazor.fsb"),

	-- 其他码师的物品的invimg
	Asset("ATLAS","images/inventoryimages/gallop_bloodaxe.xml"),
	Asset("ATLAS","images/inventoryimages/gallop_breaker.xml"),
	Asset("ATLAS","images/inventoryimages/gallop_whip.xml"),

	Asset('ATLAS','images/slotbg/eyestone_slotbg.xml'),

	-- 开枪动画(动画名: lol_fishgun_shoot ; 通道覆盖: lol_fishgun  )
	Asset("ANIM","anim/lol_fishgun.zip"),

	Asset("ATLAS","images/lol_wp_pedia/quagmire_recipebook.xml"),
	Asset("ATLAS","images/lol_wp_pedia/scrapbook.xml"),
	Asset("ATLAS","images/lol_wp_pedia/lol_wp_pedia_group_btn.xml"),
	Asset("ATLAS","images/lol_wp_pedia/lol_wp_pedia_scrollablelist.xml"),
	Asset("ATLAS","images/lol_wp_pedia/member_bg.xml"),
	Asset("ATLAS","images/lol_wp_pedia/slot_with_outline.xml"),
	Asset("ATLAS","images/lol_wp_pedia/lol_pedia_book_icon.xml"),

	Asset("ANIM", "anim/player_actions_speargun.zip" ),
    Asset("ANIM", "anim/player_mount_actions_speargun.zip"),
	-- Asset("ANIM", "anim/lol_wp_speargun.zip" ),

}

for _, v in pairs(new_Assets) do table.insert(Assets, v) end
for _, v in pairs(new_PrefabFiles) do table.insert(PrefabFiles, v) end

-- 导入mod配置
TUNING['CONFIG_'..string.upper(modid)..'_LANG'] = currentlang == 'zh' and 'cn' or 'en'
-- TUNING[string.upper('CONFIG_'..modid..'eyestone_allow_lolamulet_only')] = GetModConfigData('eyestone_allow_lolamulet_only')
TUNING[string.upper('CONFIG_'..modid..'lol_wp_bgm_whenequip')] = GetModConfigData('lol_wp_bgm_whenequip')
TUNING[string.upper('CONFIG_'..modid..'eclipse_laser_destory_everything')] = GetModConfigData('eclipse_laser_destory_everything')
TUNING[string.upper('CONFIG_'..modid..'lol_wp_s14_hubris_skill_reputation_limit')] = GetModConfigData('lol_wp_s14_hubris_skill_reputation_limit')
TUNING[string.upper('CONFIG_'..modid..'lol_wp_eyestone_item_effect_half')] = GetModConfigData('lol_wp_eyestone_item_effect_half')
TUNING[string.upper('CONFIG_'..modid..'bloodaxe_health')] = GetModConfigData('bloodaxe_health')
TUNING[string.upper('CONFIG_'..modid..'limit_lol_heartsteel_new')] = GetModConfigData('limit_lol_heartsteel_new')
TUNING[string.upper('CONFIG_'..modid..'key_lol_wp_s15_zhonya_freeze')] = GetModConfigData('key_lol_wp_s15_zhonya_freeze')
TUNING[string.upper('CONFIG_'..modid..'collector_drop_gold')] = GetModConfigData('collector_drop_gold')
TUNING[string.upper('CONFIG_'..modid..'sunfire_aura')] = GetModConfigData('sunfire_aura')
TUNING[string.upper('CONFIG_'..modid..'tears_limit')] = GetModConfigData('tears_limit')
TUNING[string.upper('CONFIG_'..modid..'darkseel_limit')] = GetModConfigData('darkseel_limit')
TUNING[string.upper('CONFIG_'..modid..'mejai_limit')] = GetModConfigData('mejai_limit')
TUNING[string.upper('CONFIG_'..modid..'not_little_items_durability')] = GetModConfigData('not_little_items_durability')
TUNING[string.upper('CONFIG_'..modid..'little_items_durability')] = GetModConfigData('little_items_durability')
TUNING[string.upper('CONFIG_'..modid..'could_repair')] = GetModConfigData('could_repair')

-- 导入常量表
modimport('scripts/core_'..modid..'/data/tuning.lua')

-- 导入工具
modimport('scripts/core_'..modid..'/utils/_register.lua')

-- 导入功能API
modimport('scripts/core_'..modid..'/api/_register.lua')
modimport('scripts/core_'..modid..'/api/skin.lua')


-- 导入语言文件
modimport('scripts/core_'..modid..'/languages/'..TUNING['CONFIG_'..string.upper(modid)..'_LANG']..'.lua')

-- 导入调用器
-- modimport('scripts/core_'..modid..'/callers/caller_badge.lua')
modimport('scripts/core_'..modid..'/callers/caller_changeactionsg.lua')
modimport('scripts/core_'..modid..'/callers/caller_ca.lua')
modimport('scripts/core_'..modid..'/callers/caller_container.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_dish.lua')
modimport('scripts/core_'..modid..'/callers/caller_keyhandler.lua')
modimport('scripts/core_'..modid..'/callers/caller_recipes.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_stack.lua')
modimport('scripts/core_'..modid..'/callers/caller_attackperiod.lua')
modimport('scripts/core_'..modid..'/callers/caller_onlyusedby.lua')


-- 导入UI
modimport('scripts/core_'..modid..'/ui/lol_wp_pedia.lua')

-- 注册客机组件
-- AddReplicableComponent('lolwp_buff_owner')
AddReplicableComponent('lolwp_passive_controller')
AddReplicableComponent('lol_wp_s7_cull_counter')
AddReplicableComponent('lol_wp_s7_tearsofgoddess')
AddReplicableComponent('lol_wp_s11_darkseal_num')
AddReplicableComponent('lol_wp_s11_mejaisoulstealer_num')
AddReplicableComponent('lol_wp_event_trigger')
AddReplicableComponent('lol_wp_s14_hubris_skill_reputation')
AddReplicableComponent('gallop_brokenking_frogblade_cd')
AddReplicableComponent('lol_wp_cd_itemtile')
AddReplicableComponent('lol_wp_potion_drinker')
AddReplicableComponent('count_from_tearsofgoddness')

-- 导入钩子 
modimport('scripts/core_'..modid..'/hooks/RegisterInventoryItemAtlas.lua') -- 注册inv图片
modimport('scripts/core_'..modid..'/hooks/sup.lua') -- 置顶
modimport('scripts/core_'..modid..'/hooks/lol_wp_dmgsys.lua') -- 伤害系统
modimport('scripts/core_'..modid..'/hooks/fix_bug_souljump.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_sheen.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_divine.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_trinity.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_overlordbloodarmor.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_warmogarmor.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_demonicembracehat.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s7_cull.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s7_doranring.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s7_tearsofgoddess.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s7_obsidianblade.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s7_doranshield.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s8_deathcap.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s8_uselessbat.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s8_lichbane.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s9_guider.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s9_eyestone_container.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s9_eyestone_container_item_fix.lua')
modimport('scripts/core_'..modid..'/hooks/riftmaker_amulet.lua')
modimport('scripts/core_'..modid..'/hooks/cantequip_whennodurability.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s10_guinsoo.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s10_blastingwand.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s10_sunfireaegis.lua')
modimport('scripts/core_'..modid..'/hooks/crystal_staff_drop.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s11_amplifyingtome.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s11_darkseal_and_mejaisoulstealer.lua')
modimport('scripts/core_'..modid..'/hooks/announce.lua')
modimport('scripts/core_'..modid..'/hooks/build_data_transfer.lua')
modimport('scripts/core_'..modid..'/hooks/blackcutter.lua')
modimport('scripts/core_'..modid..'/hooks/event_hook.lua')
modimport('scripts/core_'..modid..'/hooks/bgm.lua') -- 装备时触发bgm
modimport('scripts/core_'..modid..'/hooks/lol_wp_s12_eclipse.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s12_malignance.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s13_collector.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s14_hubris.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s14_thornmail.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_pedia.lua') -- 百科界面需要用到的钩子
modimport('scripts/core_'..modid..'/hooks/lol_wp_amulet_transfer_in_eyestone.lua') -- 眼石中可以变形的护符
modimport('scripts/core_'..modid..'/hooks/lol_wp_type_manager.lua') -- 装备类型管理器
modimport('scripts/core_'..modid..'/hooks/gallop_brokenking.lua')
modimport('scripts/core_'..modid..'/hooks/bramble_vest_dmg.lua') -- 原版的荆棘外壳反伤不吃额外伤害加成
modimport('scripts/core_'..modid..'/hooks/player_timer.lua') -- 装备cd绑定玩家
modimport('scripts/core_'..modid..'/hooks/lol_wp_s15_stopwatch.lua') -- 足迹回溯
modimport('scripts/core_'..modid..'/hooks/lol_wp_cd_itemtile.lua') -- 自定义cd
modimport('scripts/core_'..modid..'/hooks/lol_wp_potion_drinker.lua') -- 药水
modimport('scripts/core_'..modid..'/hooks/make_tradable.lua') -- 使得一些物品可以交易
modimport('scripts/core_'..modid..'/hooks/about_aoetargeting.lua') -- reticule没有正常移除导致的aoetargeting指示器出不来, 我说什么来着, 这个组件就是答辩, 
modimport('scripts/core_'..modid..'/hooks/lol_wp_s18_krakenslayer.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s18_stormrazor.lua')
modimport('scripts/core_'..modid..'/hooks/alt.lua')
modimport('scripts/core_'..modid..'/hooks/little_items.lua')
modimport('scripts/core_'..modid..'/hooks/count_from_tearsofgoddness.lua')
modimport('scripts/core_'..modid..'/hooks/world_data_lol_wp.lua')
modimport('scripts/core_'..modid..'/hooks/lol_wp_s19_fimbulwinter_armor_upgrade.lua')

-- 导入sg
modimport('scripts/core_'..modid..'/sg/leap_atk.lua')
modimport('scripts/core_'..modid..'/sg/lol_wp_blank_sg.lua')
modimport('scripts/core_'..modid..'/sg/lol_wp_s12_eclipse_leap_laser.lua')
modimport('scripts/core_'..modid..'/sg/lol_wp_handcanon.lua')
modimport('scripts/core_'..modid..'/sg/lol_wp_pocketwatch_warpback.lua')
modimport('scripts/core_'..modid..'/sg/lol_wp_shotgun.lua')
-- modimport('scripts/core_'..modid..'/sg/new_tornado.lua')

-- 皮肤
modimport('scripts/core_'..modid..'/skins/lol_wp_s7_cull.lua')
modimport('scripts/core_'..modid..'/skins/lol_wp_divine.lua')
modimport('scripts/core_'..modid..'/skins/lol_wp_s12_eclipse.lua')
modimport('scripts/core_'..modid..'/skins/lol_wp_trinity.lua')
modimport('scripts/core_'..modid..'/skins/lol_wp_overlordbloodarmor.lua')
modimport('scripts/core_'..modid..'/skins/lol_wp_s13_infinity_edge.lua')
modimport('scripts/core_'..modid..'/skins/lol_wp_demonicembracehat.lua')
modimport('scripts/core_'..modid..'/skins/gallop_breaker.lua')
modimport('scripts/core_'..modid..'/skins/lol_wp_s18_bloodthirster.lua')
modimport('scripts/core_'..modid..'/skins/crystal_scepter.lua')
modimport('scripts/core_'..modid..'/skins/lol_wp_s17_luden.lua')
modimport('scripts/core_'..modid..'/skins/lol_wp_s19_muramana.lua')
modimport('scripts/core_'..modid..'/skins/lol_wp_s19_muramana_upgrade.lua')
