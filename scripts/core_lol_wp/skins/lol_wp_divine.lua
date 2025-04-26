---@diagnostic disable: undefined-global
local prefab_id = 'lol_wp_divine'

LOLWP_SKIN_API.MakeItemSkinDefaultImage(prefab_id, "images/inventoryimages/"..prefab_id..".xml", prefab_id)

LOLWP_SKIN_API.MakeItemSkin(prefab_id,prefab_id.."_skin_kamaeru",{
    name = STRINGS.MOD_LOL_WP.SKIN_API.SKINS[prefab_id]['kamaeru'],
    rarity = STRINGS.MOD_LOL_WP.SKIN_API.elegent,
    raritycorlor = TUNING.MOD_LOL_WP.SKIN_API.elegent,
    atlas = "images/inventoryimages/"..prefab_id.."_skin_kamaeru.xml",
    image = prefab_id.."_skin_kamaeru",
    build = prefab_id.."_skin_kamaeru",
    bank =  prefab_id.."_skin_kamaeru",
    anim = "idle",
    animcircle = true,
    basebuild = prefab_id,
    basebank =  prefab_id,
    baseanim = "idle",
    baseanimcircle = true
})
