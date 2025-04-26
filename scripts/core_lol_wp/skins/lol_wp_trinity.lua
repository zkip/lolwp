---@diagnostic disable: undefined-global
local prefab_id = 'lol_wp_trinity'

-- for _,v in ipairs({

-- }) do
--     table.insert(Assets,v)
-- end

LOLWP_SKIN_API.MakeItemSkinDefaultImage(prefab_id, "images/inventoryimages/"..prefab_id..".xml", prefab_id)

LOLWP_SKIN_API.MakeItemSkin(prefab_id,prefab_id.."_skin_moonphase",{
    name = STRINGS.MOD_LOL_WP.SKIN_API.SKINS[prefab_id]['moonphase'],
    rarity = STRINGS.MOD_LOL_WP.SKIN_API.top,
    raritycorlor = TUNING.MOD_LOL_WP.SKIN_API.top,
    atlas = "images/inventoryimages/"..prefab_id.."_skin_moonphase.xml",
    image = prefab_id.."_skin_moonphase",
    build = prefab_id.."_skin_moonphase",
    bank =  prefab_id.."_skin_moonphase",
    anim = "idle",
    animcircle = true,
    basebuild = prefab_id,
    basebank =  prefab_id,
    baseanim = "idle",
    baseanimcircle = true
})

LOLWP_SKIN_API.MakeItemSkin(prefab_id,prefab_id.."_skin_needle_cluster_burst",{
    name = STRINGS.MOD_LOL_WP.SKIN_API.SKINS[prefab_id]['needle_cluster_burst'],
    rarity = STRINGS.MOD_LOL_WP.SKIN_API.top,
    raritycorlor = TUNING.MOD_LOL_WP.SKIN_API.top,
    atlas = "images/inventoryimages/"..prefab_id.."_skin_needle_cluster_burst.xml",
    image = prefab_id.."_skin_needle_cluster_burst",
    build = prefab_id.."_skin_needle_cluster_burst",
    bank =  prefab_id.."_skin_needle_cluster_burst",
    anim = "idle",
    animcircle = true,
    basebuild = prefab_id,
    basebank =  prefab_id,
    baseanim = "idle",
    baseanimcircle = true
})