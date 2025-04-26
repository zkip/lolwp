---@diagnostic disable: undefined-global
local prefab_id = 'gallop_breaker'
local mid = '_skin_'
local suffix = 'kirakira_no_ai'

LOLWP_SKIN_API.MakeItemSkinDefaultImage(prefab_id, "images/inventoryimages/"..prefab_id..".xml", prefab_id)

LOLWP_SKIN_API.MakeItemSkin(prefab_id,prefab_id..mid..suffix,{
    name = STRINGS.MOD_LOL_WP.SKIN_API.SKINS[prefab_id][suffix],
    rarity = STRINGS.MOD_LOL_WP.SKIN_API.elegent,
    raritycorlor = TUNING.MOD_LOL_WP.SKIN_API.elegent,
    atlas = "images/inventoryimages/"..prefab_id..mid..suffix..".xml",
    image = prefab_id..mid..suffix,
    build = prefab_id..mid..suffix,
    bank =  prefab_id..mid..suffix,
    anim = "idle",
    animcircle = true,
    basebuild = prefab_id,
    basebank =  prefab_id,
    baseanim = "idle",
    baseanimcircle = true
})
