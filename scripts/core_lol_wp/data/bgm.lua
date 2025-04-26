---@class _equip_bgm_data
---@field pack string # 包名
---@field volume number # 0~1
---@field group string|nil # 组名 默认 `bgm`
---@field name string|nil # 背景音乐名 默认 `bgm_`+预制物名

---@type table<string,_equip_bgm_data>
local equips = {
    gallop_brokenking = {
        pack = 'lol_wp_bgm_pack_a',
        volume = .3,
    },
    gallop_bloodaxe = {
        pack = 'lol_wp_bgm_pack_a',
        volume = .3,
    },
    gallop_blackcutter = {
        pack = 'lol_wp_bgm_pack_a',
        volume = .3,
    },
    gallop_ad_destroyer = {
        pack = 'lol_wp_bgm_pack_a',
        volume = .3,
    },
    lol_wp_s10_guinsoo = {
        pack = 'lol_wp_bgm_pack_a',
        volume = .3,
    },

    crystal_scepter = {
        -- pack = 'lol_wp_bgm_pack_b',
        pack = 'lol_wp_bgm_pack_c',
        name = 'let_it_go',
        volume = .3,
    },
    lol_wp_divine = {
        -- pack = 'lol_wp_bgm_pack_b',
        pack = 'lol_wp_bgm_pack_c',
        name = 'divine',
        volume = .3,
    },
    lol_wp_s12_malignance = {
        pack = 'lol_wp_bgm_pack_b',
        volume = .3,
    },
    lol_wp_s18_bloodthirster = {
        pack = 'lol_wp_bgm_pack_b',
        volume = .3,
    },
    lol_wp_s18_krakenslayer = {
        pack = 'lol_wp_bgm_pack_b',
        volume = .3,
    },
    lol_wp_s18_stormrazor_nosaya = {
        pack = 'lol_wp_s18_stormrazor',
        group = 'bgm',
        name = 'lol_wp_s18_stormrazor',
        volume = .3,
    },
    nashor_tooth = {
        pack = 'lol_wp_bgm_pack_b',
        volume = .3,
    },
}

return equips